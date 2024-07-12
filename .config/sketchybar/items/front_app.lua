local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
	label = {
		color = colors.seezalt_smoke,
		padding_right = 10,
		padding_left = 5,
		align = "center",
		font = {
			family = settings.font.text,
			size = 12,
      style = settings.font.style_map["Bold"]
		},
	},
	position = "left",
	update_freq = 30,
	background = {
		color = colors.bg1,
		height = 20,
	},
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({
		label = {
			string = env.INFO,
		},
	})
end)

front_app:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)
