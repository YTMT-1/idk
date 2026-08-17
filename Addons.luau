local AddonsModule = {}

function AddonsModule:Render(Window)
    local AddonsTab = Window:CreateTab({
        Name = "Addons",
        Icon = "boxes"
    })

    AddonsTab:CreateLabel({
        Text = "Custom extensions for YT_MT Hub"
    })

    if listfiles and isfolder and makefolder then
        if not isfolder("YT_MT_Addons") then
            makefolder("YT_MT_Addons")
        end

        local success, files = pcall(listfiles, "YT_MT_Addons")
        if success and #files > 0 then
            for _, filePath in pairs(files) do
                if filePath:sub(-4):lower() == ".lua" then
                    local fileName = filePath:match("([^/\\]+)%.lua$") or filePath
                    
                    AddonsTab:CreateButton({
                        Name = "Load: " .. fileName,
                        Callback = function()
                            local readSuccess, content = pcall(readfile, filePath)
                            if readSuccess and content then
                                local execSuccess, err = pcall(function()
                                    local func, compileErr = loadstring(content)
                                    if func then func() else error(compileErr) end
                                end)
                                
                                local statusText = execSuccess and "Successfully loaded " .. fileName or "Error: " .. tostring(err)
                                game:GetService("StarterGui"):SetCore("SendNotification", {
                                    Title = "YT_MT Addons",
                                    Text = statusText,
                                    Duration = 4
                                })
                            end
                        end
                    })
                end
            end
        else
            AddonsTab:CreateLabel({
                Text = "No custom addons found in 'workspace/YT_MT_Addons'."
            })
        end
    else
        AddonsTab:CreateLabel({
            Text = "Your executor does not support File System functions."
        })
    end
end

return AddonsModule
