local Library = (BlackKing.UILibrary == "Linoria" and "LinoriaLib" or "Obsidian")
local BaseUrl = "https://raw.githubusercontent.com/deividcomsono/".. Library .."/refs/heads/main/"
local BlackKingUrl = "https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/"

local Interface = {
    Library = loadstring(game:HttpGet(BaseUrl .. "Library.lua"))(),
    SaveManager = loadstring(game:HttpGet(BaseUrl .. "addons/SaveManager.lua"))(),
    ThemeManager = loadstring(game:HttpGet(BaseUrl .. "addons/ThemeManager.lua"))(),

    ApplyInfoTab = loadstring(game:HttpGet(BlackKingUrl .. "InfoTab.luau"))(),
    ApplySettingsTab = loadstring(game:HttpGet(BlackKingUrl .. "SettingsTab.luau"))()
}

Interface.ThemeManager.BuiltInThemes = {
    ["Default"]      = { FontColor = "ffffff", MainColor = "191919", AccentColor = "7d55ff", BackgroundColor = "0f0f0f", OutlineColor = "282828" },
    ["BlackKing"]    = { FontColor = "ffffff", MainColor = "1c1c1c", AccentColor = "e755ff", BackgroundColor = "1a1a1a", OutlineColor = "1a1b1d" },
    ["BBot"]         = { FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "7e48a3", BackgroundColor = "232323", OutlineColor = "141414" },
    ["Fatality"]     = { FontColor = "ffffff", MainColor = "1e1842", AccentColor = "c50754", BackgroundColor = "191335", OutlineColor = "3c355d" },
    ["Jester"]       = { FontColor = "ffffff", MainColor = "242424", AccentColor = "db4467", BackgroundColor = "1c1c1c", OutlineColor = "373737" },
    ["Mint"]         = { FontColor = "ffffff", MainColor = "242424", AccentColor = "3db488", BackgroundColor = "1c1c1c", OutlineColor = "373737" },
    ["Tokyo Night"]  = { FontColor = "ffffff", MainColor = "191925", AccentColor = "6759b3", BackgroundColor = "16161f", OutlineColor = "323232" },
    ["Ubuntu"]       = { FontColor = "ffffff", MainColor = "3e3e3e", AccentColor = "e2581e", BackgroundColor = "323232", OutlineColor = "191919" },
    ["Quartz"]       = { FontColor = "ffffff", MainColor = "232330", AccentColor = "426e87", BackgroundColor = "1d1b26", OutlineColor = "27232f" },
    ["Nord"]         = { FontColor = "eceff4", MainColor = "3b4252", AccentColor = "88c0d0", BackgroundColor = "2e3440", OutlineColor = "4c566a" },
    ["Dracula"]      = { FontColor = "f8f8f2", MainColor = "44475a", AccentColor = "ff79c6", BackgroundColor = "282a36", OutlineColor = "6272a4" },
    ["Monokai"]      = { FontColor = "f8f8f2", MainColor = "272822", AccentColor = "f92672", BackgroundColor = "1e1f1c", OutlineColor = "49483e" },
    ["Gruvbox"]      = { FontColor = "ebdbb2", MainColor = "3c3836", AccentColor = "fb4934", BackgroundColor = "282828", OutlineColor = "504945" },
    ["Solarized"]    = { FontColor = "839496", MainColor = "073642", AccentColor = "cb4b16", BackgroundColor = "002b36", OutlineColor = "586e75" },
    ["Catppuccin"]   = { FontColor = "d9e0ee", MainColor = "302d41", AccentColor = "f5c2e7", BackgroundColor = "1e1e2e", OutlineColor = "575268" },
    ["One Dark"]     = { FontColor = "abb2bf", MainColor = "282c34", AccentColor = "c678dd", BackgroundColor = "21252b", OutlineColor = "5c6370" },
    ["Cyberpunk"]    = { FontColor = "f9f9f9", MainColor = "262335", AccentColor = "00ff9f", BackgroundColor = "1a1a2e", OutlineColor = "413c5e" },
    ["Oceanic Next"] = { FontColor = "d8dee9", MainColor = "1b2b34", AccentColor = "6699cc", BackgroundColor = "16232a", OutlineColor = "343d46" },
    ["Material"]     = { FontColor = "eeffff", MainColor = "212121", AccentColor = "82aaff", BackgroundColor = "151515", OutlineColor = "424242" },
}

return Interface
