local json = require("hs.json")
local yabaiPath = "/usr/local/bin/yabai"

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

local function getCurrentSpaceIndex(callback)
	runYabaiCommand({ "-m", "query", "--spaces" }, function(success, output)
		if success then
			local spacesData = json.decode(output)
			for _, space in ipairs(spacesData) do
				if space["has-focus"] then
					callback(space["index"])
					return
				end
			end
			callback(spacesData[1]["index"]) -- Fallback to the first space's index
		else
			callback(nil)
		end
	end)
end

local function getWezTermWindowID(callback)
	runYabaiCommand({ "-m", "query", "--windows" }, function(success, output)
		if success then
			local windowsData = json.decode(output)
			for _, window in ipairs(windowsData) do
				if window.app == "WezTerm" then
					callback(window.id)
					return
				end
			end
			print("Error: Could not find WezTerm window")
			callback(nil)
		else
			callback(nil)
		end
	end)
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

local function moveWezTermToCurrentSpace()
	getCurrentSpaceIndex(function(currentSpaceIndex)
		if currentSpaceIndex then
			getWezTermWindowID(function(windowID)
				if windowID then
					hs.timer.doAfter(0.1, function()
						moveWindowToSpace(windowID, currentSpaceIndex, function()
							hs.timer.doAfter(0.2, function()
								setWindowFrame(windowID)
							end)
						end)
					end)
				else
					print("Error: Could not extract WezTerm window ID")
				end
			end)
		else
			print("Error: Could not determine current space index")
		end
	end)
end

local function launchAndMoveWezTerm()
	local wezterm = hs.application.get("WezTerm")
	if not wezterm then
		hs.application.launchOrFocusByBundleID("com.github.wez.wezterm")
		hs.timer.doAfter(0.5, moveWezTermToCurrentSpace) -- Wait a bit for the application to launch
	else
		moveWezTermToCurrentSpace()
	end
end

hs.hotkey.bind({ "command" }, "escape", function()
	local wezterm = hs.application.get("WezTerm")
	if wezterm then
		if wezterm:isHidden() then
			moveWezTermToCurrentSpace()
		else
			wezterm:hide()
		end
	else
		launchAndMoveWezTerm()
	end
end)
