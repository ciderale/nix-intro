# https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
# https://github.com/NixOS/nix/issues/2431
# use fetchTarball since simpler and it uses less disk space
# `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-18.09`
import ./nixpkgs.custom.nix