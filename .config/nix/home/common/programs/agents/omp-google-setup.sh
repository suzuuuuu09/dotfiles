set -euo pipefail

api_base="https://backend.composio.dev/api/v3.1"
user_id="${OMP_GOOGLE_USER_ID:-suzu}"
toolkit="googlesuper"
secret_selector='["composio_api_key"]'
aliases_csv="${OMP_GOOGLE_ALIASES:-personal,university}"

: "${OMP_GOOGLE_SECRETS_FILE:?OMP_GOOGLE_SECRETS_FILE is not set}"
: "${OMP_GOOGLE_SOPS_AGE_KEY_FILE:?OMP_GOOGLE_SOPS_AGE_KEY_FILE is not set}"
: "${OMP_GOOGLE_MCP_CONFIG:?OMP_GOOGLE_MCP_CONFIG is not set}"
: "${OMP_GOOGLE_API_KEY_COMMAND:?OMP_GOOGLE_API_KEY_COMMAND is not set}"

if [[ ! -f "$OMP_GOOGLE_SOPS_AGE_KEY_FILE" ]]; then
  printf 'age private key not found: %s\n' "$OMP_GOOGLE_SOPS_AGE_KEY_FILE" >&2
  exit 1
fi

if [[ ! -f "$OMP_GOOGLE_SECRETS_FILE" ]]; then
  printf 'SOPS secrets file not found: %s\n' "$OMP_GOOGLE_SECRETS_FILE" >&2
  exit 1
fi

api_key="$("$OMP_GOOGLE_API_KEY_COMMAND" 2>/dev/null || true)"
if [[ -z "$api_key" ]]; then
  if [[ ! -t 0 ]]; then
    printf 'composio_api_key is missing from the SOPS secrets file. Run omp-google-setup interactively once.\n' >&2
    exit 1
  fi

  read -r -s -p 'Composio API key: ' api_key
  printf '\n'
  if [[ -z "$api_key" ]]; then
    printf 'Composio API key must not be empty.\n' >&2
    exit 1
  fi

  printf '%s' "$api_key" \
    | jq -Rs . \
    | SOPS_AGE_KEY_FILE="$OMP_GOOGLE_SOPS_AGE_KEY_FILE" \
      sops set --value-stdin "$OMP_GOOGLE_SECRETS_FILE" "$secret_selector" >/dev/null

  api_key="$("$OMP_GOOGLE_API_KEY_COMMAND")"
  printf 'Saved composio_api_key to the SOPS-encrypted secrets file.\n'
fi

composio_get() {
  curl -fsS \
    -H "x-api-key: $api_key" \
    "$api_base$1"
}

composio_post() {
  local path="$1"
  local payload="$2"

  curl -fsS \
    -X POST \
    -H "x-api-key: $api_key" \
    -H 'Content-Type: application/json' \
    --data-binary "$payload" \
    "$api_base$path"
}

session_payload="$(jq -nc \
  --arg user_id "$user_id" \
  --arg toolkit "$toolkit" \
  '{
    user_id: $user_id,
    toolkits: { enable: [$toolkit] },
    multi_account: {
      enable: true,
      max_accounts_per_toolkit: 5,
      require_explicit_selection: true
    }
  }')"

session="$(composio_post '/tool_router/session' "$session_payload")"
session_id="$(jq -er '.session_id' <<<"$session")"
mcp_url="$(jq -er '.mcp.url' <<<"$session")"

mkdir -p "$(dirname "$OMP_GOOGLE_MCP_CONFIG")"
base_config="$(mktemp)"
tmp_config="$(mktemp)"
trap 'rm -f "$base_config" "$tmp_config"' EXIT

if [[ -f "$OMP_GOOGLE_MCP_CONFIG" ]]; then
  jq -e 'type == "object"' "$OMP_GOOGLE_MCP_CONFIG" >/dev/null
  cp "$OMP_GOOGLE_MCP_CONFIG" "$base_config"
else
  printf '{}\n' >"$base_config"
fi

jq \
  --arg url "$mcp_url" \
  --arg api_key_command "!$OMP_GOOGLE_API_KEY_COMMAND" \
  '."$schema" //= "https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/src/config/mcp-schema.json"
   | .mcpServers //= {}
   | .mcpServers.google = {
       type: "http",
       url: $url,
       headers: { "x-api-key": $api_key_command }
     }' \
  "$base_config" >"$tmp_config"

chmod 600 "$tmp_config"
mv "$tmp_config" "$OMP_GOOGLE_MCP_CONFIG"
tmp_config=""

accounts="$(composio_get '/connected_accounts?limit=100')"
IFS=',' read -r -a aliases <<<"$aliases_csv"

open_url() {
  local url="$1"
  if command -v open >/dev/null 2>&1; then
    open "$url" >/dev/null 2>&1 || true
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url" >/dev/null 2>&1 || true
  fi
}

for alias in "${aliases[@]}"; do
  alias="${alias//[[:space:]]/}"
  [[ -n "$alias" ]] || continue

  existing="$(jq -r \
    --arg user_id "$user_id" \
    --arg toolkit "$toolkit" \
    --arg alias "$alias" \
    '.items[]
     | select(.user_id == $user_id and .toolkit.slug == $toolkit and .alias == $alias)
     | [.id, .status]
     | @tsv' <<<"$accounts" | head -n 1)"

  if [[ -n "$existing" ]]; then
    IFS=$'\t' read -r connected_account_id status <<<"$existing"
    if [[ "$status" == "ACTIVE" ]]; then
      printf '%s: already connected (%s).\n' "$alias" "$connected_account_id"
      continue
    fi

    printf '%s already exists in Composio with status %s. Fix or remove that connection before rerunning.\n' "$alias" "$status" >&2
    exit 1
  fi

  link_payload="$(jq -nc --arg toolkit "$toolkit" --arg alias "$alias" '{toolkit: $toolkit, alias: $alias}')"
  link="$(composio_post "/tool_router/session/$session_id/link" "$link_payload")"
  redirect_url="$(jq -er '.redirect_url' <<<"$link")"
  connected_account_id="$(jq -er '.connected_account_id' <<<"$link")"

  printf '%s: sign in with this Google account:\n%s\n' "$alias" "$redirect_url"
  open_url "$redirect_url"

  for _ in {1..300}; do
    status="$(composio_get "/connected_accounts/$connected_account_id" | jq -r '.status')"
    case "$status" in
      ACTIVE)
        printf '%s: connected.\n' "$alias"
        break
        ;;
      FAILED|EXPIRED)
        printf '%s: connection ended with status %s.\n' "$alias" "$status" >&2
        exit 1
        ;;
    esac
    sleep 2
  done

  if [[ "$status" != "ACTIVE" ]]; then
    printf '%s: OAuth was not completed before the connection window expired.\n' "$alias" >&2
    exit 1
  fi
done

printf 'OMP Google MCP configured: %s\n' "$OMP_GOOGLE_MCP_CONFIG"
printf 'Next: restart OMP or run /mcp reload, then /mcp test google.\n'
