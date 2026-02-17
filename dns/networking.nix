{ config, pkgs, ... }:
{
  networking = {

    hostName = "nixos";
    networkmanager.enable = false;
    interfaces.ens18.ipv4.addresses = [{
      address = "192.168.2.51";
      prefixLength = 22;
    }];

    defaultGateway = {
      address = "192.168.0.1";
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
      allowedUDPPorts = [ 53 80 443 51820 ];
      allowedTCPPorts = [ 22 53 80 443 ];

      interfaces.wg0 = {
        allowedUDPPorts = [ 22 ];
        allowedTCPPorts = [ 22 ];
      };
    };

    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.1/24" ];
        listenPort = 51820;
        privateKeyFile = "/etc/wireguard/private.key";

        peers = [
          {
            publicKey = "utepZiXZv6WKhzNibICH6HWQoHtAC6h1HhUkr5mcjXg=";
            allowedIPs = [ "10.100.0.2/32" ];
          }
          {
            publicKey = "U3HTKywUedDIn7mUhOvxxOnHl63+JUoLTEY0iWpXDyg=";
            allowedIPs = [ "10.100.0.3/32" ];
          }
        ];
      };
    };
  };
}
