{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];

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

  networking.firewall = {
    allowedUDPPorts = [ 53 80 443 ];
    allowedTCPPorts = [ 22 53 80 443 ];
  };

  security.acme = {
    acceptTerms = true;
    certs = {
      "v34l.com" = {
        email = "your-email@example.com"; # Replace with your email
      };

      "jg1g.com" = {
        email = "your-email@example.com"; # Replace with your email
      };
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
