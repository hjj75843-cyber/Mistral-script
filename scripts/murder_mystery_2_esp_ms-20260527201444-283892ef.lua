local MISTRAL_BUILD_ID = "MS-20260527201444-283892EF"
local MISTRAL_VARIATION_SEED = "2072D42DB2BD5808"
local MISTRAL_REQUEST_GAME = "Murder Mystery 2"
local MISTRAL_REQUEST_MODE = "ESP"
local MISTRAL_CHANNEL = "@MistralScripts"
-- Mistral Scripts --
-- Project: Global S2.1 gen 4 — Black Hole Core
-- Channel: @MistralScripts
-- Title: Murder Mystery 2 ESP Mistral
-- Build ID: MS-20260527201444-283892EF
-- Variation Seed: 0938A04DCD36C743C5F7ED1F

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Anti-duplicate build marker
local MARKER_NAME = "MistralESP_Active_MS-20260527201444-283892EF"
if Workspace:FindFirstChild(MARKER_NAME) then
    return -- Script is already running, prevent duplication
end
local buildMarker = Instance.new("BoolValue")
buildMarker.Name = MARKER_NAME
buildMarker.Parent = Workspace
buildMarker.Value = true

-- Configuration
local config = {
    accentColor = Color3.fromRGB(196, 113, 230), -- Provided accent [196, 113, 230]
    panelWidth = 316,
    panelHeight = 180, -- Adjusted for a compact phone-first GUI with just ESP
    guiBackgroundColor = Color3.fromRGB(30, 30, 30),
    guiBorderColor = Color3.fromRGB(196, 113, 230),
    buttonColorOff = Color3.fromRGB(196, 113, 230),
    buttonColorOn = Color3.fromRGB(0, 150, 0), -- Green for ON state
    buttonTextColor = Color3.new(1, 1, 1),
    espNameColor = Color3.fromRGB(196, 113, 230),
    espStudsOffset = Vector3.new(0, 2, 0), -- Offset name tag above head
    espBillboardSize = UDim2.new(3, 0, 1, 0), -- Size of the billboard on screen, relative to Camera.ViewportSize
    espEnabled = false
}

-- Storage for active ESP indicators (BillboardGui)
local activeEspTags = {}
local espUpdateConnection = nil

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MistralESP_ScreenGui_MS"
screenGui.DisplayOrder = 999 -- Ensure it's rendered on top
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = CoreGui -- Parent to CoreGui for persistent overlay (less likely to be removed by game)

local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, config.panelWidth, 0, config.panelHeight)
mainPanel.Position = UDim2.new(0.5, -config.panelWidth/2, 0.5, -config.panelHeight/2)
mainPanel.BackgroundColor3 = config.guiBackgroundColor
mainPanel.BorderColor3 = config.guiBorderColor
mainPanel.BorderSizePixel = 2
mainPanel.Draggable = true -- Enable drag for mobile use
mainPanel.Active = true -- Important for dragging on mobile
mainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
mainPanel.Parent = screenGui

local cornerRadius = Instance.new("UICorner")
cornerRadius.CornerRadius = UDim.new(0, 8)
cornerRadius.Parent = mainPanel

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundColor3 = config.guiBackgroundColor
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = config.accentColor
titleLabel.Font = Enum.Font.RobotoBold
titleLabel.TextSize = 22
titleLabel.Text = "Mistral Scripts - MM2 ESP"
titleLabel.TextWrapped = true
titleLabel.TextScaled = true
titleLabel.Parent = mainPanel

local channelLabel = Instance.new("TextLabel")
channelLabel.Name = "ChannelLabel"
channelLabel.Size = UDim2.new(1, 0, 0, 20)
channelLabel.Position = UDim2.new(0, 0, 0, 35)
channelLabel.BackgroundColor3 = config.guiBackgroundColor
channelLabel.BackgroundTransparency = 1
channelLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
channelLabel.Font = Enum.Font.SourceSans
channelLabel.TextSize = 16
channelLabel.Text = "@MistralScripts"
channelLabel.TextWrapped = true
channelLabel.Parent = mainPanel

local buildIdLabel = Instance.new("TextLabel")
buildIdLabel.Name = "BuildIdLabel"
buildIdLabel.Size = UDim2.new(1, 0, 0, 16)
buildIdLabel.Position = UDim2.new(0, 0, 0, 55)
buildIdLabel.BackgroundColor3 = config.guiBackgroundColor
buildIdLabel.BackgroundTransparency = 1
buildIdLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
buildIdLabel.Font = Enum.Font.SourceSansLight
buildIdLabel.TextSize = 12
buildIdLabel.Text = "Build: MS-20260527201444-283892EF"
buildIdLabel.TextWrapped = true
buildIdLabel.Parent = mainPanel

local espToggleButton = Instance.new("TextButton")
espToggleButton.Name = "EspToggleButton"
espToggleButton.Size = UDim2.new(1, -20, 0, 50)
espToggleButton.Position = UDim2.new(0, 10, 0, 90)
espToggleButton.BackgroundColor3 = config.buttonColorOff
espToggleButton.TextColor3 = config.buttonTextColor
espToggleButton.Font = Enum.Font.Roboto
espToggleButton.TextSize = 20
espToggleButton.Text = "Toggle ESP: OFF"
espToggleButton.TextScaled = true -- Make text scale for better mobile fit
espToggleButton.Parent = mainPanel

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = espToggleButton

