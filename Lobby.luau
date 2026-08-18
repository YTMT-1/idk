local LoadStart = tick()
YT_MT.SavePath = "Doors/Lobby"
YTMT = "https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/YT_MT%20Image.png"

local Library = YT_MT.Interface.Library
local SaveManager = YT_MT.Interface.SaveManager
local ThemeManager = YT_MT.Interface.ThemeManager

local Toggles = Library.Toggles
local Options = Library.Options

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
	Title = "YT_MT Hub",
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

YT_MT.Interface.ApplyInfoTab(Window)
local Tabs = {
    General = Window:AddTab("General", "house"),
}

Functions.CheckCompatability = function(Array)
    local Valid = true
    for Index, Name in pairs(Array) do
        if not YT_MT.Environment[Name] then
            Valid = false
        end
    end
    return Valid
end

local function GetHiddenContainer()
	if Functions.CheckCompatability({"gethui"}) then
		return YT_MT.Environment.gethui()
	else
		return Services.CoreGui
	end
end

Functions.Notify = function(Settings)
    local ObsidianObj = getgenv().Library or getgenv().Obsidian or _G.Library
    if ObsidianObj and type(ObsidianObj.Notify) == "function" then
        ObsidianObj:Notify({
            Title = Settings.Title,
            Content = Settings.Body,
            Duration = Settings.Time or 5
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
        local char = LocalPlayer.Character
        if not char then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://12874447851"
        
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
	getgenv().YT_MT = nil
end)

YT_MT.Interface.ApplySettingsTab(Window)
local AddonsTab = Window:AddTab("Addons", "boxes")

if listfiles and isfolder and makefolder then
    if not isfolder("YT_MT") then
        makefolder("YT_MT")
    end
    if not isfolder("YT_MT/YT_MT_Addons") then
        makefolder("YT_MT/YT_MT_Addons")
    end

    local success, files = pcall(listfiles, "YT_MT/YT_MT_Addons")
    local validFiles = {}

    if success and #files > 0 then
        for _, filePath in pairs(files) do
            if filePath:sub(-5):lower() == ".luau" or filePath:sub(-4):lower() == ".lua" then
                table.insert(validFiles, filePath)
            end
        end
    end

    if #validFiles == 0 then
        -- RÁP CHUẨN UPDATEWARNINGBOX ĐỎ RỰC Y CHÓC MSPAINT BẢN GỐC:
        AddonsTab:UpdateWarningBox({
            Title = "WARNING",
            Text = "Your addons FOLDER is empty! (workspace/YT_MT/YT_MT_Addons)",
            IsNormal = false,
            Visible = true,
            LockSize = true
        })
    else
        -- Ẩn bảng warning đi nếu có file addon chạy ghen bro
        AddonsTab:UpdateWarningBox({ Visible = false })

        for _, filePath in pairs(validFiles) do
            local readSuccess, content = pcall(readfile, filePath)
            if readSuccess and content then
                
                local env = setmetatable({
                    YT_MT_Addons = {
                        Window = Window,
                        AddonsTab = AddonsTab
                    }
                }, { __index = getfenv() })

                local func, compileErr = loadstring(content)
                if func then
                    setfenv(func, env)
                    pcall(func)
                end
            end
        end
    end
else
    AddonsTab:UpdateWarningBox({
        Title = "SYSTEM ERROR",
        Text = "Your executor does not support File System functions (UNC).",
        IsNormal = false,
        Visible = true,
        LockSize = true
    })
end
Functions.Notify({ Title = "YT_MT", Body = "BlackKing Susscesfully loaded, orignal script by Geroge (Blackking Owner).", Time = 5})
