local BUILD_ID = "MS-20260527134155-9576B01C"
local PROJECT_NAME = "Mistral script"
local CHANNEL = "@MistralScripts"
local REQUEST_GAME = "Roblox/Universal"
local REQUEST_MODE = "Лазеры из глаз"
local REQUEST_FEATURES = "• Speed | • Jump | • Лазеры из глаз"
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
    local old = CoreGui:FindFirstChild("MistralScriptsGui")
    if old then old:Destroy() end
end)
local gui = Instance.new("ScreenGui")
gui.Name = "MistralScriptsGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui
local main = Instance.new("Frame")
main.Name = "MistralMain"
main.Size = UDim2.new(0, 315, 0, 405)
main.Position = UDim2.new(0.5, -157, 0.5, -202)
main.BackgroundColor3 = Color3.fromRGB(20, 14, 32)
main.BorderSizePixel = 0
main.Parent = gui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = main
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(168, 85, 247)
mainStroke.Transparency = 0.2
mainStroke.Parent = main
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 24, 82)), ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 7, 18))})
gradient.Rotation = 35
gradient.Parent = main
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 18, 0, 12)
title.Size = UDim2.new(1, -36, 0, 34)
title.Font = Enum.Font.GothamBlack
title.Text = "Mistral Scripts"
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
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Mistral Scripts", Text = tostring(text), Duration = 3})
    end)
end
local function makeBaseButton(text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -4, 0, 46)
    button.BackgroundColor3 = Color3.fromRGB(43, 27, 70)
    button.AutoButtonColor = true
    button.Text = text
    button.TextColor3 = Color3.fromRGB(250, 245, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = list
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = button
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(168, 85, 247)
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
        button.BackgroundColor3 = enabled and Color3.fromRGB(99, 58, 168) or Color3.fromRGB(43, 27, 70)
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

local laserEnabled = false
local laserDamage = 0
local function makeLaserBeam(targetPosition)
    local character = getCharacter()
    local head = character and character:FindFirstChild("Head")
    if not head then return end
    local origin = head.Position + head.CFrame.LookVector * 0.8
    local distance = (targetPosition - origin).Magnitude
    local beam = Instance.new("Part")
    beam.Name = "MistralEyeLaser"
    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.Neon
    beam.Color = Color3.fromRGB(168, 85, 247)
    beam.Size = Vector3.new(0.18, 0.18, distance)
    beam.CFrame = CFrame.new(origin, targetPosition) * CFrame.new(0, 0, -distance / 2)
    beam.Parent = workspace
    Debris:AddItem(beam, 0.18)
end
local function castEyeLaser()
    if not laserEnabled then return end
    local cam = workspace.CurrentCamera
    local origin = cam.CFrame.Position
    local direction = cam.CFrame.LookVector * 350
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {getCharacter()}
    local result = workspace:Raycast(origin, direction, params)
    local hitPos = result and result.Position or (origin + direction)
    makeLaserBeam(hitPos)
end
local function setEyeLasers(state)
    laserEnabled = state
end

addToggle("Лазеры из глаз", function(state) setEyeLasers(state) end)
addButton("Выстрел лазером", function() castEyeLaser() end)
addButton("Скрыть меню", function() main.Visible = not main.Visible end)
notify("Готово: Лазеры из глаз")
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    notify("Персонаж обновлён. Меню активно.")
end)
notify("Mistral Scripts запущен • " .. REQUEST_MODE .. " • " .. BUILD_ID)