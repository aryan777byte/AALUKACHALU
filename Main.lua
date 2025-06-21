-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- =====================
-- GUI Setup
-- =====================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StylishRedzHub"
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 460)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245) -- White background
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 18)
UICornerMain.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Dark Red
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Redz Hub Replica"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 26
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0.5, -20)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 22
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.AutoButtonColor = false
CloseButton.Parent = TitleBar

local CloseUICorner = Instance.new("UICorner")
CloseUICorner.CornerRadius = UDim.new(0, 12)
CloseUICorner.Parent = CloseButton

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(180, 0, 0)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content Scrolling Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -30, 1, -70)
ContentFrame.Position = UDim2.new(0, 15, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 6
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 14)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ContentFrame

-- Toggle Button Factory
local function CreateToggle(name, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    frame.BorderSizePixel = 0
    frame.Parent = ContentFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(60, 60, 60)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 19
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 90, 0, 35)
    toggleButton.Position = UDim2.new(1, -105, 0.5, -17)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(20, 170, 20) or Color3.fromRGB(200, 40, 40)
    toggleButton.Text = default and "ON" or "OFF"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 20
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.AutoButtonColor = false
    toggleButton.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton

    local toggled = default

    toggleButton.MouseEnter:Connect(function()
        local hoverColor = toggled and Color3.fromRGB(10, 140, 10) or Color3.fromRGB(160, 30, 30)
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    toggleButton.MouseLeave:Connect(function()
        local normalColor = toggled and Color3.fromRGB(20, 170, 20) or Color3.fromRGB(200, 40, 40)
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)

    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            toggleButton.Text = "ON"
            TweenService:Create(toggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 170, 20)}):Play()
        else
            toggleButton.Text = "OFF"
            TweenService:Create(toggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(200, 40, 40)}):Play()
        end
    end)

    return frame, function() return toggled end
end

-- =====================
-- Feature Toggles
-- =====================

local toggles = {}

-- Create toggles with default OFF
toggles.autoQuestFrame, toggles.isAutoQuest = CreateToggle("Auto Quest Accept", false)
toggles.autoFarmFrame, toggles.isAutoFarm = CreateToggle("Auto Farm", false)
toggles.autoEquipFrame, toggles.isAutoEquip = CreateToggle("Auto Equip Weapon", true)
toggles.autoAttackFrame, toggles.isAutoAttack = CreateToggle("Auto Attack", false)
toggles.autoTeleportFrame, toggles.isAutoTeleport = CreateToggle("Auto Teleport to Haunted Castle", false)
toggles.autoCollectFrame, toggles.isAutoCollect = CreateToggle("Auto Collect Rewards", false)

-- =====================
-- Core Logic Functions
-- =====================

local function teleportToHauntedCastle()
    -- Replace with your actual teleport logic for Haunted Castle
    local targetCFrame = CFrame.new(1440, 45, -1765) -- example coordinates
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = targetCFrame
    end
end

local function acceptQuest()
    -- Your quest accept logic here
    -- Example: Fire a RemoteEvent or invoke a remote function to accept quest
    local questEvent = ReplicatedStorage:FindFirstChild("QuestRemoteEvent")
    if questEvent then
        questEvent:FireServer()
    end
end

local function farmMobs()
    -- Your mob farming logic here, simplified example
    -- This would include targeting mobs, attacking them, etc.
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Find nearest mob and attack logic here
    end
end

local function equipWeapon()
    -- Your weapon equip logic here
    -- Example: equip Soul Guitar or your chosen weapon
    local backpack = player:WaitForChild("Backpack")
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            player.Character.Humanoid:EquipTool(tool)
            break
        end
    end
end

local function autoAttack()
    -- Your auto attack logic here
    -- For example, trigger attack animations or RemoteEvents repeatedly
end

local function collectRewards()
    -- Your reward collect logic here
    -- For example, pick up drops or claim chests
end

-- =====================
-- Loop to run toggled features
-- =====================

RunService.Heartbeat:Connect(function()
    if toggles.isAutoTeleport() then
        teleportToHauntedCastle()
    end

    if toggles.isAutoQuest() then
        acceptQuest()
    end

    if toggles.isAutoEquip() then
        equipWeapon()
    end

    if toggles.isAutoFarm() then
        farmMobs()
    end

    if toggles.isAutoAttack() then
        autoAttack()
    end

    if toggles.isAutoCollect() then
        collectRewards()
    end
end)
