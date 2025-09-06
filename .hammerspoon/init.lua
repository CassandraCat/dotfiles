local yabaiPath = "/usr/local/bin/yabai"
local spaces = require("hs.spaces")

local BUNDLE_ID = "com.github.wez.wezterm"
local cachedScreenUUID = hs.screen.mainScreen():getUUID()

local function runYabaiCommand(args, callback)
	hs.task
		.new(yabaiPath, function(exitCode, stdOut, stdErr)
			if exitCode == 0 then
				callback(true, stdOut)
			else
				print("Error running yabai command:", stdErr)
				callback(false, stdErr)
			end
		end, args)
		:start()
end

local function getCurrentSpaceIndex()
	local currentSpaceID = spaces.activeSpaceOnScreen()
	local allSpaces = spaces.allSpaces()
	local spaceIDsOnScreen = allSpaces[cachedScreenUUID]
	local index = nil
	for i, spaceID in ipairs(spaceIDsOnScreen) do
		if spaceID == currentSpaceID then
			index = i
			break
		end
	end
	return index
end

local function moveWindowToSpace(windowID, spaceIndex, callback)
	runYabaiCommand({ "-m", "window", tostring(windowID), "--space", tostring(spaceIndex) }, function(success, _)
		if success then
			callback()
		else
			print("Error moving WezTerm window to current space")
		end
	end)
end

local function moveAppToCurrentSpace(win)
	local currentSpaceIndex = getCurrentSpaceIndex()
	if currentSpaceIndex then
		local windowID = win:id()
		if windowID then
			moveWindowToSpace(windowID, currentSpaceIndex, function()
				win:focus()
			end)
		else
			print("Error: Could not extract WezTerm window ID")
		end
	else
		print("Error: Could not determine current space index")
	end
end

hs.hotkey.bind({ "command" }, "escape", function()
	local wezterm = hs.application.get(BUNDLE_ID)
	if wezterm ~= nil and wezterm:isFrontmost() then
		wezterm:hide()
	else
		if wezterm == nil and hs.application.launchOrFocusByBundleID(BUNDLE_ID) then
			local appWatcher = nil
			appWatcher = hs.application.watcher.new(function(_, event, app)
				local win = app:mainWindow()
				if event == hs.application.watcher.launched and app:bundleID() == BUNDLE_ID then
					win:setFrame(hs.geometry.rect(8, 40, 1904, 1035))
					moveAppToCurrentSpace(win)
					appWatcher:stop()
				end
			end)
			appWatcher:start()
		end
		if wezterm ~= nil then
			moveAppToCurrentSpace(wezterm:mainWindow())
		end
	end
end)
