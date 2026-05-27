local MISTRAL_BUILD_ID = "MS-20260527140813-DC83459E"
local MISTRAL_VARIATION_SEED = "4F3B234860965921"
local MISTRAL_REQUEST_MODE = "Лазеры из глаз"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Head = Character:WaitForChild("Head")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Unique Build ID: MS-20260527140813-DC83459E

-- GUI Setup
local MainScreenGui = Instance.new("ScreenGui")
MainScreenGui.Name = "Mistral Scripts"
MainScreenGui.DisplayOrder = 100
MainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ControlPanel = Instance.new("Frame")
ControlPanel.Name = "ControlPanel"
ControlPanel.Size = UDim2.new(0, 250, 0, 320)
ControlPanel.Position = UDim2.new(0.5, -125, 0.5, -160)
ControlPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ControlPanel.BorderSizePixel = 0
ControlPanel.Draggable = true
ControlPanel.Active = true
ControlPanel.ClipsDescendants = true
ControlPanel.AnchorPoint = Vector2.new(0.5, 0.5)

local ScriptHeader = Instance.new("TextLabel")
ScriptHeader.Name = "ScriptHeader"
ScriptHeader.Size = UDim2.new(1, 0, 0, 40)
ScriptHeader.Position = UDim2.new(0, 0, 0, 0)
ScriptHeader.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ScriptHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptHeader.Font = Enum.Font.SourceSansBold
ScriptHeader.TextSize = 20
ScriptHeader.Text = "Mistral Scripts"
ScriptHeader.TextScaled = false
ScriptHeader.ZIndex = 2

local SignatureLabel = Instance.new("TextLabel")
SignatureLabel.Name = "SignatureLabel"
SignatureLabel.Size = UDim2.new(1, 0, 0, 20)
SignatureLabel.Position = UDim2.new(0, 0, 0, 40)
SignatureLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SignatureLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
SignatureLabel.Font = Enum.Font.SourceSans
SignatureLabel.TextSize = 14
SignatureLabel.Text = "@MistralScripts"
SignatureLabel.TextScaled = false
SignatureLabel.ZIndex = 2

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 20
CloseButton.Text = "X"
CloseButton.ZIndex = 3
CloseButton.TextScaled = false

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -60)
ContentFrame.Position = UDim2.new(0, 0, 0, 60)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BorderSizePixel = 0
ContentFrame.ZIndex = 1

local UIList = Instance.new("UIListLayout")
UIList.Name = "FeatureLayout"
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = ContentFrame

-- Speed Boost Section
local SpeedToggleFrame = Instance.new("Frame")
SpeedToggleFrame.Name = "SpeedSettings"
SpeedToggleFrame.Size = UDim2.new(0.9, 0, 0, 70)
SpeedToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedToggleFrame.BorderSizePixel = 0
SpeedToggleFrame.LayoutOrder = 1
SpeedToggleFrame.Parent = ContentFrame

local SpeedToggleLabel = Instance.new("TextLabel")
SpeedToggleLabel.Name = "SpeedLabel"
SpeedToggleLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedToggleLabel.Position = UDim2.new(0, 0, 0, 5)
SpeedToggleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggleLabel.Font = Enum.Font.SourceSansSemibold
SpeedToggleLabel.TextSize = 16
SpeedToggleLabel.Text = "Скорость бега"
SpeedToggleLabel.TextXAlignment = Enum.TextXAlignment.Center
SpeedToggleLabel.Parent = SpeedToggleFrame

local SpeedActivatorButton = Instance.new("TextButton")
SpeedActivatorButton.Name = "SpeedActivatorButton"
SpeedActivatorButton.Size = UDim2.new(0.45, 0, 0, 25)
SpeedActivatorButton.Position = UDim2.new(0.025, 0, 0, 40)
SpeedActivatorButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpeedActivatorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedActivatorButton.Font = Enum.Font.SourceSansBold
SpeedActivatorButton.TextSize = 16
SpeedActivatorButton.Text = "Вкл"
SpeedActivatorButton.Parent = SpeedToggleFrame

local SpeedValueInput = Instance.new("TextBox")
SpeedValueInput.Name = "SpeedValueInput"
SpeedValueInput.PlaceholderText = "32"
SpeedValueInput.Text = "32"
SpeedValueInput.KeyboardType = Enum.KeyboardType.NumberPad
SpeedValueInput.Size = UDim2.new(0.45, 0, 0, 25)
SpeedValueInput.Position = UDim2.new(0.525, 0, 0, 40)
SpeedValueInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedValueInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValueInput.Font = Enum.Font.SourceSans
SpeedValueInput.TextSize = 16
SpeedValueInput.TextXAlignment = Enum.TextXAlignment.Center
SpeedValueInput.Parent = SpeedToggleFrame

-- Infinite Jump Section
local JumpPowerFrame = Instance.new("Frame")
JumpPowerFrame.Name = "JumpPowerSettings"
JumpPowerFrame.Size = UDim2.new(0.9, 0, 0, 45)
JumpPowerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JumpPowerFrame.BorderSizePixel = 0
JumpPowerFrame.LayoutOrder = 2
JumpPowerFrame.Parent = ContentFrame

