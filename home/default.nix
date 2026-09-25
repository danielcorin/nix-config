{ pkgs, username, ... }:

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
    ./bat
    ./ccstatusline
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
    inherit username;

    # Preserve compatibility with the Home Manager release that initialized this home.
    stateVersion = "23.11";

    packages = homePackages;
  };

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # No plugins need the Ruby or Python providers.
    withRuby = false;
    withPython3 = false;
  };
}
