{ config, pkgs, lib, ... }:

{
  home.file.".config/skhd/skhdrc" = {
    # FIXME: requires `skhd -r` to take effect
    # https://github.com/koekeishiya/skhd/issues/19
    text = ''
      # left half
      ctrl + alt + cmd - left : yabai -m window --grid 1:2:0:0:1:1

      # bottom half
      ctrl + alt + cmd - down : yabai -m window --grid 2:1:0:1:1:1

      # top half
      ctrl + alt + cmd - up : yabai -m window --grid 2:1:0:0:1:1

      # right half
      ctrl + alt + cmd - right : yabai -m window --grid 1:2:1:0:1:1

      # maximize
      ctrl + alt + cmd - m : yabai -m window --grid 1:1:0:0:1:1

      # top left corner
      ctrl + shift + alt - left : yabai -m window --grid 2:2:0:0:1:1

      # top right corner
      ctrl + shift + alt - up : yabai -m window --grid 2:2:1:0:1:1

      # bottom left corner
      ctrl + shift + alt - down : yabai -m window --grid 2:2:0:1:1:1

      # bottom right corner
      ctrl + shift + alt - right : yabai -m window --grid 2:2:1:1:1:1

      # prev display
      ctrl + alt - left : yabai -m window --display prev; yabai -m display --focus prev

      # next display
      ctrl + alt - right : yabai -m window --display next; yabai -m display --focus next

      hyper - f: open -a "Firefox"
      hyper - 2: open -a "Messages"
      hyper - r: open -a "Spotify"
      hyper - s: open -a "Slack"
      hyper - i: open -a "Cursor"
      hyper - p: open -a "1Password"
      hyper - space: open -a "Obsidian"
      hyper - a: open "https://calendar.google.com/"
      hyper - g: open "https://gmail.google.com/"
      hyper - u: open "https://console.anthropic.com/workbench?new=1"
      hyper - l: open "https://github.com/pulls"
      hyper - b: cursor "/Users/danielcorin/dev/lab/thought-eddies"
    '';
  };
}
