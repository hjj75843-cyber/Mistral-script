local MISTRAL_BUILD_ID = "MS-20260527204350-D5054A30"
local MISTRAL_VARIATION_SEED = "2006AABED20EF09E"
local MISTRAL_REQUEST_GAME = "Roblox/Universal"
local MISTRAL_REQUEST_MODE = "ESP"
local MISTRAL_CHANNEL = "@MistralScripts"
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

-- LocalState: Централизованное хранилище всех настроек ESP
local LocalState = {
    isEnabled = false,
    showBoxes = true,
    showNames = true,
    showDistance = true,
    range = 55, -- Default from user profile
    playerVisuals = {} -- Table to store references to ESP BillboardGuis per player
}

-- Utility & GUI Constants
local ACCENT_COLOR = Color3.fromRGB(142, 60, 209)
local PANEL_WIDTH = 354
local PANEL_HEIGHT = 366
local NEON_EFFECT_COLOR = Color3.fromRGB(180, 100, 255)
local BUTTON_HEIGHT = 45
local PADDING = 10

-- Services
local GUIService = {}
local CharacterTrackerService = {}
local ESPRenderService = {}

------------------------------------------------------------------------------------------------------------------------
-- GUIService: Управление пользовательским интерфейсом
------------------------------------------------------------------------------------------------------------------------
function GUIService.createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MistralESP_ScreenGui"
    screenGui.DisplayOrder = 10 -- Ensure it's on top
    screenGui.Parent = StarterGui

    -- Main Panel: Floating Neon Card Stack
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "ESPMistralPanel"
    mainFrame.Size = UDim2.new(0, PANEL_WIDTH, 0, PANEL_HEIGHT)
    mainFrame.Position = UDim2.new(0.5, -PANEL_WIDTH / 2, 0.5, -PANEL_HEIGHT / 2) -- Center initially
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 15)
    uiCorner.Parent = mainFrame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = NEON_EFFECT_COLOR
    uiStroke.Thickness = 2
    uiStroke.Transparency = 0.5
    uiStroke.Parent = mainFrame

    -- Top Bar for Dragging and Branding
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = ACCENT_COLOR
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -2 * PADDING, 1, 0)
    titleLabel.Position = UDim2.new(0, PADDING, 0, 0)
    titleLabel.BackgroundColor3 = new Color3(1,1,1,0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Text = "Universal ESP Mistral"
    titleLabel.Parent = topBar

    -- Branding and Build Info
    local brandingLabel = Instance.new("TextLabel")
    brandingLabel.Name = "BrandingInfo"
    brandingLabel.Size = UDim2.new(1, -2*PADDING, 0, 40)
    brandingLabel.Position = UDim2.new(0, PADDING, 1, -40)
    brandingLabel.AnchorPoint = Vector2.new(0, 1)
    brandingLabel.BackgroundColor3 = new Color3(1,1,1,0)
    brandingLabel.BackgroundTransparency = 1
    brandingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    brandingLabel.Font = Enum.Font.SourceSansLight
    brandingLabel.TextSize = 14
    brandingLabel.TextXAlignment = Enum.TextXAlignment.Center
    brandingLabel.TextYAlignment = Enum.TextYAlignment.Top
    brandingLabel.RichText = true
    brandingLabel.Text = "Mistral Scripts\n<font color='#8EA6DA'>@MistralScripts</font>\n<font size='10'>BuildID: MS-20260527204350-D5054A30</font>"
    brandingLabel.Parent = mainFrame

    -- Content Frame for buttons
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -2 * PADDING, 1, -40 - 40 - 2 * PADDING)
    contentFrame.Position = UDim2.new(0, PADDING, 0, 40 + PADDING)
    contentFrame.BackgroundColor3 = new Color3(1,1,1,0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.FillDirection = Enum.FillDirection.Vertical
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.Padding = UDim.new(0, 8)
    uiListLayout.Parent = contentFrame

    -- Dragging Logic
    local dragging
    local dragInput
    local startPosition

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            startPosition = mainFrame.Position
        end
    end)

    topBar.InputEnded:Connect(function(input)
        if input == dragInput then
            dragging = false
            dragInput = nil
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - UserInputService:GetMouseLocation()
            mainFrame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)

    -- Function to create a stylish toggle button
    local function createToggleButton(text, defaultState, callback)
        local button = Instance.new("TextButton")
        button.Name = text:gsub(" ", "") .. "Toggle"
        button.Size = UDim2.new(1, 0, 0, BUTTON_HEIGHT)
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.SourceSansSemibold
        button.TextSize = 18
        button.Text = text
        button.Parent = contentFrame

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 8)
        uiCorner.Parent = button

        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = ACCENT_COLOR
        uiStroke.Thickness = 0 -- Initially transparent
        uiStroke.Parent = button

        local currentState = defaultState

        local function updateButtonAppearance()
            if currentState then
                button.BackgroundColor3 = ACCENT_COLOR
                uiStroke.Thickness = 2
                uiStroke.Transparency = 0.5
            else
                button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                uiStroke.Thickness = 0
            end
        end

        updateButtonAppearance()

        button.Activated:Connect(function()
            currentState = not currentState
            updateButtonAppearance()
            callback(currentState)
        end)
        return button
    end

    -- ESP Master Toggle
    createToggleButton("Toggle ESP", LocalState.isEnabled, function(state)
        LocalState.isEnabled = state
        for _, visuals in pairs(LocalState.playerVisuals) do
            if visuals.BillboardGui then
                visuals.BillboardGui.Enabled = state
            end
        end
    end)

    -- Individual ESP feature toggles
    createToggleButton("Show Player Boxes", LocalState.showBoxes, function(state)
        LocalState.showBoxes = state
    end)
    createToggleButton("Show Player Names", LocalState.showNames, function(state)
        LocalState.showNames = state
    end)
    createToggleButton("Show Distance", LocalState.showDistance, function(state)
        LocalState.showDistance = state
    end)

    -- Range Slider (custom implementation for mobile touch)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "RangeSlider"
    sliderFrame.Size = UDim2.new(1, 0, 0, BUTTON_HEIGHT + 10)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = contentFrame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame

    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.Position = UDim2.new(0, 0, 0, 5)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.TextColor3 = Color3.new(1, 1, 1)
    sliderLabel.Font = Enum.Font.SourceSansSemibold
    sliderLabel.TextSize = 16
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Text = "Range: " .. LocalState.range .. " studs"
    sliderLabel.Parent = sliderFrame

    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, -20, 0, 8)
    track.Position = UDim2.new(0, 10, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    track.BorderSizePixel = 0
    track.Parent = sliderFrame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 4)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = ACCENT_COLOR
    fill.BorderSizePixel = 0
    fill.Parent = track

    local thumb = Instance.new("Frame")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.BackgroundColor3 = NEON_EFFECT_COLOR
    thumb.BorderSizePixel = 0
    thumb.Parent = track

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 10)
    thumbCorner.Parent = thumb

    local minRange = 10
    local maxRange = 250
    local function updateSlider(value)
        LocalState.range = math.max(minRange, math.min(maxRange, math.round(value)))
        local normalizedValue = (LocalState.range - minRange) / (maxRange - minRange)
        fill.Size = UDim2.new(normalizedValue, 0, 1, 0)
        thumb.Position = UDim2.new(normalizedValue, -thumb.Size.X.Offset / 2, 0.5, -thumb.Size.Y.Offset / 2)
        sliderLabel.Text = "Range: " .. LocalState.range .. " studs"
    end

    local isSliding = false

    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isSliding then
            local mousePos = input.Position
            local trackAbsolutePos = track.AbsolutePosition
            local trackAbsoluteSize = track.AbsoluteSize

            local relativeX = (mousePos.X - trackAbsolutePos.X) / trackAbsoluteSize.X
            relativeX = math.max(0, math.min(1, relativeX))
            updateSlider(minRange + relativeX * (maxRange - minRange))
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isSliding then
            isSliding = false
        end
    end)
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local mousePos = input.Position
            local trackAbsolutePos = track.AbsolutePosition
            local trackAbsoluteSize = track.AbsoluteSize

            local relativeX = (mousePos.X - trackAbsolutePos.X) / trackAbsoluteSize.X
            relativeX = math.max(0, math.min(1, relativeX))
            updateSlider(minRange + relativeX * (maxRange - minRange))
            isSliding = true -- Allow direct tap on track to also start sliding
        end
    end)

    updateSlider(LocalState.range) -- Initial slider position

    return screenGui
