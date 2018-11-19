{ stdenv, git, gradle, curl, nodejs }:

stdenv.mkDerivation {
  name = "awesome-project-1.0";
  buildInputs = [git gradle curl nodejs];

  phases = ["buildPhase"];
  buildPhase = ''
    mkdir -p $out/bin
    cat << EOF > $out/bin/awesome-version
    #!${stdenv.shell}
    ${gradle}/bin/gradle --version # runtime dependency
    echo "Node: $(node --version)"  # buildtime dependency
    EOF
    chmod +x $out/bin/awesome-version
  '';
}
