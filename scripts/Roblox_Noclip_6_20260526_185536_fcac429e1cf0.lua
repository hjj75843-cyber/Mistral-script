-- Mistral Scripts Noclip Local Client Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local function createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MistralNoclipGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 100
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 220, 0, 140)
    mainFrame.Position = UDim2.new(0.5, -110, 0.5, -70)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    -- UICorner
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 4)
    uiCorner.Parent = mainFrame
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Mistral Scripts"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = mainFrame
    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -20, 0, 20)
    statusLabel.Position = UDim2.new(0, 10, 0, 40)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: OFF"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = mainFrame
    -- Noclip Toggle Button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0.8, 0, 0, 30)
    toggleButton.Position = UDim2.new(0.1, 0, 0, 70)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = "Toggle Noclip"
    toggleButton.TextSize = 14
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.AutoButtonColor = false
    local toggleUICorner = Instance.new("UICorner")
    toggleUICorner.CornerRadius = UDim.new(0, 4)
    toggleUICorner.Parent = toggleButton
    toggleButton.Parent = mainFrame
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.3, 0, 0, 30)
    closeButton.Position = UDim2.new(0.1, 0, 0, 105)
    closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "Close"
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.Gotham
    closeButton.AutoButtonColor = false
    local closeUICorner = Instance.new("UICorner")
    closeUICorner.CornerRadius = UDim.new(0, 4)
    closeUICorner.Parent = closeButton
    closeButton.Parent = mainFrame
    -- Draggable Logic
    local dragging
    local dragInput
    local dragStart
    local startPos
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    titleLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    titleLabel.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    -- Noclip Logic
    local noclipConnection
    local oldCollisionGroup = character:GetAttribute("NoclipOldCollisionGroup")
    local function setNoclip(enabled)
        if enabled then
            local success, err = pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
            if not success then
                warn("Noclip error: " .. tostring(err))
                statusLabel.Text = "Status: Error (check console)"
            else
                statusLabel.Text = "Status: ON"
            end
        else
            local success, err = pcall(function()
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end)
            if not success then
                warn("Noclip reset error: " .. tostring(err))
                statusLabel.Text = "Status: Error (check console)"
            else
                statusLabel.Text = "Status: OFF"
            end
        end
    end
    toggleButton.Activated:Connect(function()
        setNoclip(not toggleButton.Text:find("Disable"))
        if toggleButton.Text:find("Enable") then
            toggleButton.Text = "Disable Noclip"
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        else
            toggleButton.Text = "Enable Noclip"
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end)
    -- Close Logic
    closeButton.Activated:Connect(function()
        setNoclip(false)
        screenGui:Destroy()
    end)
    -- Character check for cleanup
    character.AncestryChanged:Connect(function(_, parent)
        if not parent and screenGui and screenGui.Parent then
            setNoclip(false)
            pcall(function() screenGui:Destroy() end)
        end
    end)
    return screenGui
end
local noclipGui = createGui()
-- Auto noclip on respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    local statusLabel = noclipGui.MainFrame:FindFirstChild("StatusLabel")
    if statusLabel and toggleButton.Text:find("Disable") then
        setNoclip(true)
    end
end)