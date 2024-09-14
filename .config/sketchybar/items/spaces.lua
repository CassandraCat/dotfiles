local colors = require("colors")
local settings = require("settings")

local function getSpaceIcon(space, active)
	if active then
		return "􀥳"
	else
		return "􀥲"
	end
end

local right_padding = 0

-- Create a parent container with a background
local parent_container = sbar.add("parent", "parent_container", {
	width = "dynamic",
	background = {
		drawing = true,
		color = colors.bg1,
		corner_radius = 10,
		padding = 10,
	},
	position = "left",
	align = "center",
})

local spaces = {}

for i = 1, 10 do
	local space = sbar.add("space", "space." .. i, {
		parent = "parent_container",
		position = "left",
		align = "center",
		space = i,
		label = {
			color = colors.text,
			align = "center",
			font = {
				family = settings.font.text,
				size = 10,
			},
		},
		icon = {
			string = getSpaceIcon(i, false),
			size = 20,
			color = colors.cyan,
		},
	})
	spaces[i] = space

	space:subscribe("space_change", function(env)
		local selected = env.SELECTED == "true"
		sbar.animate("elastic", 10, function()
			space:set({
				label = {
					padding_right = right_padding > 0 and 0 or right_padding,
					string = selected and env.INFO or "",
				},
				icon = {
					style = settings.font.style_map.SemiBold,
					string = selected and getSpaceIcon(i, true) or getSpaceIcon(i, false),
					color = selected and colors.cyan or colors.text,
					font = {
						size = selected and 18 or 16,
					},
				},
				background = {
					drawing = selected and true or false,
				},
			})
		end)
	end)
end
