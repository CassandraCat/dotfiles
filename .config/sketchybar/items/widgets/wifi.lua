local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

sbar.exec(
	"killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0"
)
sbar.exec("networksetup -getairportnetwork en0 | cut -c 25-")
local popup_width = 120

local wifi_up = sbar.add("item", "widgets.wifi_up", {
	position = "right",
	align = "left",
	padding_left = -10,
	padding_right = 0,
	width = 0,
	icon = {
		padding_right = 10,
		padding_left = 10,
		font = {
			style = settings.font.style_map.Bold,
			size = 8,
		},
		string = icons.wifi.upload,
	},
	label = {
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map.Bold,
			size = 8,
		},
		color = colors.white,
		string = "en0 Bps",
	},
	y_offset = 4,
})

local wifi_down = sbar.add("item", "widgets.wifi_down", {
	position = "right",
	align = "left",
	padding_left = -10,
	padding_right = 0,
	icon = {
		padding_right = 10,
		font = {
			style = settings.font.style_map.Bold,
			size = 8,
		},
		string = icons.wifi.download,
	},
	label = {
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map.Bold,
			size = 8,
		},
		color = colors.red,
		string = "en0 Bps",
	},
	y_offset = -4,
})

local wifi_icon = sbar.add("item", "wifi.icon", {
	position = "right",
	icon = {
		string = icons.wifi.connected,
		color = colors.red,
		font = {
			size = 12,
		},
    y_offset = 1
	},
	label = {
		font = {
			color = colors.blue,
			size = 10,
		},
	},
})

local wifi_bracket = sbar.add("bracket", "widgets.wifi_bracket", {
	"wifi.icon",
	"widgets.wifi_up",
	"widgets.wifi_down",
}, {
	background = {
		padding_left = 10,
		padding_right = 10,
		color = colors.transparent,
	},
	popup = {
		align = "left",
		height = 28,
	},
})

-- Background around the cpu item
sbar.add("item", "widgets.wifi_padding", {
	position = "right",
})

local ssid = sbar.add("item", {
	position = "popup.widgets.wifi_bracket",
	icon = {
		font = {
			size = 12,
			style = settings.font.style_map.Bold,
		},
		string = icons.wifi.router,
	},
	width = popup_width,
	align = "right",
	padding_left = 35,
	label = {
		font = {
			style = settings.font.style_map.Bold,
			color = colors.bg1,
			size = 12,
		},
		max_chars = 18,
		string = "????????????????",
	},
	background = {
		height = 40,
		color = colors.transparent,
		y_offset = -50,
	},
})

local hostname = sbar.add("item", {
	position = "popup.widgets.wifi_bracket",
	icon = {
		align = "left",
		string = "Hostname:",
		width = popup_width,
	},
	label = {
		max_chars = 20,
		string = "????????????",
		style = settings.font.style_map.Bold,
		width = popup_width,
		align = "left",
	},
})

local ip = sbar.add("item", {
	position = "popup.widgets.wifi_bracket",
	icon = {
		align = "left",
		string = "IP:",
		width = popup_width,
	},
	label = {
		string = "???.???.???.???",
		width = popup_width,
		align = "left",
	},
})

local mask = sbar.add("item", {
	position = "popup.widgets.wifi_bracket",
	icon = {
		align = "left",
		string = "Subnet mask:",
		width = popup_width,
	},
	label = {
		string = "???.???.???.???",
		width = popup_width,
		align = "left",
	},
})

local router = sbar.add("item", {
	position = "popup.widgets.wifi_bracket",
	icon = {
		align = "left",
		string = "Router:",
		width = popup_width,
	},
	label = {
		string = "???.???.???.???",
		width = popup_width,
		align = "left",
	},
})

sbar.add("item", {
	position = "left",
	width = settings.group_paddings,
	label = {
		font = {
			size = 10,
		},
	},
})

wifi_up:subscribe("network_update", function(env)
	local up_color = env.upload == "000 Bps" and colors.grey or colors.text_active
	local down_color = env.download == "000 Bps" and colors.grey or colors.text_active
	wifi_up:set({
		icon = {
			color = colors.white,
			padding_right = 5,
		},
		label = {
			string = env.upload,
			style = settings.font.style_map.Bold,
			color = colors.white,
		},
	})
	wifi_down:set({
		icon = {
			color = colors.red,
			padding_right = 5,
		},
		label = {
			string = env.download,
			color = colors.red,
		},
	})
end)

wifi_icon:subscribe({ "wifi_change", "system_woke" }, function(env)
	sbar.exec("ipconfig getifaddr en0", function(ip)
		local connected = not (ip == "")
		wifi_icon:set({
			icon = {
				string = connected and icons.wifi.connected or icons.wifi.disconnected,
				color = connected and colors.green or colors.red,
			},
		})
	end)
end)

local function hide_details()
	wifi_bracket:set({
		popup = {
			drawing = false,
		},
	})
end

local function toggle_details()
	local should_draw = (wifi_bracket:query()).popup.drawing == "off"
	if should_draw then
		wifi_bracket:set({
			popup = {
				drawing = true,
				label = {
					font = {
						size = 8,
					},
				},
			},
		})
		sbar.exec("networksetup -getcomputername", function(result)
			hostname:set({
				label = {
					string = result:match("^%s*(.-)%s*$"),
				},
			})
		end)
		sbar.exec("ipconfig getifaddr en0", function(result)
			ip:set({
				label = {
					string = result:match("^%s*(.-)%s*$"),
				},
			})
		end)
		sbar.exec("ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'", function(result)
			ssid:set({
				label = {
					string = result:match("^%s*(.-)%s*$"),
				},
			})
		end)
		sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'", function(result)
			mask:set({
				label = {
					string = result:match("^%s*(.-)%s*$"),
				},
			})
		end)
		sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
			router:set({
				label = {
					string = result:match("^%s*(.-)%s*$"),
				},
			})
		end)
	else
		hide_details()
	end
end

wifi_up:subscribe("mouse.clicked", toggle_details)
wifi_down:subscribe("mouse.clicked", toggle_details)
wifi_icon:subscribe("mouse.clicked", toggle_details)
wifi_icon:subscribe("mouse.exited.global", hide_details)

local function copy_label_to_clipboard(env)
	local label = (sbar.query(env.NAME)).label.value
	sbar.exec('echo "' .. label .. '" | pbcopy')
	sbar.set(env.NAME, {
		label = {
			string = icons.clipboard,
			align = "center",
			size = 8,
		},
	})
	sbar.delay(1, function()
		sbar.set(env.NAME, {
			label = {
				string = label,
				align = "right",
				size = 8,
			},
		})
	end)
end

ssid:subscribe("mouse.clicked", copy_label_to_clipboard)
hostname:subscribe("mouse.clicked", copy_label_to_clipboard)
ip:subscribe("mouse.clicked", copy_label_to_clipboard)
mask:subscribe("mouse.clicked", copy_label_to_clipboard)
router:subscribe("mouse.clicked", copy_label_to_clipboard)
