local Services = setmetatable({}, {
	__index = function(Self, Name)
		return game:GetService(Name)
	end
})

local LocalPlayer = Services.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Library = YT_MT.Interface.Library
local SaveManager = YT_MT.Interface.SaveManager
local ThemeManager = YT_MT.Interface.ThemeManager

local Window = Library:CreateWindow({
	Title = "YT_MT Hub",
	Icon = "rbxasset://135701670173318",
	Footer = "Modify by YT_MT(manhtien_yt.) in Discord, Orignal Script By Geroge Join Blackking Discord dsc.gg/BlackKing",
	NotifySide = "Right",
	ShowCustomCursor = false,
	AutoShow = true,
	Center = true,
	TabPadding = 3,
	MenuFadeTime = 0,
	CornerRadius = 5,
})

YT_MT.Interface.ApplyInfoTab(Window)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

ThemeManager:SetFolder("YT_MT")
SaveManager:SetFolder("YT_MT/universal")

local Tabs = {
	Main     = Window:AddTab("Main", "house"),
	Exploits = Window:AddTab("Exploits", "bug"),
	Visuals  = Window:AddTab("Visuals", "view"),
}

local Toggles = Library.Toggles
local Options = Library.Options

local Gb = {}
Gb.Main_Player = Tabs.Main:AddLeftGroupbox("Player")

Gb.Main_Player:AddSlider("SpeedSlider", {
	Text = "Walk Speed", Min = 16, Max = 100, Default = 16, Rounding = 0, Compact = true
})
Gb.Main_Player:AddSlider("JumpSlider", {
	Text = "Jump Power", Min = 50, Max = 200, Default = 50, Rounding = 0, Compact = true
})

Gb.Main_Player:AddDivider()

Gb.Main_Player:AddToggle("SpeedToggle", {
	Text = "Speed Hack", Default = false
})
Gb.Main_Player:AddToggle("JumpToggle", {
	Text = "Jump Power Hack", Default = false
})

Gb.Main_Player:AddDivider()

Gb.Main_Player:AddToggle("InstantInteractToggle", {
	Text = "Instant Interact", Default = false
})
Gb.Main_Player:AddToggle("DisableVoidToggle", {
	Text = "Disable Roblox Void", Default = false
})
Gb.Main_Player:AddToggle("AntiAFKToggle", {
	Text = "Anti AFK", Default = false
})

Gb.Main_Player:AddDivider()

Gb.Main_Player:AddToggle("NoclipToggle", {
	Text = "Noclip", Default = false
}):AddKeyPicker("NoclipKeybind", {
	Text = "Noclip", Default = "N", Mode = "Toggle", SyncToggleState = true
})

Gb.Main_Player:AddToggle("FlyToggle", {
	Text = "Fly", Default = false
}):AddKeyPicker("FlyKeybind", {
	Text = "Fly", Default = "F", Mode = "Toggle", SyncToggleState = true
})

Gb.Main_Player:AddSlider("FlySpeed", {
	Text = "Fly Speed", Min = 10, Max = 100, Default = 16, Rounding = 0, Compact = true
})

Gb.Main_Player:AddDivider()

Gb.Main_Player:AddToggle("InfJumpToggle", {
	Text = "Inf Jump", Default = false
})

Gb.Main_Misc = Tabs.Main:AddRightGroupbox("Miscellaneous")

Gb.Main_Misc:AddButton({
	Text = "Reset",
	Func = function()
		local char = LocalPlayer.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid").Health = 0
		end
	end
})

Gb.Main_Misc:AddButton({
	Text = "Rejoin",
	Func = function()
		Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end
})

Gb.Exploits_Colors = Tabs.Exploits:AddLeftGroupbox("Colors")
Gb.Exploits_Colors:AddColorPicker("FOVCircleColor", {
	Text = "FOV Circle Color", Default = Color3.fromRGB(255, 255, 255)
})
Gb.Exploits_Colors:AddColorPicker("TargetColor", {
	Text = "Current Target Color", Default = Color3.fromRGB(0, 255, 0)
})

Gb.Exploits_Settings = Tabs.Exploits:AddLeftGroupbox("Settings")
Gb.Exploits_Settings:AddToggle("StickyAimbot", {
	Text = "Sticky Aimbot", Default = false
})

