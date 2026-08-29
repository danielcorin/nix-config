{ self, ... }:

{
  imports = [
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/macos-defaults.nix
    ../../modules/darwin/nix.nix
  ];

  environment.systemPackages = [ ];
  nixpkgs.overlays = [ ];
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    primaryUser = "danielcorin";

    # Preserve compatibility with the nix-darwin release that initialized this host.
    stateVersion = 5;
  };
}
