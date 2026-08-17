local AddonsModule = {}

function AddonsModule:Render(Window)
    local AddonsTab = Window:AddTab("Addons", "boxes")
    
    local MainGroup = AddonsTab:AddLeftGroupbox("Addons Manager")
    MainGroup:AddLabel("Place your custom (.lua / .luau) files inside 'workspace/YT_MT_Addons' folder to expand functionality.")

    if not listfiles or not isfolder or not makefolder then
        MainGroup:AddDivider()
        MainGroup:AddLabel("❌ Your executor does not support File System functions.")
        return
    end

    if not isfolder("YT_MT_Addons") then
        makefolder("YT_MT_Addons")
    end

    local success, files = pcall(listfiles, "YT_MT_Addons")
    local hasAddons = false

    if success and #files > 0 then
        for _, filePath in pairs(files) do
            if filePath:sub(-5):lower() == ".luau" or filePath:sub(-4):lower() == ".lua" then
                local readSuccess, content = pcall(readfile, filePath)
                if readSuccess and content then
                    hasAddons = true
                    
                    local currentAddonInfo = {
                        Name = filePath:match("([^/\\]+)%.[^.]+$") or "Unknown",
                        Title = "Custom Addon",
                        Description = ""
                    }

                    local GroupboxProxy = {}
                    local groupboxInstance = nil

                    function GroupboxProxy:AddButton(config)
                        if not groupboxInstance then
                            groupboxInstance = AddonsTab:AddLeftGroupbox(currentAddonInfo.Title)
                            if currentAddonInfo.Description ~= "" then
                                groupboxInstance:AddLabel(currentAddonInfo.Description)
                            end
                        end
                        groupboxInstance:AddButton(config.Text, config.Func)
                    end

                    function GroupboxProxy:AddToggle(id, config)
                        if not groupboxInstance then
                            groupboxInstance = AddonsTab:AddLeftGroupbox(currentAddonInfo.Title)
                            if currentAddonInfo.Description ~= "" then
                                groupboxInstance:AddLabel(currentAddonInfo.Description)
                            end
                        end
                        groupboxInstance:AddToggle(id, {
                            Text = config.Text,
                            Default = config.Default or false,
                            Callback = config.Func
                        })
                    end

                    local env = setmetatable({
                        YT_MT_Addons = {
                            AddonInfo = currentAddonInfo,
                            Groupbox = GroupboxProxy
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
    end

    if not hasAddons then
        MainGroup:AddDivider()
        MainGroup:AddLabel("Status: No active addons detected.")
    end
end

return AddonsModule
