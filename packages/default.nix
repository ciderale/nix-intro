{ system ? builtins.currentSystem
}:

let overlay = import ./overlay.nix; in
with (import ./nixpkgs.pinned.nix { overlays = [overlay]; inherit system; });

rec {
  awesome = callPackage ./awesome.nix {};
  more-awesome = callPackage ./moreawesome.nix {};
  awesome-web = callPackage ./awesomeweb.nix {
    data = intro;
  };

  awesome-docker = dockerTools.buildImage {
    name = "awesome-docker"; tag = "latest";
    contents = [more-awesome];
    config.entrypoint = "${more-awesome}/bin/awesome-version";
  };

  mkSlides = revealJs.mkSlides;

  intro = stdenv.mkDerivation {
    name = "Nix-Introduction";
    buildInputs = [revealJs.mkSlides nixops];
    src = ../slides.md;
    imgs = ../imgs;
    phases = [ "buildPhase" ];
    buildPhase = ''
      mkdir -p $out;
      cp $src $out/index.md;
      cp -r $imgs $out/imgs;
      mkSlides $out/index.md;
    '';

    shellHook = ''
    PROJECT_ROOT=$(pwd)
    '';
  };
}
