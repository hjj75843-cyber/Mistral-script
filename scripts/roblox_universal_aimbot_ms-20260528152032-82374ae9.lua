local MISTRAL_BUILD_ID = "MS-20260528152032-82374AE9"
local MISTRAL_VARIATION_SEED = "CB01E291656A58DF"
local MISTRAL_REQUEST_GAME = "Roblox/Universal"
local MISTRAL_REQUEST_MODE = "AimBot"
local MISTRAL_CHANNEL = "@MistralScripts"
local Players = game:GetService("Players")local Workspace = game:GetService("Workspace")local RunService = game:GetService("RunService")local UserInputService = game:GetService("UserInputService")local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()local Camera = Workspace.CurrentCamera
local Config = {    Enabled = false,    FOVRadius = 150,    Smoothness = 0.2,    AccentColor = Color3.fromRGB(173, 50, 226),    BackgroundColor = Color3.fromRGB(30, 30, 30),    TextColor = Color3.fromRGB(255, 255, 255),    ButtonColor = Color3.fromRGB(60, 60, 60)}

-- Services and utility
local PlayerService = {}
function PlayerService:GetEnemies()
    local enemies = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            table.insert(enemies, player)
        end
    end
    return enemies
end

function PlayerService:GetNearestEnemy()
    local closestEnemy = nil
    local shortestDistance = math.huge
    local localChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")

    if not localRoot then return nil end

    for _, enemyPlayer in ipairs(PlayerService:GetEnemies()) do
        local enemyChar = enemyPlayer.Character
        local enemyRoot = enemyChar and enemyChar:FindFirstChild("HumanoidRootPart")
        if enemyRoot then
            local distance = (localRoot.Position - enemyRoot.Position).Magnitude
            if distance < shortestDistance then
                local screenPoint, onScreen = Camera:WorldToScreenPoint(enemyRoot.Position)
                local viewportSize = Camera.ViewportSize
                local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
                local distanceToCenter = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
                if onScreen and distanceToCenter <= Config.FOVRadius then
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, enemyChar}
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                    local raycastResult = Workspace:Raycast(Camera.CFrame.Position, (enemyRoot.Position - Camera.CFrame.Position).Unit * 500, raycastParams)

                    if raycastResult and raycastResult.Instance and raycastResult.Instance:IsDescendantOf(enemyChar) then
                        shortestDistance = distance
                        closestEnemy = enemyPlayer
                    end
                end
            end
        end
    end
    return closestEnemy
end