Gb.Exploits_Settings:AddDivider()

Gb.Exploits_Settings:AddDropdown("TargetPart", {
	Text = "Target Part",
	Values = {"Head", "HumanoidRootPart", "Torso"},
	Default = 1,
})

Gb.Exploits_Aimbot = Tabs.Exploits:AddLeftGroupbox("Aimbot")

Gb.Exploits_Aimbot:AddToggle("AimbotToggle", {
	Text = "Enable Aimbot", Default = false
}):AddKeyPicker("AimbotKeybind", {
	Text = "Aimbot", Default = "MB2", Mode = "Toggle", SyncToggleState = true
})

Gb.Exploits_Aimbot:AddDropdown("AimbotMethod", {
	Text = "Aimbot Method",
	Values = {"Camera", "mousemovevel"},
	Default = 1,
})

Gb.Exploits_Aimbot:AddDivider()

Gb.Exploits_Aimbot:AddToggle("SilentAimToggle", {
	Text = "Enable Silent Aim", Default = false
})

Gb.Exploits_Aimbot:AddDropdown("SilentAimMethod", {
	Text = "Silent Aim Method",
	Values = {"Mouse", "Raycast", "FindPartOnRay", "FindPartOnRayWithIgnoreList", "FindPartOnRayWithWhitelist"},
	Default = 2,
})

Gb.Exploits_Aimbot:AddLabel("Silent Aim uses settings from Aimbot.")

Gb.Exploits_Aimbot:AddDivider()

Gb.Exploits_Aimbot:AddLabel("Detected Methods: None")

Gb.Exploits_Aimbot:AddButton({
	Text = "Update Label",
	Func = function()
		print("Label updated")
	end
})

Gb.Exploits_Trolling = Tabs.Exploits:AddRightGroupbox("Trolling")
Gb.Exploits_Trolling:AddToggle("TwerkDance", {
	Text = "Twerk", Default = false
})

local EspTabbox = Tabs.Visuals:AddLeftTabbox()

local EspTab = EspTabbox:AddTab("ESP")
EspTab:AddToggle("PlayerESP", {
	Text = "Player", Default = false
}):AddColorPicker("PlayerESPColor", {
	Default = Color3.fromRGB(255, 255, 255)
})

local EspSettingsTab = EspTabbox:AddTab("Settings")

EspSettingsTab:AddToggle("ESPRainbow", {
	Text = "Rainbow Effect", Default = false
})

EspSettingsTab:AddToggle("ESPShowDistance", {
	Text = "Show Distance", Default = false
})

EspSettingsTab:AddToggle("ESPTracersToggle", {
	Text = "Tracers", Default = false
})

EspSettingsTab:AddDropdown("ESPTracersOrigin", {
	Text = "Tracer Origin",
	Values = {"Bottom", "Center", "Top", "Mouse"},
	Default = 1,
})

EspSettingsTab:AddSlider("ESPTracerThickness", {
	Text = "Tracer Thickness", Min = 1, Max = 10, Default = 1, Rounding = 1, Compact = true
})

EspSettingsTab:AddToggle("ESPArrowsToggle", {
	Text = "Arrows", Default = false
})

EspSettingsTab:AddSlider("ESPArrowsRadius", {
	Text = "Arrow Radius", Min = 50, Max = 400, Default = 200, Rounding = 0, Compact = true
})

EspSettingsTab:AddDivider()

EspSettingsTab:AddSlider("ESPFillTransparency", {
	Text = "Fill Transparency", Min = 0, Max = 1, Default = 0.75, Rounding = 2, Compact = true
})

EspSettingsTab:AddSlider("ESPOutlineTransparency", {
	Text = "Outline Transparency", Min = 0, Max = 1, Default = 0, Rounding = 2, Compact = true
})

EspSettingsTab:AddSlider("ESPTextTransparency", {
	Text = "Text Transparency", Min = 0, Max = 1, Default = 0, Rounding = 2, Compact = true
})

EspSettingsTab:AddSlider("ESPTextOutlineTransparency", {
	Text = "Text Outline Transparency", Min = 0, Max = 1, Default = 0, Rounding = 2, Compact = true
})

