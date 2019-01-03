self: super: {
  # commented out => jdk8/node8
  jdk = self.jdk11;
  nodejs = self.nodejs-10_x;
  gradle = self.gradleGen.gradleGen rec {
    name = "gradle-5.0-rc-3";
    nativeVersion = "0.14";

    src = super.fetchurl {
      url = "http://services.gradle.org/distributions/${name}-bin.zip";
      sha256 = "087ai9i4fs1fyywsryijvysi38p244n3knh3gcy163gwj2nj0jk8";
    };
  };
  revealJs = super.callPackage ./revealjs.nix {};
  pinning = super.callPackage ./pinning.nix {};
}
