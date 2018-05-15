-- Luacheck configuration file

max_line_length = false

exclude_files = {
    "Libraries"
}
ignore = {
    -- Ignore unused self. This would popup for Mixins and Objects
    "212/self",

    -- Accessing an undefined global variable (because luacheck can't import WoW's API, we have a lot of those)
    "113",

    -- Allow unused loop variable if they are i (commonly used in simple for i=x; y do loops)
    "213/i"
}
