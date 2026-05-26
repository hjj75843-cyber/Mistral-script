local LocalPlayer = Players.LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
if not player then
    warn("LocalPlayer not found")
    return
end
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid", 5)
if not humanoid then
    warn("Humanoid not found")
    return
end
local rootPart = character:WaitForChild("HumanoidRootPart", 5)
if not rootPart then
    warn("HumanoidRootPart not found")
    return
end
local connectionFly
local velocity
local gyro
local flyEnabled = false
local flySpeed = 50
local baseFlySpeed = flySpeed
local bodyVelocityCleanup = {}
local bodyGyroCleanup = {}
local function cleanupFly()
    for _, obj in ipairs(bodyVelocityCleanup) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    for _, obj in ipairs(bodyGyroCleanup) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    bodyVelocityCleanup = {}
    bodyGyroCleanup = {}
end
local function setupFly()
    if not flyEnabled then return end
    cleanupFly()
    velocity = Instance.new("BodyVelocity")
    velocity.Name = "FlyVelocity"
    velocity.Velocity = Vector3.new(0, 0, 0)
    velocity.MaxForce = Vector3.new(1, 1, 1) * 4000
    velocity.P = 1250
    velocity.Parent = rootPart
    table.insert(bodyVelocityCleanup, velocity)
    gyro = Instance.new("BodyGyro")
    gyro.Name = "FlyGyro"
    gyro.CFrame = rootPart.CFrame
    gyro.MaxTorque = Vector3.new(1, 1, 1) * 4000
    gyro.P = 1000
    gyro.D = 50
    gyro.Parent = rootPart
    table.insert(bodyGyroCleanup, gyro)
    humanoid.PlatformStand = true
end
local function disableFly()
    cleanupFly()
    humanoid.PlatformStand = false
end
local function handleCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid", 5)
    rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if flyEnabled then
        setupFly()
    end
end
player.CharacterAdded:Connect(handleCharacterAdded)
local flyGui = Instance.new("ScreenGui")
flyGui.Name = "Mistral Scripts"
flyGui.ResetOnSpawn = false
flyGui.IgnoreGuiInset = true
flyGui.Enabled = true
flyGui.Parent = player.PlayerGui
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 200)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = flyGui
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Mistral Scripts"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextScaled = true
titleLabel.Parent = mainFrame
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -10, 0, 20)
statusLabel.Position = UDim2.new(0, 5, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Disabled"
statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextScaled = true
statusLabel.Parent = mainFrame
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, -10, 0, 20)
speedLabel.Position = UDim2.new(0, 5, 0, 55)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.TextScaled = true
speedLabel.Parent = mainFrame
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.8, 0, 0, 30)
toggleButton.Position = UDim2.new(0.1, 0, 0, 80)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggleButton.Text = "Toggle Fly"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.GothamSemibold
toggleButton.AutoButtonColor = false
toggleButton.Parent = mainFrame
local uiCornerToggle = Instance.new("UICorner")
uiCornerToggle.CornerRadius = UDim.new(0, 4)
uiCornerToggle.Parent = toggleButton
local speedUpButton = Instance.new("TextButton")
speedUpButton.Name = "SpeedUpButton"
speedUpButton.Size = UDim2.new(0.35, 0, 0, 25)
speedUpButton.Position = UDim2.new(0.05, 0, 0, 120)
speedUpButton.BackgroundColor3 = Color3.fromRGB(50, 120, 255)
speedUpButton.Text = "Speed +"
speedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUpButton.TextSize = 12
toggleButton.Font = Enum.Font.GothamSemibold
speedUpButton.AutoButtonColor = false
speedUpButton.Parent = mainFrame
local uiCornerSpeedUp = Instance.new("UICorner")
uiCornerSpeedUp.CornerRadius = UDim.new(0, 4)
uiCornerSpeedUp.Parent = speedUpButton
local speedDownButton = Instance.new("TextButton")
speedDownButton.Name = "SpeedDownButton"
speedDownButton.Size = UDim2.new(0.35, 0, 0, 25)
speedDownButton.Position = UDim2.new(0.45, 0, 0, 120)
speedDownButton.BackgroundColor3 = Color3.fromRGB(50, 120, 255)
speedDownButton.Text = "Speed -"
speedDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDownButton.TextSize = 12
toggleButton.Font = Enum.Font.GothamSemibold
speedDownButton.AutoButtonColor = false
speedDownButton.Parent = mainFrame
local uiCornerSpeedDown = Instance.new("UICorner")
uiCornerSpeedDown.CornerRadius = UDim.new(0, 4)
uiCornerSpeedDown.Parent = speedDownButton
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
toggleButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false
closeButton.Parent = mainFrame
local uiCornerClose = Instance.new("UICorner")
uiCornerClose.CornerRadius = UDim.new(0, 4)
uiCornerClose.Parent = closeButton
local function updateFlySpeed(newSpeed)
    flySpeed = math.clamp(newSpeed, 10, 200)
    if velocity then
        velocity.MaxForce = Vector3.new(1, 1, 1) * flySpeed * 80
    end
    speedLabel.Text = "Speed: " .. flySpeed
