let pkgs = import ./packages { system = "x86_64-linux"; };
in {
  inherit (pkgs) awesome-docker awesome-web;
}
