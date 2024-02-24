{
  description = "DCMBP Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [];

      environment.variables = {
        EDITOR = "vim";
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes repl-flake";

      nix.settings.trusted-users = [ "@admin" "danielcorin" ];

      nix.settings.max-jobs = 16;
      nix.settings.cores = 16;

      # Build Linux binaries
      nix.linux-builder.enable = true;

      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh = {
        enable = true;
        promptInit = "autoload -U promptinit && promptinit && prompt walters && setopt prompt_sp";
      };
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Unlocking sudo via fingerprint
      security.pam.enableSudoTouchIdAuth = true;

      system.defaults = {
        dock.orientation = "left";
        dock.autohide = true;
        dock.autohide-delay = 0.0;
        dock.showhidden = true;
        dock.show-recents = false;
        dock.tilesize = 32;
        dock.largesize = 48;
        dock.magnification = true;
        dock.mineffect = "suck";
        dock.launchanim = false;

        menuExtraClock.IsAnalog = true;
        screencapture.location = "~/Desktop";

        NSGlobalDomain.AppleShowAllExtensions = false;
        NSGlobalDomain.AppleShowScrollBars = "Always";
        NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;

        # TODO
        # NSGlobalDomain.NSStatusItemSelectionPadding = 6;
        # NSGlobalDomain.NSStatusItemSpacing = 6;
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .
    # "dcmbp" is the `hostname`
    darwinConfigurations."dcmbp" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.danielcorin = import ./home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."dcmbp".pkgs;
  };
}
