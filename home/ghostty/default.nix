{ lib, ... }:

let
  palette = import ../palette.nix;
in
{
  xdg.configFile."ghostty/config".text = ''
    font-family = Hack Nerd Font Mono
    font-size = 13

    # Monokai colors
    background = ${palette.background}
    foreground = ${palette.foreground}
    ${lib.concatImapStringsSep "\n" (i: c: "palette = ${toString (i - 1)}=#${c}") palette.ansi}

    cursor-style = bar
    cursor-style-blink = false

    macos-titlebar-style = tabs
    window-padding-x = 2
    window-padding-y = 2

    # Global hotkey to show/hide Ghostty (fires even when unfocused)
    keybind = global:ctrl+space=toggle_visibility

    # Navigate between panes with Cmd+Opt+Arrow
    keybind = cmd+opt+left=goto_split:left
    keybind = cmd+opt+right=goto_split:right
    keybind = cmd+opt+up=goto_split:top
    keybind = cmd+opt+down=goto_split:bottom
  '';
}
