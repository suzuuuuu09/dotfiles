_: {
  projectRootFile = "flake.nix";

  programs = {
    # Nix
    alejandra.enable = true;

    # Shell
    shfmt.enable = true;

    # NeovimなどのLua
    stylua.enable = true;

    # TOML
    taplo.enable = true;
  };
}
