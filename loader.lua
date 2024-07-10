local path = ... or "."
package.path = path .. "/?.lua" .. ";" .. package.path
package.path = path .. "/?/init.lua" .. ";" .. package.path
package.path = path .. "/spaghetti-lite/?.lua" .. ";" .. package.path
package.path = path .. "/spaghetti-lite/?/init.lua" .. ";" .. package.path