# https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
# https://github.com/NixOS/nix/issues/2431
# use fetchTarball since simpler and it uses less disk space
let
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-18.09`
  #rev = "03dc6471c12a0ef505ad8136ce07d47b332f2def"; # nixos-18.09 as of 2018-11-21
  rev = "80738ed9dc0ce48d7796baed5364eef8072c794d";  # nixos-unstable 2018-11-21
in import (builtins.fetchTarball {
  # name = "nixos-18.09-2018-11-21"; # Descriptive name to make the store path easier to identify
  name = "nixos-unstable-2018-11-21"; # Descriptive name to make the store path easier to identify
  url = "https://github.com/nixos/nixpkgs/archive/${rev}.tar.gz";
})
