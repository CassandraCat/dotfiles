local wezterm = require('wezterm')
local platform = require('utils.platform')()

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

-- Seeding random numbers before generating for use
-- Known issue with lua math library
-- see: https://stackoverflow.com/questions/20154991/generating-uniform-random-numbers-in-lua
math.randomseed(os.time())
math.random()
math.random()
math.random()

local PATH_SEP = platform.is_win and '\\' or '/'

---@class BackDrops
---@field current_idx number index of current image
---@field files string[] background images
---@field timer_started boolean flag to check if timer is already started
---@field keep_running boolean flag to check if timer should keep running

local BackDrops = {}
BackDrops.__index = BackDrops

--- Initialise backdrop controller
---@private
function BackDrops:init()
   local inital = {
      current_idx = 1,
      files = {},
      timer_started = false, -- Initialize the flag
      keep_running = false, -- Initialize the flag
   }
   local backdrops = setmetatable(inital, self)
   wezterm.GLOBAL.background = nil
   return backdrops
end

---MUST BE RUN BEFORE ALL OTHER `BackDrops` functions
---Sets the `files` after instantiating `BackDrops`.
---
--- INFO:
---   During the initial load of the config, this function can only invoked in `wezterm.lua`.
---   WezTerm's fs utility `read_dir` (used in this function) works by running on a spawned child process.
---   This throws a coroutine error if the function is invoked in outside of `wezterm.lua` in the -
---   initial load of the Terminal config.
function BackDrops:set_files()
   self.files = wezterm.read_dir(wezterm.config_dir .. PATH_SEP .. 'backdrops')
   if #self.files > 0 then
      wezterm.GLOBAL.background = self.files[1]
   else
      wezterm.log_error('No files found in backdrops directory')
   end
   return self
end

---Override the current window options for background
---@private
---@param window any WezTerm Window see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:_set_opt(window)
   if window and window.set_config_overrides then
      local overrides = window:get_config_overrides() or {}
      overrides.background = {
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
      }
      window:set_config_overrides(overrides)
      wezterm.log_info('Background set to: ' .. wezterm.GLOBAL.background)
   else
      wezterm.log_error('window object or set_config_overrides method not available')
   end
end

---Convert the `files` array to a table of `InputSelector` choices
---see: https://wezfurlong.org/wezterm/config/lua/keyassignment/InputSelector.html
function BackDrops:choices()
   local choices = {}
   for idx, file in ipairs(self.files) do
      local name = file:match('([^' .. PATH_SEP .. ']+)$')
      table.insert(choices, {
         id = tostring(idx),
         label = name,
      })
   end
   return choices
end

---Select a random file and redefine the global `wezterm.GLOBAL.background` variable
---Pass in `Window` object to override the current window options
---@param window any? WezTerm `Window` see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:random(window)
   if #self.files == 0 then
      wezterm.log_error('No files available for random selection')
      return
   end
   self.current_idx = math.random(#self.files)
   wezterm.GLOBAL.background = self.files[self.current_idx]

   wezterm.log_info('Randomly selected background: ' .. wezterm.GLOBAL.background)

   if window ~= nil then
      self:_set_opt(window)
   end
end

---Cycle the loaded `files` and select the next background
---@param window any WezTerm `Window` see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:cycle_forward(window)
   if self.current_idx == #self.files then
      self.current_idx = 1
   else
      self.current_idx = self.current_idx + 1
   end
   wezterm.GLOBAL.background = self.files[self.current_idx]
   self:_set_opt(window)
end

---Cycle the loaded `files` and select the previous background
---@param window any WezTerm `Window` see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:cycle_back(window)
   if self.current_idx == 1 then
      self.current_idx = #self.files
   else
      self.current_idx = self.current_idx - 1
   end
   wezterm.GLOBAL.background = self.files[self.current_idx]
   self:_set_opt(window)
end

---Set a specific background from the `files` array
---@param window any WezTerm `Window` see: https://wezfurlong.org/wezterm/config/lua/window/index.html
---@param idx number index of the `files` array
function BackDrops:set_img(window, idx)
   if idx > #self.files or idx < 0 then
      wezterm.log_error('Index out of range')
      return
   end

   self.current_idx = idx
   wezterm.GLOBAL.background = self.files[self.current_idx]
   self:_set_opt(window)
end

--- Start a timer to change the background every 5 seconds
---@param window any WezTerm `Window` see: https://wezfurlong.org/wezterm/config/lua/window/index.html
function BackDrops:start_timer(window)
   if self.timer_started then
      wezterm.log_info('Timer already started')
      return
   end
   self.timer_started = true -- Set the flag to true to indicate the timer has started
   self.keep_running = true -- Flag to indicate whether the timer should keep running

   local function timer_callback()
      if not self.keep_running then
         wezterm.log_info('Timer stopped')
         return
      end
      wezterm.log_info('Timer callback triggered')
      self:random(window)
      wezterm.time.call_after(3600, timer_callback)
   end
   wezterm.log_info('Starting timer')
   wezterm.time.call_after(0, timer_callback)
end

function BackDrops:stop_timer()
   self.keep_running = false -- Set flag to false to stop the timer
end

return BackDrops:init()
