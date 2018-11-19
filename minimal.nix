with (import <nixpkgs> {});

stdenv.mkDerivation {
  name = "awesome-project";
  version = "1.0";
  buildInputs = [git gradle curl nodejs];

  phases = ["buildPhase"];
  buildPhase = ''
    # gradle needs a place to write: 'libnative-platform.dylib'
    #export GRADLE_USER_HOME=$TMPDIR
    mkdir -p $out/bin
    cat << EOF > $out/bin/awesome-version
    #!${bash}/bin/bash
    ${gradle}/bin/gradle --version  #runtime dependency
    echo $(node --version)          #buildtime dependency
    EOF
    chmod +x $out/bin/awesome-version
  '';
}
