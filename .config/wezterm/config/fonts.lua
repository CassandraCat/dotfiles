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
   font = font_with_fallback({
      family = 'MonaspiceRn Nerd Font Propo',
      harfbuzz_features = {
         'zero',
      },
   }),
   font_size = platform().is_mac and 16 or 14,

   font_rules = {
      {
         intensity = 'Bold',
         font = font_with_fallback({
            family = 'MonaspiceRn Nerd Font Propo',
            harfbuzz_features = {
               'zero',
            },
            weight = 'Medium',
         }),
      },
      {
         italic = true,
         intensity = 'Bold',
         font = font_with_fallback({
            family = 'Iosevka NF',
            -- family = "Dank Mono",
            weight = 'Medium',
            italic = true,
         }),
      },
      {
         italic = true,
         font = font_with_fallback({
            -- family = "Dank Mono",
            family = 'Iosevka NF',
            weight = 'Regular',
            italic = true,
         }),
      },
   },

   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
