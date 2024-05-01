local spaces = require("hs.spaces") -- https://github.com/asmagill/hs._asm.spaces

-- Switch wezterm
hs.hotkey.bind(
	_,
	"f10",
	function() -- change your own hotkey combo here, available keys could be found here:https://www.hammerspoon.org/docs/hs.hotkey.html#bind
		local BUNDLE_ID = "com.github.wez.wezterm" -- more accurate to avoid mismatching on browser titles

		function getMainWindow(app)
			-- get main window from app
			local win = nil
			while win == nil do
				win = app:mainWindow()
			end
			return win
		end

		function moveWindow(wezterm, space)
			local win = getMainWindow(wezterm)
			if win then
				if win:isFullScreen() then
					hs.eventtap.keyStroke({ "fn" }, "f", 0, wezterm)
				end
				win:move(hs.geometry.rect(8, 50, 1776, 1060))
				spaces.moveWindowToSpace(win, space)
				win:focus()
			end
		end

		local wezterm = hs.application.get(BUNDLE_ID)
		if wezterm ~= nil and wezterm:isFrontmost() then
			wezterm:hide()
		else
			local space = spaces.activeSpaceOnScreen()
			if wezterm == nil and hs.application.launchOrFocusByBundleID(BUNDLE_ID) then
				local appWatcher = nil
				appWatcher = hs.application.watcher.new(function(name, event, app)
					if event == hs.application.watcher.launched and app:bundleID() == BUNDLE_ID then
						getMainWindow(app):move(hs.geometry.rect(8, 50, 1776, 1060))
						app:hide()
						moveWindow(app, space)
						appWatcher:stop()
					end
				end)
				appWatcher:start()
			end
			if wezterm ~= nil then
				moveWindow(wezterm, space)
			end
		end
	end
)
