local LoadStart = tick()
BlackKing.SavePath = "Doors/Lobby"

local Library = BlackKing.Interface.Library
local SaveManager = BlackKing.Interface.SaveManager
local ThemeManager = BlackKing.Interface.ThemeManager

local Toggles = Library.Toggles
local Options = Library.Options

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

local Gb = {}
local Globals = {}
local Con = {}
local Functions = {}

local LocalPlayer = Services.Players.LocalPlayer
local RemotesFolder = Services.ReplicatedStorage:WaitForChild("RemotesFolder")

while not LocalPlayer.Character do
    task.wait()
end
task.wait(1)

local Window = Library:CreateWindow({
    Title = "BlackKing",
    Footer = "dsc.gg/BlackKing",
    NotifySide = "Right",
    ShowCustomCursor = false,
    AutoShow = true,
    Center = true,
	TabPadding = 3,
	MenuFadeTime = 0,
    CornerRadius = 2,
})

BlackKing.Interface.ApplyInfoTab(Window)
local Tabs = {
    General = Window:AddTab("General", "house"),
}

Functions.CheckCompatability = function(Array)
    local Valid = true
    for Index, Name in pairs(Array) do
        if not BlackKing.Environment[Name] then
            Valid = false
        end
    end
    return Valid
end

local function GetHiddenContainer()
	if Functions.CheckCompatability({"gethui"}) then
		return BlackKing.Environment.gethui()
	else
		return Services.CoreGui
	end
end

local NotificationLibrary = {
	LiveNotifications = 0,
    Notifications = 1
}

local Container = Instance.new("ScreenGui")
Container.Name = BlackKing.ESPLibrary:GenerateRandomString()
Container.Parent = GetHiddenContainer()
Container.DisplayOrder = 32767
Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not Library.Scheme then
    Library.Scheme = setmetatable({}, {
        __index = function(self, Name)
            return Library[Name]
        end
    })
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local BlackKingGui = Instance.new("ScreenGui")
BlackKingGui.Name = "BlackKingNotificationGui"
BlackKingGui.ResetOnSpawn = false
BlackKingGui.IgnoreGuiInset = true
BlackKingGui.DisplayOrder = 999999
BlackKingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BlackKingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "NotificationHolder"
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.BorderSizePixel = 0
NotificationHolder.AnchorPoint = Vector2.new(0.5, 0.5)
NotificationHolder.Position = UDim2.fromScale(0.5, 0.5)
NotificationHolder.Size = UDim2.fromScale(1, 1)
NotificationHolder.ZIndex = 999999
NotificationHolder.Parent = BlackKingGui

local Notifications = {}

local NotificationSpacing = 0.065

local LogoURL = "https://raw.githubusercontent.com/GeorgeRoblox/Notification/refs/heads/main/Images/bcrown.png"
local LogoFile = "BlackKing_B_Crown.png"

local function GetLogoAsset()
    local Success, Result = pcall(function()
        if not isfile or not writefile or not getcustomasset then
            return nil
        end

        if not isfile(LogoFile) then
            local Request =
                (syn and syn.request)
                or request
                or http_request
                or (http and http.request)

            if not Request then
                return nil
            end

            local Response = Request({
                Url = LogoURL,
                Method = "GET"
            })

            if Response and Response.Body then
                writefile(LogoFile, Response.Body)
            end
        end

        if isfile(LogoFile) then
            return getcustomasset(LogoFile)
        end

        return nil
    end)

    if Success then
        return Result
    end

    return nil
end

local LogoAsset = GetLogoAsset()

local function UpdateBlackKingPositions()
    for Index, Data in ipairs(Notifications) do
        if Data.Main and Data.Main.Parent then
            local TargetY = 0.60 + ((Index - 1) * NotificationSpacing)

            TweenService:Create(
                Data.Main,
                TweenInfo.new(
                    0.45,
                    Enum.EasingStyle.Quart,
                    Enum.EasingDirection.Out
                ),
                {
                    Position = UDim2.fromScale(0.5, TargetY)
                }
            ):Play()
        end
    end
end

