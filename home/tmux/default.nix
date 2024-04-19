{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 100000;
    mouse = true;
    extraConfig = ''
      set -g status off
      # Set inactive pane border color to gray
      set -g pane-border-style fg=color0

      # Set active pane border color to white
      set -g pane-active-border-style fg=white
    '';
  };

}
