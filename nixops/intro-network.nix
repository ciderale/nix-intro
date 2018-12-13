let
  slides = (import ../packages {}).intro;
  pkgs = import ../packages/nixpkgs.pinned.nix { system = "x86_64-linux"; };
  base = import ./vmbaseimage.nix { inherit pkgs; };

  deployment = {
    targetEnv = "virtualbox";
    virtualbox = {
        disks.disk1.baseImage = base;
        memorySize = 1024;
        headless = true;
    };
  };

in {

  # Configure SERVER 1
  webserver = {config, pkgs, ...}:
    { inherit deployment;

      services.httpd.enable = true;
      services.httpd.adminAddr = "alice@example.org";
      services.httpd.documentRoot = "${slides}";
      networking.firewall.allowedTCPPorts = [ 80 ];

      environment.systemPackages = with pkgs; [
          vim git nfs-utils
          zsh wget htop nmap netcat telnet
      ];
    };

  # Configure SERVER 2
#  fileserver = {config, pkgs, ...}:
#    { inherit deployment;
#      programs.vim.defaultEditor = true;
#    };
}
