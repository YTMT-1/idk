local BaseUrl = "https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/"
if game.PlaceId == 137519142947486 or game.PlaceId == 92934548952604 or game.PlaceId == 131351567799504 or game.PlaceId == 104289811284920 or game.PlaceId == 6839171747 or game.PlaceId == 2440500124 or game.PlaceId == 87716067947993 or game.PlaceId == 10549820578 or game.PlaceId == 110258689672367 then
    loadstring(game:HttpGet(BaseUrl .. "Game.luau"))()
else
    loadstring(game:HttpGet(BaseUrl .. "Lobby.luau"))()
end
