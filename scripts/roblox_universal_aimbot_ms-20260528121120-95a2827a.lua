local MISTRAL_BUILD_ID = "MS-20260528121120-95A2827A"
local MISTRAL_VARIATION_SEED = "2FD80DDDA851B987"
local MISTRAL_REQUEST_GAME = "Roblox/Universal"
local MISTRAL_REQUEST_MODE = "AimBot"
local MISTRAL_CHANNEL = "@MistralScripts"
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- MistralScripts Global State
local Mistral = {
    AimBotEnabled = false,
    FOVRadius = 75, -- Degrees
    AimSpeed = 0.15, -- Lerp alpha, 0.05 (slow) to 1.0 (instant)
    TargetPart = "HumanoidRootPart", -- "Head", "Torso", "HumanoidRootPart"
    CurrentTarget = nil,
    SettingsSaved = false -- To prevent multiple saves if implemented
}

local function Notification(title, message, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration or 5,
            Icon = "rbxassetid://6758784177" -- Placeholder or custom icon id
        })
    end)
end

-- GUI Configuration
local UI_ACCENT_COLOR = Color3.new(170/255, 114/255, 223/255)
local PANEL_WIDTH = 320
local PANEL_HEIGHT = 410
local DEFAULT_FONT = Enum.Font.SourceSansBold
local TEXT_SIZE_HEADER = 22
local TEXT_SIZE_LABEL = 16
local TEXT_SIZE_BUTTON = 18
local BUTTON_HEIGHT = 40

