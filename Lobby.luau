local LoadStart = tick()
BlackKing.SavePath = "Doors/Lobby"
YTMT = "https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/YT_MT%20Image.png"

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
	Icon = YTMT,
	Footer = "Modify by YT_MT(manhtien_yt.) in Discord, Orignal Script By Geroge Join Blackking Discord dsc.gg/BlackKing",
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

Globals.DoorsNotify = function(NotifyOptions)
	local function PlaySound(Parent, SoundId, Volume)
		local Sound = Instance.new("Sound")
		Sound.SoundId = SoundId
		Sound.Volume = Volume or 1
		Sound.Parent = Parent
		task.spawn(function()
			task.wait(0.1)
			Sound:Play()
			Sound.Ended:Wait()
			Sound:Destroy()
		end)
	end

	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	local UIContainer = PlayerGui:FindFirstChild("GlobalUI") or PlayerGui:FindFirstChild("MainUI")
	if not UIContainer then return end

	local AchievementsHolder = UIContainer:FindFirstChild("AchievementsHolder")
	if not AchievementsHolder then return end

	local Achievement = AchievementsHolder.Achievement:Clone()
	Achievement.Size = UDim2.new(0, 0, 0, 0)
	Achievement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
	Achievement.Name = "LiveAchievement"
	Achievement.Visible = true

	Achievement.Frame.TextLabel.Text = NotifyOptions.Style or "NOTIFICATION"
	Achievement.Frame.Details.Title.Text = NotifyOptions.Title or "Sem Título"
	Achievement.Frame.Details.Desc.Text = NotifyOptions.Description or "Sem Descrição"
	Achievement.Frame.Details.Reason.Text = NotifyOptions.Reason or ""
	Achievement.Frame.ImageLabel.Image = (NotifyOptions.Image ~= "" and NotifyOptions.Image) or "rbxassetid://6023426923"

	local Color = NotifyOptions.Color or Color3.new(1, 1, 1)
	Achievement.Frame.TextLabel.TextColor3 = Color
	Achievement.Frame.UIStroke.Color = Color
	Achievement.Frame.Glow.ImageColor3 = Color
	Achievement.Parent = AchievementsHolder

	PlaySound(AchievementsHolder, "rbxassetid://10469938989", 1)

	task.spawn(function()
		Achievement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", 0.8, true)
		task.wait(0.8)
		Achievement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)
		Services.TweenService:Create(
			Achievement.Frame.Glow,
			TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ ImageTransparency = 1 }
		):Play()

		if typeof(NotifyOptions.Time) == "Instance" then
			NotifyOptions.Time.Destroying:Wait()
		else
			task.wait(NotifyOptions.Time or 5)
		end

		Achievement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:TweenSize(UDim2.new(1, 0, -0.1, 0), "InOut", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:Destroy()
	end)
end
local notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/GeorgeRoblox/Notification/refs/heads/main/Source.lua"))()
Functions.Notify = function(Settings)
    local HiddenContainer = GetHiddenContainer()

    if not Settings.Body then
        Settings.Body = "..."
    end

    if not Options.NotifyStyle or Options.NotifyStyle.Value == "BlackKing" then
        local IsEntity = false
        local EntityName = ""

        for Index, Object in pairs(Entities) do
            if Object.NotifyMessage.Title == Settings.Title or Object.NotifyMessage.Body == Settings.Body then
                IsEntity = true
                EntityName = Index
            end
        end
        notify("BlackKing", {
            Title = Settings.Title,
            Description = Settings.Body,
            Image = Settings.Image,
            Color = IsEntity and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 222, 189),
            Time = Settings.Time
        })
    else
        local Sound = Instance.new("Sound", HiddenContainer)
        Sound.SoundId = "rbxassetid://4590662766"
        Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value)
            or (Toggles.NotifyPlaySound and 0 or 3)
        Sound.PlayOnRemove = true
        Sound:Destroy()

        Library:OldNotify({
            Title = Settings.Title,
            Description = Settings.Body,
            Time = Settings.Time
        })
    end
end

Functions.Caption = function(Text, PlaySound)
	if typeof(PlaySound) ~= "boolean" then
		PlaySound = true
	end
	local CaptionValue = Instance.new("NumberValue")
	local Caption = Globals.MainUI:WaitForChild("MainFrame"):WaitForChild("Caption"):Clone()
	local CaptionSound = Globals.MainUI:WaitForChild("Initiator"):WaitForChild("Main_Game"):WaitForChild("Reminder"):WaitForChild("Caption")
	local CaptionSoundClone = CaptionSound:Clone()
	CaptionSoundClone.Parent = CaptionSound.Parent
	CaptionSoundClone.Volume = 0.1

	Caption.Destroying:Connect(function()
		CaptionValue:Destroy()
	end)

	for _, Child in Globals.MainUI:GetChildren() do
		if Child.Name == "LiveCaption" then
			Child:Destroy()
		end
	end

	Caption.Parent = Globals.MainUI
	Caption.Visible = true
	Caption.Name = "LiveCaption"
	Caption.Text = Text

	if PlaySound then
		CaptionSoundClone:Play()
	end

	Services.Debris:AddItem(CaptionSoundClone, 5)

	local HolderTween = Services.TweenService:Create(CaptionValue, TweenInfo.new(3), { Value = 100 })
	HolderTween:Play()
	HolderTween.Completed:Connect(function()
		CaptionValue:Destroy()
		Services.TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), { TextTransparency = 1 }):Play()
		Services.TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), { TextStrokeTransparency = 1 }):Play()
	end)
end

Functions.GetHasteTime = function()
	local TimeRemaining = FloorReplicated.DigitalTimer.Value
	local Minutes = math.floor(TimeRemaining / 60)
	local Seconds = TimeRemaining - (Minutes * 60)
	local MinutesText = Minutes < 10 and ("0" .. tostring(Minutes)) or tostring(Minutes)
	local SecondsText = Seconds < 10 and ("0" .. tostring(Seconds)) or tostring(Seconds)
	return MinutesText .. ":" .. SecondsText
end

Library.OldNotify = Library.Notify
Library.Notify = function(Data, Body, Time)
	Functions.Notify({ Title = Body, Time = Time or 5 })
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
Functions.Notify({ Title = "YT_MT", Body = "BlackKing Susscesfully loaded, orignal script by Geroge (Blackking Owner).", Image = YTMT})
