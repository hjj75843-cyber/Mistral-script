local LocalPlayer = Players.LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
-- Laser configuration
local LASER_COLOR = Color3.fromRGB(255, 0, 0)
local LASER_BRIGHTNESS = 5
local LASER_RANGE = 1000
local LASER_WIDTH = 0.2
-- Camera and input
local camera = Workspace.CurrentCamera
local currentCameraCFrame = CFrame.new()
-- State flags
local laserActive = false
local spinActive = false
local noClipActive = false
-- Store effects for cleanup
local activeLasers = {}
local spinConnection = nil
local noClipConnection = nil
-- Helper function to clean up effects
local function cleanupEffects()
    for _, laser in pairs(activeLasers) do
        if laser and laser:IsA("BasePart") then
            laser:Destroy()
        elseif laser and laser:IsA("ParticleEmitter") then
            laser.Enabled = false
            Debris:AddItem(laser, 0.1)
        end
    end
    activeLasers = {}
end
local function createLaserEffect()
    -- Create beam part
    local beam = Instance.new("Part")
    beam.Name = "MistralEyeLaser"
    beam.Anchored = true
    beam.CanCollide = false
    beam.Transparency = 0.3
    beam.Color = LASER_COLOR
    beam.Material = Enum.Material.Neon
    beam.BrickColor = BrickColor.new("Bright red")
    beam.Size = Vector3.new(LASER_WIDTH, LASER_WIDTH, LASER_RANGE)
    beam.CFrame = camera.CFrame * CFrame.new(0, 0, -LASER_RANGE/2)
    beam.Parent = Workspace
    -- Create glow effect
    local glow = Instance.new("PointLight")
    glow.Brightness = LASER_BRIGHTNESS
    glow.Color = LASER_COLOR
    glow.Range = LASER_RANGE
    glow.Parent = beam
    -- Create particle emitter
    local particles = Instance.new("ParticleEmitter")
    particles.Enabled = true
    particles.Texture = "rbxassetid://243098098"
    particles.LightEmission = 1
    particles.Lifetime = NumberRange.new(0.1, 0.3)
    particles.Size = NumberSequence.new(0.5)
    particles.Color = ColorSequence.new(LASER_COLOR)
    particles.Transparency = NumberSequence.new(0.2)
    particles.Rate = 50
    particles.Parent = beam
    table.insert(activeLasers, beam)
    table.insert(activeLasers, glow)
    table.insert(activeLasers, particles)
    return beam
end
local function updateLasers()
    if not laserActive then return end
    -- Remove old lasers
    cleanupEffects()
    if not laserActive then return end
    -- Create new laser
    local beam = createLaserEffect()
    -- Update beam position each frame
    local connection = RunService.Heartbeat:Connect(function()
        if not beam or not beam.Parent then
            if connection then connection:Disconnect() end
            return
        end
        beam.CFrame = camera.CFrame * CFrame.new(0, 0, -LASER_RANGE/2)
    end)
    table.insert(activeLasers, connection)
end
local function toggleLasers()
    laserActive = not laserActive
    if laserActive then
        statusLabel.Text = "Status: Lasers ON"
        updateLasers()
    else
        statusLabel.Text = "Status: Lasers OFF"
        cleanupEffects()
    end
end
local function toggleSpin()
    spinActive = not spinActive
    if spinActive then
        statusLabel.Text = "Status: Spin ON"
        if spinConnection then spinConnection:Disconnect() end
        spinConnection = RunService.Heartbeat:Connect(function(dt)
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(180) * dt, 0)
        end)
    else
        statusLabel.Text = "Status: Spin OFF"
        if spinConnection then
            spinConnection:Disconnect()
            spinConnection = nil
        end
    end
end
local function toggleNoClip()
    noClipActive = not noClipActive
    if noClipActive then
        statusLabel.Text = "Status: Noclip ON"
        if noClipConnection then noClipConnection:Disconnect() end
        noClipConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        statusLabel.Text = "Status: Noclip OFF"
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
            -- Restore collision
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end
-- Handle respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    rootPart = newCharacter:WaitForChild("HumanoidRootPart")
    if laserActive then
        updateLasers()
    end
