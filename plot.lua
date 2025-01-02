local strict = require("spaghetti-lite.strict")
strict.wrap_env()

local build    = require("spaghetti-lite.build")
local bitx     = require("spaghetti-lite.bitx")
local misc     = require("spaghetti-lite.misc")
local check    = require("spaghetti-lite.check")

local audited_pairs = pairs

local in_tpt = rawget(_G, "tpt") and true

local elem_mt = {}
function elem_mt:__tostring()
	return ("pt.%s"):format(self.key)
end
local pt = setmetatable({}, { __index = function(tbl, key)
	if in_tpt then
		return elem["DEFAULT_PT_" .. key]
	end
	local value = setmetatable({ key = key }, elem_mt)
	rawset(tbl, key, value)
	return value
end })

local function apply_order(parts_in)
	local parts = {}
	for i = 1, #parts_in do
		parts[i] = {}
		for key, value in audited_pairs(parts_in[i]) do
			parts[i][key] = value
		end
		parts[i].z = parts[i].z or i
	end
	table.sort(parts, function(lhs, rhs)
		if lhs.y ~= rhs.y then return lhs.y < rhs.y end
		if lhs.x ~= rhs.x then return lhs.x < rhs.x end
		if lhs.z ~= rhs.z then return lhs.z < rhs.z end
		return false
	end)
	for i = 1, #parts do
		parts[i].z = nil
	end
	return parts
end

local function merge_parts(x, y, parts_out, parts_in)
	return misc.user_wrap(function()
		check.integer("x", x)
		check.integer("y", y)
		local parts = apply_order(parts_in)
		for i = 1, #parts do
			parts[i].x = parts[i].x + x
			parts[i].y = parts[i].y + y
			table.insert(parts_out, parts[i])
		end
		return parts_out
	end)
end

local function create_parts_(x, y, parts_in, debug)
	check.integer("x", x)
	check.integer("y", y)
	local parts = apply_order(parts_in)
	for i = 1, #parts do
		parts[i].x = parts[i].x + x
		parts[i].y = parts[i].y + y
		if parts[i].ctype_high then
			parts[i].ctype = bitx.bor(parts[i].ctype, bitx.lshift(parts[i].ctype_high, sim.PMAPBITS))
		end
	end
	do
		local new_parts = {}
		local part_state = {}
		local function xy_key(x, y)
			return y * sim.XRES + x
		end
		for _, part in ipairs(parts) do
			local key = xy_key(part.x, part.y)
			if not part.unstack then
				part_state[key] = "strong"
			end
		end
		for _, part in ipairs(parts) do
			local key = xy_key(part.x, part.y)
			if not part.unstack or part_state[key] ~= "strong" then
				part_state[key] = "strong"
				table.insert(new_parts, part)
			end
		end
		parts = new_parts
	end
	local ids = {}
	for i = 1, #parts do
		local id = sim.partCreate(-3, 4, 4, pt.DMND)
		if id == -1 then
			for j = 1, i - 1 do
				sim.partKill(ids[j])
			end
			error("out of particle ids", 2)
		end
		ids[i] = id
	end
	table.sort(ids)
	local function xy_key(x, y)
		return y * sim.XRES + x
	end
	local function xy_key_back(k)
		return k % sim.XRES, math.floor(k / sim.XRES)
	end
	do
		local to_freeze = {}
		for i = 1, #parts do
			local x, y = math.floor(parts[i].x / sim.CELL), math.floor(parts[i].y / sim.CELL)
			to_freeze[xy_key(x, y)] = true
		end
		for i = 1, #parts do
			if not parts[i].freezable then
				local x, y = math.floor(parts[i].x / sim.CELL), math.floor(parts[i].y / sim.CELL)
				to_freeze[xy_key(x, y)] = nil
			end
		end
		for key in audited_pairs(to_freeze) do
			local x, y = xy_key_back(key)
			sim.createWalls(x * sim.CELL, y * sim.CELL, 1, 1, sim.walls.DEFAULT_WL_STASIS)
		end
	end
	local count_at = {}
	for i = 1, #parts do
		if debug and parts[i].print_index then
			print("layer_last", ids[i])
		end
		sim.partProperty(ids[i], "type", parts[i].type)
		for key, value in audited_pairs(parts[i]) do
			if sim["FIELD_" .. key:upper()] and key ~= "type" then
				sim.partProperty(ids[i], key, value)
			end
		end
		local key = xy_key(parts[i].x, parts[i].y)
		if parts[i].type ~= pt.PHOT and parts[i].type ~= pt.GRVT and parts[i].type ~= pt.PROT and parts[i].type ~= pt.ELEC and parts[i].type ~= pt.NEUT then count_at[key] = (count_at[key] or 0) + 1 end
	end
	for key, value in audited_pairs(count_at) do
		if value > 5 then
			local x, y = xy_key_back(key)
			sim.createWalls(x, y, 1, 1, sim.walls.DEFAULT_WL_EHOLE)
		end
	end
end

local function create_parts(x, y, parts_in, debug)
	return misc.user_wrap(function()
		return create_parts_(x, y, parts_in, debug)
	end)
end

return {
	pt              = pt,
	create_parts    = create_parts,
	merge_parts     = merge_parts,
}
