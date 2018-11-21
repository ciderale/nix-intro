{ nginx, data,
  stdenv, writeText, dockerTools }:

let
    nginxPort = "80";
    nginxConf = writeText "nginx.conf" ''
      user nginx nginx;
      daemon off;
      error_log /dev/stdout info;
      pid /dev/null;
      events {}
      http {
        access_log /dev/stdout;
        include ${nginx}/conf/mime.types;
        server {
          listen ${nginxPort};
          index index.md.html;
          location / {
            root ${data};
          }
        }
      }
    '';
in

dockerTools.buildImage {
  name = "awesome-web";
  tag = "latest";
  contents = [nginx];

  runAsRoot = ''
    #!${stdenv}.shell
    ${dockerTools.shadowSetup}
    groupadd --system nginx
    useradd --system --gid nginx nginx
  '';

  config = {
    Cmd = [ "nginx" "-c" nginxConf ];
    ExposedPorts = {
      "${nginxPort}/tcp" = {};
    };
  };
}
