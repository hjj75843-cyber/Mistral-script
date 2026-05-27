local MISTRAL_BUILD_ID = "MS-20260527213543-F81ACB66"
local MISTRAL_VARIATION_SEED = "69F7E322AFC1B59C"
local MISTRAL_REQUEST_GAME = "Roblox/Universal"
local MISTRAL_REQUEST_MODE = "GUI Hub"
local MISTRAL_CHANNEL = "@MistralScripts"
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- Script Configuration
local ACCENT_COLOR_R = 193
local ACCENT_COLOR_G = 110
local ACCENT_COLOR_B = 222
local ACCENT_COLOR = Color3.fromRGB(ACCENT_COLOR_R, ACCENT_COLOR_G, ACCENT_COLOR_B)

local PANEL_WIDTH = 327
local PANEL_HEIGHT = 400
local BUILD_ID = "MS-20260527213543-F81ACB66"
local BRAND_NAME = "Mistral Scripts"
local CHANNEL_NAME = "@MistralScripts"
local SCRIPT_TITLE = "Universal GUI Hub Mistral"

-- Internal State
local MistralState = {
    IsHubVisible = false,
    DragStart = nil,
    StartPos = nil,
    Connections = {}, -- Store connections for persistent GUI elements
    TempConnections = {}, -- Store temporary connections for drag functionality
}

-- Utility Functions
local function clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MistralScriptsHub"
ScreenGui.ResetOnSpawn = false -- Crucial for persistent GUI

local MainPanel = Instance.new("Frame")
MainPanel.Name = "MistralMainPanel"
MainPanel.Size = UDim2.new(0, PANEL_WIDTH, 0, PANEL_HEIGHT)
MainPanel.Position = UDim2.new(0.5, -PANEL_WIDTH/2, 0.5, -PANEL_HEIGHT/2)
MainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
MainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark background
MainPanel.BorderColor3 = ACCENT_COLOR
MainPanel.BorderSizePixel = 2
MainPanel.Active = true -- For input detection
MainPanel.Draggable = false -- Manual drag for mobile compatibility
MainPanel.ZIndex = 10
MainPanel.Visible = false
MainPanel.Parent = ScreenGui

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Name = "HeaderFrame"
HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
HeaderFrame.Position = UDim2.new(0,0,0,0)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
HeaderFrame.BorderColor3 = ACCENT_COLOR
HeaderFrame.BorderSizePixel = 1
HeaderFrame.Parent = MainPanel

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.95, 0, 0.4, 0)
TitleLabel.Position = UDim2.new(0.025,0,0.1,0)
TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
TitleLabel.BackgroundColor3 = Color3.fromRGB(255,255,255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = ACCENT_COLOR
TitleLabel.TextWrapped = true
TitleLabel.TextScaled = true
TitleLabel.Text = SCRIPT_TITLE
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
TitleLabel.Parent = HeaderFrame

local SubLabel = Instance.new("TextLabel")
SubLabel.Name = "SubLabel"
SubLabel.Size = UDim2.new(0.95, 0, 0.3, 0)
SubLabel.Position = UDim2.new(0.025,0,0.5,0)
SubLabel.AnchorPoint = Vector2.new(0, 0.5)
SubLabel.BackgroundColor3 = Color3.fromRGB(255,255,255)
SubLabel.BackgroundTransparency = 1
SubLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SubLabel.TextWrapped = true
SubLabel.TextScaled = true
SubLabel.Text = CHANNEL_NAME .. " | Build: " .. BUILD_ID
SubLabel.Font = Enum.Font.SourceSans
SubLabel.TextXAlignment = Enum.TextXAlignment.Center
SubLabel.TextYAlignment = Enum.TextYAlignment.Center
SubLabel.Parent = HeaderFrame

local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Name = "PlayerListFrame"
PlayerListFrame.Size = UDim2.new(1, -20, 1, -HeaderFrame.Size.Offset - 20 - 45 - 10) -- Header + Refresh button + padding
PlayerListFrame.Position = UDim2.new(0, 10, 0, HeaderFrame.Size.Offset + 10)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PlayerListFrame.BorderColor3 = ACCENT_COLOR
PlayerListFrame.BorderSizePixel = 1
PlayerListFrame.CanvasSize = UDim2.new(0,0,0,0) -- Will be updated dynamically
PlayerListFrame.ScrollBarThickness = 6
PlayerListFrame.BottomImage = "rbxassetid://200676451"
PlayerListFrame.MidImage = "rbxassetid://200676451"
PlayerListFrame.TopImage = "rbxassetid://200676451"
PlayerListFrame.Parent = MainPanel

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Name = "PlayerListLayout"
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.Parent = PlayerListFrame

local PlayerButtonTemplate = Instance.new("TextButton")
PlayerButtonTemplate.Name = "PlayerButtonTemplate"
PlayerButtonTemplate.Size = UDim2.new(0.95, 0, 0, 40)
PlayerButtonTemplate.BackgroundColor3 = ACCENT_COLOR
PlayerButtonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerButtonTemplate.TextScaled = true
PlayerButtonTemplate.TextWrapped = true
PlayerButtonTemplate.Font = Enum.Font.SourceSansBold
PlayerButtonTemplate.TextXAlignment = Enum.TextXAlignment.Center
PlayerButtonTemplate.TextYAlignment = Enum.TextYAlignment.Center
PlayerButtonTemplate.BorderColor3 = Color3.fromRGB(150, 150, 150)
PlayerButtonTemplate.BorderSizePixel = 1
PlayerButtonTemplate.Visible = false -- Make template invisible

local RefreshButton = Instance.new("TextButton")
RefreshButton.Name = "RefreshButton"
RefreshButton.Size = UDim2.new(1, -20, 0, 45) -- Large button for mobile
RefreshButton.Position = UDim2.new(0, 10, 1, -55)
RefreshButton.AnchorPoint = Vector2.new(0, 1)
RefreshButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RefreshButton.BorderColor3 = ACCENT_COLOR
RefreshButton.BorderSizePixel = 1
RefreshButton.TextColor3 = ACCENT_COLOR
RefreshButton.Text = "Обновить список игроков"
RefreshButton.TextScaled = true
RefreshButton.Font = Enum.Font.SourceSansBold
RefreshButton.TextWrapped = true
RefreshButton.Parent = MainPanel

-- Toggle Button for the Hub
local ToggleHubButton = Instance.new("TextButton")
ToggleHubButton.Name = "ToggleHubButton"
ToggleHubButton.Size = UDim2.new(0, 60, 0, 60) -- Large toggle for mobile
ToggleHubButton.Position = UDim2.new(0.01, 0, 0.5, -30) -- Left center
ToggleHubButton.BackgroundColor3 = ACCENT_COLOR
ToggleHubButton.BorderColor3 = Color3.fromRGB(15, 15, 15)
ToggleHubButton.BorderSizePixel = 2
ToggleHubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleHubButton.Text = "H"
ToggleHubButton.TextScaled = true
ToggleHubButton.Font = Enum.Font.SourceSansBold
ToggleHubButton.ZIndex = 11 -- Above other UI elements
ToggleHubButton.Parent = ScreenGui


-- Core Logic Functions

local function TeleportToPlayer(targetPlayer) 
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        StarterGui:SetCore("SendNotification", {
            Title = BRAND_NAME .. " Teleport",
            Text = "Ошибка: Ваш персонаж не найден для телепорта.",
            Icon = "rbxassetid://448336214", -- Warning icon
            Duration = 5
        })
        return
    end

    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        StarterGui:SetCore("SendNotification", {
            Title = BRAND_NAME .. " Teleport",
            Text = targetPlayer.Name .. " не имеет персонажа для телепортации.",
            Icon = "rbxassetid://448336214",
            Duration = 5
        })
        return
    end

    local localHRP = LocalPlayer.Character.HumanoidRootPart
    local targetHRP = targetPlayer.Character.HumanoidRootPart

    localHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 5, 0) -- Teleport slightly above target

    StarterGui:SetCore("SendNotification", {
        Title = BRAND_NAME .. " Teleport",
        Text = "Вы телепортированы к " .. targetPlayer.Name .. ".",
        Icon = "rbxassetid://296065664", -- Success icon
        Duration = 3
    })
