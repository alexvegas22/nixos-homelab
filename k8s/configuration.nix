{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.k3s = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };

  networking.firewall.allowedTCPPorts = [
    6443
    2379
    2380
  ];
  networking.firewall.allowedUDPPorts = [
    8472
  ];


  services.k3s = {
    enable = true;
    role = "server";
    token = "<randomized common secret>";
    clusterInit = true;
  };


  environment.systemPackages = with pkgs; [
    nfs-utils
  ];

  system.stateVersion = "24.05";
}
