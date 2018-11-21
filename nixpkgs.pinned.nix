# https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
import (builtins.fetchGit {
  # Descriptive name to make the store path easier to identify
  name = "nixos-darwin-2018-11-21";
  url = https://github.com/nixos/nixpkgs/;
  # Commit hash for nixos-unstable as of 2018-11-19
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`
  rev = "03dc6471c12a0ef505ad8136ce07d47b332f2def"; # nixos-18.09 as of 2018-11-09
  ref = "nixos-18.09"; # https://github.com/NixOS/nix/issues/2431
})
