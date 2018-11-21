let pkgs = import ./packages.nix { system = "x86_64-linux"; };
in { inherit (pkgs) awesome-docker awesome-web; }
