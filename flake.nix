{
  description = "DCMBP Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      ...
    }:
    {
      darwinConfigurations.dcmbp = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self; };
        modules = [
          ./hosts/dcmbp
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            # Activation aborts when a managed path already exists as a real
            # file. ccstatusline rewrites its own settings.json whenever the
            # file is missing, so it can reappear between build and switch;
            # move such files aside instead of failing the whole activation.
            home-manager.backupFileExtension = "hm-bak";
            home-manager.users.danielcorin = import ./home;
          }
        ];
      };

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;

      checks.aarch64-darwin.dcmbp = self.darwinConfigurations.dcmbp.system;
    };
}
