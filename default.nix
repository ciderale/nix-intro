let pkgs = import ./packages {};
in {
  inherit (pkgs) awesome more-awesome intro;
}