-- Functions for ESP indicator management
local function createEspTag(player)
    if not player or player == LocalPlayer or not player.Character or activeEspTags[player.UserId] then return end

    local head = player.Character:FindFirstChild("Head")
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not head or not humanoidRootPart then return end

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "PlayerEspTag_" .. player.Name
    billboardGui.Adornee = head
    billboardGui.Size = config.espBillboardSize
    billboardGui.StudsOffset = config.espStudsOffset
    billboardGui.AlwaysOnTop = true
    billboardGui.ExtentsOffsetWorldSpace = Vector3.new(0, head.Size.Y / 2, 0) -- Adjust offset based on head size
    billboardGui.Parent = CoreGui -- Parent to CoreGui for optimal visibility

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "PlayerNameLabel"
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = config.espNameColor
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 18
    nameLabel.TextScaled = true
    nameLabel.TextWrapped = true
    
    local distance = 0
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).magnitude
    end
    nameLabel.Text = player.Name .. " (" .. math.floor(distance + 0.5) .. "m)"
    nameLabel.Parent = billboardGui

    activeEspTags[player.UserId] = billboardGui
end

local function destroyEspTag(player)
    if player and activeEspTags[player.UserId] then
        local billboard = activeEspTags[player.UserId]
        billboard:Destroy()
        activeEspTags[player.UserId] = nil
    end
end

local function updateEspTagsVisuals()
    if not config.espEnabled then return end

    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localHRP then return end -- Cannot calculate distance without local player's HRP

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local character = player.Character
        local head = character and character:FindFirstChild("Head")
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        if character and head and humanoidRootPart then
            if not activeEspTags[player.UserId] then
                pcall(createEspTag, player) -- Attempt to create if missing
            else
                local billboard = activeEspTags[player.UserId]
                if not billboard.Parent then
                    -- Re-parent if somehow detached
                    billboard.Parent = CoreGui
                    billboard.Adornee = head
                end
                local nameLabel = billboard:FindFirstChild("PlayerNameLabel")
                if nameLabel then
                    local distance = (localHRP.Position - humanoidRootPart.Position).magnitude
                    nameLabel.Text = player.Name .. " (" .. math.floor(distance + 0.5) .. "m)"
                    billboard.Visible = true
                else -- if nameLabel was somehow destroyed
                    pcall(destroyEspTag, player)
                    pcall(createEspTag, player)
                end
            end
        else
            pcall(destroyEspTag, player) -- Clean up if character is missing
        end
    end

    -- Clean up any lingering tags for players who might have left the game
    for userId, tag in pairs(activeEspTags) do
        if not Players:GetPlayerByUserId(userId) then
            pcall(destroyEspTag, Players:GetPlayerByUserId(userId))
        end
    end
end

local function enableEsp()
    if config.espEnabled then return end
    config.espEnabled = true
    espToggleButton.Text = "Toggle ESP: ON"
    espToggleButton.BackgroundColor3 = config.buttonColorOn
    
    for _, player in ipairs(Players:GetPlayers()) do
        pcall(createEspTag, player)
    end
    espUpdateConnection = RunService.RenderStepped:Connect(updateEspTagsVisuals)
end

local function disableEsp()
    if not config.espEnabled then return end
    config.espEnabled = false
    espToggleButton.Text = "Toggle ESP: OFF"
    espToggleButton.BackgroundColor3 = config.buttonColorOff

    if espUpdateConnection then
        espUpdateConnection:Disconnect()
        espUpdateConnection = nil
    end
    for userId, tag in pairs(activeEspTags) do
        pcall(destroyEspTag, Players:GetPlayerByUserId(userId))
    end
    table.clear(activeEspTags)
end

-- Event handlers for GUI and game events
espToggleButton.MouseButton1Click:Connect(function()
    if config.espEnabled then
        disableEsp()
    else
        enableEsp()
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if config.espEnabled then
            pcall(createEspTag, player)
        end
    end)
    -- If ESP is already enabled and player character exists, create tag immediately
    if config.espEnabled and player.Character then
        pcall(createEspTag, player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    pcall(destroyEspTag, player)
end)

-- Initial connection for players already in the game when the script runs
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            if config.espEnabled then
                pcall(createEspTag, player)
            end
        end)
        -- If ESP is already enabled and player character already exists, create tag immediately
        if config.espEnabled and player.Character then
            pcall(createEspTag, player)
        end
    end
end

-- Clean up resources when the script is disabled or destroyed
-- This ensures all GUI elements and connections are removed.
script.AncestryChanged:Connect(function()
    -- Check if script is no longer parented to a valid location (e.g., deleted from PlayerGui)
    if not script:IsDescendantOf(Players.LocalPlayer.PlayerGui) and not script:IsDescendantOf(CoreGui) and not script:IsDescendantOf(Workspace) then
        disableEsp()
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
        if buildMarker and buildMarker.Parent then
            buildMarker:Destroy()
        end
    end
end)

-- Make sure to handle local player character changes to ensure distance calculations work
LocalPlayer.CharacterAdded:Connect(function(character)
    -- No direct action needed, as 'updateEspTagsVisuals' checks for local player's HRP presence.
end)
