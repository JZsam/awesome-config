-- local wethWidget =  require("wibox").widget.textbox()
local http = require("socket.http")
local body, statusCode, headers, statusText = http.request('https://wttr.in/Columbus?format=3')
print(body)
