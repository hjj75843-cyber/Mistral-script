local BUILD_ID = "MS-20260527220231-628BCCDD"
local PROJECT_NAME = "Mistral script"
local CHANNEL = "@MistralScripts"
local REQUEST_GAME = "Roblox/Universal"
local REQUEST_MODE = "Universal GUI"
local REQUEST_FEATURES = "• Universal GUI"
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
gui.Name = "MistralScriptsGui" .. "_" .. "BB9953"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui
local main = Instance.new("Frame")
main.Name = "MistralMain"
main.Size = UDim2.new(0, 316, 0, 398)
main.Position = UDim2.new(0.5, -158, 0.5, -199)
main.BackgroundColor3 = Color3.fromRGB(20, 14, 32)
main.BorderSizePixel = 0
main.Parent = gui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 19)
mainCorner.Parent = main
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(147, 51, 234)
mainStroke.Transparency = 0.2
mainStroke.Parent = main
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(54, 28, 95)), ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 6, 14))})
gradient.Rotation = 44
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
    button.Size = UDim2.new(1, -4, 0, 48)
    button.BackgroundColor3 = Color3.fromRGB(54, 31, 90)
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
    stroke.Color = Color3.fromRGB(147, 51, 234)
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
        button.BackgroundColor3 = enabled and Color3.fromRGB(126, 68, 205) or Color3.fromRGB(54, 31, 90)
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

local flyEnabled = false
local flySpeed = 73
local flyConn = nil
local function setFly(state)
    flyEnabled = state
    if flyConn then flyConn:Disconnect() flyConn = nil end
    local character = getCharacter()
    local root = character and getRoot(character)
    if state and root then
        flyConn = RunService.RenderStepped:Connect(function()
            local char = getCharacter()
            local hrp = char and getRoot(char)
            if not hrp then return end
            local cam = workspace.CurrentCamera
            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            if UserInputService.TouchEnabled and move.Magnitude < 0.1 then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then move = humanoid.MoveDirection end
            end
            if move.Magnitude > 0 then
                hrp.AssemblyLinearVelocity = move.Unit * flySpeed + Vector3.new(0, 2, 0)
            else
                hrp.AssemblyLinearVelocity = Vector3.new(0, 2, 0)
            end
        end)
    end
end


local speedEnabled = false
local speedValue = 33
local normalSpeed = 16
local function setSpeed(state)
    speedEnabled = state
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = state and speedValue or normalSpeed
    end
end
RunService.Heartbeat:Connect(function()
    if speedEnabled then
        local humanoid = getHumanoid()
        if humanoid and humanoid.WalkSpeed ~= speedValue then
            humanoid.WalkSpeed = speedValue
        end
    end
end)


local jumpEnabled = false
local jumpValue = 97
local normalJump = 50
local function setJump(state)
    jumpEnabled = state
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = state and jumpValue or normalJump
    end
end


local noclipEnabled = false
local noclipConn = nil
local function setNoclip(state)
    noclipEnabled = state
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            local character = getCharacter()
            if not character then return end
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end
end


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


local savedPoint = nil
local function saveTeleportPoint()
    local character = getCharacter()
    local root = character and getRoot(character)
    if root then
        savedPoint = root.CFrame
        notify("Точка сохранена")
    end
end
local function runTeleport()
    local character = getCharacter()
    local root = character and getRoot(character)
    if root and savedPoint then
        root.CFrame = savedPoint + Vector3.new(0, 3, 0)
    else
        notify("Сначала сохрани точку")
    end
end

addToggle("✦ Fly", function(state) setFly(state) end)
addToggle("✦ Speed", function(state) setSpeed(state) end)
addToggle("✦ Jump", function(state) setJump(state) end)
addToggle("✦ Noclip", function(state) setNoclip(state) end)
addToggle("✦ ESP", function(state) setESP(state) end)
addButton("✦ Сохранить точку", function() saveTeleportPoint() end)
addButton("✦ Телепорт", function() runTeleport() end)
addButton("✦ Свернуть панель", function() main.Visible = not main.Visible end)
notify("Панель активна: Universal GUI")
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    notify("Персонаж обновлён. Меню активно.")
end)
notify("Mistral Scripts запущен • " .. REQUEST_MODE .. " • " .. BUILD_ID)
