local wezterm = require('wezterm')
local gpu_adapters = require('utils.gpu_adapter')
local theme_utils = require('utils.theme_utils')
local colors = require('colors.custom')

local get_theme = theme_utils.get_theme
local getDefaultColors = theme_utils.getDefaultColors

wezterm.on('update-right-status', function(window, pane)
   local theme = get_theme()
   if window:get_config_overrides().color_scheme ~= theme then
      window:set_config_overrides({ color_scheme = theme })
      wezterm.log_info('Theme changed to: ' .. theme)
   end
end)

wezterm.on('timer', function(window, pane)
   wezterm.reload_configuration()
end)

return {
   animation_fps = 60,
   max_fps = 60,
   front_end = 'WebGpu',
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = gpu_adapters:pick_best(),

   -- color scheme
   colors = colors,
   color_scheme = get_theme(),

   -- background
   background = {
      {
         source = { File = wezterm.GLOBAL.background },
         horizontal_align = 'Center',
      },
      {
         source = { Color = getDefaultColors(get_theme()).background },
         height = '100%',
         width = '100%',
         opacity = 0.96,
      },
   },

   -- tab bar
   enable_tab_bar = true,
   hide_tab_bar_if_only_one_tab = true,
   use_fancy_tab_bar = false,
   tab_max_width = 25,
   show_tab_index_in_tab_bar = false,
   switch_to_last_active_tab_when_closing_tab = true,
   tab_bar_at_bottom = true,

   -- window
   window_padding = {
      left = '0.5cell',
      right = 0,
      top = 0,
      bottom = 0,
   },
   window_close_confirmation = 'NeverPrompt',
   window_decorations = 'RESIZE',

   inactive_pane_hsb = {
      saturation = 0.9,
      brightness = 0.65,
   },

   -- other
   use_dead_keys = false,
   selection_word_boundary = ' \t\n{}[]()"\'`,;:@',
   line_height = 1.25,
   bold_brightens_ansi_colors = false,
   -- scrollback_lines = 30000,
   native_macos_fullscreen_mode = false,
   hide_mouse_cursor_when_typing = true,
   pane_focus_follows_mouse = true,
   macos_window_background_blur = 32,

   bidi_enabled = true,
   bidi_direction = 'LeftToRight',
}
