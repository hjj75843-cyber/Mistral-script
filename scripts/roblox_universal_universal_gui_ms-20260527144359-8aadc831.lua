local MISTRAL_BUILD_ID = "MS-20260527144359-8AADC831"
local MISTRAL_VARIATION_SEED = "A49EE63700C4A9F2"
local MISTRAL_REQUEST_MODE = "Universal GUI"
local plrsService = game:GetService("Players")
local userInputController = game:GetService("UserInputService")
local scheduler = game:GetService("RunService")

local targetedLocalPlayer = plrsService.LocalPlayer
local charModel = targetedLocalPlayer.Character or targetedLocalPlayer.CharacterAdded:Wait()
local mainRootPart = charModel:WaitForChild("HumanoidRootPart")

local rotationActive = false
local ongoingConnection = nil

local rotationGUI = Instance.new("ScreenGui")
rotationGUI.Name = "Mistral Scripts"
rotationGUI.DisplayOrder = 10
rotationGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local containerFrame = Instance.new("Frame")
containerFrame.Name = "OperationPanel"
containerFrame.AnchorPoint = Vector2.new(0.5, 0)
containerFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
containerFrame.Size = UDim2.new(0, 250, 0, 150)
containerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
containerFrame.BorderSizePixel = 0
containerFrame.Draggable = true
containerFrame.Parent = rotationGUI

local headerText = Instance.new("TextLabel")
headerText.Name = "TitleDisplay"
headerText.Text = "Mistral Scripts"
headerText.Font = Enum.Font.Roboto
headerText.TextColor3 = Color3.fromRGB(200, 200, 255)
headerText.TextSize = 24
headerText.TextScaled = false
headerText.Size = UDim2.new(1, 0, 0.25, 0)
headerText.Position = UDim2.new(0, 0, 0, 0)
headerText.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
headerText.BorderSizePixel = 0
headerText.TextXAlignment = Enum.TextXAlignment.Center
headerText.TextYAlignment = Enum.TextYAlignment.Center
headerText.Parent = containerFrame

local toggleRotationButton = Instance.new("TextButton")
toggleRotationButton.Name = "SpinActivator"
toggleRotationButton.Text = "Commence Spin"
toggleRotationButton.Font = Enum.Font.SourceSansBold
toggleRotationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleRotationButton.TextSize = 18
toggleRotationButton.Size = UDim2.new(0.8, 0, 0.3, 0)
toggleRotationButton.Position = UDim2.new(0.1, 0, 0.3, 0)
toggleRotationButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
toggleRotationButton.BorderSizePixel = 0
toggleRotationButton.AutoButtonColor = true
toggleRotationButton.Parent = containerFrame

local signatureLabel = Instance.new("TextLabel")
signatureLabel.Name = "FooterSign"
signatureLabel.Text = "@MistralScripts"
signatureLabel.Font = Enum.Font.SourceSansItalic
signatureLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
signatureLabel.TextSize = 12
signatureLabel.Size = UDim2.new(1, 0, 0.2, 0)
signatureLabel.Position = UDim2.new(0, 0, 0.6, 0)
signatureLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
signatureLabel.BorderSizePixel = 0
signatureLabel.TextXAlignment = Enum.TextXAlignment.Right
signatureLabel.TextYAlignment = Enum.TextYAlignment.Bottom
signatureLabel.TextWrapped = true
signatureLabel.Parent = containerFrame

local buildInfoLabel = Instance.new("TextLabel")
buildInfoLabel.Name = "BuildData"
buildInfoLabel.Text = "BuildId: MS-20260527144359-8AADC831\nSeed: 3393807a90f06f72"
buildInfoLabel.Font = Enum.Font.SourceSans
buildInfoLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
buildInfoLabel.TextSize = 10
buildInfoLabel.Size = UDim2.new(1, 0, 0.2, 0)
buildInfoLabel.Position = UDim2.new(0, 0, 0.8, 0)
buildInfoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
buildInfoLabel.BorderSizePixel = 0
buildInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
buildInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
buildInfoLabel.TextWrapped = true
buildInfoLabel.Parent = containerFrame

local function executeSpinTick()
    if rotationActive and mainRootPart and charModel.Parent then
        local currentCFrame = mainRootPart.CFrame
        local rotationAngle = CFrame.Angles(0, math.rad(12), 0) -- 12 degrees per frame for smooth continuous spin
        mainRootPart.CFrame = currentCFrame * rotationAngle
    end
end

local function beginContinuousSpin()
    if not rotationActive then
        rotationActive = true
        toggleRotationButton.Text = "Halt Spin"
        toggleRotationButton.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
        ongoingConnection = scheduler.RenderStepped:Connect(executeSpinTick)
    end
end

local function endContinuousSpin()
    if rotationActive then
        rotationActive = false
        toggleRotationButton.Text = "Commence Spin"
        toggleRotationButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        if ongoingConnection then
            ongoingConnection:Disconnect()
            ongoingConnection = nil
        end
    end
end

toggleRotationButton.MouseButton1Click:Connect(function()
    if rotationActive then
        endContinuousSpin()
    else
        beginContinuousSpin()
    end
end)

rotationGUI.Parent = targetedLocalPlayer:WaitForChild("PlayerGui")