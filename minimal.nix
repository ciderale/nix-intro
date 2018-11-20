with (import <nixpkgs> {});

stdenv.mkDerivation {
  name = "awesome-project";
  buildInputs = [git gradle curl nodejs];
  phases = ["buildPhase"];
  buildPhase = ''
    mkdir -p $out/bin  # $out where to place package data
    cat << EOF > $out/bin/awesome-version
    #!${stdenv.shell}               #!shebang
    ${gradle}/bin/gradle --version  # runtime dependency
    echo $(node --version)          # buildtime dependency
    EOF
    chmod +x $out/bin/awesome-version
  '';
}