local function BlackKingNotify(TitleText, DescriptionText, Image, Color, Time)
    local MainColor = Color or Color3.fromRGB(0, 120, 255)

    local Main = Instance.new("Frame")
    Main.Name = "Notification"
    Main.Parent = NotificationHolder
    Main.AnchorPoint = Vector2.new(0.5, 0.5)

    Main.Size = UDim2.fromScale(0.23, 0.06)
    Main.Position = UDim2.fromScale(0.5, 0.68)

    Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Main.BackgroundTransparency = 1

    Main.BorderSizePixel = 1
    Main.BorderColor3 = MainColor

    Main.ZIndex = 999999

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Main

    local Line = Instance.new("Frame")
    Line.Name = "Line"
    Line.Parent = Main
    Line.AnchorPoint = Vector2.new(0, 1)
    Line.Position = UDim2.fromScale(0, 1)
    Line.Size = UDim2.fromScale(0, 0.035)
    Line.BackgroundColor3 = MainColor
    Line.BackgroundTransparency = 1
    Line.BorderSizePixel = 0
    Line.ZIndex = 1000000

    local LineCorner = Instance.new("UICorner")
    LineCorner.CornerRadius = UDim.new(1, 0)
    LineCorner.Parent = Line

    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = Main
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.Position = UDim2.fromScale(0.067, 0.5)
    Logo.Size = UDim2.fromScale(0.115, 0.88)
    Logo.BackgroundTransparency = 1
    Logo.BorderSizePixel = 0
    Logo.ScaleType = Enum.ScaleType.Fit
    Logo.ImageTransparency = 1
    Logo.ZIndex = 1000000

    if Image and Image ~= "" then
        if typeof(Image) == "string" and Image:sub(1, 13) == "rbxassetid://" then
            Logo.Image = Image
        elseif isfile and isfile(Image) and getcustomasset then
            Logo.Image = getcustomasset(Image)
        elseif LogoAsset then
            Logo.Image = LogoAsset
        end
    elseif LogoAsset then
        Logo.Image = LogoAsset
    end

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Main
    Title.AnchorPoint = Vector2.new(0, 0.5)
    Title.Position = UDim2.fromScale(0.135, 0.35)
    Title.Size = UDim2.fromScale(0.84, 0.35)
    Title.BackgroundTransparency = 1
    Title.BorderSizePixel = 0

    Title.Font = Enum.Font.SourceSans
    Title.Text = "[BlackKing] " .. tostring(TitleText or "Notification")
    Title.TextScaled = true
    Title.TextSize = 1
    Title.TextStrokeTransparency = 0.5
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextColor3 = MainColor
    Title.TextTransparency = 1
    Title.ZIndex = 1000000

    local Description = Instance.new("TextLabel")
    Description.Name = "Description"
    Description.Parent = Main
    Description.AnchorPoint = Vector2.new(0, 0.5)
    Description.Position = UDim2.fromScale(0.135, 0.68)
    Description.Size = UDim2.fromScale(0.84, 0.29)
    Description.BackgroundTransparency = 1
    Description.BorderSizePixel = 0

    Description.Font = Enum.Font.SourceSans
    Description.Text = tostring(DescriptionText or "...")
    Description.TextScaled = true
    Description.TextSize = 1
    Description.TextStrokeTransparency = 0.5
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextColor3 = MainColor
    Description.TextTransparency = 1
    Description.ZIndex = 1000000

    local Number = math.max(
        Title.TextBounds.X,
        Description.TextBounds.X
    ) * 1.125

    local FinalOffset = math.clamp(
        Number - 265,
        0,
        1000
    )

    Main.Size += UDim2.fromOffset(FinalOffset, 0)

    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://3318713980"
    Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
    Sound.PlayOnRemove = true
    Sound.Parent = game.CoreGui
    Sound:Destroy()

    local Data = {
        Main = Main,
        Line = Line,
        Logo = Logo,
        Title = Title,
        Description = Description
    }

    table.insert(Notifications, Data)

    local Index = #Notifications

    local TargetY = 0.60 + ((Index - 1) * NotificationSpacing)

    local LockColor

    LockColor = RunService.RenderStepped:Connect(function()
        if not Main or not Main.Parent then
            if LockColor then
                LockColor:Disconnect()
            end

            return
        end

        Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

        Main.BorderColor3 = MainColor:Lerp(
            Color3.new(0, 0, 0),
            0.4
        )

        Line.BackgroundColor3 = MainColor

        Logo.ImageColor3 = MainColor

        Title.TextColor3 = MainColor

        Title.TextStrokeColor3 = MainColor:Lerp(
            Color3.new(0, 0, 0),
            0.8
        )

        Description.TextColor3 = MainColor:Lerp(
            Color3.new(0, 0, 0),
            0.15
        )

        Description.TextStrokeColor3 = MainColor:Lerp(
            Color3.new(0, 0, 0),
            0.8
        )
    end)

    local Timer = Time or 3.33

    local InInfo = TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )

    TweenService:Create(
        Main,
        InInfo,
        {
            Position = UDim2.fromScale(0.5, TargetY),
            BackgroundTransparency = 0.4
        }
    ):Play()

    TweenService:Create(
        Line,
        InInfo,
        {
            BackgroundTransparency = 0
        }
    ):Play()

    TweenService:Create(
        Logo,
        InInfo,
        {
            ImageTransparency = 0
        }
    ):Play()

    TweenService:Create(
        Title,
        InInfo,
        {
            TextTransparency = 0
        }
    ):Play()

    TweenService:Create(
        Description,
        InInfo,
        {
            TextTransparency = 0
        }
    ):Play()

    Line:TweenSize(
        UDim2.fromScale(1, 0.035),
        "Out",
        "Linear",
        Timer
    )

    task.delay(Timer + 0.1, function()
        if not Main or not Main.Parent then
            return
        end

        local OutInfo = TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.In
        )

        local MainTween = TweenService:Create(
            Main,
            OutInfo,
            {
                Position = UDim2.fromScale(
                    0.5,
                    TargetY - 0.045
                ),
                BackgroundTransparency = 1
            }
        )

        MainTween:Play()

        TweenService:Create(
            Line,
            OutInfo,
            {
                BackgroundTransparency = 1
            }
        ):Play()

        TweenService:Create(
            Logo,
            OutInfo,
            {
                ImageTransparency = 1
            }
        ):Play()

        TweenService:Create(
            Title,
            OutInfo,
            {
                TextTransparency = 1
            }
        ):Play()

        TweenService:Create(
            Description,
            OutInfo,
            {
                TextTransparency = 1
            }
        ):Play()

        MainTween.Completed:Once(function()
            if LockColor then
                LockColor:Disconnect()
            end

            for i, Notification in ipairs(Notifications) do
                if Notification == Data then
                    table.remove(Notifications, i)
                    break
                end
            end

            Main:Destroy()

            UpdateBlackKingPositions()
        end)
    end)
