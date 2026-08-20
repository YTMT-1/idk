return function(Window)
    local LatestChangelog = {
        "10/8/2026",
        "<font color='rgb(0, 255, 0)'>+ Figure Old Supports.</font>",
        "7/8/2026",
        "<font color='rgb(0, 255, 0)'>+ Anti Mandrake.</font>",
        "<font color='rgb(0, 255, 0)'>+ Auto Complete Maze (Outdoors).</font>",
        "<font color='rgb(0, 255, 0)'>+ Lobby Support.</font>",
        "<font color='rgb(0, 255, 0)'>+ Fixed Bugs.</font>",
    }

    local GameStatuses = {
        "🟢 DOORS"
    }

    local function CloneReference(Object)
        if YT_MT and YT_MT.Environment.cloneref then
            return YT_MT.Environment.cloneref(Object)
        else
            return Object
        end
    end

    local Services = setmetatable({}, {
        __index = function(self, Name)
            return CloneReference(game:GetService(Name))
        end
    })

    local Library = YT_MT.Interface.Library
    local LocalPlayer = Services.Players.LocalPlayer

    local InfoTab = Window:AddTab("Home", "home")

    local LeftColumn = InfoTab:AddGroupbox("Account")
    
    -- TẦNG TRÊN BÊN PHẢI: KHUNG TABBOX CHUYÊN DỤNG CHO CHANGELOG
    local TopRightTabbox = InfoTab:AddTabbox()
    local ChangelogTab = TopRightTabbox:AddTab("Latest Changelog")

    local ImageSize = Enum.ThumbnailSize.Size420x420
    local ImageType = Enum.ThumbnailType.HeadShot
    local Content = Services.Players:GetUserThumbnailAsync(LocalPlayer.UserId, ImageType, ImageSize)

    LeftColumn:AddImage("UserIcon", {
        Image = Content
    })

    local Hour = os.date("*t").hour
    local Greeting = "Good Night"
    if Hour >= 5 and Hour < 12 then
        Greeting = "Good morning"
    elseif Hour >= 12 and Hour < 17 then
        Greeting = "Good afternoon"
    elseif Hour >= 17 and Hour < 21 then
        Greeting = "Good evening"
    end

    LeftColumn:AddLabel(Greeting .. " <font color='rgb(255, 255, 255)'><b>" .. LocalPlayer.Name .. "</b></font>! Welcome back to yt_mt!", true)
    LeftColumn:AddDivider()

    LeftColumn:AddButton("Script Dashboard", function() end)
    LeftColumn:AddButton("Main Server", function()
        if setclipboard then setclipboard("dsc.gg/gUsPTPYArx") end
        Library:Notify("Main Server link copied.")
    end)

    for _, Change in pairs(LatestChangelog) do
        ChangelogTab:AddLabel(Change, true)
    end

    -- TẦNG DƯỚI BÊN PHẢI: GROUPBOX THÔNG THƯỜNG DÀNH CHO GAME STATUS
    local RightColumnBottom = InfoTab:AddRightGroupbox("Game Status")
    for _, Status in pairs(GameStatuses) do
        RightColumnBottom:AddLabel(Status, true)
    end

    RightColumnBottom:AddDivider()
    RightColumnBottom:AddLabel("You can report bugs or suggest features in the on-site dashboard:", true)
    RightColumnBottom:AddButton("Copy Link", function()
        if setclipboard then setclipboard("https://dsc.gg") end
        Library:Notify("Dashboard link copied.")
    end)
end
