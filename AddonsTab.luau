--[[ Running For Addons Or Something Idk, Folder in YT_MT/YT_MT_Addons
]]--
local AddonsModule = function(Window)
    if not Window then return end
    
    local AddonsTab = Window:AddTab("Addons", "boxes")
    local StarterGui = game:GetService("StarterGui")
    
    local function notifyError(addonName, errMsg)
        StarterGui:SetCore("SendNotification", {
            Title = "Addon Error: " .. addonName,
            Text = errMsg:sub(1, 60) .. "...",
            Duration = 5
        })
    end
    
    if not listfiles or not isfolder or not makefolder then
        local ErrorGroup = AddonsTab:AddLeftGroupbox("System Error")
        ErrorGroup:AddLabel("Your executor does not support File System functions.")
        return
    end

    if not isfolder("YT_MT") then makefolder("YT_MT") end
    if not isfolder("YT_MT/YT_MT_Addons") then makefolder("YT_MT/YT_MT_Addons") end

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
        AddonsTab:UpdateWarningBox({
            Title = "WARNING",
            Text = "Your addons FOLDER is empty! (workspace/YT_MT/YT_MT_Addons)",
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
                    Title = "Custom Addon"
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
                        -- Bẫy lỗi Runtime (Ví dụ: Gọi hàm không tồn tại khi đang chạy)
                        notifyError(addonLogName, tostring(runErr))
                    end
                else
                    -- Bẫy lỗi cú pháp Compile (Ví dụ: Thiếu dấu ngoặc, sai chữ)
                    notifyError(addonLogName, tostring(compileErr))
                end
            end
        end
    end
end

return AddonsModule
