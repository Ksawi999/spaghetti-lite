local strict = require("spaghetti-lite.strict")
strict.wrap_env()

local LSNS_LIFE_3 = 0x10000003

return strict.make_mt_one("spaghetti-lite.build", {
	LSNS_LIFE_3  = LSNS_LIFE_3,
})
