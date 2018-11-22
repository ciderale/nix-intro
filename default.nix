let pkgs = import ./packages.nix {};
in {
  inherit (pkgs) awesome more-awesome intro;
}
