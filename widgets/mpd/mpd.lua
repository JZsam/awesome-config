local wibox = require("wibox")
local mpcWidget =  wibox.widget.textbox()
local mpc = require("widgets.mpd.mpc")
local timer = require("gears.timer")
local volume, title, status = "", "", ""

local host = os.getenv("MPD_HOST") or "localhost"
local port = os.getenv("MPD_PORT") or "6600"
local function update_widget(volume ,status)
	local text = title
	if status == "pause" then
		text = text .. " ([󰏤] paused) "
	elseif status == "stop" then
		text = text .. " ([󰓛] stopped) "
	end
	text = text .. " | " .. volume .. "%"
	mpcWidget.text = text
end
local connection
local function error_handler(err)
	mpcWidget:set_text("Error: " .. tostring(err))
	-- Try a reconnect soon-ish
	timer.start_new(10, function()
		connection:send("ping")
	end)
end
connection = mpc.new(host , port, nil, error_handler,"currentsong", function (_, result)
-- connection = mpc.new("localhost", nil, nil, error_handler,"currentsong", function (_, result)
	title = result.title
end, "status", function(_, result)
	local vol = result.volume
	local stat = result.state
	pcall(update_widget(vol,stat))
end)
return mpcWidget
