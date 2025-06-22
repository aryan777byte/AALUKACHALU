-- AALUKACHALU Final Version 1 Script

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AALUKACHALU_GUI"
gui.ResetOnSpawn = false

-- TABS
local TabsFrame = Instance.new("Frame", gui)
TabsFrame.Size = UDim2.new(0, 320, 0, 40)
TabsFrame.Position = UDim2.new(0.5, 0, 0.5, -140)
TabsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
TabsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", TabsFrame).CornerRadius = UDim.new(0, 10)

-- MAIN FRAME
local MainFrame = Instance.new("Frame", gui)
MainFrame.Size = UDim2.new(0, 320, 0, 240)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 40)
MainFrame.AnchorPoint = Vector2.new(0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local UIListLayout = Instance.new("UIListLayout", MainFrame)
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Tabs
local tabFrames = {}
local tabNames = {"Main", "Teleport", "Melee"}

for _, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", TabsFrame)
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local tab = Instance.new("Frame", MainFrame)
    tab.Name = name
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.BackgroundTransparency = 1
    tab.Visible = false
    tabFrames[name] = tab

    btn.MouseButton1Click:Connect(function()
        for n, f in pairs(tabFrames) do f.Visible = (n == name) end
    end)
end

if tabFrames["Main"] then tabFrames["Main"].Visible = true end

-- Toggle Button Function
local function createToggleButton(parent, label, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Text = "OFF - " .. label
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 0, 0)
        btn.Text = (toggled and "ON" or "OFF") .. " - " .. label
        pcall(function() callback(toggled) end)
    end)
end

-- Main tab
createToggleButton(tabFrames.Main, "Auto Quest", function(on) print("Auto Quest:", on) end)
createToggleButton(tabFrames.Main, "Auto Farm", function(on) print("Auto Farm:", on) end)
createToggleButton(tabFrames.Main, "Auto Attack", function(on) print("Auto Attack:", on) end)
createToggleButton(tabFrames.Main, "Auto Chest", function(on) print("Auto Chest:", on) end)

-- Detect sea
local placeId = game.PlaceId
local currentSea = placeId == 2753915549 and 1 or placeId == 4442272183 and 2 or placeId == 7449423635 and 3 or 1

-- Island positions
local islandsBySea = {
    [1] = {
        ["Starter Island"] = Vector3.new(106, 16, 1430),
        ["Jungle"] = Vector3.new(-1617, 36, 145),
        ["Pirate Village"] = Vector3.new(-1123, 4, 3855),
    },
    [2] = {
        ["Kingdom of Rose"] = Vector3.new(-393, 73, 667),
        ["Green Zone"] = Vector3.new(-2290, 72, -2740),
        ["Snow Mountain"] = Vector3.new(1400, 428, -3200),
    },
    [3] = {
        ["Haunted Castle"] = Vector3.new(-9542, 141, 5762),
        ["Hydra Island"] = Vector3.new(5228, 200, -11072),
        ["Great Tree"] = Vector3.new(2337, 25, -7150),
    }
}

-- Tween Teleport
local function tweenTo(pos)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        TweenService:Create(hrp, TweenInfo.new(1.5), {CFrame = CFrame.new(pos)}):Play()
    end
end

-- Teleport tab
for name, pos in pairs(islandsBySea[currentSea]) do
    local btn = Instance.new("TextButton", tabFrames.Teleport)
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        tweenTo(pos)
    end)
end

-- Melee tab
local label = Instance.new("TextLabel", tabFrames.Melee)
label.Size = UDim2.new(0, 280, 0, 30)
label.Text = "Click to print Melee Tools"
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1

local drop = Instance.new("TextButton", tabFrames.Melee)
drop.Size = UDim2.new(0, 280, 0, 30)
drop.Text = "Show Tools"
drop.Font = Enum.Font.GothamBold
drop.TextScaled = true
drop.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
drop.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 6)

drop.MouseButton1Click:Connect(function()
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then print("Found Tool:", tool.Name) end
    end
end)

print("[AALUKACHALU] Final Version 1 Loaded")
