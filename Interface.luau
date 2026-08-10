local Library = (BlackKing.UILibrary == "Linoria" and "LinoriaLib" or "Obsidian")

local BaseUrl = "https://raw.githubusercontent.com/deividcomsono/" .. Library .. "/refs/heads/main/"
local BlackKingUrl = "https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/"

print("=========================================")
print("[START DEBUG] Bắt đầu kiểm tra lỗi script...")
print("=========================================")

local errorList = {} -- Nơi lưu trữ tất cả các lỗi phát hiện được

-- Hàm kiểm tra lỗi chi tiết từng file
local function debugLoad(url, name)
    print("\n-----------------------------------------")
    print("[DEBUG] Đang xử lý file: " .. name)
    print("[DEBUG] URL: " .. url)
    
    -- 1. Kiểm tra tải file (HttpGet)
    local getSuccess, content = pcall(game.HttpGet, game, url)
    if not getSuccess then
        local errMsg = "KHÔNG THỂ KẾT NỐI URL (Lỗi HttpGet). Chi tiết: " .. tostring(content)
        warn("[LỖI] " .. name .. " -> " .. errMsg)
        table.insert(errorList, {file = name, step = "HttpGet", details = errMsg})
        return nil
    end
    
    -- Kiểm tra nếu GitHub trả về 404 (Sai link)
    if content:find("404: Not Found") or content == "" or content:find("<!DOCTYPE html>") then
        local errMsg = "LỖI 404 NOT FOUND (Đường dẫn URL bị sai hoặc file không tồn tại trên GitHub)."
        warn("[LỖI] " .. name .. " -> " .. errMsg)
        table.insert(errorList, {file = name, step = "Check Content", details = errMsg})
        return nil
    end

    -- 2. Kiểm tra cú pháp Luau/Lua (loadstring)
    local compileSuccess, result = pcall(loadstring, content)
    if not compileSuccess then
        local errMsg = "LỖI BIÊN DỊCH LOADSTRING. Chi tiết: " .. tostring(result)
        warn("[LỖI] " .. name .. " -> " .. errMsg)
        table.insert(errorList, {file = name, step = "loadstring", details = errMsg})
        return nil
    elseif not result then
        local errMsg = "LỖI CÚ PHÁP SCRIPT (Syntax Error bên trong code của file). Chi tiết lỗi của executor: " .. tostring(result)
        warn("[LỖI] " .. name .. " -> " .. errMsg)
        table.insert(errorList, {file = name, step = "Syntax", details = errMsg})
        return nil
    end

    -- 3. Kiểm tra khởi chạy code (Execution)
    local runSuccess, finalModule = pcall(result)
    if not runSuccess then
        local errMsg = "SCRIPT BỊ CRASH KHI CHẠY (Runtime Error). Chi tiết: " .. tostring(finalModule)
        warn("[LỖI] " .. name .. " -> " .. errMsg)
        table.insert(errorList, {file = name, step = "Runtime", details = errMsg})
        return nil
    end

    print("[THÀNH CÔNG] File " .. name .. " hoạt động hoàn hảo.")
    return finalModule
end

-- Tiến hành tải và kiểm tra từng file
local Interface = {
    Library          = debugLoad(BaseUrl .. "Library.lua", "Library.lua"),
    SaveManager      = debugLoad(BaseUrl .. "addons/SaveManager.lua", "SaveManager.lua"),
    ThemeManager     = debugLoad(BaseUrl .. "addons/ThemeManager.lua", "ThemeManager.lua"),
    ApplyInfoTab     = debugLoad(BlackKingUrl .. "Components/InfoTab.luau", "InfoTab.luau"),
    ApplySettingsTab = debugLoad(BlackKingUrl .. "Components/SettingsTab.luau", "SettingsTab.luau")
}

-- Kiểm tra ThemeManager
print("\n-----------------------------------------")
if Interface.ThemeManager then
    print("[DEBUG] Đang nạp danh sách BuiltInThemes...")
    local themeSuccess, themeErr = pcall(function()
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
    end)
    if themeSuccess then
        print("[THÀNH CÔNG] Đã nạp bảng màu BuiltInThemes.")
    else
        local errMsg = "Lỗi khi gán BuiltInThemes. Chi tiết: " .. tostring(themeErr)
        warn("[LỖI] ThemeManager -> " .. errMsg)
        table.insert(errorList, {file = "ThemeManager", step = "SetThemes", details = errMsg})
    end
else
    local errMsg = "Bỏ qua nạp BuiltInThemes vì ThemeManager không tải được từ trước."
    warn("[CẢNH BÁO] " .. errMsg)
    table.insert(errorList, {file = "ThemeManager", step = "Skip", details = errMsg})
end

-- =========================================
-- TỔNG KẾT KẾT QUẢ DEBUG ĐỂ BẠN COPPY
-- =========================================
print("\n=========================================")
print("[TỔNG KẾT] DANH SÁCH TOÀN BỘ LỖI PHÁT HIỆN:")
print("=========================================")

if #errorList == 0 then
    print("[HOÀN HẢO] Không phát hiện bất kỳ lỗi nào! Script sẵn sàng hoạt động.")
else
    warn("[CHÚ Ý] Tìm thấy " .. #errorList .. " lỗi sau đây:")
    for idx, err in ipairs(errorList) do
        print(string.format("[%d] File: %s | Bước bị lỗi: %s", idx, err.file, err.step))
        print("    -> Nội dung lỗi: " .. err.details)
    end
end
print("=========================================\n")

return Interface
