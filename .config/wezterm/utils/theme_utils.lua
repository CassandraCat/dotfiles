local wezterm = require('wezterm')

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

local function getDefaultColors(theme)
   return wezterm.color.get_builtin_schemes()[theme]
end

return {
   get_theme = get_theme,
   getDefaultColors = getDefaultColors,
}