EspSettingsTab:AddSlider("ESPFadeTime", {
	Text = "Fade Time", Min = 0, Max = 5, Default = 0, Rounding = 1, Compact = true
})

EspSettingsTab:AddSlider("ESPRenderLimit", {
	Text = "Render Limit", Min = 10, Max = 500, Default = 240, Rounding = 0, Compact = true
})

EspSettingsTab:AddSlider("ESPTextSize", {
	Text = "Text Size", Min = 10, Max = 32, Default = 20, Rounding = 0, Compact = true
})

EspSettingsTab:AddDropdown("ESPTextFont", {
	Text = "Text Font",
	Values = {"RobotoCondensed", "Legacy", "Arial", "Gotham", "SourceSans", "Roboto"},
	Default = 1,
})

Gb.Visuals_Ambient = Tabs.Visuals:AddRightGroupbox("Ambient")

Gb.Visuals_Ambient:AddSlider("BrightnessSlider", {
	Text = "Brightness", Min = 0, Max = 3, Default = 0, Rounding = 0, Compact = true
})

Gb.Visuals_Ambient:AddToggle("FullbrightToggle", {
	Text = "Fullbright", Default = false
}):AddColorPicker("FullbrightColor", {
	Default = Color3.fromRGB(255, 255, 255)
})

Gb.Visuals_Ambient:AddToggle("NoFogToggle", {
	Text = "No Fog", Default = false
})

Gb.Visuals_Ambient:AddToggle("AntiLagToggle", {
	Text = "Anti-Lag", Default = false
})

Toggles.ESPRainbow:OnChanged(function(V)        YT_MT.ESPLibrary:SetRainbow(V) end)
Toggles.ESPShowDistance:OnChanged(function(V)   YT_MT.ESPLibrary:SetShowDistance(V) end)
Options.ESPFillTransparency:OnChanged(function(V)        YT_MT.ESPLibrary:SetFillTransparency(V) end)
Options.ESPOutlineTransparency:OnChanged(function(V)     YT_MT.ESPLibrary:SetOutlineTransparency(V) end)
Options.ESPTextTransparency:OnChanged(function(V)        YT_MT.ESPLibrary:SetTextTransparency(V) end)
Options.ESPTextOutlineTransparency:OnChanged(function(V) YT_MT.ESPLibrary:SetTextOutlineTransparency(V) end)
Options.ESPFadeTime:OnChanged(function(V)        YT_MT.ESPLibrary:SetFadeTime(V) end)
Options.ESPRenderLimit:OnChanged(function(V)     YT_MT.ESPLibrary:SetRenderLimit(V) end)
Options.ESPTextSize:OnChanged(function(V)        YT_MT.ESPLibrary:SetTextSize(V) end)
Options.ESPTextFont:OnChanged(function(V)        YT_MT.ESPLibrary:SetFont(Enum.Font[V]) end)
Toggles.ESPTracersToggle:OnChanged(function(V)   YT_MT.ESPLibrary:SetTracers(V) end)
Options.ESPTracersOrigin:OnChanged(function(V)   YT_MT.ESPLibrary:SetTracerOrigin(V) end)
Options.ESPTracerThickness:OnChanged(function(V) YT_MT.ESPLibrary:SetTracerSize(V) end)
Toggles.ESPArrowsToggle:OnChanged(function(V)    YT_MT.ESPLibrary:SetArrows(V) end)
Options.ESPArrowsRadius:OnChanged(function(V)    YT_MT.ESPLibrary:SetArrowRadius(V) end)

local function AddPlayerESP(player)
	if player == LocalPlayer then return end
	
	local function OnCharacterAdded(char)
		if Toggles.PlayerESP.Value then
			YT_MT.ESPLibrary:AddESP({
				Object = char,
				Text = player.Name,
				Color = Options.PlayerESPColor.Value
			})
		end
	end
	
	if player.Character then
		OnCharacterAdded(player.Character)
	end
	player.CharacterAdded:Connect(OnCharacterAdded)
end

for _, player in ipairs(Services.Players:GetPlayers()) do
	AddPlayerESP(player)
end
Services.Players.PlayerAdded:Connect(AddPlayerESP)