end

------------------------------------------------------------------------------------------------------------------------
-- CharacterTrackerService: Отслеживание игроков и их персонажей
------------------------------------------------------------------------------------------------------------------------
function CharacterTrackerService.createPlayerVisuals(player)
    if player == LocalPlayer or not player.Character then return end
    if LocalState.playerVisuals[player.UserId] then return end -- Already tracked

    local character = player.Character
    local humanRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanRootPart then return end

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = player.Name .. "ESP"
    billboardGui.Size = UDim2.new(0, 120, 0, 120) -- Example size, dynamic based on content
    billboardGui.AlwaysOnTop = true
    billboardGui.ExtentsOffset = Vector3.new(0, 2, 0) -- Slightly above character
    billboardGui.StudsOffset = Vector3.new(0, 4.5, 0) -- Keep it above head
    billboardGui.ClipsDescendants = false
    billboardGui.Enabled = LocalState.isEnabled -- Initial state

    local boxFrame = Instance.new("Frame")
    boxFrame.Name = "ESPBox"
    boxFrame.Size = UDim2.new(1, 0, 1, 0)
    boxFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    boxFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    boxFrame.BackgroundColor3 = new Color3(1,1,1,0)
    boxFrame.BackgroundTransparency = 1
    boxFrame.BorderSizePixel = 2
    boxFrame.BorderColor3 = ACCENT_COLOR
    boxFrame.Visible = LocalState.showBoxes
    boxFrame.Parent = billboardGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "ESPName"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, -20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = false
    nameLabel.TextSize = 16
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = player.Name
    nameLabel.Visible = LocalState.showNames
    nameLabel.Parent = billboardGui

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "ESPDistance"
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.Position = UDim2.new(0, 0, 0, 110)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
    distanceLabel.TextScaled = false
    distanceLabel.TextSize = 14
    distanceLabel.TextXAlignment = Enum.TextXAlignment.Center
    distanceLabel.Font = Enum.Font.SourceSansLight
    distanceLabel.Text = "0m"
    distanceLabel.Visible = LocalState.showDistance
    distanceLabel.Parent = billboardGui

    billboardGui.Parent = humanRootPart -- Attach to HRP or Head for follow behavior

    LocalState.playerVisuals[player.UserId] = {
        BillboardGui = billboardGui,
        Box = boxFrame,
        Name = nameLabel,
        Distance = distanceLabel,
        Player = player,
        Character = character -- Keep character ref for later updates
    }
