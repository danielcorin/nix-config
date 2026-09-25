# Monokai, shared by every config that sets colors by hand. Values are bare
# RRGGBB so each consumer can add the prefix its format expects.
rec {
  background = "1e1f1c";
  foreground = "f8f8f2";

  # ANSI 0-15, in terminal palette order.
  ansi = [
    # Normal
    "333333"
    "c4265e"
    "86b42b"
    "b3b42b"
    "6a7ec8"
    "8c6bc8"
    "56adbc"
    "e3e3dd"
    # Bright
    "666666"
    "f92672"
    "a6e22e"
    "e2e22e"
    "819aff"
    "ae81ff"
    "66d9ef"
    "f8f8f2"
  ];

  # Named accents. Most are bright ANSI entries; orange, yellow and comment are
  # Monokai syntax colors with no terminal-palette slot.
  pink = builtins.elemAt ansi 9;
  green = builtins.elemAt ansi 10;
  blue = builtins.elemAt ansi 12;
  purple = builtins.elemAt ansi 13;
  cyan = builtins.elemAt ansi 14;
  orange = "fd971f";
  yellow = "e6db74";
  comment = "75715e";
}
