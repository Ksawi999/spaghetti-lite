local strict = require("spaghetti-lite.strict")
strict.wrap_env()

local misc = require("spaghetti-lite.misc")

local function typef(typev, name, value)
	if type(value) ~= typev then
		misc.user_error("%s is not of type %s", name, typev)
	end
end

local function number(name, value)
	typef("number", name, value)
end

local function integer(name, value)
	number(name, value)
	if math.floor(value) ~= value then
		misc.user_error("%s is not an integer", name)
	end
end

return strict.make_mt_one("spaghetti-lite.check", {
	integer          = integer,
})
