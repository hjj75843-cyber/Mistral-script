-- Mistral Scripts client laser eyes script
local LocalPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Mistral_LaserEyes_GUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 6)
uiCorner.Parent = mainFrame
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
--tLighting:GetPropertyChangedSignal("TimeOfDay"):Connect(function()
titleLabel.Text = "Mistral Scripts"
titleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
titleLabel.TextStrokeTransparency = 0.5
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = mainFrame
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -28, 0, 3)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.TextStrokeTransparency = 0.5
closeButton.Parent = mainFrame
local dragger = Instance.new("Frame")
dragger.Name = "Dragger"
dragger.Size = UDim2.new(1, 0, 0, 28)
dragger.Position = UDim2.new(0, 0, 0, 0)
dragger.BackgroundTransparency = 1
dragger.Parent = mainFrame
local draggerText = Instance.new("TextLabel")
draggerText.Name = "DraggerText"
draggerText.Size = UDim2.new(1, 0, 1, 0)
draggerText.BackgroundTransparency = 1
draggerText.Text = "Mistral Scripts"
draggerText.TextColor3 = titleLabel.TextColor3
draggerText.Font = titleLabel.Font
draggerText.TextSize = titleLabel.TextSize
draggerText.TextStrokeTransparency = titleLabel.TextStrokeTransparency
draggerText.TextXAlignment = Enum.TextXAlignment.Center
draggerText.Parent = dragger
local uig = Instance.new("UIPadding")
uig.PaddingLeft = UDim.new(0, 8)
uig.PaddingRight = UDim.new(0, 8)
uig.Parent = mainFrame
local uig2 = Instance.new("UIListLayout")
uig2.Padding = UDim.new(0, 6)
uig2.Parent = mainFrame
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -16, 0, 20)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Laser Eyes: OFF | Spin: OFF | NoClip: OFF"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextStrokeTransparency = 0.3
statusLabel.Parent = mainFrame
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(1, -16, 0, 100)
buttonsFrame.Position = UDim2.new(0, 8, 0, 55)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame
local buttonsLayout = Instance.new("UIListLayout")
buttonsLayout.Padding = UDim.new(0, 8)
buttonsLayout.Parent = buttonsFrame
local laserButton = Instance.new("TextButton")
laserButton.Name = "LaserButton"
laserButton.Size = UDim2.new(1, 0, 0, 30)
laserButton.Text = "Toggle Laser Eyes"
laserButton.TextColor3 = Color3.new(1, 1, 1)
laserButton.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
laserButton.BorderSizePixel = 0
laserButton.Font = Enum.Font.GothamSemibold
laserButton.TextSize = 14
laserButton.TextStrokeTransparency = 0.2
laserButton.Parent = buttonsFrame
local spinButton = Instance.new("TextButton")
spinButton.Name = "SpinButton"
spinButton.Size = UDim2.new(1, 0, 0, 30)
spinButton.Text = "Toggle Spin"
spinButton.TextColor3 = Color3.new(1, 1, 1)
spinButton.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
spinButton.BorderSizePixel = 0
spinButton.Font = Enum.Font.GothamSemibold
spinButton.TextSize = 14
spinButton.TextStrokeTransparency = 0.2
spinButton.Parent = buttonsFrame
local noclipButton = Instance.new("TextButton")
noclipButton.Name = "NoClipButton"
noclipButton.Size = UDim2.new(1, 0, 0, 30)
noclipButton.Text = "Toggle NoClip"
noclipButton.TextColor3 = Color3.new(1, 1, 1)
noclipButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
noclipButton.BorderSizePixel = 0
noclipButton.Font = Enum.Font.GothamSemibold
noclipButton.TextSize = 14
noclipButton.TextStrokeTransparency = 0.2
noclipButton.Parent = buttonsFrame
local function updateStatus()
	statusLabel.Text = string.format("Laser Eyes: %s | Spin: %s | NoClip: %s",
		laserEnabled and "ON" or "OFF",
		spinEnabled and "ON" or "OFF",
		noclipEnabled and "ON" or "OFF")
end
local destroying = false
local function destroyGUI()
	if destroying then return end
	destroying = true
	pcall(function()
		mainFrame:Destroy()
	end)
	task.delay(0.3, function()
		pcall(function()
			screenGui:Destroy()
		end)
	end)
