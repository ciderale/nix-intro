{ fetchgit, pandoc, writeShellScriptBin }:

rec {

  reveal-js = fetchgit {
    url = "https://github.com/hakimel/reveal.js.git";
    rev = "65bdccd5807b6dfecad6eb3ea38872436d291e81";
    sha256 = "07460ij4v7l2j0agqd2dsg28gv18bf320rikcbj4pb54k5pr1218";
  };

  mkRevealJs = writeShellScriptBin "mkRevealJs" ''
    ${pandoc}/bin/pandoc -s -t revealjs -V revealjs-url=${reveal-js} $*
  '';

  mkSlides = writeShellScriptBin "mkSlides" ''
    ${mkRevealJs}/bin/mkRevealJs --slide-level=2 $1 > $1.html
  '';

}
