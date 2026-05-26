local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Mistral ScriptssGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")
-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 240)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -120)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
mainFrame.TitleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Mistral Scripts"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.TextScaled = true
mainFrame.Parent = titleLabel
titleLabel.Parent = mainFrame
-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleLabel
-- Draggable Setup
local dragging
local dragInput
local dragStart
local startPos
local function update(input)
	dragInput = input
	local delta = input.Position - dragStart
	local newPosition = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
	mainFrame.Position = newPosition
end
titleLabel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		update(input)
	end
end)
-- Main Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame
-- Mode Selection
local modeLabel = Instance.new("TextLabel")
modeLabel.Name = "ModeLabel"
modeLabel.Size = UDim2.new(0.9, 0, 0, 20)
modeLabel.Position = UDim2.new(0.05, 0, 0, 10)
modeLabel.BackgroundTransparency = 1
modeLabel.Font = Enum.Font.Gotham
modeLabel.Text = "Current Mode: Fly"
modeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
modeLabel.TextSize = 12
modeLabel.Parent = contentFrame
local modeButton = Instance.new("TextButton")
modeButton.Name = "ModeButton"
modeButton.Size = UDim2.new(0.9, 0, 0, 30)
modeButton.Position = UDim2.new(0.05, 0, 0, 35)
modeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
modeButton.BorderSizePixel = 0
modeButton.Text = "Switch Mode"
modeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
modeButton.TextSize = 12
modeButton.Font = Enum.Font.Gotham
modeButton.Parent = contentFrame
-- Fly Mode Elements
local flyEnabled = false
local flyBodyVelocity
local flySpeed = 50
local isUpPressed = false
local isDownPressed = false
local flySettingsFrame = Instance.new("Frame")
flySettingsFrame.Name = "FlySettings"
flySettingsFrame.Size = UDim2.new(1, 0, 1, -70)
flySettingsFrame.Position = UDim2.new(0, 0, 0, 70)
flySettingsFrame.BackgroundTransparency = 1
flySettingsFrame.Visible = true
flySettingsFrame.Parent = contentFrame
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0, 10)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Speed: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 12
speedLabel.Parent = flySettingsFrame
local speedUpButton = Instance.new("TextButton")
speedUpButton.Name = "SpeedUpButton"
speedUpButton.Size = UDim2.new(0.4, 0, 0, 30)
speedUpButton.Position = UDim2.new(0.05, 0, 0, 40)
speedUpButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
speedUpButton.BorderSizePixel = 0
speedUpButton.Text = "Speed Up"
speedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUpButton.TextSize = 12
speedUpButton.Font = Enum.Font.Gotham
speedUpButton.Parent = flySettingsFrame
local speedDownButton = Instance.new("TextButton")
speedDownButton.Name = "SpeedDownButton"
speedDownButton.Size = UDim2.new(0.4, 0, 0, 30)
speedDownButton.Position = UDim2.new(0.55, 0, 0, 40)
speedDownButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
speedDownButton.BorderSizePixel = 0
speedDownButton.Text = "Speed Down"
speedDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDownButton.TextSize = 12
speedDownButton.Font = Enum.Font.Gotham
speedDownButton.Parent = flySettingsFrame
local flyStatusLabel = Instance.new("TextLabel")
flyStatusLabel.Name = "FlyStatusLabel"
flyStatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
flyStatusLabel.Position = UDim2.new(0.05, 0, 0, 85)
flyStatusLabel.BackgroundTransparency = 1
flyStatusLabel.Font = Enum.Font.Gotham
flyStatusLabel.Text = "Status: Disabled"
flyStatusLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
flyStatusLabel.TextSize = 12
flyStatusLabel.Parent = flySettingsFrame
local upButton = Instance.new("TextButton")
upButton.Name = "UpButton"
upButton.Size = UDim2.new(0.3, 0, 0.2, 0)
upButton.Position = UDim2.new(0.05, 0, 0.6, 0)
upButton.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
upButton.BorderSizePixel = 0
upButton.Text = "↑"
upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upButton.TextSize = 16
upButton.Font = Enum.Font.GothamBold
upButton.Parent = flySettingsFrame
local downButton = Instance.new("TextButton")
downButton.Name = "DownButton"
downButton.Size = UDim2.new(0.3, 0, 0.2, 0)
downButton.Position = UDim2.new(0.375, 0, 0.6, 0)
downButton.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
downButton.BorderSizePixel = 0
downButton.Text = "↓"
downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
downButton.TextSize = 16
downButton.Font = Enum.Font.GothamBold
downButton.Parent = flySettingsFrame
local cleanupButton = Instance.new("TextButton")
cleanupButton.Name = "CleanupButton"
cleanupButton.Size = UDim2.new(0.3, 0, 0.15, 0)
cleanupButton.Position = UDim2.new(0.7, 0, 0.65, 0)
cleanupButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
cleanupButton.BorderSizePixel = 0
cleanupButton.Text = "Cleanup"
cleanupButton.TextColor3 = Color3.fromRGB(255, 255, 255)
cleanupButton.TextSize = 12
cleanupButton.Font = Enum.Font.Gotham
cleanupButton.Parent = flySettingsFrame
-- Mobile Input Handling
UserInputService.TouchStarted:Connect(function(input, gameProcessed)
	if flying() then
		if input.Position.Y < 300 then
			isUpPressed = true
		end
	end
end)
UserInputService.TouchEnded:Connect(function(input, gameProcessed)
	if flying() then
		if input.Position.Y < 300 then
			isUpPressed = false
		end
	end
end)
-- Mode Variables
local currentMode = "Fly"
local noclipEnabled = false
local noclipConnection
local function flying()
	return flyEnabled and character and character:FindFirstChild("HumanoidRootPart")
