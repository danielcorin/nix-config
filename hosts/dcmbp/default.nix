{ self, username, ... }:

{
  imports = [
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/macos-defaults.nix
    ../../modules/darwin/nix.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Home Manager derives home.homeDirectory from this.
  users.users.${username}.home = "/Users/${username}";

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    primaryUser = username;

    # Preserve compatibility with the nix-darwin release that initialized this host.
    stateVersion = 5;
  };
}