end

local function UpdatePlayerList()
    -- Clear existing player buttons and their connections
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Name:find("PlayerButton_") then
            if MistralState.Connections[child.Name] then
                MistralState.Connections[child.Name]:Disconnect()
                MistralState.Connections[child.Name] = nil
            end
            child:Destroy()
        elseif child:IsA("TextLabel") and child.Name == "NoPlayersLabel" then
            child:Destroy()
        end
    end

    local currentPlayers = Players:GetPlayers()
    local playerCount = 0
    for _, player in ipairs(currentPlayers) do
        if player ~= LocalPlayer then
            playerCount = playerCount + 1
            local playerButton = PlayerButtonTemplate:Clone()
            playerButton.Name = "PlayerButton_" .. player.UserId
            playerButton.Text = player.Name
            playerButton.Parent = PlayerListFrame
            playerButton.Visible = true

            MistralState.Connections[playerButton.Name] = playerButton.MouseButton1Click:Connect(function()
                TeleportToPlayer(player)
            end)
        end
    end

    if playerCount == 0 then
         local noPlayersLabel = Instance.new("TextLabel")
         noPlayersLabel.Name = "NoPlayersLabel"
         noPlayersLabel.Size = UDim2.new(1, 0, 0, 40)
         noPlayersLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
         noPlayersLabel.BackgroundTransparency = 1
         noPlayersLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
         noPlayersLabel.Text = "Других игроков не найдено."
         noPlayersLabel.TextScaled = true
         noPlayersLabel.Font = Enum.Font.SourceSansBold
         noPlayersLabel.TextWrapped = true
         noPlayersLabel.Parent = PlayerListFrame
    end

    -- Adjust CanvasSize after all buttons are added
    local contentHeight = (playerCount * (PlayerButtonTemplate.Size.Offset.Y + UIListLayout.Padding.Offset))
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(PlayerListFrame.AbsoluteSize.Y, contentHeight + 5)) -- Add extra padding
end

