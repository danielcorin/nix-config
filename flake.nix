{
  description = "DCMBP Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs; [ ];

        nixpkgs.overlays = [ ];

        # nix.package = pkgs.nix;

        services.sketchybar = {
          enable = false;
        };

        # Necessary for using flakes on this system.
        nix.settings = {
          experimental-features = "nix-command flakes";
          trusted-users = [ "@admin" "danielcorin" ];
          max-jobs = 16;
          cores = 16;
        };

        # Build Linux binaries
        nix.linux-builder.enable = true;

        nix.extraOptions = ''
          extra-platforms = x86_64-darwin aarch64-darwin
        '';
        nix.gc = {
          automatic = true;
          interval = {
              Day = 7;
          };
          options = "--delete-older-than 7d";
        };

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh = {
          enable = true;
          # using starship
          # promptInit = "autoload -U promptinit && promptinit && prompt walters && setopt prompt_sp";
          shellInit = ''eval "$(/opt/homebrew/bin/brew shellenv)"'';
        };
        # programs.fish.enable = true;

        homebrew = {
          enable = true;
          onActivation = {
            autoUpdate = true;
            cleanup = "zap";
          };
          global.brewfile = true;
          brews = [
            "colima"
            "deno"
            "node"
            "llm"
            "lua"
            "nowplaying-cli"
            "ollama"
            "repomix"
            "sqlite3"
            "switchaudio-osx"
            "temporal"
            "tctl"
            "uv"
          ];
          casks = [
            "font-sf-mono"
            "font-sf-pro"
            "intellij-idea-ce"
            "keycastr"
            "macfuse"
            "sf-symbols"
            "Wezterm"
          ];
          taps = [
            "homebrew/bundle"
            "homebrew/cask-fonts"
            "homebrew/services"
            # custom
            "FelixKratz/formulae" # borders
          ];
        };

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Unlocking sudo via fingerprint
        security.pam.services.sudo_local.touchIdAuth = true;

        system.defaults = {
          dock = {
            orientation = "left";
            autohide = true;
            autohide-delay = 0.0;
            showhidden = true;
            show-recents = false;
            tilesize = 32;
            largesize = 48;
            magnification = true;
            mineffect = "suck";
            launchanim = false;
          };

          menuExtraClock = {
            IsAnalog = true;
          };

          screencapture.location = "~/Desktop";

          NSGlobalDomain = {
            AppleShowAllExtensions = false;
            AppleInterfaceStyle = "Dark";
            AppleFontSmoothing = 1;
            AppleShowScrollBars = "Always";
            NSAutomaticQuoteSubstitutionEnabled = false;
            # set key repeat to be faster
            InitialKeyRepeat = 18; # default: 68
            KeyRepeat = 1; # default: 6
            "com.apple.trackpad.scaling" = 1.0;
            "com.apple.sound.beep.feedback" = 0;
            _HIHideMenuBar = false;
          };

          trackpad = {
            Clicking = true;
          };

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
            home-manager.users.danielcorin = import ./home;
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."dcmbp".pkgs;
    };
}
