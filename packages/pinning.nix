{ writeShellScriptBin, nix, git, coreutils }:

writeShellScriptBin "pinning" ''
  BRANCH=''${1:-nixos-unstable}
  DATE=$(${coreutils}/bin/date +%Y-%m-%d)
  if [ ''${#BRANCH} -eq 40 ]; then
      REVISION=$BRANCH
      NAME=$BRANCH
  else
      REVISION=$(${git}/bin/git ls-remote https://github.com/nixos/nixpkgs-channels $BRANCH | ${coreutils}/bin/cut -f1 )
      NAME="$BRANCH.$DATE"
  fi

  TARBALL="https://github.com/NixOS/nixpkgs/archive/$REVISION.tar.gz"
  SHA256=$(${nix}/bin/nix-prefetch-url --name $NAME --unpack $TARBALL)
  cat <<EOF
  # generated with $0 $* on $DATE
  import (builtins.fetchTarball {
    name   = "$NAME";
    url    = "$TARBALL";
    sha256 = "$SHA256";
  })
  EOF
''
