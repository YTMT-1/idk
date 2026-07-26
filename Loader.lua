local BaseUrl = "https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/"

-- Nếu người chơi đang ở game Doors HOẶC game phụ thì mới tải script
if game.PlaceId == 6516141723 or game.PlaceId == 1785036888943 then
    loadstring(game:HttpGet(BaseUrl .. "ye.luau"))()
end
