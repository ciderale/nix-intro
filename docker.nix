let pkgs = import ./packages { system = "x86_64-linux"; };
in { inherit (pkgs) awesome-docker; } # awesome-web; } # use nixos18.09 instead of unstable
