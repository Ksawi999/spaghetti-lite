# spaghetti-lite

Simple, cross-platform, user-friendly [spaghetti](https://github.com/LBPHacker/spaghetti) alternative. Production-ready, **feel free to open issues**.

## setup

Paste spaghetti-lite folder wherever you want. It will work no matter where it is but **it's recommended to keep it in "The Powder Toy" folder**.
If you installed spaghetti-lite to custom folder, it's recommended to write `loadfile("spaghetti-lite/loader.lua")(path)` in tpt console **(required only after every startup of tpt)**, where `path` is path to spaghetti-lite parent folder (for example "C:\Lua").
You can use `loadfile("spaghetti-lite/loader.lua")()` with no arguments if you installed spaghetti-lite to default path to ensure compatibility with included files, also being able to easily use `require()` instead of `loadfile()()`, although it's not required for spaghetti-lite to work.

## usage

Type `loadfile("spaghetti-lite/init.lua")(x, y, "path.to.init", [param1], [param2])` in tpt console, where (`x`, `y`) are the coordinates of the **top-left** corner of the output. `param1` and `param2`) are [build parameters](#params).
This command automatically calls `loader.lua` so you don't have to call it as long as spaghetti-lite is in the default path.

### old method

Type `loadfile("spaghetti-lite/plot.lua")().create_parts(x, y, loadfile("path/to/init.lua")().build(params))` in tpt console, where (`x`, `y`) are the coordinates of the **top-left** corner of the output and `params` are [build parameters](#params). `Generated` files are in most cases named `generated.lua` or `init.lua`, but spaghetti-lite ships also with `r2_adapter.lua` and `termination.lua`.\
If you used `loader.lua`, you can also use the shorter version:\
`require("plot").create_parts(x, y, require("path.to.init").build(params))`.\
Files named `generated.lua` have to be used directly (without `.build()`) so use `loadfile("spaghetti-lite/plot.lua")().create_parts(x, y, loadfile("path/to/generated.lua")())` or `require("plot").create_parts(x, y, require("path.to.generated").build(params))` respectively.

These commands work with the default spaghetti too, although they require much harder setup.

### params

Some scripts require additional parameters. To dispel doubts, they're listed here for every function included in spaghetti-lite.

| file                                            | build function | params                                 | description                                                                                                                        |
|-------------------------------------------------|----------------|----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|
| [r3/init.lua](r3/init.lua)                      | build()        | core_count, height_order, [machine_id] | builds r3 with `core_count` cores, `height_order` tall RAM with id of `machine_id` (last param is optional and is 1337 by default) |
| [r3/bus/r2_adapter.lua](r3/bus/r2_adapter.lua)  | build()        | control_ba, data_ba                    | builds r3->r2 output adapter                                                                                                       |
| [r3/bus/termination.lua](r3/bus/termination.lua)| build()        | *none*                                 | builds termination                                                                                                                 |
| [r3/core/generated.lua](r3/core/generated.lua)  | *none*         | *none*                                 | builds core                                                                                                                        |
| [r3/rread/generated.lua](r3/rread/generated.lua)| *none*         | *none*                                 | builds rread                                                                                                                       |
| [r3term/init.lua](r3term/init.lua)              | build()        | *none*                                 | builds r3 terminal                                                                                                                 |

There are also some additional params hidden in lua files, but for better compatibility provided files come directly from [R316 repo](https://github.com/LBPHacker/R316) (modified just to handle placement inside of spaghetti-lite, but original ones could work as well). You can also get asm examples [here](https://github.com/LBPHacker/R316/tree/v2/examples) and the tptasm from [here](https://github.com/LBPHacker/tptasm)