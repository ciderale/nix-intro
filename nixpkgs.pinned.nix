# https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
import (builtins.fetchGit {
  # Descriptive name to make the store path easier to identify
  name = "nixos-unstable-2018-11-19";
  url = https://github.com/nixos/nixpkgs/;
  # Commit hash for nixos-unstable as of 2018-11-19
  # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`
  rev = "80738ed9dc0ce48d7796baed5364eef8072c794d";
})
