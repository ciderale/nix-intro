# Introduction and exploration of *nix* and its ecosystem

## Installation of nix

- https://nixos.org/nix/download.html
- `curl https://nixos.org/nix/install | sh`

## Basic nix examples: the 'awesome' script

A simple shell script called 'awesome' is used to demonstrate
the multi-version capabilities of 'nix'. More specifically, by
commenting two lines in 'packages/overlay.nix' one can change
the used version of node and the jdk used by gradle.

- `nix build`: builds all attributes in default.nix. That is
  two versions of 'awesome' and the presentation slides explaining
  all the steps in this repository in more detail.
- the results are symlinked in `./result*`.
- `./result/bin/awesome-version` displays the node/gradle version
- (un)comment the marked lines in packages/overlay.nix, `nix build`,
  re-run `./result/bin/awesome-version`, and observe the changed version.

## Reproducible build environment

- `nix-shell`: creates an build environment with various programs
  provided through the `/nix/store` in a pinned version.
  `which mkSlides gradle npm docker`.
- `mkSlides slides.md` builds the slides using reveal.js & pandoc

## Nix/Docker example

Nix can be used to build docker images. However, a linux binary
must be build, because we cannot execute an e.g. MacOS binary
within the docker container. Therefore, this example must be run
on a linux system, or a or a remote builder for system 'x86_64-linux'
and 'kvm' capabilities must be configured (https://github.com/LnL7/nix-docker) (https://github.com/LnL7/nix-docker).


- `nix build -f docker.nix`
- `nix-shell`
- `docker load < ./result`
- `docker run --rm awesome-docker`

## NixOps example

Note that this examples requires a linux system, or
a remote builder for system 'x86_64-linux' and 'kvm' capabilities.

- `nix-shell`   # provides us with nixops
- `nixops create -d intro nixops/intro-network.nix`
- `nixops deploy -d intro`
- `WEBSERVERIP=$(nixops info -d intro --plain | awk '{print $5}')`
- `open http://$WEBSERVERIP/index.md.html`
- `nixops destroy -d intro`
- `nixops delete -d intro`
