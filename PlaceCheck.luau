local BaseUrl = "https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/"

local placeToFile = {
    [137519142947486] = "Game.luau",
    [92934548952604] = "Game.luau",
    [131351567799504] = "Game.luau",
    [104289811284920] = "Game.luau",
    [6839171747] = "Game.luau",
    [2440500124] = "Game.luau",
    [87716067947993] = "Game.luau",
    [10549820578] = "Game.luau",
    [110258689672367] = "Game.luau",
    [15722706376] = "Game.luau",
    [6839171747] = "Game.luau",
    [6516141723] = "Lobby.luau",
    [107838858975205] = "Lobby.luau",
    [74871629393921] = "Lobby.luau",
}

local filename = placeToFile[game.PlaceId] or "Universal.luau"

local ok, bodyOrErr = pcall(function()
    return game:HttpGet(BaseUrl .. filename)
end)

if not ok then
    warn("HttpGet failed:", bodyOrErr)
    return
end

local chunk, loadErr = loadstring(bodyOrErr)
if not chunk then
    warn("loadstring error:", loadErr)
    return
end

local success, runErr = pcall(chunk)
if not success then
    warn("error running loaded code:", runErr)
end
