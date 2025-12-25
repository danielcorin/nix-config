{ config, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  fonts = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses.
    nerd-fonts.hack

  ];

  systemPackages = with pkgs; [
    bat
    bun
    cargo
    chamber
    coreutils
    delta
    devbox
    direnv
    docker
    eza
    fd
    ffmpeg
    fzf
    gh
    git-lfs
    glow
    go
    goku
    jq
    lazygit
    neofetch
    neovim
    nix-init
    nixpkgs-fmt
    pipx
    pngquant
    postgresql
    pre-commit
    python3
    railway
    rclone
    ripgrep
    rlwrap
    rustc
    tmux
    tree
    unison
    watchexec
    yabai
    yarn
    yt-dlp
    zoxide
  ];
in
{
  imports = [
    ./alacritty
    ./bat
    ./direnv
    ./eza
    ./fzf
    ./git
    ./karabiner
    ./starship
    ./tmux
    ./wezterm
    ./zsh
  ];

  fonts.fontconfig.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "danielcorin";
    homeDirectory = pkgs.lib.mkForce (
      "/Users/danielcorin"
    );

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ] ++ systemPackages ++ fonts;

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';

      # https://github.com/direnv/direnv/issues/73#issuecomment-392342423
      ".direnvrc".text = ''
      export_function() {
        local name=$1
        local alias_dir=$PWD/.direnv/aliases
        mkdir -p "$alias_dir"
        PATH_add "$alias_dir"
        local target="$alias_dir/$name"
        if declare -f "$name" >/dev/null; then
          echo "#!$SHELL" > "$target"
          declare -f "$name" >> "$target" 2>/dev/null
          # Notice that we add shell variables to the function trigger.
          echo "$name \$*" >> "$target"
          chmod +x "$target"
        fi
      }
      '';
    };
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
