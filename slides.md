---
#title: Introduction to Nix(pkgs)
title: Nix -- The Purely Functional Package Manager
author: Alain Lehmann
date: 23. November 2018
theme: beige
---

# Why should you care?


## What tools does your project require?

```
$ which git gradle curl npm
/Users/ale/.nix-profile/bin/git # what version?
gradle not found                # oh no..
/usr/bin/curl                   # what version?
npm not found                   # really?
```

- How to install them? In which version?
- How to switch among projects?

## What tools does your project require?

JVM, gradle, NodeJS, python, curl, kpcli, etc.

- *How to install*?
  - Undocumented: assume they are just there
  - Readme/Confluence: typically outdated
  - Shell script install: Globally? What about updates?
- *How to switch* between projects?
  - eg. switch between JDK8 and JDK11

## Nothing but Nix required!

(pun intended)


```
# details: https://nixos.org/nix/download.html
curl https://nixos.org/nix/install | sh
```
```
pkgs = import <nixpkgs> {};
pkgs.stdenv.mkDerivation {
  name = "awesome-project-1.0";
  buildInputs = with pkgs; [git gradle curl nodejs];
}
```
```
# nix provides all dependencies in exact versions
$ nix-shell --run 'which git gradle curl npm'
/nix/store/hbfjnla1p7qni7gdwd2j5ampyfmy55kz-git-2.19.1/bin/git
/nix/store/3f110h2fwmiabsw2rhw57sqjprbggrag-gradle-4.10/bin/gradle
/nix/store/0qklz87k9knxhimv6h9slizwrxm2fs9g-curl-7.61.1-bin/bin/curl
/nix/store/ghfhw6xza78bl7d340kipj06cazlircz-nodejs-8.11.4/bin/npm
```
## Experiment with tools

- I need something to process csv & json
```
$ nix search csv json
> * nixpkgs.miller (miller-5.3.0)
>   Miller is like awk, sed, cut, join, and sort for name-indexed
>   data such as CSV, TSV, and tabular JSON.
```
```
$ nix-shell -p miller # Brilliant.. get me that
$$ mlr --version      # is it really there?
> Miller 5.3.0        # yes it is
$$ exit               # but, not what I need
$ which mlr           # is it really gone?
mlr not found         # nix-shell doesn't pollute the environment
```
- You want to improve the tool?
```
nix-shell '<nixpkgs> -A miller  # note: -A instead of -p
# shell with miller's dependencies installed.. happy hacking
```

## Outline

- Nix Ecosystem
- Nix 101 - The basics
- Nix Modularity
- Advanced Nix Features
- Docker & Remote Builds
- NixOPS / NixOS
- References

# Nix Ecosystem

## Overview -- https://nixos.org/nix/

Nix is a package manager for *Linux and other Unix* that makes
package management *reliable* and *reproducible*.

It provides *atomic upgrades and rollbacks*,<br>
side-by-side installation of *multiple package versions*,
and *easy setup of build environments*


:::::::::::::: {.columns}
::: {.column width="50%"}
- Reliable
- Reproducible
- Great for developers
:::
::: {.column width="50%"}
- Multi-user, multi-version
- Source/binary model
- Portable
:::
::::::::::::::

## Nix History -- here to stay

The Purely Functional Software Deployment Model (Dolstra, PhD Thesis, 2006)

- C. 1. Nix Release 2.1 (2018-09-02)
- C. 2. Nix Release 2.0 (2018-02-22)
- C.17. Nix Release 1.0 (2012-05-11)
- C.32. Nix Release 0.6 (2004-11-14)


NixOS: A Purely Functional Linux Distro. (ICFP 2008)

- B. 1. NixOS Release 18.09 (“Jellyfish”, 2018/10/05)
- B.10. NixOS Release 13.10 (“Aardvark”, 2013/10/31)

<!--
## Nix is active

![](imgs/nix-activity-1month.png)
-->

## Nix is steadily growing

![](imgs/nix-activity-all.png)


## Nix Ecosystem at large

- **Nix** The Purely Functional Package Manager
- **Nixpkgs** The Nix Packages collection
- **NixOS** The Purely Functional Linux Distribution
- **NixOps** The NixOS Cloud Deployment Tool
- **Disnix** Distributed service deployment toolset
- **Hydra** Continuous build system

