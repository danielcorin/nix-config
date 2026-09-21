{ pkgs, ... }:

let
  homePackages = with pkgs; [
    chamber
    coreutils
    devbox
    docker
    fastfetch
    fd
    ffmpeg
    gh
    glow
    jq
    lazygit
    neovim
    nix-init
    nixfmt
    pngquant
    postgresql
    pre-commit
    railway
    rclone
    ripgrep
    rlwrap
    tree
    unison
    watchexec
    yt-dlp
  ];
in
{
  imports = [
    ./alacritty
    ./bat
    ./ccstatusline
    ./direnv
    ./eza
    ./fzf
    ./ghostty
    ./git
    ./karabiner
    ./skhd
    ./starship
    ./tmux
    ./wezterm
    ./zoxide
    ./zsh
  ];

  fonts.fontconfig.enable = true;

  home = {
    username = "danielcorin";
    homeDirectory = pkgs.lib.mkForce "/Users/danielcorin";

    # Preserve compatibility with the Home Manager release that initialized this home.
    stateVersion = "23.11";

    packages = homePackages;
  };

  programs.home-manager.enable = true;
}
