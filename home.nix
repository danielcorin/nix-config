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
    direnv
    fzf
    goku
    jq
    nodejs-18_x
    postgresql
    python3
    sqlite
    tree
    yarn
    zoxide

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

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

  programs.bat.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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
    };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    initExtra = ''
      function mcd () {
        mkdir -p "$1" && cd "$1";
      }

      function push() {
        git push origin $(git rev-parse --abbrev-ref HEAD)
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
      h = "history";
      o = "open .";

      # ls
      ls = "ls --color=auto";
      sl = "ls";
      "l." = "ls -ltrah";

      # git
      gs = "git status";
      gd = "git diff";
      gl = "git log";
      gds = "git diff --staged";
      gb = "git branch";

      # colorful cat
      cat = "bat";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
