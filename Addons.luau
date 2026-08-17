local AddonsModule = {}

function AddonsModule:Render(Window)
    local AddonsTab = Window:CreateTab({
        Name = "Addons",
        Icon = "boxes"
    })

    if not listfiles or not isfolder or not makefolder then
        AddonsTab:CreateLabel({ Text = "Your executor does not support File System functions." })
        return
    end

    if not isfolder("YT_MT_Addons") then
        makefolder("YT_MT_Addons")
    end

    local success, files = pcall(listfiles, "YT_MT_Addons")
    if success and #files > 0 then
        for _, filePath in pairs(files) do
            if filePath:sub(-5):lower() == ".luau" or filePath:sub(-4):lower() == ".lua" then
                local readSuccess, content = pcall(readfile, filePath)
                if readSuccess and content then
                    
                    local currentAddonInfo = {
                        Name = filePath:match("([^/\\]+)%.[^.]+$") or "Unknown",
                        Title = "Custom Addon",
                        Description = ""
                    }

                    local GroupboxProxy = {}
                    local groupboxInstance = nil

                    function GroupboxProxy:AddButton(config)
                        if not groupboxInstance then
                            groupboxInstance = AddonsTab:CreateGroupbox({ Title = currentAddonInfo.Title })
                            if currentAddonInfo.Description ~= "" then
                                groupboxInstance:CreateLabel({ Text = currentAddonInfo.Description })
                            end
                        end
                        groupboxInstance:CreateButton({
                            Name = config.Text,
                            Callback = config.Func
                        })
                    end

                    function GroupboxProxy:AddToggle(id, config)
                        if not groupboxInstance then
                            groupboxInstance = AddonsTab:CreateGroupbox({ Title = currentAddonInfo.Title })
                            if currentAddonInfo.Description ~= "" then
                                groupboxInstance:CreateLabel({ Text = currentAddonInfo.Description })
                            end
                        end
                        groupboxInstance:CreateToggle({
                            Name = config.Text,
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
    else
        AddonsTab:CreateLabel({ Text = "No custom addons found in 'workspace/YT_MT_Addons'." })
    end
end

return AddonsModule
