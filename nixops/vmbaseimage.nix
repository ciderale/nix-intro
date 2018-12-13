{ pkgs ? import <nixpkgs> {}
}:

with pkgs;

let
  repoNixOps = fetchFromGitHub {
      owner = "NixOS";
      repo = "nixops";
      rev = "e795b963f626162221ccccee9464a3a973a94e98";
      sha256 = "1zd5c7mkx1s0fd0a5q7hsmp7p7a69nknxza0941in1py3lcv5pz9";
  };

  machine-configuration = import "${repoNixOps}/nix/virtualbox-image-nixops.nix";

  machine = import "${pkgs.path}/nixos" {
    system = "x86_64-linux";
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

