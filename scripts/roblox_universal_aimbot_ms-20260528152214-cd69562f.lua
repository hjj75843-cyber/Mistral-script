local MISTRAL_BUILD_ID = "MS-20260528152214-CD69562F"
local MISTRAL_VARIATION_SEED = "ADC4782CCD375509"
local MISTRAL_REQUEST_GAME = "Roblox/Universal"
local MISTRAL_REQUEST_MODE = "AimBot"
local MISTRAL_CHANNEL = "@MistralScripts"
-- MistralScripts Platform - Universal AimBot
-- Build ID: MS-20260528152214-CD69562F
-- Variation Seed: 48B9264F0CF8FED1EDCD4B08

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration based on provided profile
local PANEL_WIDTH = 321
local PANEL_HEIGHT = 381
local ACCENT_COLOR = Color3.new(176/255, 110/255, 224/255) -- Purple accent
local AIM_SPEED_VALUE = 35 -- Used for aiming smoothness/speed
local AIM_RANGE_VALUE = 63 -- Used for FOV/target distance

-- Internal State
local SharedState = {
    AimEnabled = false,
    CurrentTarget = nil,
    PanelDragging = false,
    PanelDragOffset = Vector2.zero
}

--[[ MistralGUI Module ]]
local MistralGUI = {}

function MistralGUI.CreatePanel()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Mistral_SG_MS2026"
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainPanel"
    MainFrame.Size = UDim2.new(0, PANEL_WIDTH, 0, PANEL_HEIGHT)
    MainFrame.Position = UDim2.new(0.5, -PANEL_WIDTH/2, 0.5, -PANEL_HEIGHT/2)
    MainFrame.BackgroundColor3 = ACCENT_COLOR:Lerp(Color3.new(0.05, 0.05, 0.05), 0.7) -- Darker background
    MainFrame.BorderSizePixel = 0
    MainFrame.Draggable = false -- Custom drag implementation
    MainFrame.BorderColor3 = ACCENT_COLOR
    MainFrame.ClipsDescendants = true

    local UIStrokeBorder = Instance.new("UIStroke")
    UIStrokeBorder.Color = ACCENT_COLOR
    UIStrokeBorder.Thickness = 2
    UIStrokeBorder.Parent = MainFrame

    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Name = "HeaderLabel"
    HeaderLabel.Size = UDim2.new(1, 0, 0, 40)
    HeaderLabel.Position = UDim2.new(0, 0, 0, 0)
    HeaderLabel.BackgroundColor3 = ACCENT_COLOR:Lerp(Color3.new(0,0,0), 0.3)
    HeaderLabel.Text = "Universal AimBot"
    HeaderLabel.Font = Enum.Font.Oswald
    HeaderLabel.TextColor3 = Color3.new(1, 1, 1)
    HeaderLabel.TextSize = 24
    HeaderLabel.TextWrapped = true
    HeaderLabel.BorderSizePixel = 0
    HeaderLabel.Parent = MainFrame

    local BuildInfoLabel = Instance.new("TextLabel")
    BuildInfoLabel.Name = "BuildInfoLabel"
    BuildInfoLabel.Size = UDim2.new(1, -20, 0, 30)
    BuildInfoLabel.Position = UDim2.new(0, 10, 0, 40)
    BuildInfoLabel.BackgroundColor3 = Color3.new(1, 1, 1):Lerp(ACCENT_COLOR, 0.1)
    BuildInfoLabel.BackgroundTransparency = 1
    BuildInfoLabel.Text = "@MistralScripts | MS-20260528152214-CD69562F"
    BuildInfoLabel.Font = Enum.Font.SourceSansPro
    BuildInfoLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    BuildInfoLabel.TextSize = 14
    BuildInfoLabel.TextWrapped = true
    BuildInfoLabel.TextXAlignment = Enum.TextXAlignment.Center
    BuildInfoLabel.TextYAlignment = Enum.TextYAlignment.Center
    BuildInfoLabel.Parent = MainFrame

    local AimToggleButton = Instance.new("TextButton")
    AimToggleButton.Name = "AimToggleButton"
    AimToggleButton.Size = UDim2.new(0.9, 0, 0, 60)
    AimToggleButton.Position = UDim2.new(0.05, 0, 0, 90)
    AimToggleButton.BackgroundColor3 = ACCENT_COLOR:Lerp(Color3.new(0.2, 0.2, 0.2), 0.5) -- Darker base
    AimToggleButton.Text = "AimBot: OFF"
    AimToggleButton.Font = Enum.Font.Oswald
    AimToggleButton.TextColor3 = Color3.new(1, 1, 1)
    AimToggleButton.TextSize = 28
    AimToggleButton.TextWrapped = true
    AimToggleButton.BorderSizePixel = 0
    AimToggleButton.AutoButtonColor = false

    local UIStrokeBtn = Instance.new("UIStroke")
    UIStrokeBtn.Color = ACCENT_COLOR
    UIStrokeBtn.Thickness = 2
    UIStrokeBtn.Parent = AimToggleButton

    AimToggleButton.Parent = MainFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 50)
    StatusLabel.Position = UDim2.new(0.05, 0, 0, 170)
    StatusLabel.BackgroundColor3 = ACCENT_COLOR:Lerp(Color3.new(0,0,0), 0.6)
    StatusLabel.BackgroundTransparency = 0.5
    StatusLabel.Text = "Status: Inactive"
    StatusLabel.Font = Enum.Font.SourceSansPro
    StatusLabel.TextColor3 = Color3.new(1, 1, 1)
    StatusLabel.TextSize = 20
    StatusLabel.TextWrapped = true
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.TextYAlignment = Enum.TextYAlignment.Center
    StatusLabel.BorderSizePixel = 0
    StatusLabel.Parent = MainFrame

    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    MistralGUI.MainFrame = MainFrame
    MistralGUI.AimToggleButton = AimToggleButton
    MistralGUI.StatusLabel = StatusLabel

    -- Dragging logic for MainPanel
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if MistralGUI.MainFrame:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)[1] == MistralGUI.MainFrame then
                SharedState.PanelDragging = true
                SharedState.PanelDragOffset = Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(MistralGUI.MainFrame.AbsolutePosition.X, MistralGUI.MainFrame.AbsolutePosition.Y)
                UserInputService.MouseBehavior = Enum.MouseBehavior.Exclusive -- Prevent camera movement on desktop
            end
        end
    end

    local function onInputChanged(input, gameProcessed)
        if gameProcessed then return end
        if SharedState.PanelDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            local newX = input.Position.X - SharedState.PanelDragOffset.X
            local newY = input.Position.Y - SharedState.PanelDragOffset.Y
            MistralGUI.MainFrame.Position = UDim2.new(0, newX, 0, newY)
        end
    end

    local function onInputEnded(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SharedState.PanelDragging = false
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end

    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
    UserInputService.InputEnded:Connect(onInputEnded)
end

function MistralGUI.UpdateAimButton(isEnabled)
    local button = MistralGUI.AimToggleButton
    if button then
        button.Text = "AimBot: " .. (isEnabled and "ON" or "OFF")
        button.BackgroundColor3 = isEnabled and ACCENT_COLOR:Lerp(Color3.new(0.1, 0.4, 0.1), 0.3) or ACCENT_COLOR:Lerp(Color3.new(0.2, 0.2, 0.2), 0.5)
        button.TextColor3 = isEnabled and Color3.new(0, 1, 0) or Color3.new(1,1,1)
    end
end

function MistralGUI.UpdateStatus(message)
    local label = MistralGUI.StatusLabel
    if label then
        label.Text = "Status: " .. message
    end
end

--[[ AimCoordinator Module ]]
local AimCoordinator = {}

function AimCoordinator.FindClosestTarget()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local localHRP = LocalPlayer.Character.HumanoidRootPart

    local closestTarget = nil
    local shortestDistance = AIM_RANGE_VALUE + 1 -- Initialize with value outside range

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            local distance = (localHRP.Position - targetHRP.Position).Magnitude

            if distance < shortestDistance and distance <= AIM_RANGE_VALUE then
                closestTarget = player.Character
                shortestDistance = distance
            end
        end
    end
    return closestTarget
end

function AimCoordinator.SmoothlyAimAtTarget(deltaTime, targetCharacter)
    if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then return end
    local targetHRP = targetCharacter.HumanoidRootPart

    local targetPosition = targetHRP.Position

    local lookVector = (targetPosition - Camera.CFrame.Position).Unit
    local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + lookVector)

    local smoothnessFactor = math.clamp(AIM_SPEED_VALUE * deltaTime, 0, 1) -- Adjust speed based on configured value and delta time
    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothnessFactor)
