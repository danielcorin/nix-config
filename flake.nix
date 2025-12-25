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

        services.skhd = {
          enable = true;
          skhdConfig = ''
            # left half
            ctrl + alt + cmd - left : yabai -m window --grid 1:2:0:0:1:1

            # bottom half
            ctrl + alt + cmd - down : yabai -m window --grid 2:1:0:1:1:1

            # top half
            ctrl + alt + cmd - up : yabai -m window --grid 2:1:0:0:1:1

            # right half
            ctrl + alt + cmd - right : yabai -m window --grid 1:2:1:0:1:1

            # maximize
            ctrl + alt + cmd - m : yabai -m window --grid 1:1:0:0:1:1

            # top left corner
            ctrl + shift + alt - left : yabai -m window --grid 2:2:0:0:1:1

            # top right corner
            ctrl + shift + alt - up : yabai -m window --grid 2:2:1:0:1:1

            # bottom left corner
            ctrl + shift + alt - down : yabai -m window --grid 2:2:0:1:1:1

            # bottom right corner
            ctrl + shift + alt - right : yabai -m window --grid 2:2:1:1:1:1

            # prev display
            ctrl + alt - left : yabai -m window --display prev; yabai -m display --focus prev

            # next display
            ctrl + alt - right : yabai -m window --display next; yabai -m display --focus next

            hyper - f: open -a "Firefox"
            hyper - 2: open -a "Messages"
            hyper - r: open -a "Spotify"
            hyper - s: open -a "Slack"
            hyper - i: open -a "Cursor"
            hyper - p: open -a "1Password"
            hyper - space: open -a "Obsidian"
            hyper - a: open "https://calendar.google.com/"
            hyper - g: open "https://gmail.google.com/"
            hyper - u: open "https://console.anthropic.com/workbench?new=1"
            hyper - l: open "https://github.com/pulls"
            hyper - b: cursor "/Users/danielcorin/dev/lab/thought-eddies"
          '';
        };

        homebrew = {
          enable = true;
          onActivation = {
            autoUpdate = true;
            cleanup = "zap";
          };
          global.brewfile = true;
          brews = [
            "ast-grep"
            "cloudflared"
            "colima"
            "create-dmg"
            "deno"
            "jamescun/formulas/httplog"
            "jj"
            "just"
            "licenseplist"
            "llm"
            "lua"
            "node"
            "nowplaying-cli"
            "ollama"
            "pnpm"
            "repomix"
            "sqlite3"
            "switchaudio-osx"
            "temporal"
            "tctl"
            "uv"
            "wrangler"
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

        # Set the primary user for options that require it
        system.primaryUser = "danielcorin";

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
