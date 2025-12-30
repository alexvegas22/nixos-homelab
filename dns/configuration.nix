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
      config = ''
server {
    listen 80;
    server_name *.v34l.com;

    location / {
        proxy_pass http://192.168.3.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 80;
    server_name *.jg1g.com;

    location / {
        proxy_pass http://192.168.1.5;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
'';
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
