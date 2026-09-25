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
    let
      username = "danielcorin";
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in
    {
      darwinConfigurations.dcmbp = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self username; };
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
            home-manager.extraSpecialArgs = { inherit username; };
            home-manager.users.${username} = import ./home;
          }
        ];
      };

      formatter.aarch64-darwin = pkgs.nixfmt-tree;

      checks.aarch64-darwin = {
        dcmbp = self.darwinConfigurations.dcmbp.system;

        # Unused bindings and lambda arguments.
        deadnix = pkgs.runCommand "deadnix" { } ''
          ${pkgs.deadnix}/bin/deadnix --fail ${self}
          touch $out
        '';

        # Anti-patterns and deprecated constructs.
        statix = pkgs.runCommand "statix" { } ''
          ${pkgs.statix}/bin/statix check --config ${self}/statix.toml ${self}
          touch $out
        '';
      };
    };
}