end)
-- Create GUI
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local statusLabel = Instance.new("TextLabel")
local laserButton = Instance.new("TextButton")
local spinButton = Instance.new("TextButton")
local noclipButton = Instance.new("TextButton")
local closeButton = Instance.new("TextButton")
screenGui.Name = "Mistral Scriptss"
screenGui.Parent = player.PlayerGui
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 5)
-- Title
local titleFont = Instance.new("TextLabel")
titleFont.Name = "Title"
titleFont.Parent = mainFrame
titleFont.Size = UDim2.new(1, 0, 0, 25)
titleFont.Position = UDim2.new(0, 0, 0, 5)
titleFont.Text = "Mistral Scripts"
titleFont.TextColor3 = Color3.fromRGB(255, 255, 255)
titleFont.TextSize = 16
titleFont.Font = Enum.Font.GothamBold
titleFont.BackgroundTransparency = 1
-- Status label
statusLabel.Name = "StatusLabel"
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 0, 35)
statusLabel.Text = "Status: Ready"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 14
titleLabel.Font = Enum.Font.Gotham
titleLabel.BackgroundTransparency = 1
-- Laser button
laserButton.Name = "LaserButton"
laserButton.Parent = mainFrame
laserButton.Size = UDim2.new(0.9, 0, 0, 30)
laserButton.Position = UDim2.new(0.05, 0, 0, 65)
laserButton.Text = "Toggle Lasers"
laserButton.TextColor3 = Color3.fromRGB(255, 255, 255)
laserButton.TextSize = 14
laserButton.Font = Enum.Font.Gotham
titleLabel.BackgroundTransparency = 0
laserButton.BackgroundColor3 = Color3.fromRGB(70, 20, 20)
local laserCorner = Instance.new("UICorner")
laserCorner.CornerRadius = UDim.new(0, 4)
laserCorner.Parent = laserButton
-- Spin button
spinButton.Name = "SpinButton"
spinButton.Parent = mainFrame
spinButton.Size = UDim2.new(0.9, 0, 0, 30)
spinButton.Position = UDim2.new(0.05, 0, 0, 105)
spinButton.Text = "Toggle Spin"
spinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spinButton.TextSize = 14
spinButton.Font = Enum.Font.Gotham
titleLabel.BackgroundTransparency = 0
spinButton.BackgroundColor3 = Color3.fromRGB(20, 70, 20)
local spinCorner = Instance.new("UICorner")
spinCorner.CornerRadius = UDim.new(0, 4)
spinCorner.Parent = spinButton
-- Noclip button
noclipButton.Name = "NoclipButton"
noclipButton.Parent = mainFrame
noclipButton.Size = UDim2.new(0.9, 0, 0, 30)
noclipButton.Position = UDim2.new(0.05, 0, 0, 145)
noclipButton.Text = "Toggle Noclip"
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.TextSize = 14
noclipButton.Font = Enum.Font.Gotham
titleLabel.BackgroundTransparency = 0
noclipButton.BackgroundColor3 = Color3.fromRGB(20, 20, 70)
local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 4)
noclipCorner.Parent = noclipButton
-- Close button
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.Size = UDim2.new(0.2, 0, 0, 25)
closeButton.Position = UDim2.new(0.78, 0, 0.05, 0)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.Gotham
titleLabel.BackgroundTransparency = 0
closeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 3)
closeCorner.Parent = closeButton
-- Button connections
laserButton.MouseButton1Click:Connect(toggleLasers)
spinButton.MouseButton1Click:Connect(toggleSpin)
noclipButton.MouseButton1Click:Connect(toggleNoClip)
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    cleanupEffects()
    if spinConnection then spinConnection:Disconnect() end
    if noClipConnection then noClipConnection:Disconnect() end
end)
-- Initial status
statusLabel.Text = "Status: Ready"
-- Cleanup on script destroy
local cleanup = function()
    cleanupEffects()
    if spinConnection then spinConnection:Disconnect() end
    if noClipConnection then noClipConnection:Disconnect() end
    pcall(function()
        player.PlayerGui:FindFirstChild("Mistral Scriptss"):Destroy()
    end)
end
-- Handle script termination
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F7 then
        cleanup()
    end
end)
player.CharacterRemoving:Connect(cleanup)