{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "danielcorin";
  home.homeDirectory = pkgs.lib.mkForce (
    "/Users/danielcorin"
  );


  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    awscli
    bat
    chamber
    coreutils
    devbox
    difftastic
    direnv
    eza
    fd
    fzf
    glow
    goku
    jq
    nixpkgs-fmt
    nodejs-18_x
    postgresql
    python3
    pipx
    skhd
    sqlite
    tmux
    tree
    typst
    unison
    watchexec
    yabai
    yarn
    zoxide

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (nerdfonts.override { fonts = [ "Hack" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/danielcorin/etc/profile.d/hm-session-vars.sh
  #

  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = true;
      colors = {
        normal = {
          black = "#333333";
          red = "#C4265E";
          green = "#86B42B";
          yellow = "#B3B42B";
          blue = "#6A7EC8";
          magenta = "#8C6BC8";
          cyan = "#56ADBC";
          white = "#e3e3dd";
        };
        bright = {
          black = "#666666";
          red = "#f92672";
          green = "#A6E22E";
          yellow = "#e2e22e";
          blue = "#819aff";
          magenta = "#AE81FF";
          cyan = "#66D9EF";
          white = "#f8f8f2";
        };
        cursor = {
          cursor = "0xd8d8d8";
          text = "0x181818";
        };
      };

      cursor = {
        style = "Beam";
        unfocused_hollow = false;
        thickness = 0.2;
      };

      selection = {
        save_to_clipboard = true;
      };

      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = ["--login" "-c" "tmux new-session -A -s main-alacritty"];
      };

      font = {
        normal = {
          family = "Hack Nerd Font Mono";
          style = "Regular";
        };
        italic = {
          family = "Hack Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "Hack Nerd Font Mono";
          style = "Italic";
        };
        bold = {
          family = "Hack Nerd Font Mono";
          style = "Bold";
        };
        size = 14.0;
      };
      keyboard.bindings = [
        # ⌘ + enter puts window in macOS full screen
        { key = "Enter"; mods = "Command"; action = "ToggleFullscreen"; }
        # opt + right and left jump between words
        { key = "Right"; mods = "Alt"; chars = "\\u001BF"; }
        { key = "Left"; mods = "Alt"; chars = "\\u001BB"; }
        # ⌘ + d adds a pane to the right (splits window vertically)
        { key = "D"; mods = "Command"; chars = "\\u0002%"; }
        # ⌘ + ⇧ + d adds a pane below (splits window horizontally)
        { key = "D"; mods = "Command|Shift"; chars = "\\u0002\""; }
        # ⌘ + w prompts you to close the pane; "y" to confirm
        { key = "W"; mods = "Command"; chars = "\\u0002x"; }
        # ⌘ + arrows are for directional navigation around the panes
        { key = "Down"; mods = "Command"; chars = "\\u0002\\u001b[B"; }
        { key = "Up"; mods = "Command"; chars = "\\u0002\\u001b[A"; }
        { key = "Left"; mods = "Command"; chars = "\\u0002\\u001b[D"; }
        { key = "Right"; mods = "Command"; chars = "\\u0002\\u001b[C"; }
        # ⌘ + ⇧ + enter maximizes the pane within the alacritty window
        { key = "Enter"; mods = "Command|Shift"; chars = "\\u0002z"; }
      ];

      window = {
        padding = {
          x = 2;
          y = 2;
        };
        decorations = "Full";
        dynamic_padding = true;
        dynamic_title = true;
        startup_mode = "Maximized";
      };
    };
  };

  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    extraOptions = [ "--group-directories-first" ];
    icons = true;
    git = true;
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type file --hidden";

    defaultOptions = [
      "--height='80%'"
      "--marker='* '"
      "--pointer='▶'"
      "--preview-window='right:60%'"
      "--bind='ctrl-p:toggle-preview'"
      "--bind='alt-a:select-all'"
      "--bind='alt-n:deselect-all'"
      "--bind='ctrl-f:jump'"
    ];
  };

  programs.git = {
    enable = true;
    userName = "Dan Corin";
    userEmail = "dcorin6@gmail.com";
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      github.user = "danielcorin";
      push.default = "tracking";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
    difftastic = {
      enable = true;
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 100000;
    mouse = true;
    extraConfig = ''
      # Set status bar on
      set -g status on

      # Update the status line every second
      set -g status-interval 1

      # Set the position of window lists.
      set -g status-justify centre # [left | centre | right]

      # Set Vi style keybinding in the status line
      set -g status-keys vi

      # Set the status bar position
      set -g status-position top # [top, bottom]

      # Set status bar background and foreground color.
      set -g status-style fg=colour136,bg="#002b36"

      # Set left side status bar length and style
      set -g status-left-length 60
      set -g status-left-style default

      # Display the session name
      set -g status-left "#[fg=green] ❐ #S #[default]"

      # Display the os version (Mac Os)
      set -ag status-left " #[fg=black] #[fg=green,bright]  #(sw_vers -productVersion) #[default]"

      # Display the battery percentage (Mac OS)
      set -ag status-left "#[fg=green,bg=default,bright] 🔋 #(pmset -g batt | tail -1 | awk '{print $3}' | tr -d ';') #[default]"

      # Set right side status bar length and style
      set -g status-right-length 140
      set -g status-right-style default

      # Display the cpu load (Mac OS)
      set -g status-right "#[fg=green,bg=default,bright]  #(top -l 1 | grep -E "^CPU" | sed 's/.*://') #[default]"

      # Display the date
      set -ag status-right "#[fg=white,bg=default]  %a %d #[default]"

      # Display the time
      set -ag status-right "#[fg=colour172,bright,bg=default] ⌚︎%l:%M %p #[default]"

      # Display the hostname
      set -ag status-right "#[fg=cyan,bg=default] ☠ #H #[default]"

      # dim inactive pane
      set -g window-style 'fg=color8,bg=default'
      set -g window-active-style 'fg=color7,bg=default'
    '';
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      extended = true;
    };
    initExtra = ''
      function mcd () {
        mkdir -p "$1" && cd "$1";
      }

      function now() {
        if [ $# -eq 0 ]; then
          date +%s;
        else
          date -d @$1;
        fi
      }

      eval "$(zoxide init zsh)"
    '';
    shellAliases = {
      dr = "darwin-rebuild switch --flake ~/.config/nix/flake.nix";
      h = "history";
      o = "open .";

      # ls
      ls = "eza --color=auto";
      sl = "eza --color=auto";
      ll = "eza -l --color=auto";
      "l." = "eza -la --color=auto";

      # git
      gs = "git status";
      gd = "git diff";
      gl = "git log";
      gds = "git diff --staged";
      gb = "git branch";
      gp = "git pull";
      ggm = "git checkout main";
      push = "git push origin $(git rev-parse --abbrev-ref HEAD)";

      # colorful cat
      cat = "bat";

      # python
      ea = ". env/bin/activate";

      # caffeinate
      caf = "pgrep caffeinate > /dev/null && echo '☕' || echo '💤'";
      tcaf = "pgrep caffeinate > /dev/null && kill $(pgrep caffeinate) || caffeinate -dim &";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
