if getgenv().BlackKing then
    return 
end

getgenv().BlackKing = {
    Legit = true
}

local GameList = {
    [2440500124] = "Doors",
    [15722706376] = "FigureOld",
    [93149414018318] = "FigureByMoon",
}

local BaseUrl = "https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/"

BlackKing.Environment = {
    cloneref = type(cloneref) == "function" and cloneref or function(obj) return obj end,
    writefile = type(writefile) == "function" and writefile or nil,
    readfile = type(readfile) == "function" and readfile or nil,
    isfile = type(isfile) == "function" and isfile or function() return false end
}

local function CloneReference(Object)
    if BlackKing and BlackKing.Environment.cloneref then
        return BlackKing.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

-- Hệ thống quản lý UserData ghi nhận số lần chạy script
if BlackKing.Environment.writefile and BlackKing.Environment.readfile then
    if not BlackKing.Environment.isfile("BlackKing/UserData.json") then
        local Data = { TotalExecutions = 0, UILibrary = "Obsidian" }
        if type(makefolder) == "function" then makefolder("BlackKing") end
        BlackKing.Environment.writefile("BlackKing/UserData.json", Services.HttpService:JSONEncode(Data))
    end

    local UserData = BlackKing.Environment.readfile("BlackKing/UserData.json")
    local Decoded = Services.HttpService:JSONDecode(UserData)
    if not Decoded then Decoded = { TotalExecutions = 0, UILibrary = "Obsidian" } end
    Decoded.TotalExecutions = (Decoded.TotalExecutions or 0) + 1
    BlackKing.TotalExecutions = Decoded.TotalExecutions
    BlackKing.Environment.writefile("BlackKing/UserData.json", Services.HttpService:JSONEncode(Decoded))
end

local function LoadComponent(fileName)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BaseUrl .. fileName))()
    end)
    if not success then
        warn("[BlackKing Bootstrapper] Lỗi khi nạp thành phần " .. fileName .. ": " .. tostring(result))
    end
    return result
end

BlackKing.Environment = LoadComponent("Environment.luau") or BlackKing.Environment
BlackKing.ESPLibrary = LoadComponent("ESPLibrary.luau")

BlackKing.Interface = LoadComponent("Interface.luau")
BlackKing.InfoTab = LoadComponent("InfoTab.luau")
BlackKing.SettingsTab = LoadComponent("SettingsTab.luau")

--[[local CurrentGame = GameList[game.GameId]
if CurrentGame then
    loadstring(game:HttpGet(BaseUrl .. "ye.luau"))()
end]]--
loadstring(game:HttpGet(BaseUrl .. "ye.luau"))()
print("yall, Madium is Good and Script will run, Enjoy!")