and more..

Focus on: **Nix/Nixpkgs**, maybe NixOps



# NIX 101<br>Let's get started
<!-- # Introduction to Nix(pkgs) -->

## The three main stages/commands

1. **nix-shell : build environments** <= our focus

    2. nix-build : building packages

        3. nix-env : "apt-get with rollback"

\

- new improved "nix" command to rule them all
  - currently only nix-build (and others)



## nix-env : "apt-get" with rollback

:::::::::::::: {.columns}
::: {.column width="50%"}
```
nix-env -i git     # git
nix-env -i kpcli   # kpcli, git
nix-env -e git     # kpcli
nix-env --rollback # kpcli, git
# nix-env --switch-generation 53
```
:::
::: {.column width="50%"}
```
$ nix-env --list-generations
53 2018-11-19 17:36:36 (before)
54 2018-11-20 18:27:25
55 2018-11-20 18:28:21 (current)
56 2018-11-20 18:29:07
```
:::
::::::::::::::
[
![](https://nixos.org/nix/manual/figures/user-environments.png){ width=60% }
](https://nixos.org/nix/manual/#fig-user-environments)

## nix-build: a too minimal example

```
// default.nix
pkgs = import <nixpkgs> {};
pkgs.stdenv.mkDerivation {
  name = "awesome-project";
  buildInputs = with pkgs; [git gradle curl nodejs];
  ... # and more to come
}
```
```
$ nix build  # defaults to build all of default.nix
```
fails, since not defined how to build
```
> builder for '/nix/store/nqyf....kf-awesome-projgect.drv' failed with exit code 1; last 2 log lines:
>   unpacking sources
>   variable $src or $srcs should point to the source
> [0 built (1 failed), 0.0 MiB DL]
> error: build of '/nix/store/nqyfn7kbfh98crcrzn9c2wx4fmj6z7kf-awesome-projgect.drv' failed
```

<!--
- specified only what is needed, not how to build
- import nix-expressions from channel \<nixpkgs\>
- define a derivation with name and version
- specify build dependencies
-->

<!--
## Nix-Shell: provides all dependencies

```
$ nix-shell minimal.nix --run 'which git gradle curl npm'
/nix/store/hbfjnla1p7qni7gdwd2j5ampyfmy55kz-git-2.19.1/bin/git
/nix/store/3f110h2fwmiabsw2rhw57sqjprbggrag-gradle-4.10/bin/gradle
/nix/store/0qklz87k9knxhimv6h9slizwrxm2fs9g-curl-7.61.1-bin/bin/curl
/nix/store/ghfhw6xza78bl7d340kipj06cazlircz-nodejs-8.11.4/bin/npm
```
- nix store keeps /nix/store/\$hash-\$name-\$version
- normal environment lacks tools

```
$ which git gradle curl npm
/Users/ale/.nix-profile/bin/git
gradle not found
/usr/bin/curl
npm not found
```
-->

<!--
## nix build : requires build command


```
$ nix build -f minimal.nix

> builder for '/nix/store/nqyfn7kbfh98crcrzn9c2wx4fmj6z7kf-awesome-projgect.drv' failed with exit code 1; last 2 log lines:
>   unpacking sources
>   variable $src or $srcs should point to the source
> [0 built (1 failed), 0.0 MiB DL]
> error: build of '/nix/store/nqyfn7kbfh98crcrzn9c2wx4fmj6z7kf-awesome-projgect.drv' failed
```

- Fails, because we did not specify how to build
- focus on nix-shell, ie. "build-environment" for now
-->

## mkDerivation: overridable "phases"


```
stdenv.mkDerivation { ...
  phases = ["buildPhase"];
  buildPhase = ''
    mkdir -p $out/bin     # $out where to place package data
    cat << EOF > $out/bin/awesome-version
    #!${stdenv.shell}               #!shebang
    ${gradle}/bin/gradle --version  # runtime dependency
    echo $(node --version)          # buildtime dependency
    EOF
    chmod +x $out/bin/awesome-version
  '';
}
```
- [unpack, patch, configure, build, install, check, fixup](https://nixos.org/nixpkgs/manual/#sec-stdenv-phases)
- default is like "configure; make install", but
- [language specific builders exist: Python, Haskell, etc.](https://nixos.org/nixpkgs/manual/#chap-language-support)

## nix-build: do it!

```
$ nix build
> these derivations will be built:
>  /nix/store/m107mj....6vxl-awesome-project.drv
> building '/nix/store/m107mj....6vxl-awesome-project.drv'...
> building /nix/store/ds8f2f....kg4kcs7gwfz8jg-awesome-project
```
<!--
> building '/nix/store/m107mji94027354yn14ih5qj3ky16vxl-awesome-project.drv'...
> building /nix/store/ds8f2f6pn1kh6as6j7kg4kcs7gwfz8jg-awesome-project
-->
- instantiates the derivation and builds the package
- result in /nix/store/\$hash-\$package is symlinked
```
$ ./result/bin/awesome-version  # test with symlink
$ nix-env -f default.nix -i     # install it
$ awesome-version               # run it
```
- Note: $out/bin is added to the PATH in nix-env/shell!
- [Note: "hooks" exists to provide such functionality](https://nixos.org/nixos/nix-pills/basic-dependencies-and-hooks.html)

<!--
```
nix-env -f minimal.nix -i; awesome-version  # runs; installed
nix-env --list-generation                   # gen x+1
>  52   2018-11-19 17:24:01 (current)

nix-env -e awesome-project; awesome-version # fails; uninstalled
nix-env --list-generations                  # gen x+2
>  52   2018-11-19 17:24:01
>  53   2018-11-19 17:36:36   (current)

nix-env --rollback; awesome-version         # gen x+1 => runs
>  52   2018-11-19 17:24:01   (current)
>  53   2018-11-19 17:36:36
```
-->


## Nix 101 -- The Summary

- Nix-Expression: define packages
- Derivation: concrete package (with fixed versions)
- Nix-Store: storage of all artifacts in /nix/store

### Typical commands

- nix-shell: build environment with dependencies
- nix [search | repl | build | log]  "since 2.0"
- and some more (not detailed)
    - nix-env: install a derivation in user env "apt-get"
    - nix-channel: "manage" what '\<nixpkgs\>' means

# Nix Modularity


## Organize with imports

```
// awesome.nix : extract derivation details
{ stdenv, git, gradle, curl, nodejs }: # indicate dependencies
stdenv.mkDerivation { name = "awesome-project"; ... };
```

```
// default.nix
with (import <nixpkgs> {});
callPackage ./awesome.nix {}; # simply import other files
```
- import expression is "substituted" by file content
- imports can be ./local, \<channel\>, git, tarball, etc.
```
callPackage ./awesome.nix {}; # convenience for import & call
# import ./awesome.nix { stdenv=stdenv; gradle=gradle; ... }
# callPackage ./awesome.nix { gradle = gradle_5 }; # overrides
```


## reproducibility: Pin nixpkgs version

- [nix-channel --update](https://nixos.wiki/wiki/Nix_Channels) evolves \<nixpkgs\> over time
- Reproducibility requires [pinning of nixpkgs](https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs)

```
# with (import <nixpkgs> {});          # unpinned, may change
with (import ./nixpkgs.pinned.nix {}); # pinned
stdenv.mkDerivation { name = "awesome-project"; ... };
```
```
// nixpkgs.pinned.nix
# git ls-remote \
#   https://github.com/nixos/nixpkgs-channels nixos-18.09
let rev = "03dc6471c12a0ef505ad8136ce07d47b332f2def";
in  import (builtins.fetchTarball {
  name = "nixos-18.09-2018-11-21"; # Descriptive name
  url = "https://github.com/nixos/nixpkgs/archive/${rev}.tar.gz";
})
```



## Overlays for package customization

```
nix-build && ./result/bin/awesome-version # Without Overlay
Gradle 4.10.2
JVM:  1.8.0_121 (Azul Systems, Inc. 25.121-b15)
Node: v8.12.0
```

```
# select/replace/patch packages using overlays
let overlay = self: super: { # self: nixpkgs after *all* overlays
  jdk = self.jdk11;          # super: nixpkgs before this overlay
  nodejs = self.nodejs-10_x;
}; in
with (import ./nixpkgs.pinned.nix { overlays = [overlay]; });
callPackage ./awesome.nix {}
```
```
nix-build && ./result/bin/awesome-version # With Overlay
Gradle 4.10.2
JVM:  11.0.1 (Azul Systems, Inc. 11.0.1+13-LTS)
Node: v10.12.0
```
- [Overlay dos and donts](https://blog.flyingcircus.io/2017/11/07/nixos-the-dos-and-donts-of-nixpkgs-overlays/)


## Custom gradle version

```
// default.nix
let overlay = import ./overlay.nix; in
with (import ./nixpkgs.pinned.nix { overlays = [overlay]; });
callPackage ./awesome.nix {}
```

```
// overlays.nix : extract overlays
self: super: {
  jdk = self.jdk11; nodejs = self.nodejs-10_x;
  gradle = self.gradleGen.gradleGen rec {
    name = "gradle-5.0-rc-3"; # bleding edge not yet in nixpkgs
    nativeVersion = "0.14";
    src = super.fetchurl { # remote need a hash
url = "http://services.gradle.org/distributions/${name}-bin.zip";
sha256 = "087ai9i4fs1fyywsryijvysi38p244n3knh3gcy163gwj2nj0jk8";
    }; }; }
```
```
nix-build && ./result/bin/awesome-version
Gradle 5.0-rc-3
JVM:  11.0.1 (Azul Systems, Inc. 11.0.1+13-LTS)
Node: v10.12.0
```


## Handling multiple derivations

```
// default.nix
let overlay = import ./overlay.nix; in
with (import ./nixpkgs.pinned.nix { overlays = [overlay]; });
{ # attribute set of derivations
  awesome = callPackage ./awesome.nix {};
  more-awesome = callPackage ./moreawesome.nix {};
}
```
```
nix-build -A more-awesome        # build selected derivation
nix-build                        # build all attributes
```

```
nix path-info -rS ./result-1 # more awsome's total closure size
/nix/store/18m8l...2sc20bz-Libsystem-osx-10.11.6	    8048744
/nix/store/n9hba...idyzxbz-bash-4.4-p23         	    9078736
/nix/store/qhyzy...1ii65ys-awesome-project-2.0  	    9080080
```

## Slides using [pandoc](https://pandoc.org) & [reveal.js](https://revealjs.com/#/)

- helper scripts become distributable

```
// revealjs.nix
{ fetchgit, pandoc, coreutils, writeShellScriptBin }: rec {
 reveal-js = fetchgit {
   url = "https://github.com/hakimel/reveal.js.git";
   rev = "65bdccd5807b6dfecad6eb3ea38872436d291e81";
   sha256="07460ij4v7l2j0agqd2dsg28gv18bf320rikcbj4pb54k5pr1218";
 };

 mkSlides = writeShellScriptBin "mkSlides" ''
   RJS=$(${coreutils}/bin/dirname $1)/reveal.js
   [ ! -e $RJS ] && ${coreutils}/bin/ln -s ${reveal-js} $RJS
   ${pandoc}/bin/pandoc -s -t revealjs -V revealjs-url=$RJS \
      --slide-level=2 $1 > $1.html
 '';
}
```
```
// overlay.nix
{ .. revealJs = super.callPackage ./revealjs.nix {}; .. }
```

## Shell.nix & Default.nix

```
// default.nix : define all derivation
...
{ awesome = ...; moreawesome = ...;
  slides = stdenv.mkDerivation {
    name = "Slides"; src = ./slides.md;
    buildInputs = [revealJs.mkSlides]; phases = [ "buildPhase" ];
    buildPhase = ''
      mkdir -p $out;
      cp $src $out/index.md;
      mkSlides $out/index.md; # create index.md.html from md
    '';
  };
}
```
```
// shell.nix : make a selection for used by nix-shell
(import ./default.nix).slides
```

```
$ nix-shell  # use shell.nix: mkSlides will be on path
$ nix-build  # builds all three default.nix derivations
```

# Advanced Functionality

## Inspect runtime dependencies

```
$ nix-build && nix-store -q --tree ./result # symlink to awesome
/nix/store/5khj2...x65fjqld2vv-awesome-project-1.0
+---/nix/store/n9hba...laxhidyzxbz-bash-4.4-p23
|   +---/nix/store/18m8l...6pvw2sc20bz-Libsystem-osx-10.11.6
|   |   +---/nix/store/18m8l....0bz-Libsystem-osx-10.11.6 [...]
|   +---/nix/store/n9hba0...axhidyzxbz-bash-4.4-p23 [...]
+---/nix/store/fiqcf2r2...rifb8pan-gradle-5.0-rc-3
    +---/nix/store/n9hba03...xhidyzxbz-bash-4.4-p23 [...]
    +---/nix/store/psmpz...lka0jlyjzb5-zulu11.2.3-jdk11.0.1
    |   +---/nix/store/h0a20...6g9rr6cbn47-hook
    |   +---/nix/store/psmpz...zb5-zulu11.2.3-jdk11.0.1 [...]
    +---/nix/store/fiqcf2r2i...ifb8pan-gradle-5.0-rc-3 [...]
```

```
$ nix path-info -rS ./result               # total closure size
/nix/store/18m8l...w2sc20bz-Libsystem-osx-10.11.6	    8048744
/nix/store/5khj2...fjqld2vv-awesome-project-1.0  	  416999280
/nix/store/fiqcf...rifb8pan-gradle-5.0-rc-3      	  416998576
/nix/store/h0a20...rr6cbn47-hook                 	        792
/nix/store/n9hba...hidyzxbz-bash-4.4-p23         	    9078736
/nix/store/psmpz...0jlyjzb5-zulu11.2.3-jdk11.0.1 	  310548928
```

## Price of reproducibility & isolation

- gradle requires a writable GRADLE_USER_HOME
  and needs to be set <small>(writes 'libnative-platform.dylib')</small>

```
name = "awesome-project-2.0";
buildPhase = ''
  export GRADLE_USER_HOME=$TMPDIR # set explicitly
  mkdir -p $out/bin
  cat << EOF > $out/bin/awesome-version
  #!${stdenv.shell}
  #  \${gradle}/bin/gradle --version #previously runtime dep
  echo "$(gradle --version)"     #buildtime dependency
  echo "Node: $(node --version)" #buildtime dependency
  EOF
  chmod +x $out/bin/awesome-version
'';
```
- fixup usually set artifact runtime-search-path (rpath)

## Overlays -- Back to the future

```
# self: all packages after *all* overlays applied
# super: all packages before this overlay
overlay = self: super: { # return: set of package modifications
  jdk = self.jdk11; # default is jdk = jdk8
  # gradle depends on jdk will use jdk11 now
  # jdk = self.jdk would create an infinite loop!
}
```

```
let # a // b combines sets with entries in b "winning"
  initial = {};
  first   = initial // (overlay1 final initial)
  second  = first   // (overlay2 final first)
  final   = second  // (overlay3 final second)
in final # laziness allows using final as input
```

- [Overlay dos and donts](https://blog.flyingcircus.io/2017/11/07/nixos-the-dos-and-donts-of-nixpkgs-overlays/)
- [Talk with implementation details (fixpoint ahead)](https://youtu.be/6bLF7zqB7EM?t=39m50s)


## TODO: SHELLHOOK

# Docker, NIX, and remote builder

## Nix / Docker Comparison

- Docker create isolated run environment
  - isolation includes network (eg. ports)
  - requires mounting folder, passing env vars
  - local builds differ? only jenkins in docker?

- Nix isolates at build (setting rpath etc)
  - no network isolation at runtime
  - but binaries/libraries are isolated
  - more modular than docker
  - but, smaller community than docker

## nix.dockerTools: the best of both?

TODO: reduce text

- nix is modular! mix and match content
  - various utilities to create users/etc.
  - [build-support/docker/examples.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/docker/examples.nix)
- "from scratch" or based on base image
  - single-layer or one-layer per 'derivation'*
  - include only the bare minimal dependencies

- builds images without docker interaction
  - but requires linux (not osx) binaries

## Building a docker image

TODO: document example; show more
```
rec {
  more-awesome = ... ;

  awesome-docker = dockerTools.buildImage {
     name = "awesome-docker"; tag = "latest";
     contents = [more-awesome];
     config.entrypoint = "${more-awesome}/bin/awesome-version";
  };
}
```
TODO: maybe show build/load here

## OSX/Docker suprise

TODO: combine with remote builders?

```
nix build -f . awesome-docker # make the image
docker load < ./result        # load it
docker run awesome-docker     # run it
> standard_init_linux.go:190: exec user process caused "exec format error"
# should work as is on linux, but platform mismatch on osx:
# cannot run osx binary in linux container!
```
- remote builder support
  - docker requires linux (not osx) binaries
  - cross-compilation or remote builder needed
  building on osx => linux binaries => remote builders


## Remote Builders : Delegate Builds

- transparently offload build to remote host
  - copies data to and results back from remote
- build on ssh accessible, nix-enabled hosts
  - configure ssh-credentials & and its capabilities
  - [LnL7/nix-docker](https://github.com/LnL7/nix-docker) on Mac for details

## Enforce linux-flavoured builds

```
# import "linux-flavoured" derivations
import <nixpkgs> { system = "x86_64-linux"; }
# but sure to have a linux remote builder on OSX
# OSX cannot build locally => must delegate
```

```
nix build -f . awesome-docker
docker load < ./result        # load it (just 9.7MB!)
docker run awesome-docker     # run it
> OS: Linux 4.9.93-linuxkit-aufs amd64
```

- make it command line selectable
```
// default.nix
{ system ? builtins.currentSystem  }: # cmdline arg with default
with (import <nixpkgs> { inherit system });
...
```
```
nix build -f .    # build for current sytem, linux or osx
nix build -f . --argstr system x86_64-linux  # build for linux
```

## Serve Slides via Docker/Nginx

```
let nginxPort = "80";
    nginxConf = writeText "nginx.conf" '' ... '';
in dockerTools.buildImage {
  name = "awesome-web"; tag = "latest";
  contents = [nginx];
  runAsRoot = ''
    #!${stdenv}.shell
    ${dockerTools.shadowSetup}
    groupadd --system nginx
    useradd --system --gid nginx nginx
  '';
  config = {
    Cmd = [ "nginx" "-c" nginxConf ];
    ExposedPorts = { "${nginxPort}/tcp" = {}; };
  };
}

```

::: notes

nice effects.. filename&path in docker and /nix/store are identical
error with filename is locally inspectable

:::



# NixOPS

## Maybe Quick look at nixops

```
nixops create -d intro intro-network.nix
nixops deploy -d intro
nixops ssh -d intro webserver
nixops destroy -d intro
nixops delete -d intro
```

TODO deploy slides via node1:nfs => node:nginx?


# References

## Documentation / References

- Nix Manual: https://nixos.org/nix/manual/
- Nix Pills: https://nixos.org/nixos/nix-pills/
- Packages: https://nixos.org/nixos/packages.html#
- Github: https://github.com/NixOS/nixpkgs
- https://nixos.wiki/wiki/Main_Page
- https://nixcloud.io/tour/?id=1

## Nice to know commands

nix edit nixpkgs.gradle
repl repl  => :l <nixpkgs>
nix log nixpkgs.jq
nix-store --verify --check-contents


## Expriment with packages (Adhoc)

```
which kpcli
> kpcli not found

nix-shell '<nixpkgs>' -p kpcli --run 'kpcli --help'
> Usage: .kpcli-wrapped [--kdb=<file.kdb>] [--key=<file.key>] ...
```


```
git --version  => git version 2.18.0
nix-shell '<nixpkgs>' -p git           # enter environment
git --version  => git version 2.19.1   # within nix-shell
exit                                   # leave environment
git --version  => git version 2.18.0
```

## drawbackes?

- Community is not mainstream, but still quite big
  => numbers: packages, contributors
- Packaging requires freezing "dynamic dependencies"
  => unavoidable for true multiversioning!
  => makes packaging more complicated
  => typically done by package maintainers!
- OSX has less packages than linux
  => but typicall git/curl/jdk things work well

## Todos:

- garbage collection
- jenkins integration (jenkinsfiles/node/agent)
- (nfs) shared local caches

- defining new nixos services
https://www.reddit.com/r/NixOS/comments/9yggp9/nixos_configuration/

