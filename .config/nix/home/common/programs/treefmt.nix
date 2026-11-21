_: {
  projectRootFile = "flake.nix";

  programs = {
    # Nix
    nixfmt.enable = true;

    # Shell
    shfmt = {
      enable = true;
      indent_size = 2;
      simplify = true;
    };

    # NeovimなどのLua
    stylua.enable = true;

    # TOML
    taplo.enable = true;

    # Python
    ruff.enable = true;
  };
}
