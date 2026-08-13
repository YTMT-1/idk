local BaseUrl = "https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/"
if game.PlaceId == 6516141723 then
    loadstring(game:HttpGet(BaseUrl .. "Lobby.luau"))()
else
    loadstring(game:HttpGet(BaseUrl .. "Game.luau"))()
end
