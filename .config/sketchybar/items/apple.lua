local colors = require("colors")
local icons = require("icons")

sbar.add("item", {
	width = 0,
})

local apple = sbar.add("item", {
	icon = {
		padding_left = 10,
		padding_right = 10,
		align = "center",
		font = {
			size = 16,
		},
		string = "􀬚",
		color = colors.seezalt_dark,
	},
	background = {
		color = colors.transparent,
	},
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})
sbar.add("bracket", {
	apple.name,
}, {})

apple:subscribe("mouse.entered", function(env)
	sbar.animate("elastic", 15, function()
		apple:set({
			icon = {
				string = "Menu",
				color = colors.text,
				font = {
					size = 16,
				},
			},
		})
	end)
end)
apple:subscribe("mouse.exited", function(env)
	sbar.animate("elastic", 15, function()
		apple:set({
			icon = {
				string = icons.apple,
				color = colors.seezalt_dark,
				font = {
					size = 16,
				},
			},
		})
	end)
end)
apple:subscribe("mouse.clicked", function(env)
	sbar.animate("elastic", 15, function()
		apple:set({
			label = {
				font = {
					colors = colors.bg1,
				},
			},
		})
	end)
end)
