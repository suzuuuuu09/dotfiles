# Build Japanese input around macSKK

Use macSKK as the center of Japanese input, with azoo-key-skkserv for conversion support, Karabiner-Elements to switch between alphanumeric and kana input, and macism to return to alphanumeric input from Neovim. Relying only on the macOS Japanese input method would reduce the configuration, but it would not prioritize SKK input and stable input switching between applications. Keep dictionaries, kana input rules, key bindings, and launch settings reconstructible through nix-darwin.