local function ToggleHubVisibility()
    MistralState.IsHubVisible = not MistralState.IsHubVisible
    MainPanel.Visible = MistralState.IsHubVisible
    if MistralState.IsHubVisible then
        UpdatePlayerList() -- Refresh list when opening
    end
end

-- Drag functionality for MainPanel (for mobile touch drag)
local function handleInputBegan(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- Only drag if input is within MainPanel but not on PlayerListFrame or RefreshButton or ToggleHubButton
        if MainPanel.Visible and MainPanel:IsAncestorOf(input.Target) and input.Target ~= PlayerListFrame and input.Target.Parent ~= PlayerListFrame and input.Target ~= RefreshButton then
            MistralState.DragStart = input.Position
            MistralState.StartPos = MainPanel.Position
            MistralState.TempConnections.InputChanged = UserInputService.InputChanged:Connect(handleInputChanged)
            MistralState.TempConnections.InputEnded = UserInputService.InputEnded:Connect(handleInputEnded)
        end
    end
end

local function handleInputChanged(input)
    if MistralState.DragStart and MistralState.StartPos and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - MistralState.DragStart
        local newX = MistralState.StartPos.X.Offset + delta.X
        local newY = MistralState.StartPos.Y.Offset + delta.Y

        -- Clamp position to screen bounds
        local maxX = UserInputService.ViewportSize.X - MainPanel.AbsoluteSize.X
        local maxY = UserInputService.ViewportSize.Y - MainPanel.AbsoluteSize.Y

        newX = clamp(newX, 0, maxX)
        newY = clamp(newY, 0, maxY)

        MainPanel.Position = UDim2.new(0, newX, 0, newY)
    end
end

local function handleInputEnded(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MistralState.DragStart = nil
        MistralState.StartPos = nil
        
        -- Disconnect temporary inputchanged/ended connections
        if MistralState.TempConnections.InputChanged then MistralState.TempConnections.InputChanged:Disconnect(); MistralState.TempConnections.InputChanged = nil end
        if MistralState.TempConnections.InputEnded then MistralState.TempConnections.InputEnded:Disconnect(); MistralState.TempConnections.InputEnded = nil end
    end
end

local function setupConnections()
    MistralState.Connections.ToggleHubButton = ToggleHubButton.MouseButton1Click:Connect(ToggleHubVisibility)
    MistralState.Connections.RefreshButton = RefreshButton.MouseButton1Click:Connect(UpdatePlayerList)
    MistralState.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        if MistralState.IsHubVisible then
            UpdatePlayerList()
        end
    end)
    MistralState.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        if MistralState.IsHubVisible then
            UpdatePlayerList()
        end
    end)

    MistralState.Connections.InputBeganGlobal = UserInputService.InputBegan:Connect(handleInputBegan)
end

local function disconnectAllSignals()
    for key, conn in pairs(MistralState.Connections) do
        if conn.Connected then
            conn:Disconnect()
        end
        MistralState.Connections[key] = nil
    end
    -- Also disconnect any remaining temporary drag connections
    if MistralState.TempConnections.InputChanged then MistralState.TempConnections.InputChanged:Disconnect(); MistralState.TempConnections.InputChanged = nil end
    if MistralState.TempConnections.InputEnded then MistralState.TempConnections.InputEnded:Disconnect(); MistralState.TempConnections.InputEnded = nil end
end

-- Main initialization on CharacterAdded or initial load
local function initializeHub()
    disconnectAllSignals() -- Clean up previous connections to avoid duplicates on respawn
    ScreenGui.Parent = StarterGui
    MainPanel.Visible = MistralState.IsHubVisible -- Restore previous visibility or keep false
    setupConnections()
    if MistralState.IsHubVisible then
        UpdatePlayerList() -- Update list if GUI is visible on init
    end

    -- Ensure UI positioning is correct after potential screen resize
    local function updatePanelPosition()
        MainPanel.Position = UDim2.new(0.5, -PANEL_WIDTH/2, 0.5, -PANEL_HEIGHT/2)
    end
    MistralState.Connections.ScreenResized = UserInputService.WindowFocused:Connect(updatePanelPosition)
    MistralState.Connections.ScreenResized2 = RunService.RenderStepped:Connect(function()
        if MainPanel.Visible and not MistralState.DragStart then -- Only center if not actively dragging
            MainPanel.Position = UDim2.new(0.5, -MainPanel.AbsoluteSize.X/2, 0.5, -MainPanel.AbsoluteSize.Y/2)
        end
    end)
end

-- Connect to CharacterAdded for clean state reset (handles respawn)
MistralState.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function()
    wait(1) -- Give character a moment to load fully before re-initializing
    initializeHub()
end)

-- Initial setup when script first runs
initializeHub()