end

function CharacterTrackerService.removePlayerVisuals(player)
    local visuals = LocalState.playerVisuals[player.UserId]
    if visuals then
        visuals.BillboardGui:Destroy()
        LocalState.playerVisuals[player.UserId] = nil
    end
end

function CharacterTrackerService.initiateTracking()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CharacterTrackerService.createPlayerVisuals(player)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            -- Allow a short delay for character to fully load
            task.delay(0.1, function()
                CharacterTrackerService.createPlayerVisuals(player)
            end)
        end)
        player.CharacterRemoving:Connect(function(character)
            CharacterTrackerService.removePlayerVisuals(player)
        end)

        if player.Character then
            CharacterTrackerService.createPlayerVisuals(player)
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        CharacterTrackerService.removePlayerVisuals(player)
    end)
end

------------------------------------------------------------------------------------------------------------------------
-- ESPRenderService: Обновление визуальных эффектов ESP на каждый кадр
------------------------------------------------------------------------------------------------------------------------
function ESPRenderService.renderLoop()
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localHRP then return end

    for userId, visuals in pairs(LocalState.playerVisuals) do
        local targetPlayer = visuals.Player
        local targetCharacter = targetPlayer.Character
        local billboardGui = visuals.BillboardGui
        local box = visuals.Box
        local name = visuals.Name
        local distLabel = visuals.Distance

        local updateRequired = true

        if not targetCharacter or not targetCharacter.Parent or targetPlayer.MembershipType == Enum.MembershipType.GroupMember -- Example of how you might filter, removed for universal scope.
           then
            -- Character no longer exists or should not be tracked, remove visuals
            CharacterTrackerService.removePlayerVisuals(targetPlayer)
            updateRequired = false
        end
        
        if not updateRequired then continue end

        local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetHRP then 
            -- If HRP is gone, but character still exists, visuals might get re-attached on character refresh. For now, try to disable.
            if billboardGui.Parent then
                billboardGui.Enabled = false
            end
            continue 
        end

        billboardGui.Adornee = targetHRP

        -- Calculate distance
        local distance = (localHRP.Position - targetHRP.Position).Magnitude
        local withinRange = distance <= LocalState.range

        -- Enable/Disable billboard GUI based on master toggle and range
        billboardGui.Enabled = LocalState.isEnabled and withinRange

        if billboardGui.Enabled then
            box.Visible = LocalState.showBoxes
            name.Visible = LocalState.showNames
            distLabel.Visible = LocalState.showDistance

            if distLabel.Visible then
                distLabel.Text = math.floor(distance) .. "m"
            end
        else
            -- Ensure sub-elements are hidden if parent is disabled/not enabled
            box.Visible = false
            name.Visible = false
            distLabel.Visible = false
        end
    end
end

------------------------------------------------------------------------------------------------------------------------
-- Main Initialization
------------------------------------------------------------------------------------------------------------------------
local function init()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false) -- Optional: Hide player list for clean UI
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

    -- Create GUI
    local gui = GUIService.createGUI()
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Initiate character tracking
    CharacterTrackerService.initiateTracking()

    -- Start rendering loop on RenderStepped
    RunService.RenderStepped:Connect(ESPRenderService.renderLoop)

    print("Mistral ESP Script Initialized: " .. os.date("%Y-%m-%d %H:%M:%S"))
end


-- Wait for character to be ready before initializing
if LocalPlayer.Character then
    init()
else
    LocalPlayer.CharacterAdded:Once(init)
end