end
local function createBeam(character)
	local head = character:WaitForChild("Head")
	local rayOrigin = head.Position
	local beam = Instance.new("Part")
	beam.Name = "LaserBeam"
	beam.Size = Vector3.new(0.2, 0.2, 1000)
	beam.Anchored = true
	beam.CanCollide = false
	beam.CastShadow = false
	beam.Material = Enum.Material.Neon
	beam.Color = Color3.fromRGB(255, 0, 0)
	beam.Transparency = 0.2
	beam.Parent = workspace
	Debris:AddItem(beam, 0.1)
	local attachment0 = Instance.new("Attachment")
	attachment0.Parent = beam
	local beamLight = Instance.new("PointLight")
	beamLight.Parent = beam
	beamLight.Color = Color3.fromRGB(255, 0, 0)
	beamLight.Brightness = 2
	beamLight.Range = 15
	beamLight.Shadows = false
	local part0 = Instance.new("Part")
	part0.Size = Vector3.new(0.1, 0.1, 0.1)
	part0.Anchored = true
	part0.CanCollide = false
	part0.Transparency = 1
	part0.Parent = workspace
	Debris:AddItem(part0, 0.1)
	local attachment1 = Instance.new("Attachment")
	attachment1.Parent = part0
	local beamEffect = Instance.new("Beam")
	beamEffect.Name = "LaserEffect"
	beamEffect.Attachment0 = attachment0
	beamEffect.Attachment1 = attachment1
	beamEffect.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
	beamEffect.Width0 = 0.3
	beamEffect.Width1 = 0.1
	beamEffect.CurveSize0 = 0
	beamEffect.CurveSize1 = 0
	beamEffect.Texture = "rbxassetid://1185395909"
	beamEffect.TextureMode = Enum.TextureMode.Stretch
	beamEffect.TextureLength = beamEffect.Width0 * 1000
	beamEffect.Parent = beam
	local distance = 1000
	local direction = head.CFrame.LookVector
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {character}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.IgnoreWater = true
	raycastParams.CollisionGroup = "LaserCollision"
	local rayResult = workspace:Raycast(rayOrigin, direction * distance, raycastParams)
	if rayResult then
		local hitPos = rayResult.Position
		local hitNormal = rayResult.Normal
		local distance = (hitPos - rayOrigin).Magnitude
		beam.Size = Vector3.new(0.2, 0.2, distance)
		beam.CFrame = CFrame.new(rayOrigin, rayOrigin + direction) * CFrame.new(0, 0, -distance/2)
		beam.CFrame = beam.CFrame * CFrame.new(0, 0, -distance/2)
		if rayResult.Instance then
			local part = rayResult.Instance
			if part:IsA("BasePart") then
				local emitter = Instance.new("ParticleEmitter")
				emitter.Name = "ImpactParticles"
				emitter.LightEmission = 0.5
				emitter.Texture = "rbxassetid://243661898"
				emitter.Lifetime = NumberRange.new(0.3)
				emitter.Size = NumberRange.new(0.3, 0.1)
				emitter.SizeVariation = NumberRange.new(0.1)
				emitter.Speed = NumberRange.new(5)
				emitter.SpreadAngle = Vector2.new(180, 180)
				emitter.Rotation = NumberRange.new(0, 360)
				emitter.RotSpeed = NumberRange.new(-360, 360)
				emitter.Enabled = true
				emitter.Parent = part
				Debris:AddItem(emitter, 1)
			end
		end
	else
		beam.Size = Vector3.new(0.2, 0.2, distance)
		beam.CFrame = CFrame.new(rayOrigin, rayOrigin + direction) * CFrame.new(0, 0, -distance/2)
	end
	TweenService:Create(beamLight, TweenInfo.new(0.2), {
		Brightness = 0
	}):Play()
	return beam, beamLight
