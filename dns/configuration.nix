{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./networking.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  nix.settings = {
    trusted-users = [ "%wheel" ];
    experimental-features = [ "nix-command" "flakes" ];
  };
  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  users.users.serv = {
    isNormalUser = true;
    description = "serv";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ wget vim emacs dig git wireguard-tools];

  system.stateVersion = "24.05"; # Did you read the comment?
}
