local wezterm = require 'wezterm'

return {
  -- Update the config when changes are detected
  automatically_reload_config = true,

  -- Hide traffic lights but allow window resizing
  window_decorations = "RESIZE",

  -- Set the font settings
  font_size = 13.0,

  -- Dim inactive panes
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.7,
  },

  -- Cursor Style
  default_cursor_style = "SteadyBar",
  cursor_thickness = "0.1",

  color_scheme = "Monokai (dark) (terminal.sexy)",

  keys = {
    -- Pane splitting
    {
      key = 'd',
      mods = 'CMD',
      action = wezterm.action.SplitHorizontal
    },
    {
      key = 'd',
      mods = 'SHIFT|CMD',
      action = wezterm.action.SplitVertical
    },
    -- Pane closing
    {
      key="w",
      mods="CMD",
      action = wezterm.action{CloseCurrentPane={confirm=true}}
    },
    -- Pane full screen
    {
      key = 'Enter',
      mods = 'CMD|SHIFT',
      action = wezterm.action.TogglePaneZoomState,
    },
    -- Command prompt word navigation
    {key="LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb"}},
    {key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"}},

    -- Pane navigation
    {key="UpArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Up")},
    {key="DownArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Down")},
    {key="LeftArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Left")},
    {key="RightArrow", mods="CMD", action=wezterm.action.ActivatePaneDirection("Right")},

    -- Command+option+arrows to move between tabs
    {key="LeftArrow", mods="CMD|OPT", action=wezterm.action.ActivateTabRelative(-1)},
    {key="RightArrow", mods="CMD|OPT", action=wezterm.action.ActivateTabRelative(1)},

    -- Clear terminal
    {
      key = 'k',
      mods = 'CMD',
      action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
    },
  }
}
