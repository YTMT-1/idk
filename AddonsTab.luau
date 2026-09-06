local AddonsModule = function(Window)
	if not Window then return end
	
	local AddonsTab = Window:AddTab("Addons", "boxes")
	
	if not listfiles or not isfolder or not makefolder then
		local ErrorGroup = AddonsTab:AddLeftGroupbox("System Error")
		ErrorGroup:AddLabel("<font color='rgb(255, 65, 65)'>Your executor does not support File System functions.</font>", true)
		return
	end

	if not isfolder("YT_MT") then makefolder("YT_MT") end
	if not isfolder("YT_MT/Addons") then makefolder("YT_MT/Addons") end

	local success, files = pcall(listfiles, "YT_MT/Addons")
	local validFiles = {}

	if success and #files > 0 then
		for _, filePath in pairs(files) do
			if filePath:sub(-5):lower() == ".luau" or filePath:sub(-4):lower() == ".lua" then
				table.insert(validFiles, filePath)
			end
		end
	end

	if #validFiles == 0 then
		AddonsTab:UpdateWarningBox({
			Title = "WARNING",
			Text = "Your addons FOLDER is empty! (workspace/YT_MT/Addons)",
			IsNormal = false,
			Visible = true,
			LockSize = true
		})
	else
		AddonsTab:UpdateWarningBox({ Visible = false })

		for _, filePath in pairs(validFiles) do
			local readSuccess, content = pcall(readfile, filePath)
			local addonLogName = filePath:match("([^/\\]+)%.[^.]+$") or "Unknown"
			
			if readSuccess and content then
				local currentAddonInfo = {
					Name = addonLogName,
					Title = addonLogName
				}

				local groupboxInstance = nil

				local function ensureGroupbox()
					if not groupboxInstance then
						groupboxInstance = AddonsTab:AddLeftGroupbox(currentAddonInfo.Title)
					end
				end

				local function renderErrorGroupbox(errMsg)
					ensureGroupbox()
					groupboxInstance:AddDivider({
						Text = "<font color='rgb(255, 65, 65)'><b>[ ADDON ERROR ]</b></font>",
						MarginTop = 2,
						MarginBottom = 2
					})
					groupboxInstance:AddLabel("<font color='rgb(255, 65, 65)'>Status: Failed to load</font>", true)
					groupboxInstance:AddLabel("<b>Reason:</b> " .. tostring(errMsg), true)
				end

				local GroupboxProxy = {}

				function GroupboxProxy:AddButton(config)
					ensureGroupbox()
					groupboxInstance:AddButton({
						Text = config.Text,
						Func = config.Func,
						Risky = config.Risky
					})
				end

				function GroupboxProxy:AddToggle(id, config)
					ensureGroupbox()
					groupboxInstance:AddToggle(id, {
						Text = config.Text,
						Default = config.Default or false,
						Callback = config.Func,
						Risky = config.Risky
					})
				end

				function GroupboxProxy:AddDivider(config)
					ensureGroupbox()
					groupboxInstance:AddDivider({
						Text = config.Text,
						MarginTop = config.MarginTop or 2,
						MarginBottom = config.MarginBottom or -2
					})
				end

				local env = setmetatable({
					YT_MT = {
						AddonInfo = currentAddonInfo,
						Groupbox = GroupboxProxy
					}
				}, { __index = getfenv() })

				local func, compileErr = loadstring(content, "=" .. addonLogName)
				if func then
					setfenv(func, env)
					local runSuccess, runErr = pcall(func)
					
					if not runSuccess then
						renderErrorGroupbox(runErr)
					end
				else
					renderErrorGroupbox(compileErr)
				end
			else
				local errGroup = AddonsTab:AddLeftGroupbox(addonLogName)
				errGroup:AddLabel("<font color='rgb(255, 65, 65)'>Error: Could not read file content from disk.</font>", true)
			end
		end
	end
end

return AddonsModule
