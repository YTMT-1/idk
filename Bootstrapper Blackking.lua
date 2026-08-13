if getgenv().BlackKing then
    return
end

-- --- BẮT ĐẦU SCRIPT GỐC ---
getgenv().BlackKing = {
    Legit = true
}

getgenv().BlackKing = {
    Legit = true
}

local BlackKing = getgenv().BlackKing

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

BlackKing.Interface = LoadComponent("Interface.luau")

local ObsidianLib = getgenv().Library or getgenv().Obsidian or _G.Library

local Loading = ObsidianLib:CreateLoading({ Title = "BlackKing Hub", TotalSteps = 4 })
Loading:ShowSidebarPage(true)
Loading.Sidebar:AddLabel("User: " .. Services.Players.LocalPlayer.Name)
Loading.Sidebar:AddLabel("Executions: " .. tostring(BlackKing.TotalExecutions or 1))

Loading:SetMessage("Loading Script")

Loading:SetCurrentStep(1)
Loading:SetDescription("Loading Environment core...")
BlackKing.Environment = LoadComponent("Environment.luau") or BlackKing.Environment
task.wait(0.2)

Loading:SetCurrentStep(2)
Loading:SetDescription("Loading ESP Library components...")
BlackKing.ESPLibrary = LoadComponent("ESPLibrary.luau")
task.wait(0.2)

Loading:SetCurrentStep(3)
Loading:SetDescription("Injecting Info and Settings tabs...")
BlackKing.InfoTab = LoadComponent("InfoTab.luau")
BlackKing.SettingsTab = LoadComponent("SettingsTab.luau")
task.wait(0.2)

Loading:SetCurrentStep(4)
Loading:SetDescription("Executing main feature script...")
loadstring(game:HttpGet(BaseUrl .. "Game.luau"))()
task.wait(0.5)

Loading:Continue()
print("Script Running Success, Enjoy!")
