local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local AutoFarmLevelEnabled = false
local AutoFarmChestEnabled = false
local SelectedMeleeTool = "Soul Guitar"

-- Utility Functions
local function getCurrentSea()
    local pos = humanoidRootPart.Position
    if pos.X < 0 then
        return "First Sea"
    elseif pos.X < 500 then
        return "Second Sea"
    elseif pos.X < 1000 then
        return "Third Sea"
    else
        return "Unknown Sea"
    end
end

local function getIslandsForSea(seaName)
    local seaIslands = {
        ["First Sea"] = {"Island1", "Island2", "Island3"},
        ["Second Sea"] = {"IslandA", "IslandB", "IslandC"},
        ["Third Sea"] = {"IslandX", "IslandY", "IslandZ"},
        ["Unknown Sea"] = {}
    }
    return seaIslands[seaName] or {}
end

local function tweenFlyTo(position, duration)
    local goal = CFrame.new(position + Vector3.new(0, 5, 0))
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = goal})
    tween:Play()
    tween.Completed:Wait()
end

local function equipTool(toolName)
    local backpack = player:WaitForChild("Backpack")
    local char = player.Character or player.CharacterAdded:Wait()
    local tool = backpack:FindFirstChild(toolName) or char:FindFirstChild(toolName)
    if tool and tool:IsA("Tool") then
        tool.Parent = char
    end
end

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AALUKACHALU_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (smaller and centered)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 380) -- smaller size
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- centered
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- center anchor
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35) -- slightly smaller height
Title.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Text = "AALUKACHALU Hub"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Tabs Container (Buttons)
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, 0, 0, 40)
TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
TabsFrame.Parent = MainFrame

-- Content Frames for each tab (stacked, only one visible at a time)
local TabContents = {}

-- Helper to create tab button
local function createTabButton(name, posX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = TabsFrame
    return btn
end

-- Create Tab Buttons
local tabButtons = {}
tabButtons["AutoFarm"] = createTabButton("Auto Farm", 0)
tabButtons["Teleport"] = createTabButton("Teleport", 95)
tabButtons["Melee"] = createTabButton("Melee", 190)

-- Create content frames
local function createTabContent()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, -75)
    frame.Position = UDim2.new(0, 0, 0, 75)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = MainFrame
    return frame
end

TabContents["AutoFarm"] = createTabContent()
TabContents["Teleport"] = createTabContent()
TabContents["Melee"] = createTabContent()

-- Activate one tab function
local function activateTab(tabName)
    for name, frame in pairs(TabContents) do
        frame.Visible = (name == tabName)
    end
    for name, btn in pairs(tabButtons) do
        if name == tabName then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
    end
end

-- Initial tab active
activateTab("AutoFarm")

-- Tab button events
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        activateTab(name)
    end)
end

-- ========== AutoFarm Tab Content ===========
local autoFarmFrame = TabContents["AutoFarm"]

-- Auto Farm Level toggle button
local autoFarmLevelBtn = Instance.new("TextButton")
autoFarmLevelBtn.Size = UDim2.new(0, 200, 0, 50)
autoFarmLevelBtn.Position = UDim2.new(0.5, -100, 0, 20)
autoFarmLevelBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
autoFarmLevelBtn.TextColor3 = Color3.new(1,1,1)
autoFarmLevelBtn.Font = Enum.Font.SourceSansBold
autoFarmLevelBtn.TextSize = 20
autoFarmLevelBtn.Text = "Auto Farm Level: OFF"
autoFarmLevelBtn.Parent = autoFarmFrame

