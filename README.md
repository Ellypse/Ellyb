# Ellyb, Ellypse's Library

Various Lua tools bundled in a convenient library for my various projects of add-ons for World of Warcraft.

Some of the functions are based on the utils function made by [Kajisensei/Telkostrasz](https://github.com/kajisensei) in [Total RP 3](https://github.com/Ellypse/Total-RP-3) that have been either refactored or re-implemented.

## How to use

The global reference to the library `Ellyb` keeps track of which version was bundled in your add-on using the add-on name passed as a file argument. You can ask it to give your the instance of the library using the `GetInstance` method.

```lua
local myAddonName = ...;
local Ellyb = Ellyb:GetInstance(myAddonName);
```

This also means that if you need to interface with another add-on using Ellyb and you want to make sure you use their version, you can get their own instance.

```lua
local MyEllyb = Ellyb:GetInstance(...); -- Version 1.1
local TRP3Ellyb = Ellyb:GetInstance("totalRP3"); -- Version 1.0 bundled with Total RP 3
```

The rest of the documentation assume `Ellyb` is referring to an instance of the library and not the global function.