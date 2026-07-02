{
  lib,
  cctools,
  stdenv,
  writeShellScriptBin,
  zig_0_15,
  baseHerdr,
}:
baseHerdr.overrideAttrs (old: let
  darwinSdkRoot = "${stdenv.cc.fallback_sdk}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
  darwinDeveloperDir = "${stdenv.cc.fallback_sdk}/Platforms/MacOSX.platform/Developer";
  darwinXcodeSelect = writeShellScriptBin "xcode-select" ''
    if [ "$1" = "--print-path" ]; then
      echo ${lib.escapeShellArg darwinDeveloperDir}
      exit 0
    fi
    echo "unsupported xcode-select invocation: $*" >&2
    exit 1
  '';
  darwinXcrun = writeShellScriptBin "xcrun" ''
    if [ "$1" = "--sdk" ] && [ "$3" = "--show-sdk-path" ]; then
      echo ${lib.escapeShellArg darwinSdkRoot}
      exit 0
    fi
    echo "unsupported xcrun invocation: $*" >&2
    exit 1
  '';
in {
  patches =
    (old.patches or [])
    ++ [
      ./patches/herdr-skip-bench-init-when-disabled.patch
    ];

  nativeBuildInputs =
    (old.nativeBuildInputs or [])
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools
      darwinXcodeSelect
      darwinXcrun
    ];

  env =
    (old.env or {})
    // {
      LIBGHOSTTY_VT_OPTIMIZE = "ReleaseFast";
      LIBGHOSTTY_VT_SIMD = "true";
      LIBGHOSTTY_VT_ZIG_SYSTEM_DIR = old.zigDeps;
      ZIG = lib.getExe zig_0_15;
    }
    // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
      SDKROOT = darwinSdkRoot;
    };

  preBuild =
    (old.preBuild or "")
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-global-cache"
      export ZIG_LOCAL_CACHE_DIR="$TMPDIR/zig-local-cache"
    '';
})
