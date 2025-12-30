{ config, pkgs, ... }:

{
  imports = [	./hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    interfaces.ens18.ipv4.addresses = [{
      address = "192.168.2.51";
      prefixLength = 22;
    }];
    defaultGateway = {
      address = "192.168.0.1";
      interface = "ens18";
    };
  };
  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.vm = {
    isNormalUser = true;
    description = "vm";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ wget vim emacs dig git];

  services = {
    xserver.xkb = {
      layout = "us";
      variant = "intl";
    };
    
    nginx = {
      enable = true;
      virtualHosts = {
        "v34l.com" = {
          # enableACME = true;
          # forceSSL = true;
          locations."/" = {
            proxyPass = "https://192.168.3.1";
            proxyWebsockets = true;
            # extraConfig = "proxy_ssl_server_name on;" + "proxy_pass_header Authorization;"
          };
        };
        
        "jg1g.com" = {
          # enableACME = true;
          # forceSSL = true;
          locations."/" = {
            proxyPass = "https://192.168.1.5";
            proxyWebsockets = true;
            # extraConfig = "proxy_ssl_server_name on;" + "proxy_pass_header Authorization;"
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
        address = [ "/.v34l.com/192.168.3.1" ];
      };
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 22 53 ];
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
