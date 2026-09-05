return function(Window)
	local LatestChangelog = {
		"5/9/2026",
		"<font color='rgb(0, 255, 0)'>+ Add Honcho Box Esp.</font>",
		"3/9/2026",
		"<font color='rgb(0, 255, 0)'>+ Add Auto Position Spoof</font>",
		"1/9/2026",
		"<font color='rgb(0, 255, 0)'>+ Add Clock Notify.</font>",
		"29/8/2026",
		"<font color='rgb(0, 255, 0)'>+ Fixing Bypass Drones Not Work.</font>",
		"27/8/2026",
		"<font color='rgb(0, 255, 0)'>+ Archives Support.</font>",
		"10/8/2026",
		"<font color='rgb(0, 255, 0)'>+ Figure Old Supports.</font>",
		"7/8/2026",
		"<font color='rgb(0, 255, 0)'>+ Anti Mandrake.</font>",
		"<font color='rgb(0, 255, 0)'>+ Auto Complete Maze (Outdoors).</font>",
		"<font color='rgb(0, 255, 0)'>+ Lobby Support.</font>",
		"<font color='rgb(0, 255, 0)'>+ Fixed Bugs.</font>",
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
	local SaveManager = YT_MT.Interface.SaveManager
	local ThemeManager = YT_MT.Interface.ThemeManager

	local Toggles = Library.Toggles
	local Options = Library.Options

	local LocalPlayer = Services.Players.LocalPlayer
	local InfoTab = Window:AddTab("Info", "door-closed")

	local User = InfoTab:AddLeftGroupbox("User Info")

	local ImageSize = Enum.ThumbnailSize.Size420x420
	local ImageType = Enum.ThumbnailType.HeadShot

	local Content = Services.Players:GetUserThumbnailAsync(LocalPlayer.UserId, ImageType, ImageSize)

	User:AddImage("UserIcon", {
		Image = Content
	})

	local CurrentTime = os.date("*t")
	local Hour = CurrentTime.hour
	
	local Greeting
	if Hour >= 5 and Hour < 12 then
		Greeting = "Good Morning"
	elseif Hour >= 12 and Hour < 17 then
		Greeting = "Good Afternoon"
	elseif Hour >= 17 and Hour < 21 then
		Greeting = "Good Evening"
	else
		Greeting = "Good Night"
	end
	
	User:AddLabel(Greeting .. ", " .. LocalPlayer.Name .. ", Thanks For Using This Script Also You Executed This Script: " .. (YT_MT.TotalExecutions and tostring(YT_MT.TotalExecutions) or "N/A") .. " times.", true)
	User:AddDivider()

	InfoTab:UpdateWarningBox({
		Title = "Changelogs",
		Text = table.concat(LatestChangelog, "\n"),
		IsNormal = true,
		Visible = true,
		LockSize = true,
	})

	local Name, Version = YT_MT.Environment.identifyexecutor()
	local Executor = InfoTab:AddRightGroupbox("Executor Info")

	for Index, Result in pairs(YT_MT.Environment.Results) do
		-- fix for veloshitty 💔
		Result = Result:gsub("<", "(")
		Result = Result:gsub(">", ")")

		Executor:AddLabel(Result, true)
	end

	local Community = InfoTab:AddLeftGroupbox("Community")
	Community:AddButton("Copy Discord Invite", function()
		toclipboard("https://dsc.gg/gUsPTPYArx")
		Library:Notify("Discord invite copied.")
	end)
end
