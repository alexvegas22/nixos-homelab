{ config, pkgs, ... }:
{
  services = {
    factorio = {
      enable = true;
      description = "Veal's factorio server";
      openFirewall = true;
      lan = true;
      game-name = "Veal's World";
      admins = [ "veal" ];
      port = 34197;
    };

    xserver.xkb = {
      layout = "us";
      variant = "intl";
    };
    avahi.enable = true;
    nginx = {
      enable = true;

      streamConfig = ''
    map $ssl_preread_server_name $backend {
      ~^(.+)\.v34l\.com 192.168.3.50:443;
      v34l.com 192.168.3.50:443;
      ~^(.+)\.m15ty\.com 192.168.3.50:443;
      m15ty.com 192.168.3.50:443;
      ~^(.+)\.jg1g\.com 192.168.4.10:443;
      jg1g.com 192.168.4.10:443;
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

    i2pd = {
      enable = true;
      address = "0.0.0.0";
      ifname = "wg0";
      port = 10110;
      ntcp2.port = 10112 ;
      proto = {
        http.enable = true;
        socksProxy.enable = true;
        httpProxy.enable = true;
        sam.enable = true;
      };
    };


    openssh.enable = true;
  };
}
