return {
	paddings = 2,
	group_paddings = 4,

	icons = "sf-symbols", -- alternatively available: NerdFont

	-- -- This is a font configuration for SF Pro and SF Mono (installed manually)
	-- font = require("helpers.default_font"),

	-- Alternatively, this is a font config for MonaspiceRn Nerd Font Propo
	font = {
		text = "MonaspiceRn Nerd Font Propo", -- Used for text
		numbers = "MonaspiceRn Nerd Font Propo", -- Used for numbers
		style_map = {
			["Regular"] = "Regular",
			["Semibold"] = "Medium",
			["Bold"] = "Bold",
			["Heavy"] = "Bold Italic",
			["Black"] = "Bold Italic",
		},
	},
}
