{ config, pkgs, ... }:

{
  xdg.configFile."ghostty/config".text = ''
    font-family = Hack Nerd Font Mono
    font-size = 13

    # Monokai colors
    background = 1e1f1c
    foreground = f8f8f2

    # Normal colors
    palette = 0=#333333
    palette = 1=#c4265e
    palette = 2=#86b42b
    palette = 3=#b3b42b
    palette = 4=#6a7ec8
    palette = 5=#8c6bc8
    palette = 6=#56adbc
    palette = 7=#e3e3dd

    # Bright colors
    palette = 8=#666666
    palette = 9=#f92672
    palette = 10=#a6e22e
    palette = 11=#e2e22e
    palette = 12=#819aff
    palette = 13=#ae81ff
    palette = 14=#66d9ef
    palette = 15=#f8f8f2

    cursor-style = bar
    cursor-style-blink = false

    macos-titlebar-style = tabs
    window-padding-x = 2
    window-padding-y = 2

    # Navigate between panes with Cmd+Opt+Arrow
    keybind = cmd+opt+left=goto_split:left
    keybind = cmd+opt+right=goto_split:right
    keybind = cmd+opt+up=goto_split:top
    keybind = cmd+opt+down=goto_split:bottom
  '';
}