local JumpPowerLabel = Instance.new("TextLabel")
JumpPowerLabel.Name = "JumpLabel"
JumpPowerLabel.Size = UDim2.new(1, 0, 0, 20)
JumpPowerLabel.Position = UDim2.new(0, 0, 0, 5)
JumpPowerLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JumpPowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpPowerLabel.Font = Enum.Font.SourceSansSemibold
JumpPowerLabel.TextSize = 16
JumpPowerLabel.Text = "Бесконечный прыжок"
JumpPowerLabel.TextXAlignment = Enum.TextXAlignment.Center
JumpPowerLabel.Parent = JumpPowerFrame

local JumpActivatorButton = Instance.new("TextButton")
JumpActivatorButton.Name = "JumpActivatorButton"
JumpActivatorButton.Size = UDim2.new(0.95, 0, 0, 25)
JumpActivatorButton.Position = UDim2.new(0.025, 0, 0, 40)
JumpActivatorButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
JumpActivatorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpActivatorButton.Font = Enum.Font.SourceSansBold
JumpActivatorButton.TextSize = 16
JumpActivatorButton.Text = "Вкл"
JumpActivatorButton.Parent = JumpPowerFrame

-- Eye Lasers Section
local EyeLasersFrame = Instance.new("Frame")
EyeLasersFrame.Name = "EyeLasersSettings"
EyeLasersFrame.Size = UDim2.new(0.9, 0, 0, 45)
EyeLasersFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
EyeLasersFrame.BorderSizePixel = 0
EyeLasersFrame.LayoutOrder = 3
EyeLasersFrame.Parent = ContentFrame

local EyeLasersLabel = Instance.new("TextLabel")
EyeLasersLabel.Name = "LasersLabel"
EyeLasersLabel.Size = UDim2.new(1, 0, 0, 20)
EyeLasersLabel.Position = UDim2.new(0, 0, 0, 5)
EyeLasersLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
EyeLasersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
EyeLasersLabel.Font = Enum.Font.SourceSansSemibold
EyeLasersLabel.TextSize = 16
EyeLasersLabel.Text = "Лазеры из глаз"
EyeLasersLabel.TextXAlignment = Enum.TextXAlignment.Center
EyeLasersLabel.Parent = EyeLasersFrame

local EyeLasersButton = Instance.new("TextButton")
EyeLasersButton.Name = "EyeLasersToggle"
EyeLasersButton.Size = UDim2.new(0.95, 0, 0, 25)
EyeLasersButton.Position = UDim2.new(0.025, 0, 0, 40)
EyeLasersButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
EyeLasersButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EyeLasersButton.Font = Enum.Font.SourceSansBold
EyeLasersButton.TextSize = 16
EyeLasersButton.Text = "Вкл"
EyeLasersButton.Parent = EyeLasersFrame

-- Parent all GUI elements
ScriptHeader.Parent = ControlPanel
SignatureLabel.Parent = ControlPanel
CloseButton.Parent = ControlPanel
ContentFrame.Parent = ControlPanel
ControlPanel.Parent = MainScreenGui
MainScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Script Logic
local originalWalkSpeed = Humanoid.WalkSpeed
local isSpeedEnabled = false
local currentSpeedValue = tonumber(SpeedValueInput.Text) or 32

local isInfiniteJumpEnabled = false

local isEyeLasersActive = false
local leftEyePart = nil
local rightEyePart = nil
local leftLaserBeam = nil
local rightLaserBeam = nil

local function updateButtonAppearance(button, isEnabled, enabledText, disabledText)
    if isEnabled then
        button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        button.Text = enabledText
    else
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        button.Text = disabledText
    end
end

-- Speed Logic
local function adjustPlayerSpeed(newSpeed)
    Humanoid.WalkSpeed = newSpeed
end

SpeedActivatorButton.MouseButton1Click:Connect(function()
    isSpeedEnabled = not isSpeedEnabled
    updateButtonAppearance(SpeedActivatorButton, isSpeedEnabled, "ВКЛ.", "ВЫКЛ.")

    if isSpeedEnabled then
        adjustPlayerSpeed(currentSpeedValue)
    else
        adjustPlayerSpeed(originalWalkSpeed)
    end
end)

SpeedValueInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newSpeed = tonumber(SpeedValueInput.Text)
        if newSpeed and newSpeed > 0 then
            currentSpeedValue = newSpeed
            if isSpeedEnabled then
                adjustPlayerSpeed(currentSpeedValue)
            end
        else
            SpeedValueInput.Text = tostring(currentSpeedValue) -- Revert if invalid
        end
    end
end)

