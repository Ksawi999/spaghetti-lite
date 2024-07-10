local forward_frame_name = "=[spaghetti_forward_frame]"
local user_wrap = loadstring([[
	local function packn(...)
		return { select("#", ...), ... }
	end
	local params_in = packn(...)
	local params_out = packn(params_in[2](unpack(params_in, 3, params_in[1] + 1)))
	return unpack(params_out, 2, params_out[1] + 1)
]], forward_frame_name)

local audited_pairs = pairs

local function user_error(...)
	local level = 1
	while true do
		local info = assert(debug.getinfo(level), "cannot find the topmost user frame")
		if info.source == forward_frame_name then
			break
		end
		level = level + 1
	end
	level = level + 1
	while true do
		local info = assert(debug.getinfo(level), "cannot find the topmost user frame")
		if info.source ~= forward_frame_name then
			error(string.format(...), level)
		end
		level = level + 1
	end
end

return {
	user_wrap       = user_wrap,
	user_error      = user_error,
}
