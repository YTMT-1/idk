if getgenv().BlackKing then return end
getgenv().BlackKing = { Legit = true }

local BaseUrl = "https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/"

-- Setup environment with error handling
local env = {
    cloneref = type(cloneref) == "function" and cloneref or function(obj) return obj end,
    writefile = type(writefile) == "function" and writefile or nil,
    readfile = type(readfile) == "function" and readfile or nil,
    isfile = type(isfile) == "function" and isfile or function() return false end,
    HttpService = game:GetService("HttpService")
}
getgenv().BlackKing.Environment = env

-- Helper to load components safely
local function LoadComponent(fileName)
    local success, result = pcall(function()
        local code = game:HttpGet(BaseUrl .. fileName)
        if not code or code == "" then return nil end
        local func = loadstring(code)
        return func and func()
    end)
    if not success then warn("[BlackKing] Failed to load " .. fileName) end
    return result
end

-- Load modules
getgenv().BlackKing.ESPLibrary = LoadComponent("ESPLibrary.luau")
getgenv().BlackKing.Interface = LoadComponent("Interface.luau")

-- Main loader
local success, rawCode = pcall(function() return game:HttpGet(BaseUrl .. "ye.luau") end)
if success and rawCode then
    local func = loadstring(rawCode)
    if func then pcall(func) else warn("[BlackKing] Error in ye.luau") end
else
    warn("[BlackKing] Failed to fetch ye.luau")
end

print("Script initialized successfully!")
