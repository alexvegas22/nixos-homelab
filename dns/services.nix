{ config, pkgs, ... }:
{
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "intl";
    };

    nginx = {
      enable = true;
      virtualHosts = {
        "v34l.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "https://192.168.3.1";
            proxyWebsockets = true;
            extraConfig = "proxy_ssl_server_name on;" + "proxy_pass_header Authorization;";
          };
        };

        "jg1g.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "https://192.168.1.5";
            proxyWebsockets = true;
            extraConfig = "proxy_ssl_server_name on;" + "proxy_pass_header Authorization;";
          };
        };
      };
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
