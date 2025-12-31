{ config, pkgs, ... }:
{
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "intl";
    };

    nginx = {
      enable = true;

      streamConfig = ''
    map $ssl_preread_server_name $backend {
      v34l.com 192.168.3.1:443;
      jg1g.com 192.168.1.5:443;
      default 192.168.3.1:443;
    }

    server {
      listen 443;
      proxy_pass $backend;
      ssl_preread on;
    }

    server {
      listen 80;
      proxy_pass $backend;
      ssl_preread on;
    }
  '';
    };


    openssh.enable = true;
    dnsmasq = {
      enable = true;
      alwaysKeepRunning = true;
      settings = {
        server = [ "1.1.1.1" ];
        address = [ "/.v34l.com/192.168.3.1" "/.jg1g.com/192.168.1.5" ];
      };
    };
  };
}
