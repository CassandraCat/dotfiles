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

local function focusWindowWithYabai(windowID)
	runYabaiCommand({ "-m", "window", "--focus", tostring(windowID) }, function(success, _)
		if not success then
			print("yabai focus window command failed")
		end
	end)
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

local function setWindowFrame(windowID)
	local win = hs.window.find(windowID)
	if win then
		win:setFrame(hs.geometry.rect(8, 50, 1776, 1060))
		focusWindowWithYabai(windowID)
	else
		print("Failed to resize and reposition WezTerm window: no window with the given ID found.")
	end
end

local function moveAppToCurrentSpace()
	local currentSpaceIndex = getCurrentSpaceIndex()
	if currentSpaceIndex then
		local windowID = hs.application.find(BUNDLE_ID):mainWindow():id()
		if windowID then
			moveWindowToSpace(windowID, currentSpaceIndex, function()
				setWindowFrame(windowID)
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
			appWatcher = hs.application.watcher.new(function(name, event, app)
				if event == hs.application.watcher.launched and app:bundleID() == BUNDLE_ID then
					app:mainWindow():move(hs.geometry.rect(8, 50, 1776, 1060))
					moveAppToCurrentSpace()
					appWatcher:stop()
					appWatcher = nil
				end
			end)
			appWatcher:start()
		end
		if wezterm ~= nil then
			moveAppToCurrentSpace()
		end
	end
end)