end

Functions.Notify = function(Settings)
    local Container
    if Functions.CheckCompatability({"gethui"}) then
        Container = BlackKing.Environment.gethui()
    else
        Container = Services.CoreGui
    end

	local NotificationColor = Color3.fromRGB(0, 120, 255)

	BlackKingNotify(
            Settings.Title,
            Settings.Body,
            Settings.Image,
            NotificationColor,
            Settings.Time or 5
        )
end

Library.Notify = function(Data, Body, Time)
    Functions.Notify({Title = Body, Time = Time or 5})
end

Functions.CheckElevators = function()
    local TargetFound = false
	if not Toggles.AutoJoinElevator.Value then
		return
	end
	local TargetCharacter
	if typeof(Options.AutoJoinElevatorTarget.Value) == "Instance" then
		TargetCharacter = Options.AutoJoinElevatorTarget.Value.Character
	elseif typeof(Options.AutoJoinElevatorTarget.Value) == "string" then
		TargetCharacter = Services.Players:FindFirstChild(Options.AutoJoinElevatorTarget.Value).Character
	end

	for Index, Elevator in pairs(Services.Workspace.Lobby.LobbyElevators:GetChildren()) do
		if TargetCharacter and Elevator and TargetCharacter:GetAttribute("InGameElevator") and Elevator:GetAttribute("ID") and Elevator:GetAttribute("ID") == TargetCharacter:GetAttribute("InGameElevator") then
			TargetFound = true
			RemotesFolder.ElevatorJoin:FireServer(Elevator)
        end
    end
	if TargetFound == false then
		RemotesFolder.ElevatorExit:FireServer()
	end
end

