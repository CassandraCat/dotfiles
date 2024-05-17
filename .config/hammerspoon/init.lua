local json = require("hs.json")

local function getCurrentSpaceIndex(callback)
	hs.task
		.new("/usr/local/bin/yabai", function(exitCode, stdOut, stdErr)
			if exitCode == 0 then
				print("Current space data:", stdOut)
				local spacesData = json.decode(stdOut)
				local foundSpace = false
				for _, space in ipairs(spacesData) do
					if space["has-focus"] then
						foundSpace = true
						callback(space["index"]) -- Now using index instead of id
						break
					end
				end
				if not foundSpace then
					callback(spacesData[1]["index"]) -- Assume the first space's index as a fallback
				end
			else
				print("Error getting space index:", stdErr)
			end
		end, { "-m", "query", "--spaces" })
		:start()
end

local function getWezTermWindowID(callback)
	hs.task
		.new("/usr/local/bin/yabai", function(exitCode, stdOut, stdErr)
			if exitCode == 0 then
				local windowsData = json.decode(stdOut)
				for _, window in ipairs(windowsData) do
					-- Ensure the application name matches exactly what's reported by yabai
					if window.app == "WezTerm" then
						callback(window.id)
						return
					end
				end
				print("Error: Could not find WezTerm window")
				callback(nil)
			else
				print("Error getting window ID:", stdErr)
				callback(nil)
			end
		end, { "-m", "query", "--windows" })
		:start()
end

local function focusWindowWithYabai(windowID)
	hs.task
		.new("/usr/local/bin/yabai", function(exitCode, stdOut, stdErr)
			-- exitCode 为 0 表示成功，非 0 表示有错误发生
			if exitCode ~= 0 then
				print("yabai focus window command failed: " .. stdErr)
			end
		end, { "-m", "window", "--focus", tostring(windowID) })
		:start()
end

local function moveWezTermToCurrentSpace()
	getCurrentSpaceIndex(function(currentSpaceIndex)
		if currentSpaceIndex then
			getWezTermWindowID(function(windowID)
				if windowID then
					hs.task
						.new("/usr/local/bin/yabai", function(exitCode, stdOut, stdErr)
							if exitCode == 0 then
								-- Make the WezTerm window visible
								hs.task
									.new(
										"/usr/local/bin/yabai",
										nil,
										{ "-m", "window", tostring(windowID), "--toggle", "visible" }
									)
									:start()

								-- Wait for the window to become visible
								hs.timer.doAfter(0.1, function()
									-- Now move the WezTerm window to the current space
									hs.task
										.new("/usr/local/bin/yabai", nil, {
											"-m",
											"window",
											tostring(windowID),
											"--space",
											tostring(currentSpaceIndex),
										})
										:start()

									-- Wait for the window to move, then set the size and position
									hs.timer.doAfter(0.2, function()
										local win = hs.window.find(windowID)
										if win then
											-- Set the WezTerm window frame
											win:setFrame(hs.geometry.rect(8, 50, 1776, 1060))
											focusWindowWithYabai(windowID)
										else
											print(
												"Failed to resize and reposition WezTerm window: no window with the given ID found."
											)
										end
									end)
								end)
							else
								print("Error moving WezTerm window with yabai:", stdErr)
							end
						end, { "-m", "query", "--windows", "--window", tostring(windowID) })
						:start()
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
		-- Wait for WezTerm to launch and get its main window
		hs.timer.doAfter(0.5, function() -- Wait a bit for the application to launch
			moveWezTermToCurrentSpace()
		end)
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
