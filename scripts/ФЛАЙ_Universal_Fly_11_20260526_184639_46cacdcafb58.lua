local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local isFlying = false
local flySpeed = 100
local flyVelocity = nil
local connections = {}
local function cleanup()
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    connections = {}
    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end
    isFlying = false
end
local function createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Mistral Scriptss_Gui"
    screenGui.Parent = playerGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 150)
    mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 5)
    uiCorner.Parent = mainFrame
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(100, 100, 100)
    uiStroke.Thickness = 2
    uiStroke.Parent = mainFrame
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Mistral Scripts"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextStrokeTransparency = 0.5
    titleLabel.Parent = mainFrame
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -25, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame
    local uiCornerClose = Instance.new("UICorner")
    uiCornerClose.CornerRadius = UDim.new(0, 5)
    uiCornerClose.Parent = closeButton
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -20, 0, 20)
    statusLabel.Position = UDim2.new(0, 10, 0, 30)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: Disabled"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 14
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = mainFrame
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, -20, 0, 20)
    speedLabel.Position = UDim2.new(0, 10, 0, 55)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: 100"
    speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    speedLabel.TextSize = 14
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = mainFrame
    local upButton = Instance.new("TextButton")
    upButton.Name = "UpButton"
    upButton.Size = UDim2.new(0, 70, 0, 30)
    upButton.Position = UDim2.new(0.5, -35, 0, 80)
    upButton.AnchorPoint = Vector2.new(0.5, 0)
    upButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    upButton.Text = "Up"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.TextSize = 16
    upButton.Font = Enum.Font.GothamBold
    upButton.AutoButtonColor = false
    upButton.Parent = mainFrame
    local uiCornerUp = Instance.new("UICorner")
    uiCornerUp.CornerRadius = UDim.new(0, 5)
    uiCornerUp.Parent = upButton
    local downButton = Instance.new("TextButton")
    downButton.Name = "DownButton"
    downButton.Size = UDim2.new(0, 70, 0, 30)
    downButton.Position = UDim2.new(0.5, -35, 0, 120)
    downButton.AnchorPoint = Vector2.new(0.5, 0)
    downButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    downButton.Text = "Down"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.TextSize = 16
    downButton.Font = Enum.Font.GothamBold
    downButton.AutoButtonColor = false
    downButton.Parent = mainFrame
    local uiCornerDown = Instance.new("UICorner")
    uiCornerDown.CornerRadius = UDim.new(0, 5)
    uiCornerDown.Parent = downButton
    local cleanupButton = Instance.new("TextButton")
    cleanupButton.Name = "CleanupButton"
    cleanupButton.Size = UDim2.new(0, 60, 0, 25)
    cleanupButton.Position = UDim2.new(0.5, -30, 1, -30)
    cleanupButton.AnchorPoint = Vector2.new(0.5, 1)
    cleanupButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    cleanupButton.Text = "Cleanup"
    cleanupButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cleanupButton.TextSize = 14
    cleanupButton.Font = Enum.Font.GothamBold
    cleanupButton.AutoButtonColor = false
    cleanupButton.Parent = mainFrame
    local uiCornerClean = Instance.new("UICorner")
    uiCornerClean.CornerRadius = UDim.new(0, 5)
    uiCornerClean.Parent = cleanupButton
    -- Draggable frame
    local dragInput
    local dragStart
    local startPos
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragInput = nil
                end
            end)
        end
    end)
    mainFrame.InputChanged:Connect(function(input)
        if input == dragInput then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end
    end)
    local dragConnection
    dragConnection = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragInput then
            update(input)
        end
    end)
    table.insert(connections, dragConnection)
    -- Close button
    closeButton.MouseButton1Click:Connect(function()
        cleanup()
        screenGui:Destroy()
    end)
    -- Cleanup button
    cleanupButton.MouseButton1Click:Connect(function()
        cleanup()
    end)
    -- Fly toggle logic
    local function toggleFly()
        isFlying = not isFlying
        if isFlying then
            if not localPlayer.Character then
                localPlayer.CharacterAdded:Wait()
            end
            local character = localPlayer.Character
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.Name = "FlyVelocity"
            flyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            flyVelocity.P = 1250
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyVelocity.Parent = humanoidRootPart
            local flyConnection
            flyConnection = RunService.RenderStepped:Connect(function(deltaTime)
                if not isFlying or not character or not character.Parent or not humanoidRootPart or not humanoidRootPart.Parent then
                    cleanup()
                    return
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Dead then
                    cleanup()
                    return
                end
                local camera = workspace.CurrentCamera
                if not camera then return end
                local cameraCFrame = camera.CFrame
                local moveVector = Vector3.new(0, 0, 0)
                if flyVelocity then
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsGamepadButtonDown(Enum.GamepadButton.R2) then
                        moveVector = moveVector + (cameraCFrame.LookVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsGamepadButtonDown(Enum.GamepadButton.L2) then
                        moveVector = moveVector - (cameraCFrame.LookVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveVector = moveVector - (cameraCFrame.RightVector * flySpeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveVector = moveVector + (cameraCFrame.RightVector * flySpeed)
                    end
                    flyVelocity.Velocity = moveVector
                end
            end)
            table.insert(connections, flyConnection)
            statusLabel.Text = "Status: Flying"
            statusLabel.TextColor3 = Color3.fromRGB(50, 200, 50)
        else
            cleanup()
            statusLabel.Text = "Status: Disabled"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    -- Mobile buttons
    upButton.MouseButton1Click:Connect(function()
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if not flyVelocity then
                toggleFly()
            end
            local character = localPlayer.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                flyVelocity.Velocity = flyVelocity.Velocity + Vector3.new(0, flySpeed, 0)
            end
        end
    end)
    downButton.MouseButton1Click:Connect(function()
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if not flyVelocity then
                toggleFly()
            end
            local character = localPlayer.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                flyVelocity.Velocity = flyVelocity.Velocity + Vector3.new(0, -flySpeed, 0)
            end
        end
    end)
    -- Speed control
    local speedUpButton = Instance.new("TextButton")
    speedUpButton.Name = "SpeedUpButton"
    speedUpButton.Size = UDim2.new(0, 50, 0, 20)
    speedUpButton.Position = UDim2.new(0.5, -75, 0, 85)
    speedUpButton.AnchorPoint = Vector2.new(0.5, 0)
    speedUpButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    speedUpButton.Text = "+"
    speedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedUpButton.TextSize = 14
    speedUpButton.Font = Enum.Font.GothamBold
    speedUpButton.AutoButtonColor = false
    speedUpButton.Visible = false
    speedUpButton.Parent = mainFrame
    local speedDownButton = Instance.new("TextButton")
    speedDownButton.Name = "SpeedDownButton"
    speedDownButton.Size = UDim2.new(0, 50, 0, 20)
    speedDownButton.Position = UDim2.new(0.5, 25, 0, 85)
    speedDownButton.AnchorPoint = Vector2.new(0.5, 0)
    speedDownButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    speedDownButton.Text = "-"
    speedDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDownButton.TextSize = 14
    speedDownButton.Font = Enum.Font.GothamBold
    speedDownButton.AutoButtonColor = false
    speedDownButton.Visible = false
    speedDownButton.Parent = mainFrame
    speedUpButton.MouseButton1Click:Connect(function()
        flySpeed = math.min(flySpeed + 10, 500)
        speedLabel.Text = "Speed: " .. flySpeed
    end)
    speedDownButton.MouseButton1Click:Connect(function()
        flySpeed = math.max(flySpeed - 10, 10)
        speedLabel.Text = "Speed: " .. flySpeed
    end)
    -- Toggle speed buttons visibility
    local speedToggleButton = Instance.new("TextButton")
    speedToggleButton.Name = "SpeedToggleButton"
    speedToggleButton.Size = UDim2.new(0, 110, 0, 20)
    speedToggleButton.Position = UDim2.new(0.5, -55, 0, 50)
    speedToggleButton.AnchorPoint = Vector2.new(0.5, 0)
    speedToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    speedToggleButton.Text = "Speed Controls"
    speedToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    speedToggleButton.TextSize = 12
    speedToggleButton.Font = Enum.Font.Gotham
    speedToggleButton.AutoButtonColor = false
    speedToggleButton.Parent = mainFrame
    local uiCornerSpeed = Instance.new("UICorner")
    uiCornerSpeed.CornerRadius = UDim.new(0, 3)
    uiCornerSpeed.Parent = speedToggleButton
    speedToggleButton.MouseButton1Click:Connect(function()
        speedUpButton.Visible = not speedUpButton.Visible
        speedDownButton.Visible = not speedDownButton.Visible
    end)
    local function onCharacterAdded(character)
        cleanup()
        if isFlying then
            toggleFly()
        end
    end
    localPlayer.CharacterAdded:Connect(onCharacterAdded)
end
pcall(function()
    if not playerGui:FindFirstChild("Mistral Scriptss_Gui") then
        createGui()
    end
end)