Globals.RedeemingCodes = false
Globals.CodesList = {
    "67",
	"54",
	"41",
	"CHEDDAR BALLS",
	"XQC",
	"PENGUINZ0",
	"KREEKCRAFT",
	"ISHOWSPEED",
	"DANTDM",
	"KUBZ SCOUTS",
	"FIND THE TROLLFACES",
	"THINKNOODLES",
	"W",
	"RAGDOLL UNIVERSE",
	"RAGDOLL MAYHEM",
	"BIJUU MIKE",
	"8BITRYAN",
	"SCREECHSUCKS",
	"LORE",
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ",
	"FIND THE TROLLFACES",
	"3rd",
	"LAZYDEVS",
	"RAGDOLL COMBAT",
	"VOCAB HAVOC",
	"PATHSWAP",
	"JUMP OVER THE BRICK"
}
Globals.UnlockedBadges = {}

Gb.General_Self = Tabs.General:AddLeftGroupbox("Self")

Gb.General_Self:AddToggle("AutoJoinElevator", {
    Text = "Auto Join Elevator",
    Default = false,
    Tooltip = "Automatically joins the selected player's elevator."
})

Gb.General_Self:AddDropdown("AutoJoinElevatorTarget", {
    Text = "Target",
    SpecialType = "Player",
    ExcludeLocalPlayer = true,
    Searchable = true
})
Gb.General_Self:AddDivider()
Gb.General_Self:AddToggle("TwerkDance", { 
    Text = "Twerk", 
    Default = false, 
    Tooltip = "just Twerk." 
})
local track


Toggles.TwerkDance:OnChanged(function(Value)
    if Value then

        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://12874447851"

		local hum = Character:FindFirstChildOfClass("Humanoid")
        track = hum:LoadAnimation(anim)
        track.Looped = true
        track:Play()

    else
        if track then
            track:Stop()
        end
    end
end)
Gb.General_Automation = Tabs.General:AddLeftGroupbox("Automation")

Gb.General_Automation:AddToggle("CycleAchievements", {
    Text = "Cycle Achievements",
    Default = false,
    Tooltip = "Rapidly equips a random badge."
})

Gb.General_Automation:AddSlider("CycleAchievementsDelay", {
    Text = "Cycle Delay",
    Min = 0,
    Max = 1,
    Default = 0.1,
    Rounding = 2,
    Compact = true
})

Gb.General_Automation:AddDivider()

