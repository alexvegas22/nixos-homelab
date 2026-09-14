{ config, pkgs, ... }:
{
  networking = {

    hostName = "nixos";
    networkmanager.enable = false;
    interfaces.ens18.ipv4.addresses = [{
      address = "192.168.2.51";
      prefixLength = 24;
    }];

    defaultGateway = {
      address = "192.168.2.1";
      interface = "ens18";
    };

    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "ens18";
      internalInterfaces = [ "wg0" ];
    };

    firewall = {
      checkReversePath = "loose";
      allowedUDPPorts = [
        53
        80
        443
        51820
      ];
      allowedTCPPorts = [
        22
        53
        80
        443

      ];

      interfaces.wg0 = {
        allowedUDPPorts = [
          22
          4444 # default i2p http proxy port
          4447 # default i2p socks proxy port
        ];
        allowedTCPPorts = [
          22
          4444 # default http proxy port
          4447 # default socks proxy port
          7070 # default web interface port
        ];
      };
    };

    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.1/24" ];
        listenPort = 51820;
        privateKeyFile = "/etc/wireguard/private.key";

        peers = [
          {
            publicKey = "dPL1mA0DGASZErmo5JpovNSWKgiIpPF9UtNGwoAzdD8=";
            allowedIPs = [ "10.100.0.2/32" ];
            persistentKeepalive = 25;
          }
          {
            publicKey = "U3HTKywUedDIn7mUhOvxxOnHl63+JUoLTEY0iWpXDyg=";
            allowedIPs = [ "10.100.0.3/32" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
