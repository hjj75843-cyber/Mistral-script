local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local flying = false
local flySpeed = 25
local flyBodyVelocity = nil
local connection = nil
local function createFlyButton(frame, text, position, size)
	local button = Instance.new("TextButton")
	button.Name = text
	button.Text = text
	button.Size = size
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.AutoButtonColor = false
	button.Parent = frame
	return button
end
local function createStatusLabel(frame, text)
	local label = Instance.new("TextLabel")
	label.Name = "StatusLabel"
	label.Text = text
	label.Size = UDim2.new(1, 0, 0.1, 0)
	label.Position = UDim2.new(0, 0, 0.9, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 12
	label.TextStrokeTransparency = 0.5
	label.Parent = frame
	local function updateStatus()
		if flying then
			label.Text = string.format("Fly: ON | Speed: %d", flySpeed)
		else
			label.Text = "Fly: OFF | Speed: "..tostring(flySpeed)
		end
	end
	return updateStatus
end
local function setupFly()
	if connection then
		connection:Disconnect()
		connection = nil
	end
	if flyBodyVelocity then
		flyBodyVelocity:Destroy()
		flyBodyVelocity = nil
	end
	if character and rootPart and humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
		flying = not flying
		if flying then
			flyBodyVelocity = Instance.new("BodyVelocity")
			flyBodyVelocity.Name = "FlyBodyVelocity"
			flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
			flyBodyVelocity.MaxForce = Vector3.new(0, 0, 0)
			flyBodyVelocity.Parent = rootPart
			connection = RunService.Heartbeat:Connect(function(deltaTime)
				if not rootPart or not humanoid then
					return
				end
				local camera = workspace.CurrentCamera
				local cameraCFrame = camera.CFrame
				local moveDirection = humanoid.MoveDirection
				local lookVector = cameraCFrame.LookVector
				local upVector = cameraCFrame.UpVector
				if moveDirection.Magnitude > 0 then
					local moveVector = Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit
					local rightVector = Vector3.new(lookVector.Z, 0, -lookVector.X).Unit
					local moveCF = CFrame.new(Vector3.new(), moveVector)
					local rightCF = CFrame.new(Vector3.new(), rightVector)
					local cameraCF = CFrame.new(cameraCFrame.Position, cameraCFrame.Position + lookVector)
					local relativeMove = (cameraCF * moveCF):VectorToWorldSpace(Vector3.new(0, 0, moveDirection.Z))
					local relativeRight = (cameraCF * rightCF):VectorToWorldSpace(Vector3.new(moveDirection.X, 0, 0))
					local velocity = (relativeMove + relativeRight).Unit * flySpeed
					velocity = Vector3.new(velocity.X, 0, velocity.Z)
					if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
						velocity = velocity + (upVector * flySpeed * 0.7)
					end
					if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
						velocity = velocity - (upVector * flySpeed * 0.7)
					end
					flyBodyVelocity.Velocity = velocity
				else
					flyBodyVelocity.Velocity = Vector3.new(0, UserInputService:IsKeyDown(Enum.KeyCode.Space) and flySpeed * 0.7 or (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -flySpeed * 0.7 or 0), 0)
				end
			end)
		else
			flying = false
		end
	end
end
local function createFlyUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Mistral ScriptssGui"
	screenGui.ResetOnSpawn = false
	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0.25, 0, 0.4, 0)
	frame.Position = UDim2.new(0.75, 0, 0.3, 0)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 2
	frame.BorderColor3 = Color3.fromRGB(100, 100, 100)
	frame.Active = true
	frame.Draggable = true
	frame.Parent = screenGui
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Text = "Mistral Scripts"
	title.Size = UDim2.new(1, 0, 0.15, 0)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextStrokeTransparency = 0.2
	title.Parent = frame
	local upButton = createFlyButton(frame, "↑", UDim2.new(0.35, 0, 0.2, 0), UDim2.new(0.3, 0, 0.15, 0))
	local downButton = createFlyButton(frame, "↓", UDim2.new(0.35, 0, 0.4, 0), UDim2.new(0.3, 0, 0.15, 0))
	local speedUpButton = createFlyButton(frame, "+S", UDim2.new(0.1, 0, 0.6, 0), UDim2.new(0.35, 0, 0.15, 0))
	local speedDownButton = createFlyButton(frame, "-S", UDim2.new(0.55, 0, 0.6, 0), UDim2.new(0.35, 0, 0.15, 0))
	local toggleButton = createFlyButton(frame, "TOGGLE FLY", UDim2.new(0.1, 0, 0.8, 0), UDim2.new(0.8, 0, 0.15, 0))
	local statusUpdate = createStatusLabel(frame, "Fly: OFF | Speed: "..tostring(flySpeed))
	local function onButtonActivated(button)
		if button == toggleButton then
			setupFly()
		elseif button == upButton and flying then
			if flyBodyVelocity then
				local camera = workspace.CurrentCamera
				if camera then
					local upVector = camera.CFrame.UpVector
					flyBodyVelocity.Velocity = flyBodyVelocity.Velocity + (upVector * flySpeed * 0.2)
				end
			end
		elseif button == downButton and flying then
			if flyBodyVelocity then
				local camera = workspace.CurrentCamera
				if camera then
					local upVector = camera.CFrame.UpVector
					flyBodyVelocity.Velocity = flyBodyVelocity.Velocity - (upVector * flySpeed * 0.2)
				end
			end
		elseif button == speedUpButton then
			flySpeed = math.min(flySpeed + 5, 100)
			statusUpdate()
		elseif button == speedDownButton then
			flySpeed = math.max(flySpeed - 5, 5)
			statusUpdate()
		end
	end
	for _, button in ipairs({upButton, downButton, speedUpButton, speedDownButton, toggleButton}) do
		button.MouseButton1Click:Connect(function()
			onButtonActivated(button)
		end)
	end
	screenGui.Parent = player:WaitForChild("PlayerGui")
	return screenGui
end
local function cleanup()
	if connection then
		connection:Disconnect()
		connection = nil
	end
	if flyBodyVelocity then
		flyBodyVelocity:Destroy()
		flyBodyVelocity = nil
	end
	flying = false
end
local function init()
	local success, err = pcall(function()
		local gui = createFlyUI()
		player.CharacterAdded:Connect(function(newCharacter)
			character = newCharacter
			humanoid = newCharacter:WaitForChild("Humanoid")
			rootPart = newCharacter:WaitForChild("HumanoidRootPart")
			if flying then
				setupFly()
			end
		end)
		userInputService = game:GetService("UserInputService")
		humanoid.Died:Connect(function()
			cleanup()
		end)
	end)
	if not success then
		warn("Fly script error: "..err)
	end
end
init()