{ system ? builtins.currentSystem
}:

let pkgs = import <nixpkgs> { inherit system; };
# let pkgs = import ./nixpkgs.pinned.nix { inherit system; };

in with pkgs;

let
  repoNixOps = fetchFromGitHub {
      owner = "NixOS";
      repo = "nixops";
      rev = "3d5e816e622b7863daa76732902fd20dba72a0b8";
      sha256 = "0lb9rdnmi91hkyij10lgv1chi6cgviyxc5g6070hz03g2w8039kb";
  };

  machine-configuration = import "${repoNixOps}/nix/virtualbox-image-nixops.nix";

  machine = import <nixpkgs/nixos> {
  #machine = import "${pkgs.path}/nixos" {
    inherit system;
    configuration = machine-configuration;
  };

in stdenv.mkDerivation rec {
  name = "vmbaseimage-${version}";
  version = "${machine.config.system.nixos.version}";

  phases = [ "buildPhase" ];
  buildPhase = ''
    uname -a
    echo ${machine.config.system.nixos.version}
    # building the OVA uses the wrong system
    echo ${machine.config.system.build.virtualBoxOVA}
    tar xvf ${machine.config.system.build.virtualBoxOVA}/nixos*.ova
    mv nixos*.vmdk $out
  '';
}