Toggles.PlayerESP:OnChanged(function(Value)
	for _, player in ipairs(Services.Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			if Value then
				YT_MT.ESPLibrary:AddESP({
					Object = player.Character,
					Text = player.Name,
					Color = Options.PlayerESPColor.Value
				})
			else
				YT_MT.ESPLibrary:RemoveESP(player.Character)
			end
		end
	end
end)

Options.PlayerESPColor:OnChanged(function(Value)
	for _, player in ipairs(Services.Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			YT_MT.ESPLibrary:UpdateObjectColor(player.Character, Value)
		end
	end
end)

local RunService = Services.RunService
local UserInputService = Services.UserInputService
local Character, Humanoid, RootPart

local function UpdateCharacter()
	Character = LocalPlayer.Character
	if Character then
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
		RootPart = Character:FindFirstChild("HumanoidRootPart")
	end
end

LocalPlayer.CharacterAdded:Connect(UpdateCharacter)
UpdateCharacter()

RunService.Heartbeat:Connect(function()
	if not Character or not Humanoid then return end
	
	if Toggles.SpeedToggle.Value then
		Humanoid.WalkSpeed = Options.SpeedSlider.Value
	end
	
	if Toggles.JumpToggle.Value then
		Humanoid.UseJumpPower = true
		Humanoid.JumpPower = Options.JumpSlider.Value
	end
	
	if Toggles.NoclipToggle.Value then
		for _, part in ipairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
	
	if Toggles.DisableVoidToggle.Value then
		pcall(function()
			workspace.FallenPartsDestroyHeight = 0/0
		end)
	end
end)

RunService.RenderStepped:Connect(function()
	if Toggles.InstantInteractToggle.Value then
		for _, prompt in ipairs(workspace:GetDescendants()) do
			if prompt:IsA("ProximityPrompt") then
				prompt.HoldDuration = 0
			end
		end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if Toggles.InfJumpToggle.Value and Humanoid then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

LocalPlayer.Idled:Connect(function()
	if Toggles.AntiAFKToggle.Value then
		Services.VirtualUser:CaptureController()
		Services.VirtualUser:ClickButton2(Vector2.new())
	end
end)

local flyConnection
Toggles.FlyToggle:OnChanged(function(Value)
	if Value then
		if not RootPart then return end
		local bv = Instance.new("BodyVelocity")
		bv.Name = "FlyVelocity"
		bv.Parent = RootPart
		bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bv.Velocity = Vector3.zero

		local bg = Instance.new("BodyGyro")
		bg.Name = "FlyGyro"
		bg.Parent = RootPart
		bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.CFrame = Camera.CFrame

		flyConnection = RunService.RenderStepped:Connect(function()
			if not RootPart or not Character then return end
			bg.CFrame = Camera.CFrame
			local moveDir = Vector3.zero
			
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector end
			
			bv.Velocity = moveDir * Options.FlySpeed.Value
		end)
	else
		if flyConnection then flyConnection:Disconnect() end
		if RootPart then
			if RootPart:FindFirstChild("FlyVelocity") then RootPart.FlyVelocity:Destroy() end
			if RootPart:FindFirstChild("FlyGyro") then RootPart.FlyGyro:Destroy() end
		end
	end
end)

local track
Toggles.TwerkDance:OnChanged(function(Value)
	if Value then
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://12874447851"

		local hum = Character and Character:FindFirstChildOfClass("Humanoid")
		if hum then
			track = hum:LoadAnimation(anim)
			track.Looped = true
			track:Play()
		end
	else
		if track then
			track:Stop()
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if Toggles.FullbrightToggle.Value then
		Services.Lighting.Ambient = Color3.new(1, 1, 1)
		Services.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
		Services.Lighting.Brightness = Options.BrightnessSlider.Value > 0 and Options.BrightnessSlider.Value or 2
	end
	
	if Toggles.NoFogToggle.Value then
		Services.Lighting.FogEnd = 9e9
	end
end)

YT_MT.Interface.ApplySettingsTab(Window)
SaveManager:LoadAutoloadConfig()

local success, AddonsTab = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/AddonsTab.luau"))()
end)
if success and type(AddonsTab) == "function" then
	pcall(function()
		AddonsTab(Window)
	end)
end
