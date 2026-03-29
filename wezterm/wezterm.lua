local wezterm = require("wezterm")
local config = wezterm.config_builder()
wezterm.on("gui-startup", function(cmd)
  local screen = wezterm.gui.screens().active
  local ratio = 0.7
  local width, height = screen.width * ratio, screen.height * ratio
  local _, _, window = wezterm.mux.spawn_window(cmd or {
    position = { x = (screen.width - width) / 2, y = (screen.height - height) / 2 },
  })
  window:gui_window():set_inner_size(width, height) -- window:gui_window():maximize()
end)

config.initial_cols = 120
config.initial_rows = 28

config.font_size = 10
config.color_scheme = "Tango (terminal.sexy)"
config.font = wezterm.font("JetBrainsMono NF")
config.window_background_opacity = 80 / 100

config.window_close_confirmation = "NeverPrompt"
config.tab_bar_at_bottom = true
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

return config
