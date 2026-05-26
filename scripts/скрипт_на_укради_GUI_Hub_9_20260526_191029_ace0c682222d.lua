local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local function getCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return Character
end
local function getRoot()
    local character = getCharacter()
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
end
local function getHumanoid()
    return getCharacter():FindFirstChildOfClass("Humanoid")
end
local oldGui = PlayerGui:FindFirstChild("Mistral Scriptss_cfa90a6f563d")
if oldGui then oldGui:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "Mistral Scriptss_cfa90a6f563d"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui
local frame = Instance.new("Frame")
frame.Name = "MistralFrame"
frame.Size = UDim2.new(0, 260, 0, 190)
frame.Position = UDim2.new(0.5, -130, 0.45, -95)
frame.BackgroundColor3 = Color3.fromRGB(20, 8, 38)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = frame
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(180, 80, 255)
stroke.Parent = frame
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 0, 36)
title.Position = UDim2.new(0, 8, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Mistral Scripts"
title.TextColor3 = Color3.fromRGB(235, 210, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -16, 0, 22)
subtitle.Position = UDim2.new(0, 8, 0, 42)
subtitle.BackgroundTransparency = 1
subtitle.Text = "GUI Hub"
subtitle.TextColor3 = Color3.fromRGB(190, 155, 255)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 13
subtitle.Parent = frame
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -16, 0, 22)
status.Position = UDim2.new(0, 8, 1, -30)
status.BackgroundTransparency = 1
status.Text = "Готово · build cfa90a6f563d"
status.TextColor3 = Color3.fromRGB(160, 255, 210)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = frame
local function button(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -24, 0, 34)
    b.Position = UDim2.new(0, 12, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(92, 34, 160)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Text = text
    b.Parent = frame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 12)
    c.Parent = b
    return b
end
local enabled = false
local toggle = button("Включить", 76)
local close = button("Закрыть", 116)
toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggle.Text = enabled and "Выключить" or "Включить"
    status.Text = enabled and "Активно" or "Выключено"
end)
close.MouseButton1Click:Connect(function() gui:Destroy() end)