end
local function enableFly()
	if flying() then return end
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	flyEnabled = true
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	flyBodyVelocity = Instance.new("BodyVelocity")
	flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
	flyBodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
	flyBodyVelocity.Parent = rootPart
	local gyro = Instance.new("BodyGyro")
	gyro.MaxTorque = Vector3.new(4000, 4000, 4000)
	gyro.CFrame = rootPart.CFrame
	gyro.Parent = rootPart
	flyStatusLabel.Text = "Status: Enabled"
	flyStatusLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
end
local function disableFly()
	flyEnabled = false
	if flyBodyVelocity and flyBodyVelocity.Parent then
		flyBodyVelocity:Destroy()
		flyBodyVelocity = nil
	end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart then
		local gyro = rootPart:FindFirstChildOfClass("BodyGyro")
		if gyro then
			gyro:Destroy()
		end
	end
	flyStatusLabel.Text = "Status: Disabled"
	flyStatusLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
end
local function updateFlyVelocity()
	if not flying() or not flyBodyVelocity then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	local camera = workspace.CurrentCamera
	local cameraCFrame = camera.CFrame
	local lookVector = cameraCFrame.LookVector
	local rightVector = cameraCFrame.RightVector
	local moveDirection = Vector3.new(0, 0, 0)
	-- Forward/Backward
	if isKeyDown("W") or isKeyDown("Up") then
		moveDirection = moveDirection + lookVector * flySpeed
	end
	if isKeyDown("S") or isKeyDown("Down") then
		moveDirection = moveDirection - lookVector * flySpeed
	end
	-- Left/Right
	if isKeyDown("A") or isKeyDown("Left") then
		moveDirection = moveDirection - rightVector * flySpeed
	end
	if isKeyDown("D") or isKeyDown("Right") then
		moveDirection = moveDirection + rightVector * flySpeed
	end
	-- Up/Down (Mobile)
	if isUpPressed then
		moveDirection = moveDirection + Vector3.new(0, 1, 0) * flySpeed
	end
	if isDownPressed then
		moveDirection = moveDirection - Vector3.new(0, 1, 0) * flySpeed
	end
	-- Apply velocity with same Y velocity to maintain height better
	flyBodyVelocity.Velocity = Vector3.new(moveDirection.X, 0, moveDirection.Z)
	-- Update gyro to match camera direction
	local gyro = rootPart:FindFirstChildOfClass("BodyGyro")
	if gyro then
		local lookVectorFlat = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
		gyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + lookVectorFlat)
	end
end
local function isKeyDown(key)
	return UserInputService:IsKeyDown(Enum.KeyCode[key])
end
-- Fly Toggle
local flyToggle = Instance.new("TextButton")
flyToggle.Name = "FlyToggle"
flyToggle.Size = UDim2.new(0.4, 0, 0, 30)
flyToggle.Position = UDim2.new(0.05, 0, 0.35, 0)
flyToggle.BackgroundColor3 = flyEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
flyToggle.BorderSizePixel = 0
flyToggle.Text = flyEnabled and "Disable Fly" or "Enable Fly"
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.TextSize = 12
flyToggle.Font = Enum.Font.Gotham
flyToggle.Parent = flySettingsFrame
flyToggle.MouseButton1Click:Connect(function()
	if flyEnabled then
		disableFly()
	else
		enableFly()
	end
	flyToggle.BackgroundColor3 = flyEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
	flyToggle.Text = flyEnabled and "Disable Fly" or "Enable Fly"
end)
-- Speed Controls
speedUpButton.MouseButton1Click:Connect(function()
	flySpeed = math.min(flySpeed + 10, 200)
	speedLabel.Text = "Speed: " .. flySpeed
end)
speedDownButton.MouseButton1Click:Connect(function()
	flySpeed = math.max(flySpeed - 10, 10)
	speedLabel.Text = "Speed: " .. flySpeed
end)
-- Mobile Buttons
local function setupMobileButtons()
	-- Fly Up
	upButton.MouseButton1Down:Connect(function()
		isUpPressed = true
	end)
	upButton.MouseButton1Up:Connect(function()
		isUpPressed = false
	end)
	-- Fly Down
	downButton.MouseButton1Down:Connect(function()
		isDownPressed = true
	end)
	downButton.MouseButton1Up:Connect(function()
		isDownPressed = false
	end)
	-- Cleanup
	cleanupButton.MouseButton1Click:Connect(function()
		disableFly()
		flySpeed = 50
		speedLabel.Text = "Speed: " .. flySpeed
		flyToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		flyToggle.Text = "Enable Fly"
		flyStatusLabel.Text = "Status: Disabled"
		flyStatusLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
	end)
end
setupMobileButtons()
-- Update Loop
RunService.Heartbeat:Connect(function()
	if flying() then
		updateFlyVelocity()
	end
end)
-- Cleanup on script removal
local function cleanup()
	disableFly()
	if flySettingsFrame then
		flySettingsFrame:Destroy()
	end
	if mainFrame then
		mainFrame:Destroy()
	end
end
-- Close button
closeButton.MouseButton1Click:Connect(function()
	cleanup()
	screenGui:Destroy()
end)
-- Mode switching
modeButton.MouseButton1Click:Connect(function()
	-- Currently only Fly mode is implemented
	modeLabel.Text = "Current Mode: Fly"
end)