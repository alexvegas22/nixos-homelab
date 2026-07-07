{
  description = "Server config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, inputs }: {
    formatter.x86_64-linux = "alejandra";
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./configuration.nix];
      specialArgs = {
        host = "nixos";
        username = "serv";
        inherit inputs;
      };
    };
  };
}
