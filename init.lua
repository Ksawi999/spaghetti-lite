loadfile("spaghetti-lite/loader.lua")()
local params = {...}
local file = params[1]
local x = params[2] or 100
local y = params[3] or x
if params[4] ~= nil and params[5] ~= nil then require("plot").create_parts(x, y, require(file).build(params[4], params[5]))
else
	local loadedfile = require(file)
	if loadedfile.build then loadedfile = loadedfile.build() end
	require("plot").create_parts(x, y, loadedfile)
end