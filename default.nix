let overlay = import ./overlay.nix; in

with (import ./nixpkgs.pinned.nix { overlays = [overlay]; });

{
  awesome = callPackage ./awesome.nix {};
  more-awesome = callPackage ./moreawesome.nix {};

  slides = stdenv.mkDerivation {
    name = "Nix-Introduction";
    buildInputs = [revealJs.mkSlides];
    src = ./slides.md;
    phases = [ "buildPhase" ];
    buildPhase = ''
      mkdir -p $out;
      cp $src $out/index.md;
      mkSlides $out/index.md;
    '';
  };
}