-- GUI Module
local GuiService = {}
function GuiService:CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MistralScriptsAimBotGui"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 200, 0, 150)
    MainFrame.Position = UDim2.new(0.5, -100, 0.2, -75)
    MainFrame.BackgroundColor3 = Config.BackgroundColor
    MainFrame.BorderColor3 = Config.AccentColor
    MainFrame.BorderSizePixel = 2
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "FrameHeader"
    TitleBar.Size = UDim2.new(1, 0, 0, 24)
    TitleBar.BackgroundColor3 = Config.AccentColor
    TitleBar.Parent = MainFrame
    TitleBar.Draggable = true

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -24, 1, 0)
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.BackgroundColor3 = Config.AccentColor
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Config.TextColor
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextSize = 18
    TitleLabel.Text = "AimBot | MistralScripts"
    TitleLabel.TextWrapped = true
    TitleLabel.Parent = TitleBar

    local CollapseButton = Instance.new("TextButton")
    CollapseButton.Name = "CollapseButton"
    CollapseButton.Size = UDim2.new(0, 24, 1, 0)
    CollapseButton.Position = UDim2.new(1, -24, 0, 0)
    CollapseButton.BackgroundColor3 = Config.BackgroundColor
    CollapseButton.BackgroundTransparency = 0
    CollapseButton.TextColor3 = Config.TextColor
    CollapseButton.Font = Enum.Font.FredokaOne
    CollapseButton.TextSize = 18
    CollapseButton.Text = "-"
    CollapseButton.Parent = TitleBar
    CollapseButton.MouseButton1Click:Connect(function()
        local isCollapsed = MainFrame.Size.Y.Offset < 50
        if isCollapsed then
            MainFrame:TweenSize(UDim2.new(0, 200, 0, 150), "Out", "Quad", 0.2)
            CollapseButton.Text = "-"
        else
            MainFrame:TweenSize(UDim2.new(0, 200, 0, 24), "Out", "Quad", 0.2)
            CollapseButton.Text = "+"
        end
    end)

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -10, 1, -34)
    ContentFrame.Position = UDim2.new(0, 5, 0, 29)
    ContentFrame.BackgroundColor3 = Config.BackgroundColor
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = ContentFrame

    -- Toggle Button
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "AimBotToggle"
    ToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
    ToggleButton.BackgroundColor3 = Config.ButtonColor
    ToggleButton.TextColor3 = Config.TextColor
    ToggleButton.Font = Enum.Font.FredokaOne
    ToggleButton.TextSize = 18
    ToggleButton.Text = "AimBot: OFF"
    ToggleButton.TextWrapped = true
    ToggleButton.Parent = ContentFrame
    ToggleButton.MouseButton1Click:Connect(function()
        Config.Enabled = not Config.Enabled
        ToggleButton.Text = "AimBot: " .. (Config.Enabled and "ON" or "OFF")
        ToggleButton.BackgroundColor3 = Config.Enabled and Config.AccentColor or Config.ButtonColor
    end)

    -- FOV Slider (mobile friendly)
    local FOVLabel = Instance.new("TextLabel")
    FOVLabel.Size = UDim2.new(0.9, 0, 0, 20)
    FOVLabel.BackgroundColor3 = Config.BackgroundColor
    FOVLabel.BackgroundTransparency = 1
    FOVLabel.TextColor3 = Config.TextColor
    FOVLabel.Font = Enum.Font.FredokaOne
    FOVLabel.TextSize = 16
    FOVLabel.Text = "FOV: " .. Config.FOVRadius
    FOVLabel.Parent = ContentFrame

    local FOVSlider = Instance.new("Frame")
    FOVSlider.Size = UDim2.new(0.9, 0, 0, 15)
    FOVSlider.BackgroundColor3 = Config.ButtonColor
    FOVSlider.Parent = ContentFrame
    
    local UICornerSlider = Instance.new("UICorner")
    UICornerSlider.CornerRadius = UDim.new(0, 4)
    UICornerSlider.Parent = FOVSlider

    local FOVIndicator = Instance.new("Frame")
    FOVIndicator.Size = UDim2.new(Config.FOVRadius / 500, 0, 1, 0)
    FOVIndicator.BackgroundColor3 = Config.AccentColor
    FOVIndicator.Parent = FOVSlider

    local draggingFOV = false
    FOVSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingFOV = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingFOV = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingFOV and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativeX = (input.Position.X - FOVSlider.AbsolutePosition.X) / FOVSlider.AbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            local newFOV = math.floor(relativeX * (500 - 50) + 50) -- From 50 to 500
            Config.FOVRadius = newFOV
            FOVIndicator.Size = UDim2.new(Config.FOVRadius / 500, 0, 1, 0)
            FOVLabel.Text = "FOV: " .. Config.FOVRadius
        end
    end)
    
    -- Footer text
    local FooterLabel = Instance.new("TextLabel")
    FooterLabel.Size = UDim2.new(1, 0, 0, 16)
    FooterLabel.Position = UDim2.new(0,0,1,-16) -- Place at bottom
    FooterLabel.BackgroundColor3 = Config.BackgroundColor
    FooterLabel.BackgroundTransparency = 1
    FooterLabel.TextColor3 = Config.TextColor
    FooterLabel.Font = Enum.Font.SourceSansLight
    FooterLabel.TextSize = 11
    FooterLabel.Text = "@MistralScripts | Build ID: MS-20260528152032-82374AE9"
    FooterLabel.TextWrapped = true
    FooterLabel.Parent = MainFrame

    return {MainFrame = MainFrame, ToggleButton = ToggleButton, FOVIndicator = FOVIndicator}