Gb.General_Automation:AddButton("Redeem All Codes", function()
    if Globals.RedeemingCodes then
        return
    end

    Functions.Notify({Title = "Redeeming " .. #Globals.CodesList .. " codes.", Body = "Please wait."})
    Globals.RedeemingCodes = true
    for Index, Code in pairs(Globals.CodesList) do
        RemotesFolder.ShopCode:FireServer(Code)
        task.wait(5.1)
    end
end)

for Index, Frame in pairs(LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:GetChildren()) do
	if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
		table.insert(Globals.UnlockedBadges, Frame.Name)
	end
end

Con.BadgeAddedConnection = LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List.ChildAdded:Connect(function(Frame)
	Services.RunService.Heartbeat:Wait()
	if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
		table.insert(Globals.UnlockedBadges, Frame.Name)
	end
end)

Globals.LastBadgeChange = tick()
Globals.LastElevatorCheck = tick()
Con.MainConnection = Services.RunService.Heartbeat:Connect(function()
	if tick() - Globals.LastElevatorCheck > 0.25 then
    	Functions.CheckElevators()
		Globals.LastElevatorCheck = tick()
	end

    if Toggles.CycleAchievements.Value and tick() - Globals.LastBadgeChange > Options.CycleAchievementsDelay.Value then
        local Badge = Globals.UnlockedBadges[math.random(1, #Globals.UnlockedBadges)]
        if Badge == PreviousBadge then
            while task.wait() do
				local NewBadge = Globals.UnlockedBadges[math.random(1, #Globals.UnlockedBadges)]
				if NewBadge ~= PreviousBadge then
					Badge = NewBadge
					break
				end
			end
		end
		for Index, Frame in pairs(LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:GetChildren()) do
			if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
				LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Frame.Name).Icons.Star.Visible = false
			end
		end
		RemotesFolder:WaitForChild("FlexAchievement"):FireServer(Badge)
		PreviousBadge = Badge
		LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Badge).Icons.Star.Visible = true

        Globals.LastBadgeChange = tick()
	end
end)

Gb.General_QuickPlay = Tabs.General:AddRightGroupbox("Quick Play")
Gb.General_QuickPlay:AddSlider("AmountOfPlayers", {
    Text = "Amount Of Players",
    Min = 1,
    Max = 50,
    Default = 1,
    Rounding = 0,
    Compact = true
})
Gb.General_QuickPlay:AddButton({
	Text = "The Hotel",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {},
        	Settings = {},
        	Destination = "Hotel",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddButton({
	Text = "The Mines",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {},
        	Settings = {},
        	Destination = "Mines",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddButton({
	Text = "The Backdoor",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {},
        	Settings = {},
        	Destination = "Backdoor",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddButton({
	Text = "The Rooms",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {},
        	Settings = {},
        	Destination = "Rooms",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddButton({
	Text = "The Outdoors",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {},
        	Settings = {},
        	Destination = "Garden",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddDivider()

Gb.General_QuickPlay:AddButton({
	Text = "Battle Mode",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {},
        	Settings = {},
        	Destination = "Party",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddButton({
	Text = "Retro Mode",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {},
        	Settings = {},
        	Destination = "Retro",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddButton({
	Text = "Rush Mode",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {},
        	Settings = {},
        	Destination = "Fools26",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddDivider()

Gb.General_QuickPlay:AddButton({
	Text = "Halloween",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {},
        	Settings = {},
        	Destination = "Halloween25",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddButton({
	Text = "Hotel-",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {},
        	Settings = {},
        	Destination = "BeforePlus",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddButton({
	Text = "Super Hard Mode",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {},
        	Settings = {},
        	Destination = "SuperHardMode",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddDivider()

Gb.General_QuickPlay:AddButton({
	Text = "The Rooms [Free, No Progress]",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {
				"AdminPanel"
			},
        	Settings = {},
        	Destination = "Rooms",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_QuickPlay:AddButton({
	Text = "The Outdoors [Free, No Progress]",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {
				"AdminPanel"
			},
        	Settings = {},
        	Destination = "Garden",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})

Gb.General_Challenges = Tabs.General:AddRightGroupbox("Challenges")
Gb.General_Challenges:AddButton({
	Text = "Hotel Hell",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        Mods = {
            "PlayerHealthLess",
            "Gloombat",
            "RoomsA90",
            "EntitiesMost",
            "EyesLevel2",
            "DupeMost",
            "BackdoorVacuum",
            "BackdoorLookman",
            "NoKeySound",
            "BackdoorRush",
            "EyesMore",
            "Dread",
            "FigureFaster",
            "RushMore",
            "LockMost",
            "FiredampMost"
        },
        	Settings = {},
        	Destination = "Hotel",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})
Gb.General_Challenges:AddButton({
	Text = "Not Five Stars",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        Mods = {
            "PlayerHealthLess",
            "Gloombat",
            "NoKeySound",
            "PlayerLessSlots",
            "GoldSpawnNone",
            "LockMost"
        },
        	Settings = {},
        	Destination = "Hotel",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})
Gb.General_Challenges:AddButton({
	Text = "A hard Place",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {
            "PlayerHealthLess",
            "PlayerLeastSlots",
            "RoomsA90",
            "EntitiesMost",
            "DupeMost",
            "BackdoorVacuum",
            "BackdoorLookman",
            "NoKeySound",
            "Dread",
            "GoldSpawnNone",
            "FigureFaster",
            "RushQuiet",
            "RushMore",
            "FiredampMost"
			},
        	Settings = {},
        	Destination = "Mines",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})
Gb.General_Challenges:AddButton({
	Text = "Rocky Road",
	DoubleClick = false,
	Func = function()
		RemotesFolder.CreateElevator:FireServer({
        	Mods = {
			"PlayerHealthLess",
            "PlayerLessSlots",
            "GoldSpawnNone",
            "RushQuiet",
            "FiredampMost"
			},
        	Settings = {},
        	Destination = "Mines",
        	FriendsOnly = false,
        	MaxPlayers = Options.AmountOfPlayers.Value
    	})
	end
})
Library:OnUnload(function()
    Con.MainConnection:Disconnect()
	getgenv().BlackKing = nil
end)

BlackKing.Interface.ApplySettingsTab(Window)
Functions.Notify({ Title = "Successfully loaded in " .. math.floor((tick() - LoadStart) * 1000) / 1000 .. " seconds." , Body = "Press '" .. tostring(Options.MenuKeybind.Value) .. "' to toggle the UI."})
