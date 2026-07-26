local myUrl = ""https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/""

local success, err = pcall(function()
    loadstring(game:HttpGet(myUrl .. "ye.luau"))()
end)

if success then
    print("[BlackKing] Features loaded seamlessly.")
else
    warn("[BlackKing] Fail to hook features: " .. tostring(err))
end
