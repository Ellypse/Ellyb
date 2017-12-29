# Ellyb, Ellypse's Library

Various Lua tools bundled in a convenient library for my various projects of add-ons for World of Warcraft.

Some of the functions are based on the utils function made by [Kajisensei/Telkostrasz](https://github.com/kajisensei) in [Total RP 3](https://github.com/Ellypse/Total-RP-3) that have been either refactored or re-implemented.

## How to use

Ellyb defines one global function `Ellyb()` that can be used to get an new instance of the library.

```lua
local Ellyb = Ellyb();
```

The rest of the documentation assume `Ellyb` is referring to an instance of the library and not the global function.

## What's included

### Assertions

```lua
local Assertions = Ellyb.Assertions;
```

All of Assertions functions are used to check that something is conform to a specified rule. They will return true if the rule is true or false if it isn't. If it isn't, an error message will be generated using the information provided as a second return value. This is so the Assertions functions can be used in an `assert()` statement. The name of the variable has to be provided so that the error message generated is actually helpful.

**Note: The assertions are actually only run if `Ellyb.DEBUG_MODE` is true. When not in `DEBUG_MODE` the assertions will be skipped and will always return true, to limit potential overhead.** 

#### Assertions.isType(variable, expectedType, variableName)

Check if a variable is of the expected type. It can check the type of UI Widget too.

```lua
assert(Assertions.isType(myVar, "string", "myVar"));
assert(Assertions.isType(myFrame, "Button", "myFrame"));
```

#### Assertions.isOfTypes(variable, expectedTypes, variableName)

Check if a variable is of one of the expected type.

```lua
assert(Assertions.isType(myVar, {"string", "number", "table"}, "myVar"));
assert(Assertions.isType(myFrame, {"Button", "Texture", "Slider"}, "myFrame"));
```

#### Assertions.isNotNil(variable, variableName)

Check if a variable is not nil.

```lua
assert(Assertions.isNotNil(myVar, "myVar"));
```

#### Assertions.isNotEmpty(variable, variableName)

Check if a variable is not empty. This means `nil`, an empty string `""` or an empty table `{}`.

```lua
assert(Assertions.isNotEmpty(myTable, "myTable"));
```