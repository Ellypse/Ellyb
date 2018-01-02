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

- [Assertions]
- [Color]
- [ColorManager]
- [Logger]

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

Check if a variable is of one of the expected types.

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

### Color

The [Color] model provides methods to handle colors and colored text.

```lua
local Color = Ellyb.Color
```

#### Ellyb.Color(red, green, blue, [alpha]) or Color(colorCode) or Color(colorTable)

Constructor. Used to create a new [Color].

```lua
local red = Color(1, 0, 0);
local yellow = Color(255, 255, 0);
local grey = Color("#CCC");
local purple = Color({ r = 1, g = 0, b = 1});
```
 
#### Color:__tostring()

Get a text representation of the [Color]: the hexadecimal code of the [Color], colored using [UI escape sequences].

```lua
local red = Color(1, 0 ,0);
print(red); -- #FF0000
```

#### Color:__call(text)

The [Color] itself can be called directly as a shortcut to [Color:WrapTextInColorCode(text) 
](#colorwraptextincolorcode-text-)

```lua
local red = Color("#FF0000");
local redText = red("My colored text");
```

#### Color:IsEqualTo(colorB)

Check if a color is equal to another color.

```lua
local red = Color("#FF0000");
local otherRed = Color(1, 0, 0);
local blue = Color(0, 0, 1);

red:IsEqualTo(otherRed); -- true
red:IsEqualTo(blue); -- false
```

#### Color:GetRed()

Returns the red value of the color.

```lua
local color = Color("#FF0000");
local red = color:GetRed(); -- 1 
```

#### Color:GetGreen()

Returns the green value of the color.

```lua
local color = Color("#00FF00");
local green = color:GetGreen(); -- 1 
```

#### Color:GetBlue()

Returns the blue value of the color.

```lua
local color = Color("#0000FF");
local blue = color:GetBlue(); -- 1 
```

#### Color:GetAlpha()

Returns the alpha value of the color.

```lua
local color = Color("#FF0000");
local alpha = color:GetAlpha(); -- 1 
```

#### Color:GetRGB()

Returns the red, green and blue color values.

```lua
local color = Color(123, 202, 198);
local red, green, blue = color:getRGB(); -- 0.482352941, 0.792156863, 0.776470588  
```

#### Color:GetRGBA()

Returns the red, green, blue and alpha color values.

```lua
local color = Color(123, 202, 198);
local red, green, blue, alpha = color:getRGBA(); -- 0.482352941, 0.792156863, 0.776470588, 1  
```

#### Color:GetRGBAsBytes()

Returns the red, green and blue color values using 0-255 based values.

```lua
local color = Color("#C8A2C8");
local red, green, blue = color:getRGBA(); -- 200, 162, 200  
```

#### Color:GetRGBAAsBytes()

Returns the red, green, blue and alpha color values using 0-255 based values.

```lua
local color = Color("#C8A2C8");
local red, green, blue, alpha = color:getRGBA(); -- 200, 162, 200, 255  
```

#### Color:SetRed(red)

Set the red color value.

```lua
local red = Color(0, 0, 0);
red:SetRed(1);
```

#### Color:SetGreen(green)

Set the green color value.

```lua
local green = Color(0, 0, 0);
green:SetGreen(1);
```

#### Color:SetBlue(blue)

Set the blue color value.

```lua
local blue = Color(0, 0, 0);
blue:SetBlue(1);
```

#### Color:SetAlpha(alpha)

Set the alpha color value.

```lua
local alpha = Color(0, 0, 0);
alpha:SetAlpha(0.5);
```

#### Color:SetRGBA(red, green, blue, alpha)

Set the red, green, blue and alpha color values.

```lua
local color = Color(0, 0, 0);
color:SetRGBA(0.6, 1, 0.75, 1)
```

#### Color:Freeze()

Freeze a [Color] so that it cannot be mutated in the future. No changes can be made to the [Color] values, calling setters will silently fail. A color cannot be unfrozen.

_`Color:Freeze()` return the [Color] itself so that it can be used in a declaration statement._

```lua
local color = Color("#FF0000");
print(color:GetRed()); -- 1
color:SetRed(0.5);
print(color:GetRed()); -- 0.5
color:Freeze();
color:SetRed(0.3);
print(color:GetRed()); -- 0.5
```

#### Color:Clone()

Clone a [Color], creates a new [Color] with the same color values. The new color is not frozen and can be mutated.

```lua
local CONSTANT_COLOR = Color("#FF0000"):Freeze();
local myColor = CONSTANT_COLOR:Clone();
myColor:setBlue(1);
```

#### Color:GenerateHexadecimalColor([doNotIncludeAlpha])

Generate an hexadecimal color code representing the red, green, blue and alpha values of the [Color]. By default the code will include the alpha channel as the first hexadecimal code. Pass `true` to the function to remove the alpha value.

```lua
local lilac = Color(200, 162, 200);
print(lilac:GenerateHexadecimalColor()) -- FFC8A2C8
print("#" .. lilac:GenerateHexadecimalColor(true)) -- #C8A2C8
```

#### Color:WrapTextInColorCode(text)

Wraps a given text in the [UI escape sequences] necessary to have the text colored with the [Color].

_Note: You can call the color directly as a shortcut. See [`Color:__call(text)`](#colorcall-text-)_

```lua
local red = Color(1, 0, 0);
print(red:WrapTextInColorCode("Red text"));
```

### ColorManager

```lua
local ColorManager = Ellyb.ColorManager;
```

#### ColorManager.convertColorBytesToBits(red, green, blue, [alpha])

Converts a set of RGBA color values from a 0-255 based value to a 0-1 based value.

```lua
local red, green, blue, alpha = 123, 202, 198;
red, green, blue = ColorManager.convertColorBytesToBits(red, green, blue); -- 0.482352941, 0.792156863, 0.776470588 
```

#### ColorManager.hexaToNumber(hexadecimalCode)

Converts an hexadecimal code from a string into RGBA values.

```lua
local red, green, blue, alpha = ColorManager.hexaToNumber("#CCAABB");
local red, green, blue, alpha = ColorManager.hexaToNumber("|cffaaccbb");
local red, green, blue, alpha = ColorManager.hexaToNumber("FFF");
```

#### ColorManager.getClassColor(class)

Get the [Color] corresponding to the given class.

```lua
local demonHunterColor = ColorManager.getClassColor("DEMONHUNTER");
```

#### ColorManager.getChatColorForChannel(channel)

Get the [Color] associated with a chat channel.

```lua
local whispersColor = ColorManager.getChatColorForChannel("WHISPER");
```


[Assertions]: #assertions
[Color]: #color
[ColorManager]: #colormanager
[Logger]: #logger

[UI escape sequences]: http://wowwiki.wikia.com/wiki/UI_escape_sequences