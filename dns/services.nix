{ config, pkgs, ... }:
{
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "intl";
    };
    avahi.enable = true;
    nginx = {
      enable = true;

      streamConfig = ''
    map $ssl_preread_server_name $backend {
      ~^(.+)\.v34l\.com 192.168.3.1:443;
      v34l.com 192.168.3.1:443;
      ~^(.+)\.jg1g\.com 192.168.1.5:443;
      jg1g.com 192.168.1.5:443;
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
        listen-address = [
          "127.0.0.1"
          "192.168.2.51"
          "10.100.0.1"
        ];

        bind-interfaces = true;
        local-service = false;
        interface = [ "ens18" "wg0" ];
        server = [ "1.1.1.1" ];
        address = [
          "/home.v34l.com/192.168.2.52"
          "/.v34l.com/192.168.3.1"
          "/.jg1g.com/192.168.1.5"
        ];
      };
    };
  };
}
