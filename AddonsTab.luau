local AddonsModule = function(Window)
    if not Window then return end
    
    local AddonsTab = Window:AddTab("Addons", "boxes")
    
    if not listfiles or not isfolder or not makefolder then
        local ErrorGroup = AddonsTab:AddLeftGroupbox("System Error")
        ErrorGroup:AddLabel("Your executor does not support File System functions.")
        return
    end

    if not isfolder("YT_MT") then
        makefolder("YT_MT")
    end
    if not isfolder("YT_MT/YT_MT_Addons") then
        makefolder("YT_MT/YT_MT_Addons")
    end

    local success, files = pcall(listfiles, "YT_MT/YT_MT_Addons")
    local addedAnyAddon = false
    local toggleCount = 0

    if success and #files > 0 then
        for _, filePath in pairs(files) do
            if filePath:sub(-5):lower() == ".luau" or filePath:sub(-4):lower() == ".lua" then
                local readSuccess, content = pcall(readfile, filePath)
                if readSuccess and content then
                    
                    local currentAddonInfo = {
                        Name = filePath:match("([^/\\]+)%.[^.]+$") or "Unknown",
                        Title = "Custom Addon",
                        Game = {"Doors/Game", "Doors/Lobby"}
                    }

                    local GroupboxProxy = {}
                    local groupboxInstance = nil

                    local function ensureGroupbox()
                        if not groupboxInstance then
                            groupboxInstance = AddonsTab:AddLeftGroupbox(currentAddonInfo.Title)
                        end
                    end

                    function GroupboxProxy:AddButton(config)
                        ensureGroupbox()
                        groupboxInstance:AddButton({
                            Text = config.Text,
                            Func = config.Func
                        })
                    end

                    function GroupboxProxy:AddToggle(id, config)
                        ensureGroupbox()
                        toggleCount = toggleCount + 1
                        groupboxInstance:AddToggle(id or ("AddonToggle_" .. toggleCount), {
                            Text = config.Text,
                            Default = config.Default or false,
                            Callback = config.Func
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

                    local func, compileErr = loadstring(content)
                    if func then
                        setfenv(func, env)
                        local runSuccess = pcall(func)
                        
                        if runSuccess then
                            -- Giao phó toàn bộ quyền phân loại Game và tự động sắp xếp Risky hóa đỏ cho Obsidian LIB xử lý ngầm ghen bro!
                            addedAnyAddon = true
                        end
                    end
                end
            end
        end
    end

    if not addedAnyAddon then
        AddonsTab:UpdateWarningBox({
            Title = "WARNING",
            Text = "Your addons FOLDER is empty! (workspace/YT_MT/YT_MT_Addons)",
            IsNormal = false,
            Visible = true,
            LockSize = true
        })
    else
        AddonsTab:UpdateWarningBox({ Visible = false })
    end
end

return AddonsModule