end

-- Visuals
local function DrawFOV()
    local FOVCircle = Instance.new("Part")
    FOVCircle.Name = "FOVCircle"
    FOVCircle.Transparency = 0.8
    FOVCircle.CanCollide = false
    FOVCircle.Size = Vector3.new(0.1, Config.FOVRadius * 2, Config.FOVRadius * 2)
    FOVCircle.Shape = Enum.PartType.Cylinder
    FOVCircle.BrickColor = BrickColor.new(Config.AccentColor)
    FOVCircle.Parent = Workspace
    FOVCircle.Anchored = true
    FOVCircle.CFrame = Camera.CFrame * CFrame.new(0, 0, -50) * CFrame.Angles(0, math.rad(90), 0)

    return FOVCircle
end

local currentFOVCircle = nil
local function UpdateFOVCircleVisibility(isVisible)
    if isVisible and not currentFOVCircle then
        currentFOVCircle = DrawFOV()
    elseif not isVisible and currentFOVCircle then
        currentFOVCircle:Destroy()
        currentFOVCircle = nil
    end
end

-- Main AimBot Logic
local connections = {}
local function EnableAimBot()
    print("AimBot Enabled")
    UpdateFOVCircleVisibility(true)
    connections.RenderStep = RunService.RenderStepped:Connect(function()
        local targetChar = PlayerService:GetNearestEnemy()
        if targetChar then
            local targetRoot = targetChar.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                -- Smoothly aim camera
                local targetPos = targetRoot.Position + Vector3.new(0, targetChar.Character.Humanoid.Head.Size.Y / 2, 0) -- Aim at head level
                local currentCFrame = Camera.CFrame
                local desiredCFrame = CFrame.new(currentCFrame.Position, targetPos)
                Camera.CFrame = currentCFrame:Lerp(desiredCFrame, Config.Smoothness)
            end
        end
        if currentFOVCircle then
            currentFOVCircle.CFrame = Camera.CFrame * CFrame.new(0, 0, -20) * CFrame.Angles(0, math.rad(90), 0)
            currentFOVCircle.Size = Vector3.new(0.1, Config.FOVRadius * 2, Config.FOVRadius * 2)
        end
    end)
end

local function DisableAimBot()
    print("AimBot Disabled")
    UpdateFOVCircleVisibility(false)
    if connections.RenderStep then
        connections.RenderStep:Disconnect()
        connections.RenderStep = nil
    end
end

-- State Change Handler
local function OnConfigChanged(property)
    if property == "Enabled" then
        if Config.Enabled then
            pcall(EnableAimBot)
        else
            pcall(DisableAimBot)
        end
    end
end

-- Initialize
local guiComponents = GuiService:CreateUI()

-- Apply initial GUI state based on config
if Config.Enabled then
    guiComponents.ToggleButton.Text = "AimBot: ON"
    guiComponents.ToggleButton.BackgroundColor3 = Config.AccentColor
    pcall(EnableAimBot)
else
    guiComponents.ToggleButton.Text = "AimBot: OFF"
    guiComponents.ToggleButton.BackgroundColor3 = Config.ButtonColor
end

-- Watch for toggle changes from GUI
guiComponents.ToggleButton.MouseButton1Click:Connect(function() OnConfigChanged("Enabled") end)

-- General cleanup on script removal
LocalPlayer.PlayerGui.ChildRemoved:Connect(function(child)
    if child == guiComponents.MainFrame then
        pcall(DisableAimBot)
        if currentFOVCircle then currentFOVCircle:Destroy() end
    end
end)

-- Optionally, if we ever want to explicitly set a property and trigger update logic:
function Config:Set(prop, value)
    self[prop] = value
    OnConfigChanged(prop)
end