-- Infinite Jump Logic
local function activateInfiniteJump(active)
    if active then
        UserInputService.JumpRequest:Connect(function()
            if Humanoid and Character then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

JumpActivatorButton.MouseButton1Click:Connect(function()
    isInfiniteJumpEnabled = not isInfiniteJumpEnabled
    updateButtonAppearance(JumpActivatorButton, isInfiniteJumpEnabled, "АКТИВНО", "НЕАКТИВНО")

    activateInfiniteJump(isInfiniteJumpEnabled)
end)

-- Eye Lasers Logic
local function createLaserBeam(parent, color)
    local part = Instance.new("Part")
    part.Name = "LaserOrigin"
    part.Anchored = true
    part.CanCollide = false
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Transparency = 1
    part.Parent = parent

    local beam = Instance.new("Beam")
    beam.Name = "EyeLaserBeam"
    beam.Color = ColorSequence.new(color)
    beam.FaceCamera = false
    beam.LightEmission = 1
    beam.LightInfluence = 0
    beam.TextureLength = 1
    beam.TextureMode = Enum.TextureMode.Static
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.ZOffset = 0
    beam.Brightness = 2
    beam.Transparency = NumberSequence.new(0)
    beam.Segments = 10
    beam.Enabled = true
    beam.Parent = part

    local attachment0 = Instance.new("Attachment")
    attachment0.Name = "Attach0"
    attachment0.Parent = part
    beam.Attachment0 = attachment0

    local attachment1 = Instance.new("Attachment")
    attachment1.Name = "Attach1"
    attachment1.Parent = part
    beam.Attachment1 = attachment1
    
    return part, beam, attachment0, attachment1
end

local function toggleEyeLasers(enabled)
    if enabled and Character and Head then
        -- Assume eyes are slightly to the sides of the head
        local leftEyeOffset = CFrame.new(-0.4, 0.2, -0.6)
        local rightEyeOffset = CFrame.new(0.4, 0.2, -0.6)

        leftEyePart, leftLaserBeam, _, _ = createLaserBeam(Character, Color3.fromRGB(255, 0, 0))
        rightEyePart, rightLaserBeam, _, _ = createLaserBeam(Character, Color3.fromRGB(255, 0, 0))

        RunService.RenderStepped:Connect(function()
            if isEyeLasersActive and Character and Head then
                local headCFrame = Head.CFrame
                local leftEyeCFrame = headCFrame * leftEyeOffset
                local rightEyeCFrame = headCFrame * rightEyeOffset

                if leftEyePart and leftLaserBeam then
                    leftEyePart.CFrame = leftEyeCFrame
                    leftLaserBeam.Attachment0.WorldPosition = leftEyeCFrame.p
                    
                    local rayOrigin = leftEyeCFrame.p
                    local rayDirection = leftEyeCFrame.LookVector * 500
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {Character, MainScreenGui}
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

                    if raycastResult then
                        leftLaserBeam.Attachment1.WorldPosition = raycastResult.Position
                    else
                        leftLaserBeam.Attachment1.WorldPosition = rayOrigin + rayDirection
                    end
                end

                if rightEyePart and rightLaserBeam then
                    rightEyePart.CFrame = rightEyeCFrame
                    rightLaserBeam.Attachment0.WorldPosition = rightEyeCFrame.p
                    
                    local rayOrigin = rightEyeCFrame.p
                    local rayDirection = rightEyeCFrame.LookVector * 500
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {Character, MainScreenGui}
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

                    if raycastResult then
                        rightLaserBeam.Attachment1.WorldPosition = raycastResult.Position
                    else
                        rightLaserBeam.Attachment1.WorldPosition = rayOrigin + rayDirection
                    end
                end
            end
        end)
    else
        if leftEyePart then leftEyePart:Destroy() end
        if rightEyePart then rightEyePart:Destroy() end
        leftEyePart = nil
        rightEyePart = nil
        leftLaserBeam = nil
        rightLaserBeam = nil
    end
end

EyeLasersButton.MouseButton1Click:Connect(function()
    isEyeLasersActive = not isEyeLasersActive
    updateButtonAppearance(EyeLasersButton, isEyeLasersActive, "СВЕТИТ", "ОТКЛЮЧЕН")
    toggleEyeLasers(isEyeLasersActive)
end)


-- GUI Visibility Toggle
CloseButton.MouseButton1Click:Connect(function()
    ControlPanel.Visible = not ControlPanel.Visible
    CloseButton.Text = ControlPanel.Visible and "X" or "O"
    if ControlPanel.Visible then
        CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        CloseButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
end)

-- Ensure character changes are handled
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    Head = Character:WaitForChild("Head")
    originalWalkSpeed = Humanoid.WalkSpeed -- Reset original speed

    -- Reapply features if enabled
    if isSpeedEnabled then
        adjustPlayerSpeed(currentSpeedValue)
    end
    if isInfiniteJumpEnabled then
        activateInfiniteJump(true) -- Reconnect JumpRequest
    end
    if isEyeLasersActive then
        toggleEyeLasers(false) -- Clear old lasers
        toggleEyeLasers(true)  -- Create new lasers
    end
end)

-- Initial setup
updateButtonAppearance(SpeedActivatorButton, isSpeedEnabled, "ВКЛ.", "ВЫКЛ.")
updateButtonAppearance(JumpActivatorButton, isInfiniteJumpEnabled, "АКТИВНО", "НЕАКТИВНО")
updateButtonAppearance(EyeLasersButton, isEyeLasersActive, "СВЕТИТ", "ОТКЛЮЧЕН")