local function createMobileGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Mistral_AimBot_UI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainPanel = Instance.new("Frame")
    MainPanel.Name = "MainPanel"
    MainPanel.Size = UDim2.new(0, PANEL_WIDTH, 0, PANEL_HEIGHT)
    MainPanel.Position = UDim2.new(0.5, -PANEL_WIDTH/2, 0.5, -PANEL_HEIGHT/2)
    MainPanel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    MainPanel.BackgroundTransparency = 0.2
    MainPanel.BorderSizePixel = 0
    MainPanel.Draggable = true
    MainPanel.Parent = ScreenGui

    local UIAspectRatio = Instance.new("UIAspectRatioConstraint")
    UIAspectRatio.AspectRatio = PANEL_WIDTH / PANEL_HEIGHT
    UIAspectRatio.Parent = MainPanel

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainPanel

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.Parent = MainPanel

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    UIListLayout.Parent = MainPanel

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -20, 0, 30)
    TitleLabel.Text = "Universal AimBot Mistral"
    TitleLabel.Font = DEFAULT_FONT
    TitleLabel.TextSize = TEXT_SIZE_HEADER
    TitleLabel.TextColor3 = UI_ACCENT_COLOR
    TitleLabel.BackgroundColor3 = Color3.new(0,0,0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = MainPanel

    -- Separator
    local Separator1 = Instance.new("Frame")
    Separator1.Name = "Separator1"
    Separator1.Size = UDim2.new(1, -20, 0, 2)
    Separator1.BackgroundColor3 = UI_ACCENT_COLOR
    Separator1.BackgroundTransparency = 0.7
    Separator1.BorderSizePixel = 0
    Separator1.Parent = MainPanel

    -- AimBot Toggle
    local AimBotToggle = Instance.new("TextButton")
    AimBotToggle.Name = "AimBotToggle"
    AimBotToggle.Size = UDim2.new(1, -20, 0, BUTTON_HEIGHT)
    AimBotToggle.Text = "AimBot: OFF"
    AimBotToggle.Font = DEFAULT_FONT
    AimBotToggle.TextSize = TEXT_SIZE_BUTTON
    AimBotToggle.TextColor3 = Color3.new(1,1,1)
    AimBotToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    AimBotToggle.Parent = MainPanel

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = AimBotToggle

    local function updateAimBotToggle()
        if Mistral.AimBotEnabled then
            AimBotToggle.Text = "AimBot: ON"
            AimBotToggle.BackgroundColor3 = UI_ACCENT_COLOR
        else
            AimBotToggle.Text = "AimBot: OFF"
            AimBotToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            Mistral.CurrentTarget = nil -- Clear target when disabled
        end
    end

    AimBotToggle.MouseButton1Click:Connect(function()
        Mistral.AimBotEnabled = not Mistral.AimBotEnabled
        updateAimBotToggle()
        Notification("AimBot Status", "AimBot is " .. (Mistral.AimBotEnabled and "ENABLED" or "DISABLED"), 3)
    end)
    updateAimBotToggle()

    -- FOV Settings
    local FovContainer = Instance.new("Frame")
    FovContainer.Name = "FovContainer"
    FovContainer.Size = UDim2.new(1, -20, 0, BUTTON_HEIGHT)
    FovContainer.BackgroundColor3 = Color3.new(0,0,0)
    FovContainer.BackgroundTransparency = 1
    FovContainer.Parent = MainPanel

    local FovLayout = Instance.new("UIListLayout")
    FovLayout.FillDirection = Enum.FillDirection.Horizontal
    FovLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    FovLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    FovLayout.Parent = FovContainer

    local FovLabel = Instance.new("TextLabel")
    FovLabel.Name = "FovLabel"
    FovLabel.Size = UDim2.new(0.6, 0, 1, 0)
    FovLabel.Text = "FOV: " .. Mistral.FOVRadius .. "°"
    FovLabel.Font = DEFAULT_FONT
    FovLabel.TextSize = TEXT_SIZE_LABEL
    FovLabel.TextColor3 = Color3.new(1,1,1)
    FovLabel.BackgroundColor3 = Color3.new(0,0,0)
    FovLabel.BackgroundTransparency = 1
    FovLabel.TextXAlignment = Enum.TextXAlignment.Left
    FovLabel.Parent = FovContainer

    local FovDecreaseBtn = Instance.new("TextButton")
    FovDecreaseBtn.Name = "FovDecreaseBtn"
    FovDecreaseBtn.Size = UDim2.new(0.2, 0, 1, 0)
    FovDecreaseBtn.Text = "-"
    FovDecreaseBtn.Font = DEFAULT_FONT
    FovDecreaseBtn.TextSize = TEXT_SIZE_BUTTON
    FovDecreaseBtn.TextColor3 = Color3.new(1,1,1)
    FovDecreaseBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    FovDecreaseBtn.Parent = FovContainer

    local FovIncreaseBtn = Instance.new("TextButton")
    FovIncreaseBtn.Name = "FovIncreaseBtn"
    FovIncreaseBtn.Size = UDim2.new(0.2, 0, 1, 0)
    FovIncreaseBtn.Text = "+"
    FovIncreaseBtn.Font = DEFAULT_FONT
    FovIncreaseBtn.TextSize = TEXT_SIZE_BUTTON
    FovIncreaseBtn.TextColor3 = Color3.new(1,1,1)
    FovIncreaseBtn.BackgroundColor3 = UI_ACCENT_COLOR
    FovIncreaseBtn.Parent = FovContainer

    local FovCornerMinus = Instance.new("UICorner")
    FovCornerMinus.CornerRadius = UDim.new(0, 6)
    FovCornerMinus.Parent = FovDecreaseBtn
    local FovCornerPlus = Instance.new("UICorner")
    FovCornerPlus.CornerRadius = UDim.new(0, 6)
    FovCornerPlus.Parent = FovIncreaseBtn

    FovDecreaseBtn.MouseButton1Click:Connect(function()
        Mistral.FOVRadius = math.max(10, Mistral.FOVRadius - 5)
        FovLabel.Text = "FOV: " .. Mistral.FOVRadius .. "°"
    end)

    FovIncreaseBtn.MouseButton1Click:Connect(function()
        Mistral.FOVRadius = math.min(180, Mistral.FOVRadius + 5)
        FovLabel.Text = "FOV: " .. Mistral.FOVRadius .. "°"
    end)

    -- Aim Speed Settings
    local SpeedContainer = Instance.new("Frame")
    SpeedContainer.Name = "SpeedContainer"
    SpeedContainer.Size = UDim2.new(1, -20, 0, BUTTON_HEIGHT)
    SpeedContainer.BackgroundColor3 = Color3.new(0,0,0)
    SpeedContainer.BackgroundTransparency = 1
    SpeedContainer.Parent = MainPanel

    local SpeedLayout = Instance.new("UIListLayout")
    SpeedLayout.FillDirection = Enum.FillDirection.Horizontal
    SpeedLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SpeedLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    SpeedLayout.Parent = SpeedContainer

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Name = "SpeedLabel"
    SpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
    SpeedLabel.Text = "Speed: " .. string.format("%.2f", Mistral.AimSpeed)
    SpeedLabel.Font = DEFAULT_FONT
    SpeedLabel.TextSize = TEXT_SIZE_LABEL
    SpeedLabel.TextColor3 = Color3.new(1,1,1)
    SpeedLabel.BackgroundColor3 = Color3.new(0,0,0)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    SpeedLabel.Parent = SpeedContainer

    local SpeedDecreaseBtn = Instance.new("TextButton")
    SpeedDecreaseBtn.Name = "SpeedDecreaseBtn"
    SpeedDecreaseBtn.Size = UDim2.new(0.2, 0, 1, 0)
    SpeedDecreaseBtn.Text = "-"
    SpeedDecreaseBtn.Font = DEFAULT_FONT
    SpeedDecreaseBtn.TextSize = TEXT_SIZE_BUTTON
    SpeedDecreaseBtn.TextColor3 = Color3.new(1,1,1)
    SpeedDecreaseBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    SpeedDecreaseBtn.Parent = SpeedContainer

    local SpeedIncreaseBtn = Instance.new("TextButton")
    SpeedIncreaseBtn.Name = "SpeedIncreaseBtn"
    SpeedIncreaseBtn.Size = UDim2.new(0.2, 0, 1, 0)
    SpeedIncreaseBtn.Text = "+"
    SpeedIncreaseBtn.Font = DEFAULT_FONT
    SpeedIncreaseBtn.TextSize = TEXT_SIZE_BUTTON
    SpeedIncreaseBtn.TextColor3 = Color3.new(1,1,1)
    SpeedIncreaseBtn.BackgroundColor3 = UI_ACCENT_COLOR
    SpeedIncreaseBtn.Parent = SpeedContainer

    local SpeedCornerMinus = Instance.new("UICorner")
    SpeedCornerMinus.CornerRadius = UDim.new(0, 6)
    SpeedCornerMinus.Parent = SpeedDecreaseBtn
    local SpeedCornerPlus = Instance.new("UICorner")
    SpeedCornerPlus.CornerRadius = UDim.new(0, 6)
    SpeedCornerPlus.Parent = SpeedIncreaseBtn

    SpeedDecreaseBtn.MouseButton1Click:Connect(function()
        Mistral.AimSpeed = math.max(0.01, Mistral.AimSpeed - 0.01)
        SpeedLabel.Text = "Speed: " .. string.format("%.2f", Mistral.AimSpeed)
    end)

    SpeedIncreaseBtn.MouseButton1Click:Connect(function()
        Mistral.AimSpeed = math.min(1.0, Mistral.AimSpeed + 0.01)
        SpeedLabel.Text = "Speed: " .. string.format("%.2f", Mistral.AimSpeed)
    end)

    -- Target Part Selection
    local PartSelectionLabel = Instance.new("TextLabel")
    PartSelectionLabel.Name = "PartSelectionLabel"
    PartSelectionLabel.Size = UDim2.new(1, -20, 0, 20)
    PartSelectionLabel.Text = "Target Part: " .. Mistral.TargetPart
    PartSelectionLabel.Font = DEFAULT_FONT
    PartSelectionLabel.TextSize = TEXT_SIZE_LABEL
    PartSelectionLabel.TextColor3 = Color3.new(1,1,1)
    PartSelectionLabel.BackgroundColor3 = Color3.new(0,0,0)
    PartSelectionLabel.BackgroundTransparency = 1
    PartSelectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    PartSelectionLabel.Parent = MainPanel

    local PartButtonsContainer = Instance.new("Frame")
    PartButtonsContainer.Name = "PartButtonsContainer"
    PartButtonsContainer.Size = UDim2.new(1, -20, 0, BUTTON_HEIGHT)
    PartButtonsContainer.BackgroundColor3 = Color3.new(0,0,0)
    PartButtonsContainer.BackgroundTransparency = 1
    PartButtonsContainer.Parent = MainPanel

    local PartLayout = Instance.new("UIListLayout")
    PartLayout.FillDirection = Enum.FillDirection.Horizontal
    PartLayout.Padding = UDim.new(0, 5)
    PartLayout.Parent = PartButtonsContainer

    local parts = {"Head", "Torso", "HumanoidRootPart"}
    local partButtons = {}

    for i, partName in ipairs(parts) do
        local PartButton = Instance.new("TextButton")
        PartButton.Name = partName .. "Button"
        PartButton.Size = UDim2.new((1/3), -10, 1, 0)
        PartButton.Text = partName
        PartButton.Font = DEFAULT_FONT
        PartButton.TextSize = TEXT_SIZE_BUTTON
        PartButton.TextColor3 = Color3.new(1,1,1)
        PartButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        PartButton.Parent = PartButtonsContainer

        local PartButtonCorner = Instance.new("UICorner")
        PartButtonCorner.CornerRadius = UDim.new(0, 6)
        PartButtonCorner.Parent = PartButton

        PartButton.MouseButton1Click:Connect(function()
            Mistral.TargetPart = partName
            PartSelectionLabel.Text = "Target Part: " .. Mistral.TargetPart
            for _, btn in pairs(partButtons) do
                btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            end
            PartButton.BackgroundColor3 = UI_ACCENT_COLOR
            Notification("Target Part", "Targeting: " .. partName, 2)
        end)
        partButtons[partName] = PartButton
    end

    -- Initial highlight for TargetPart
    if partButtons[Mistral.TargetPart] then
        partButtons[Mistral.TargetPart].BackgroundColor3 = UI_ACCENT_COLOR
    end

    -- Footer
    local FooterLabel = Instance.new("TextLabel")
    FooterLabel.Name = "FooterLabel"
    FooterLabel.Size = UDim2.new(1, -20, 0, 25)
    FooterLabel.Text = "MistralScripts | @MistralScripts\nBuild ID: MS-20260528121120-95A2827A"
    FooterLabel.Font = DEFAULT_FONT
    FooterLabel.TextSize = 12
    FooterLabel.TextColor3 = Color3.new(0.7,0.7,0.7)
    FooterLabel.BackgroundColor3 = Color3.new(0,0,0)
    FooterLabel.BackgroundTransparency = 1
    FooterLabel.TextWrapped = true
    FooterLabel.Parent = MainPanel

    return ScreenGui
end

local function getTargetPosition(targetCharacter, targetPartName)
    local part = targetCharacter:FindFirstChild(targetPartName)
    if part and part:IsA("BasePart") then
        return part.Position
    end
    -- Fallback to HumanoidRootPart if specific part not found
    local hrp = targetCharacter:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:IsA("BasePart") then
        return hrp.Position
    end
    return nil
end

local function findNearestTarget()
    local localHRP = nil
    local currentCharacter = LocalPlayer.Character
    if currentCharacter then
        localHRP = currentCharacter:FindFirstChild("HumanoidRootPart")
    end

    if not localHRP or not Camera then return nil end

    local minDistance = math.huge
    local bestTarget = nil

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local targetHRP = char and char:FindFirstChild("HumanoidRootPart")

            if char and hum and hum.Health > 0 and targetHRP then
                local distance = (localHRP.Position - targetHRP.Position).Magnitude
                local targetPosition = targetHRP.Position

                -- FOV check (angular)
                local directionToTarget = (targetPosition - Camera.CFrame.Position).Unit
                local cameraLookVector = Camera.CFrame.LookVector
                local dotProduct = directionToTarget:Dot(cameraLookVector)
                local angularFOV = Mistral.FOVRadius / 2 -- Half angle for comparison
                local requiredDotProduct = math.cos(math.rad(angularFOV))

                if dotProduct >= requiredDotProduct then
                    if distance < minDistance then
                        minDistance = distance
                        bestTarget = player
                    end
                end
            end
        end
    end
    return bestTarget
end

local function AimBotUpdate()
    if not Mistral.AimBotEnabled then return end

    local success, currentCharacter = pcall(function() return LocalPlayer.Character end)
    if not success or not currentCharacter then return end

    if not Camera then return end

    Mistral.CurrentTarget = findNearestTarget()

    if Mistral.CurrentTarget then
        local targetChar = Mistral.CurrentTarget.Character
        if targetChar then
            local targetPos = getTargetPosition(targetChar, Mistral.TargetPart)
            if targetPos then
                local currentCFrame = Camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
                Camera.CFrame = currentCFrame:Lerp(targetCFrame, Mistral.AimSpeed)
            end
        end
    end
end

-- Main Execution
local gui = createMobileGUI()

-- Connect the AimBot logic to RenderStepped
RunService.RenderStepped:Connect(AimBotUpdate)

Notification("Mistral AimBot", "Universal AimBot loaded! Developed by @MistralScripts", 4)
