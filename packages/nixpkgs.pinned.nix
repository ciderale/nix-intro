# https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
# https://github.com/NixOS/nix/issues/2431
# use fetchTarball since simpler and it uses less disk space
# `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-18.09`
with (import ./nixos.unstable.nix); # currently unstable or 1809
import (builtins.fetchTarball {
  url = "https://github.com/nixos/nixpkgs/archive/${rev}.tar.gz";
  inherit name sha256;
})
