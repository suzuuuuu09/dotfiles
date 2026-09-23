_: {
  projectRootFile = "flake.nix";

  programs = {
    # Nix
    nixfmt.enable = true;

    # Shell
    shfmt.enable = true;

    # NeovimなどのLua
    stylua.enable = true;

    # TOML
    taplo.enable = true;

    # Python
    ruff.enable = true;
  };
}
