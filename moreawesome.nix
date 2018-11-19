{ stdenv, gradle, nodejs }:

stdenv.mkDerivation {
  name = "awesome-project-2.0";
  buildInputs = [gradle nodejs];

  phases = ["buildPhase"];
  buildPhase = ''
    # gradle needs a place to write: 'libnative-platform.dylib'
    export GRADLE_USER_HOME=$TMPDIR

    mkdir -p $out/bin
    cat << EOF > $out/bin/awesome-version
    #!${stdenv.shell}
    echo "$(gradle --version)"     #buildTime dependency
    echo "Node: $(node --version)" #buildtime dependency
    EOF
    chmod +x $out/bin/awesome-version
  '';
}
