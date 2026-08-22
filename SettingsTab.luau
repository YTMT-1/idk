return function(Window)
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
	local SaveManager = YT_MT.Interface.SaveManager
	local ThemeManager = YT_MT.Interface.ThemeManager
	
	local Toggles = Library.Toggles
	local Options = Library.Options
	
	local SettingsTab = Window:AddTab("Settings", "settings")
	local MenuGroup = SettingsTab:AddLeftGroupbox("Menu")
	
	MenuGroup:AddToggle("KeybindMenuOpen", {
		Default = Library.KeybindFrame.Visible,
		Text = "Open Keybind Menu",
		Callback = function(value)
			Library.KeybindFrame.Visible = value
		end,
	})
	MenuGroup:AddToggle("ShowCustomCursor", {
		Text = "Custom Cursor",
		Default = false,
		Callback = function(Value)
			Library.ShowCustomCursor = Value
		end,
	})

	_G.ReExecuteOnTeleport = _G.ReExecuteOnTeleport or false

	MenuGroup:AddToggle("ReExecuteOnTeleportToggle", {
		Text = "Re-execute On Teleport",
		Default = _G.ReExecuteOnTeleport,
		Callback = function(Value)
			_G.ReExecuteOnTeleport = Value
			if Value then
				local queue_teleport = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
				if queue_teleport then
					local ScriptToRepeat = [==[
						if not game:IsLoaded() then game.Loaded:Wait() end
						local Plrs = game:GetService("Players")
						local LP = Plrs.LocalPlayer
						while not LP.Character do
							task.wait(0.2)
						end
						local Char = LP.Character
						while not Char:FindFirstChild("HumanoidRootPart") do
							task.wait(0.2)
						end
						loadstring(game:HttpGet("https://raw.githubusercontent.com/YTMT-1/idk/refs/heads/main/Loader.lua"))()
					]==]
					queue_teleport(ScriptToRepeat)
					Library:Notify("Re-execute On Teleport Enabled.")
				else
					Library:Notify("Executor does not support queue_on_teleport!")
				end
			else
				Library:Notify("Re-execute On Teleport Disabled.")
			end
		end,
	})

	local currentUI = YT_MT.UILibrary or "Obsidian"
	MenuGroup:AddDropdown("UILibrary", {
		Text = "UI Style",
		Values = {
			"Obsidian",
			"Linoria"
		},
		Default = (currentUI == "Linoria" and 2 or 1),
		Callback = function(Value)
			if YT_MT.Environment.writefile and YT_MT.Environment.readfile then
				if not YT_MT.Environment.isfile("YT_MT/UserData.json") then
					local Data = {
						TotalExecutions = 0,
						UILibrary = "Obsidian"
					}
					YT_MT.Environment.writefile("YT_MT/UserData.json", Services.HttpService:JSONEncode(Data))
				end

				local UserData = YT_MT.Environment.readfile("YT_MT/UserData.json")
				local Decoded = Services.HttpService:JSONDecode(UserData)
				Decoded.UILibrary = Value

				if not Decoded.UILibrary then
					Decoded.UILibrary = "Obsidian"
				end

				YT_MT.TotalExecutions = Decoded.TotalExecutions
				YT_MT.UILibrary = Decoded.UILibrary

				YT_MT.Environment.writefile("YT_MT/UserData.json", Services.HttpService:JSONEncode(Decoded))
			end
		end
	})
	
	MenuGroup:AddDropdown("DPIDropdown", {
		Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
		Default = "100%",
	
		Text = "DPI Scale",
	
		Callback = function(Value)
			Value = Value:gsub("%%", "")
			local DPI = tonumber(Value)
	
			Library:SetDPIScale(DPI)
		end,
	})
	MenuGroup:AddDivider()
	MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
	
	MenuGroup:AddButton("Copy Discord Invite", function()
		toclipboard("https://dsc.gg")
		Library:Notify("Discord invite copied.")
	end)
	
	MenuGroup:AddButton("Unload", function()
		Library:Unload()
	end)
	
	Library.ToggleKeybind = Options.MenuKeybind
	
	local targetSavePath = YT_MT.SavePath or "Default_Save"
	
	ThemeManager:SetLibrary(Library)
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes({"UILibrary"})
	ThemeManager:SetFolder("YT_MT")
	SaveManager:SetFolder("YT_MT/" .. targetSavePath)
	SaveManager:BuildConfigSection(SettingsTab)
	ThemeManager:ApplyToTab(SettingsTab)
	SaveManager:LoadAutoloadConfig()
end
