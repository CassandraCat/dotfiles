local wezterm = require('wezterm')
local platform = require('utils.platform')

local function font_with_fallback(name, params)
   local names = {
      name,
      'mini-file-icons',
      'Hack Nerd Font',
      'SauceCodePro Nerd Font',
   }
   return wezterm.font_with_fallback(names, params)
end

return {
   font = font_with_fallback('CaskaydiaCove Nerd Font Mono', {
      weight = 'Bold',
      style = 'Italic',
   }),
   font_size = platform().is_mac and 17.5 or 14,

   font_rules = {
      {
         italic = true,
         font = font_with_fallback({
            family = 'CaskaydiaCove Nerd Font Mono',
            weight = 'Bold',
            italic = true,
         }),
      },
   },

   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
