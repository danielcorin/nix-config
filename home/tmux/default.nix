{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    # The default 500ms makes Esc feel sluggish in Neovim.
    escapeTime = 10;
    historyLimit = 100000;
    mouse = true;
    extraConfig = ''
      set -g status off

      # Pass truecolor through from the outer terminal.
      set -as terminal-features ",xterm-256color:RGB,xterm-ghostty:RGB"

      # Set inactive pane border color to gray
      set -g pane-border-style fg=color0

      # Set active pane border color to white
      set -g pane-active-border-style fg=white
    '';
  };

}
