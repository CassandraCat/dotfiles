local wezterm = require('wezterm')
local gpu_adapters = require('utils.gpu_adapter')
local colors = require('colors.custom')

local function get_theme()
   local _time = os.date('*t')
   if _time.hour >= 1 and _time.hour < 9 then
      return 'Rosé Pine (base16)'
   elseif _time.hour >= 9 and _time.hour < 17 then
      return 'tokyonight_night'
   elseif _time.hour >= 17 and _time.hour < 21 then
      return 'Catppuccin Mocha'
   elseif _time.hour >= 21 and _time.hour < 24 or _time.hour >= 0 and _time.hour < 1 then
      return 'kanagawabones'
   end
end

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
         opacity = 0.3
      },
      {
         source = { Color = colors.background },
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
   window_frame = {
      active_titlebar_bg = '#090909',
      -- font = fonts.font,
      -- font_size = fonts.font_size,
   },
   window_decorations = 'RESIZE',
   -- window_background_opacity = 0.8,

   inactive_pane_hsb = {
      saturation = 0.9,
      brightness = 0.65,
   },

   -- other
   use_dead_keys = false,
   selection_word_boundary = ' \t\n{}[]()"\'`,;:@',
   line_height = 1.25,
   bold_brightens_ansi_colors = false,
   scrollback_lines = 30000,
   native_macos_fullscreen_mode = false,
   hide_mouse_cursor_when_typing = true,
   pane_focus_follows_mouse = true,
   macos_window_background_blur = 32,

   bidi_enabled = true,
   bidi_direction = 'LeftToRight',
}