end

function AimCoordinator.OnHeartbeat(deltaTime)
    if not SharedState.AimEnabled then return end

    -- Pcall wrapper for main targeting and aiming logic
    local success, err = pcall(function()
        SharedState.CurrentTarget = AimCoordinator.FindClosestTarget()

        if SharedState.CurrentTarget then
            AimCoordinator.SmoothlyAimAtTarget(deltaTime, SharedState.CurrentTarget)
            MistralGUI.UpdateStatus("Target: " .. SharedState.CurrentTarget.Name)
        else
            MistralGUI.UpdateStatus("No Target Found")
        end
    end)

    if not success then
        warn("AimBot Error: " .. err)
        MistralGUI.UpdateStatus("Error: " .. err)
    end
end

function AimCoordinator.ToggleAim(enable)
    SharedState.AimEnabled = enable
    MistralGUI.UpdateAimButton(enable)
    if not enable then
        SharedState.CurrentTarget = nil
        MistralGUI.UpdateStatus("Inactive")
    else
        MistralGUI.UpdateStatus("Searching Target...")
    end
end

function AimCoordinator.Init()
    -- Initialize GUI
    MistralGUI.CreatePanel()

    -- Connect GUI button to toggle AimBot
    MistralGUI.AimToggleButton.MouseButton1Click:Connect(function()
        AimCoordinator.ToggleAim(not SharedState.AimEnabled)
    end)

    -- Connect to RunService for continuous aim updates
    RunService.Heartbeat:Connect(AimCoordinator.OnHeartbeat)

    -- Reset target on player respawn
    LocalPlayer.CharacterAdded:Connect(function(character)
        SharedState.CurrentTarget = nil
        if SharedState.AimEnabled then
            MistralGUI.UpdateStatus("Respawned. Searching Target...")
        end
    end)

    -- Initial GUI state
    MistralGUI.UpdateAimButton(false)
    MistralGUI.UpdateStatus("Ready")
end

-- Initialize the AimBot system
AimCoordinator.Init()