end
local laserEnabled = false
local spinEnabled = false
local noclipEnabled = false
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local activeBeams = {}
local function toggleLasers()
	laserEnabled = not laserEnabled
	updateStatus()
	if not laserEnabled then
		for _, beamData in pairs(activeBeams) do
			pcall(function()
				beamData.beam:Destroy()
				beamData.light:Destroy()
			end)
		end
		activeBeams = {}
	else
		local function beamLoop()
			if not laserEnabled then return end
			pcall(function()
				if character and character:FindFirstChild("Head") and humanoid and humanoid.Health > 0 then
					local beamData = createBeam(character)
					table.insert(activeBeams, {beam = beamData[1], light = beamData[2]})
				end
			end)
task.wait(0.2)
			if laserEnabled then
				beamLoop()
			end
		end
		beamLoop()
	end
end
local spinConnection = nil
local function rotateCharacter()
	spinEnabled = not spinEnabled
	updateStatus()
	if spinConnection then
		spinConnection:Disconnect()
		spinConnection = nil
		if humanoid then
			humanoid.AutoRotate = true
			rootPart.Anchored = false
		end
	else
		spinConnection = RunService.Heartbeat:Connect(function(dt)
			if not spinEnabled or not character or not rootPart or not humanoid or humanoid.Health <= 0 then
				return
			end
			local randomRot = Vector3.new(0, math.random(-180, 180) * dt * 100, 0)
			rootPart.CFrame = rootPart.CFrame * CFrame.Angles(math.rad(randomRot.Y), math.rad(randomRot.X), math.rad(randomRot.Z))
		end)
		humanoid.AutoRotate = false
	end
end
local noclipParts = {}
local function toggleNoClip()
	noclipEnabled = not noclipEnabled
	updateStatus()
	if noclipEnabled then
		local function setupNoClip()
			if not character then return end
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.CanCollide = false
					part:SetNetworkOwner(nil)
					table.insert(noclipParts, part)
				end
			end
			local checkConnection
			checkConnection = RunService.Heartbeat:Connect(function()
				if not noclipEnabled or not character or character ~= LocalPlayer.Character then
					if checkConnection then
						checkConnection:Disconnect()
					end
					return
				end
				for _, part in pairs(noclipParts) do
					if part and part.Parent then
						part.CanCollide = false
					end
				end
			end)
		end
		setupNoClip()
	else
		for _, part in pairs(noclipParts) do
			if part and part.Parent then
				pcall(function()
					part.CanCollide = true
					part:SetNetworkOwner(LocalPlayer)
				end)
			end
		end
		noclipParts = {}
	end
end
local function onCharacterAdded(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
	for _, beamData in pairs(activeBeams) do
		pcall(function()
			beamData.beam:Destroy()
			beamData.light:Destroy()
		end)
	end
	activeBeams = {}
	if noclipEnabled then
		toggleNoClip()
		toggleNoClip()
	end
	if spinEnabled then
		toggleNoClip()
		rotateCharacter()
	end
end
local function setupDragging()
	local dragging = false
	local dragStart = Vector2.new(0, 0)
	local frameStart = Vector2.new(0, 0)
	dragger.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = Vector2.new(UserInputService:GetMouseLocation())
			frameStart = Vector2.new(mainFrame.Position.X.Offset, mainFrame.Position.Y.Offset)
			local connection
			connection = UserInputService.InputEnded:Connect(function(input2)
				if input2.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
					if connection then
						connection:Disconnect()
					end
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = Vector2.new(UserInputService:GetMouseLocation())
			local delta = mousePos - dragStart
			mainFrame.Position = UDim2.new(0, frameStart.X + delta.X, 0, frameStart.Y + delta.Y)
		end
	end)
end
local function initialize()
	pcall(function()
		character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		humanoid = character:WaitForChild("Humanoid")
		rootPart = character:WaitForChild("HumanoidRootPart")
		LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
		setupDragging()
		laserButton.MouseButton1Click:Connect(toggleLasers)
		spinButton.MouseButton1Click:Connect(rotateCharacter)
		noclipButton.MouseButton1Click:Connect(toggleNoClip)
		closeButton.MouseButton1Click:Connect(destroyGUI)
		mainFrame.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.LeftShift then
				toggleLasers()
			elseif input.KeyCode == Enum.KeyCode.LeftAlt then
				rotateCharacter()
			elseif input.KeyCode == Enum.KeyCode.LeftControl then
				toggleNoClip()
			end
		end)
		updateStatus()
	end)
end
initialize()