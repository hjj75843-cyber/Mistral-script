local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local function CreateGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "Mistral Scripts"
    gui.ResetOnSpawn = false
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 200, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -100, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = gui
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 5)
    uiCorner.Parent = mainFrame
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Mistral Scripts"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    local dragger = Instance.new("Frame")
    dragger.Name = "Dragger"
    dragger.Size = UDim2.new(1, 0, 0, 20)
    dragger.Position = UDim2.new(0, 0, 0, 0)
    dragger.BackgroundTransparency = 1
    dragger.Parent = mainFrame
    local draggerInput = Instance.new("TextButton")
    draggerInput.Name = "DragInput"
    draggerInput.Size = UDim2.new(1, 0, 1, 0)
    draggerInput.Position = UDim2.new(0, 0, 0, 0)
    draggerInput.BackgroundTransparency = 1
    draggerInput.Text = ""
    draggerInput.ZIndex = 2
    draggerInput.Parent = dragger
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -20, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = mainFrame
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, -20)
    content.Position = UDim2.new(0, 0, 0, 20)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame
    return gui, mainFrame, closeBtn
end
local function MakeDraggable(frame)
    local dragging
    local dragInput
    local dragStartPos
    local startPos
    local function update(input)
        local delta = input.Position - dragStartPos
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.DragInput.MouseButton1Down:Connect(function()
        dragging = true
        dragStartPos = Vector2.new(frame.AbsolutePosition.X, frame.AbsolutePosition.Y)
        startPos = frame.Position
        local inputConnection
        inputConnection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input == dragInput then
                dragging = false
                inputConnection:Disconnect()
            end
        end)
    end)
end
local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end
local function CreateStatusLabel(parent)
    local label = Instance.new("TextLabel")
    label.Name = "StatusLabel"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 1, -20)
    label.BackgroundTransparency = 1
    label.Text = "Status: Off"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.Parent = parent
    return label
end
local function CreateMobileButtons(parent)
    local buttonsFrame = Instance.new("Frame")
    buttonsFrame.Name = "MobileButtons"
    buttonsFrame.Size = UDim2.new(1, 0, 0, 70)
    buttonsFrame.Position = UDim2.new(0, 0, 0.5, -35)
    buttonsFrame.BackgroundTransparency = 1
    buttonsFrame.Parent = parent
    local upBtn = Instance.new("TextButton")
    upBtn.Name = "UpBtn"
    upBtn.Size = UDim2.new(0.3, 0, 1, 0)
    upBtn.Position = UDim2.new(0.35, 0, 0, 0)
    upBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    upBtn.Text = "↑"
    upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    upBtn.TextSize = 20
    upBtn.Font = Enum.Font.GothamBold
    upBtn.Parent = buttonsFrame
    local downBtn = Instance.new("TextButton")
    downBtn.Name = "DownBtn"
    downBtn.Size = UDim2.new(0.3, 0, 1, 0)
    downBtn.Position = UDim2.new(0.35, 0, 0, 70)
    downBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    downBtn.Text = "↓"
    downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    downBtn.TextSize = 20
    downBtn.Font = Enum.Font.GothamBold
    downBtn.Parent = buttonsFrame
    return upBtn, downBtn
end
local flyEnabled = false
local flyVelocity
local bodyVelocity
local function Fly(player, enabled)
    if enabled then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyVelocity.Parent = rootPart
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.P = 1000
            bodyGyro.D = 50
            bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + (camera.CFrame.LookVector))
            bodyGyro.Parent = rootPart
            RunService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Camera.Value, function()
                if not flyEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    return
                end
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if not humanoid or humanoid:GetState() == Enum.HumanoidStateType.Dead then
                    Fly(player, false)
                    return
                end
                local moveDirection = Vector3.new(0, 0, 0)
                local moveSpeed = 0.5
                if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
                    moveDirection = moveDirection + (camera.CFrame.LookVector * moveSpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then
                    moveDirection = moveDirection - (camera.CFrame.LookVector * moveSpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - (camera.CFrame.RightVector * moveSpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + (camera.CFrame.RightVector * moveSpeed)
                end
                if moveDirection.Magnitude > 0 then
                    flyVelocity.Velocity = moveDirection
                    bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + moveDirection)
                else
                    flyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    else
        if flyVelocity then
            flyVelocity:Destroy()
            flyVelocity = nil
        end
        local gyro = player.Character and player.Character.HumanoidRootPart and player.Character.HumanoidRootPart:FindFirstChildOfClass("BodyGyro")
        if gyro then
            gyro:Destroy()
        end
        RunService:UnbindFromRenderStep("FlyMovement")
    end
end
local function SetupFlyButtons(mainFrame)
    local content = mainFrame.Content
    local statusLabel = CreateStatusLabel(content)
    local flyBtn = CreateButton(content, "Toggle Fly [F]", function()
        flyEnabled = not flyEnabled
        Fly(localPlayer, flyEnabled)
        statusLabel.Text = "Status: " .. (flyEnabled and "On" or "Off")
    end)
    local upBtn, downBtn = CreateMobileButtons(content)
    upBtn.MouseButton1Down:Connect(function()
        if flyEnabled and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = localPlayer.Character.HumanoidRootPart
            local moveVelocity = Instance.new("BodyVelocity")
            moveVelocity.Velocity = Vector3.new(0, 50, 0)
            moveVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            moveVelocity.Parent = rootPart
            RunService.Heartbeat:Wait()
            moveVelocity:Destroy()
        end
    end)
    downBtn.MouseButton1Down:Connect(function()
        if flyEnabled and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = localPlayer.Character.HumanoidRootPart
            local moveVelocity = Instance.new("BodyVelocity")
            moveVelocity.Velocity = Vector3.new(0, -50, 0)
            moveVelocity.MaxForce = Vector3.new(0, math.huge, 0)
            moveVelocity.Parent = rootPart
            RunService.Heartbeat:Wait()
            moveVelocity:Destroy()
        end
    end)
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F then
            flyEnabled = not flyEnabled
            Fly(localPlayer, flyEnabled)
            statusLabel.Text = "Status: " .. (flyEnabled and "On" or "Off")
        end
    end)
    local cleanupBtn = CreateButton(content, "Cleanup", function()
        Fly(localPlayer, false)
        flyEnabled = false
        if statusLabel then
            statusLabel.Text = "Status: Off"
        end
        if gui then
            gui:Destroy()
        end
    end)
    return flyBtn, statusLabel, cleanupBtn
end
local success, err = pcall(function()
    local gui, mainFrame, closeBtn = CreateGui()
    MakeDraggable(mainFrame)
    local flyBtn, statusLabel, cleanupBtn = SetupFlyButtons(mainFrame)
    closeBtn.MouseButton1Click:Connect(function()
        Fly(localPlayer, false)
        flyEnabled = false
        if statusLabel then
            statusLabel.Text = "Status: Off"
        end
        if gui then
            gui:Destroy()
        end
    end)
    gui.Parent = game:GetService("CoreGui")
end)
if not success then
    warn("Mistral Scripts failed to load: " .. err)
end