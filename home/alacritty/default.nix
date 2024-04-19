{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = true;
      colors = {
        primary = {
          background = "#1E1F1C";
        };
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
        dim = {
          black = "#1c1c1c";
          red = "#ff6565";
          green = "#93d44f";
          yellow = "#eab93d";
          blue = "#204a87";
          magenta = "#ce5c00";
          cyan = "#89b6e2";
          white = "#cccccc";
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
        args = [ "--login" "-c" "tmux new-session -A -s main-alacritty" ];
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
        size = 13.0;
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
        decorations = "Buttonless";
        dynamic_padding = true;
        dynamic_title = true;
        startup_mode = "Maximized";
      };
    };
  };
}
