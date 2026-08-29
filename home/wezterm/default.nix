{
  # Homebrew owns the macOS app bundle; Home Manager owns its configuration.
  xdg.configFile."wezterm/wezterm.lua".source = ./config.lua;
}
