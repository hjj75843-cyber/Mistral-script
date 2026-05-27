local BUILD_ID = "MS-20260527220433-2998EF29"
local PROJECT_NAME = "Mistral script"
local CHANNEL = "@MistralScripts"
local REQUEST_GAME = "Brookhaven"
local REQUEST_MODE = "ESP"
local REQUEST_FEATURES = "• ESP"
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
gui.Name = "MistralScriptsGui" .. "_" .. "FF3236"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui
local main = Instance.new("Frame")
main.Name = "MistralMain"
main.Size = UDim2.new(0, 311, 0, 419)
main.Position = UDim2.new(0.5, -155, 0.5, -209)
main.BackgroundColor3 = Color3.fromRGB(20, 14, 32)
main.BorderSizePixel = 0
main.Parent = gui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = main
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(168, 85, 247)
mainStroke.Transparency = 0.2
mainStroke.Parent = main
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(31, 20, 58)), ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 8, 25))})
gradient.Rotation = 70
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
    corner.CornerRadius = UDim.new(0, 13)
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
        button.BackgroundColor3 = enabled and Color3.fromRGB(126, 68, 205) or Color3.fromRGB(43, 27, 70)
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

local espEnabled = false
local espFolder = Instance.new("Folder")
espFolder.Name = "MistralESP_" .. BUILD_ID
espFolder.Parent = CoreGui
local function clearESP()
    for _, obj in ipairs(espFolder:GetChildren()) do obj:Destroy() end
end
local function createESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local root = getRoot(char)
    if not root or espFolder:FindFirstChild(player.Name) then return end
    local bill = Instance.new("BillboardGui")
    bill.Name = player.Name
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 160, 0, 38)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.Adornee = root
    bill.Parent = espFolder
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Text = "👤 " .. player.Name
    label.TextColor3 = Color3.fromRGB(216, 180, 254)
    label.TextStrokeTransparency = 0.35
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Parent = bill
end
local function setESP(state)
    espEnabled = state
    clearESP()
    if state then
        for _, plr in ipairs(Players:GetPlayers()) do createESP(plr) end
    end
end
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if espEnabled then createESP(plr) end
    end)
end)
RunService.Heartbeat:Connect(function()
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do createESP(plr) end
    end
end)

addToggle("✦ ESP", function(state) setESP(state) end)
addButton("✦ Мини-режим", function() main.Visible = not main.Visible end)
notify("Скрипт запущен: ESP")
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    notify("Персонаж обновлён. Меню активно.")
end)
notify("Mistral Scripts запущен • " .. REQUEST_MODE .. " • " .. BUILD_ID)
