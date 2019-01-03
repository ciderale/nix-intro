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
      imports = [ ./jenkins.nix ];

      services.httpd.enable = true;
      services.httpd.adminAddr = "alice@example.org";
      services.httpd.documentRoot = "${slides}";
      networking.firewall.allowedTCPPorts = [ 80  8080 ];

      virtualisation.docker.enable = true;

      environment.systemPackages = with pkgs; [
          vim git nfs-utils docker
          zsh wget htop nmap netcat telnet
      ];

      fileSystems."/mnt/remote" =
        { fsType = "nfs4";
          device = "fileserver:/data";
          options = ["x-systemd.automount" "noauto"];
        };

    };

  # Configure SERVER 2
  fileserver = {config, pkgs, ...}:
    { inherit deployment;
      programs.vim.defaultEditor = true;

      services.nfs.server.enable = true;
      services.nfs.server.exports = ''
      /data  192.168.56.0/255.255.255.0(rw,no_root_squash,no_acl)
      '';

      services.nfs.server.createMountPoints = true;
      services.nfs.server.statdPort = 4000;
      services.nfs.server.lockdPort = 4001;
      networking.firewall.allowedTCPPorts = [ 2049 111 4000 4001 ];
      networking.firewall.allowedUDPPorts = [ 2049 111 4000 4001 ];
    };
}