end
local function updateStatus(enabled)
    if enabled then
        statusLabel.Text = "Status: Enabled"
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        flyEnabled = true
        setupFly()
    else
        statusLabel.Text = "Status: Disabled"
        statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        flyEnabled = false
        disableFly()
    end
end
local function toggleFly()
    updateStatus(not flyEnabled)
end
local function onSpeedUp()
    updateFlySpeed(flySpeed + 5)
end
local function onSpeedDown()
    updateFlySpeed(flySpeed - 5)
end
toggleButton.MouseButton1Click:Connect(toggleFly)
speedUpButton.MouseButton1Click:Connect(onSpeedUp)
speedDownButton.MouseButton1Click:Connect(onSpeedDown)
closeButton.MouseButton1Click:Connect(function()
    flyGui.Enabled = false
    cleanupFly()
    humanoid.PlatformStand = false
end)
local flyConnection
local function onFlyInput(input, gameProcessed)
    if not flyEnabled or not rootPart or not velocity or not gyro or gameProcessed then
        return
    end
    local moveDirection = humanoid.MoveDirection
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local lookVector = camera.CFrame.LookVector
    lookVector = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
    local rightVector = camera.CFrame.RightVector
    rightVector = Vector3.new(rightVector.X, 0, rightVector.Z).Unit
    local moveVelocity = Vector3.new(0, 0, 0)
    if moveDirection.Magnitude > 0.1 then
        if input.KeyCode == Enum.KeyCode.W or input.UserInputType == Enum.UserInputType.Gamepad1 then
            moveVelocity = moveVelocity + lookVector * flySpeed
        elseif input.KeyCode == Enum.KeyCode.S or input.UserInputType == Enum.UserInputType.Gamepad1 then
            moveVelocity = moveVelocity - lookVector * flySpeed
        end
        if input.KeyCode == Enum.KeyCode.A or input.UserInputType == Enum.UserInputType.Gamepad1 then
            moveVelocity = moveVelocity - rightVector * flySpeed
        elseif input.KeyCode == Enum.KeyCode.D or input.UserInputType == Enum.UserInputType.Gamepad1 then
            moveVelocity = moveVelocity + rightVector * flySpeed
        end
    end
    local yMovement = 0
    if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Gamepad1 then
        yMovement = flySpeed * 0.7
    elseif input.KeyCode == Enum.KeyCode.LeftShift or input.UserInputType == Enum.UserInputType.Gamepad1 then
        yMovement = -flySpeed * 0.7
    end
    velocity.Velocity = moveVelocity + Vector3.new(0, yMovement, 0)
    gyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + moveVelocity.Unit)
end
flyConnection = UserInputService.InputBegan:Connect(onFlyInput)
local function onRenderStep()
    if not flyEnabled or not rootPart then return end
    if gyro then
        gyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + (Workspace.CurrentCamera.CFrame.LookVector * 10))
    end
end
local renderConnection = RunService.RenderStepped:Connect(onRenderStep)
character.AncestryChanged:Connect(function(_, parent)
    if not parent then
        cleanupFly()
    end
end)
player.CharacterRemoving:Connect(function()
    cleanupFly()
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if not flyEnabled or not rootPart or not velocity then return end
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        if input.Position.Z > 0 then
            updateFlySpeed(flySpeed + 5)
        elseif input.Position.Z < 0 then
            updateFlySpeed(flySpeed - 5)
        end
    end
end)
updateStatus(false)