autoFarmLevelBtn.MouseButton1Click:Connect(function()
    AutoFarmLevelEnabled = not AutoFarmLevelEnabled
    if AutoFarmLevelEnabled then
        autoFarmLevelBtn.Text = "Auto Farm Level: ON"
        autoFarmLevelBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        autoFarmLevelBtn.Text = "Auto Farm Level: OFF"
        autoFarmLevelBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Auto Farm Chest toggle button
local autoFarmChestBtn = Instance.new("TextButton")
autoFarmChestBtn.Size = UDim2.new(0, 200, 0, 50)
autoFarmChestBtn.Position = UDim2.new(0.5, -100, 0, 90)
autoFarmChestBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
autoFarmChestBtn.TextColor3 = Color3.new(1,1,1)
autoFarmChestBtn.Font = Enum.Font.SourceSansBold
autoFarmChestBtn.TextSize = 20
autoFarmChestBtn.Text = "Auto Farm Chest: OFF"
autoFarmChestBtn.Parent = autoFarmFrame

autoFarmChestBtn.MouseButton1Click:Connect(function()
    AutoFarmChestEnabled = not AutoFarmChestEnabled
    if AutoFarmChestEnabled then
        autoFarmChestBtn.Text = "Auto Farm Chest: ON"
        autoFarmChestBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        autoFarmChestBtn.Text = "Auto Farm Chest: OFF"
        autoFarmChestBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- ========== Teleport Tab Content ===========
local teleportFrame = TabContents["Teleport"]

local teleportLabel = Instance.new("TextLabel")
teleportLabel.Size = UDim2.new(1, -20, 0, 30)
teleportLabel.Position = UDim2.new(0, 10, 0, 10)
teleportLabel.BackgroundTransparency = 1
teleportLabel.Text = "Islands to teleport:"
teleportLabel.Font = Enum.Font.SourceSansBold
teleportLabel.TextSize = 18
teleportLabel.TextColor3 = Color3.new(0,0,0)
teleportLabel.TextXAlignment = Enum.TextXAlignment.Left
teleportLabel.Parent = teleportFrame

local islandsList = Instance.new("ScrollingFrame")
islandsList.Size = UDim2.new(1, -20, 1, -50)
islandsList.Position = UDim2.new(0, 10, 0, 45)
islandsList.CanvasSize = UDim2.new(0, 0, 0, 0)
islandsList.ScrollBarThickness = 6
islandsList.BackgroundColor3 = Color3.fromRGB(245,245,245)
islandsList.BorderSizePixel = 0
islandsList.Parent = teleportFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = islandsList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local function updateIslands()
    islandsList:ClearAllChildren()
    local sea = getCurrentSea()
    local islands = getIslandsForSea(sea)
    teleportLabel.Text = "Islands in "..sea..":"

    for i, islandName in ipairs(islands) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        btn.TextColor3 = Color3.new(0,0,0)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        btn.Text = islandName
        btn.Parent = islandsList

        btn.MouseButton1Click:Connect(function()
            -- Replace below with your actual island teleport positions
            local islandPos = Vector3.new(0, 0, 0)
            local hash = 0
            for c in islandName:gmatch(".") do hash = hash + c:byte() end
            islandPos = Vector3.new(hash * 5, 10, hash * 3)
            tweenFlyTo(islandPos, 3)
        end)
    end

    local listHeight = (#islands * 45)
    islandsList.CanvasSize = UDim2.new(0, 0, 0, listHeight)
end

updateIslands()

spawn(function()
    while true do
        wait(10)
        updateIslands()
    end
end)

-- ========== Melee Tab Content ===========
local meleeFrame = TabContents["Melee"]

local meleeLabel = Instance.new("TextLabel")
meleeLabel.Size = UDim2.new(1, -20, 0, 30)
meleeLabel.Position = UDim2.new(0, 10, 0, 10)
meleeLabel.BackgroundTransparency = 1
meleeLabel.Text = "Select Melee Tool:"
meleeLabel.Font = Enum.Font.SourceSansBold
meleeLabel.TextSize = 18
meleeLabel.TextColor3 = Color3.new(0,0,0)
meleeLabel.TextXAlignment = Enum.TextXAlignment.Left
meleeLabel.Parent = meleeFrame

local meleeTools = {"Soul Guitar", "Melee Sword", "Fists"} -- Customize your tools here

local meleeButtons = {}

for i, toolName in ipairs(meleeTools) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 45 + (i-1)*50)
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = toolName
    btn.Parent = meleeFrame

    btn.MouseButton1Click:Connect(function()
        SelectedMeleeTool = toolName
        equipTool(toolName)
        for _, b in pairs(meleeButtons) do
            b.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end)

    meleeButtons[toolName] = btn
end

if meleeButtons[SelectedMeleeTool] then
    meleeButtons[SelectedMeleeTool].BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end

-- You can add auto farm loops and logic here triggered by the toggles
