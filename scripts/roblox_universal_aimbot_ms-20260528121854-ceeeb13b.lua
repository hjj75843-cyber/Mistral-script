local BUILD_ID = "MS-20260528121854-CEEEB13B"
local PROJECT_NAME = "MistralScripts"
local CHANNEL = "@MistralScripts"
local REQUEST_GAME = "Roblox/Universal"
local REQUEST_MODE = "AimBot"
local REQUEST_FEATURES = "• AimBot"
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function getHumanoid()
    local character = getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end
local function getRoot(character)
    character = character or getCharacter()
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
end
pcall(function()
    for _, old in ipairs(CoreGui:GetChildren()) do
        if old.Name:find("MistralScriptsGui") then old:Destroy() end
    end
end)
local gui = Instance.new("ScreenGui")
gui.Name = "MistralScriptsGui" .. "_" .. "7BA171"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui
local main = Instance.new("Frame")
main.Name = "MistralMain"
main.Size = UDim2.new(0, 304, 0, 404)
main.Position = UDim2.new(0.5, -152, 0.5, -202)
main.BackgroundColor3 = Color3.fromRGB(20, 14, 32)
main.BorderSizePixel = 0
main.Parent = gui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = main
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(192, 92, 255)
mainStroke.Transparency = 0.2
mainStroke.Parent = main
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(31, 20, 58)), ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 6, 14))})
gradient.Rotation = 36
gradient.Parent = main
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 18, 0, 12)
title.Size = UDim2.new(1, -36, 0, 34)
title.Font = Enum.Font.GothamBold
title.Text = "MistralScripts"
title.TextColor3 = Color3.fromRGB(245, 235, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main
local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 18, 0, 48)
subtitle.Size = UDim2.new(1, -36, 0, 26)
subtitle.Font = Enum.Font.GothamMedium
subtitle.Text = CHANNEL .. " • " .. REQUEST_GAME .. " • " .. REQUEST_MODE
subtitle.TextColor3 = Color3.fromRGB(216, 180, 254)
subtitle.TextScaled = true
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = main
local list = Instance.new("ScrollingFrame")
list.Name = "Controls"
list.Position = UDim2.new(0, 14, 0, 88)
list.Size = UDim2.new(1, -28, 1, -104)
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.ScrollBarThickness = 4
list.BackgroundTransparency = 1
list.Parent = main
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list
local function notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "MistralScripts", Text = tostring(text), Duration = 3})
    end)
end
local function makeBaseButton(text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -4, 0, 43)
    button.BackgroundColor3 = Color3.fromRGB(39, 24, 67)
    button.AutoButtonColor = true
    button.Text = text
    button.TextColor3 = Color3.fromRGB(250, 245, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = list
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = button
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(192, 92, 255)
    stroke.Transparency = 0.5
    stroke.Parent = button
    return button
end
local function addButton(text, callback)
    local button = makeBaseButton(text)
    button.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback)
        if not ok then notify("Ошибка функции: " .. tostring(err):sub(1, 80)) end
    end)
    return button
end
local function addToggle(text, callback)
    local enabled = false
    local button = makeBaseButton("□ " .. text)
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.Text = (enabled and "■ " or "□ ") .. text
        button.BackgroundColor3 = enabled and Color3.fromRGB(126, 68, 205) or Color3.fromRGB(39, 24, 67)
        local ok, err = pcall(function() callback(enabled) end)
        if ok then notify(text .. (enabled and " включён" or " выключен")) else notify("Ошибка: " .. tostring(err):sub(1, 80)) end
    end)
    return button
end
local dragging = false
local dragStart = nil
local startPos = nil
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local aimEnabled = false
local aimFov = 135
local aimSmooth = 0.18
local function getNearestAimTarget()
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closest = nil
    local bestDistance = aimFov
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                local pos, visible = camera:WorldToViewportPoint(head.Position)
                if visible then
                    local distance = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if distance < bestDistance then
                        bestDistance = distance
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end
local function setAimBot(state)
    aimEnabled = state
end
RunService.RenderStepped:Connect(function()
    if not aimEnabled then return end
    local camera = workspace.CurrentCamera
    local target = getNearestAimTarget()
    if camera and target then
        local targetCFrame = CFrame.new(camera.CFrame.Position, target.Position)
        camera.CFrame = camera.CFrame:Lerp(targetCFrame, aimSmooth)
    end
end)

addToggle("◆ AimBot", function(state) setAimBot(state) end)
addButton("◆ Свернуть панель", function() main.Visible = not main.Visible end)
notify("Готово: AimBot")
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    notify("Персонаж обновлён. Меню активно.")
end)
notify("MistralScripts запущен • " .. REQUEST_MODE .. " • " .. BUILD_ID)
