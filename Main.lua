-- AALUKACHALU Main.lua | Redz Hub Style Script with Working GUI, Teleport Dropdown & Tween

local player = game.Players.LocalPlayer local TweenService = game:GetService("TweenService") local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui")) ScreenGui.Name = "AALUKACHALU_GUI" ScreenGui.ResetOnSpawn = false

-- Main Frame local MainFrame = Instance.new("Frame", ScreenGui) MainFrame.Size = UDim2.new(0, 320, 0, 240) MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) MainFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", MainFrame) UICorner.CornerRadius = UDim.new(0, 10)

local UIListLayout = Instance.new("UIListLayout", MainFrame) UIListLayout.Padding = UDim.new(0, 6) UIListLayout.FillDirection = Enum.FillDirection.Vertical UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Create Toggle Buttons local function createToggleButton(label, callback) local btn = Instance.new("TextButton") btn.Size = UDim2.new(0, 280, 0, 30) btn.Text = "OFF - " .. label btn.Font = Enum.Font.GothamBold btn.TextScaled = true btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) btn.TextColor3 = Color3.new(1, 1, 1) btn.AutoButtonColor = false

local corner = Instance.new("UICorner", btn)
corner.CornerRadius = UDim.new(0, 6)

local toggled = false
btn.MouseButton1Click:Connect(function()
    toggled = not toggled
    btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 0, 0)
    btn.Text = (toggled and "ON" or "OFF") .. " - " .. label
    pcall(function() callback(toggled) end)
end)

btn.Parent = MainFrame
return btn

end

-- Tween teleport local function tweenTo(position) local char = player.Character or player.CharacterAdded:Wait() local hrp = char:WaitForChild("HumanoidRootPart") local goal = {CFrame = CFrame.new(position)} TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), goal):Play() end

-- Button Features createToggleButton("Auto Quest", function(on) print("Auto Quest:", on) end)

createToggleButton("Auto Farm", function(on) print("Auto Farm:", on) end)

createToggleButton("Auto Attack", function(on) print("Auto Attack:", on) end)

createToggleButton("Auto Chest", function(on) print("Auto Chest:", on) end)

-- Sea Detection local placeId = game.PlaceId local currentSea = 1 if placeId == 2753915549 then currentSea = 1 elseif placeId == 4442272183 then currentSea = 2 elseif placeId == 7449423635 then currentSea = 3 end

-- Island Data local islandsBySea = { [1] = { ["Starter Island"] = Vector3.new(106, 16, 1430), ["Jungle"] = Vector3.new(-1617, 36, 145), ["Pirate Village"] = Vector3.new(-1123, 4, 3855), }, [2] = { ["Kingdom of Rose"] = Vector3.new(-393, 73, 667), ["Green Zone"] = Vector3.new(-2290, 72, -2740), ["Snow Mountain"] = Vector3.new(1400, 428, -3200), }, [3] = { ["Haunted Castle"] = Vector3.new(-9542, 141, 5762), ["Hydra Island"] = Vector3.new(5228, 200, -11072), ["Great Tree"] = Vector3.new(2337, 25, -7150), } }

-- Teleport Button local teleportButton = Instance.new("TextButton") teleportButton.Size = UDim2.new(0, 280, 0, 30) teleportButton.Text = "Teleport to Island" teleportButton.Font = Enum.Font.GothamBold teleportButton.TextScaled = true teleportButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255) teleportButton.TextColor3 = Color3.new(1, 1, 1) teleportButton.AutoButtonColor = false

local tpCorner = Instance.new("UICorner", teleportButton) tpCorner.CornerRadius = UDim.new(0, 6) teleportButton.Parent = MainFrame

-- Dropdown Frame (separate) local dropdownFrame = Instance.new("Frame", ScreenGui) dropdownFrame.Size = UDim2.new(0, 280, 0, 120) dropdownFrame.Position = UDim2.new(0.5, 0, 0.5, 140) dropdownFrame.AnchorPoint = Vector2.new(0.5, 0) dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) dropdownFrame.Visible = false

local dropCornerFrame = Instance.new("UICorner", dropdownFrame) dropCornerFrame.CornerRadius = UDim.new(0, 6)

local dropLayout = Instance.new("UIListLayout", dropdownFrame) dropLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Populate Dropdown on Click teleportButton.MouseButton1Click:Connect(function() dropdownFrame.Visible = not dropdownFrame.Visible for _, child in ipairs(dropdownFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end

for name, pos in pairs(islandsBySea[currentSea]) do
    local islandBtn = Instance.new("TextButton", dropdownFrame)
    islandBtn.Size = UDim2.new(1, 0, 0, 30)
    islandBtn.Text = name
    islandBtn.Font = Enum.Font.Gotham
    islandBtn.TextColor3 = Color3.new(1, 1, 1)
    islandBtn.TextScaled = true
    islandBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local corner = Instance.new("UICorner", islandBtn)
    corner.CornerRadius = UDim.new(0, 6)

    islandBtn.MouseButton1Click:Connect(function()
        tweenTo(pos)
        dropdownFrame.Visible = false
    end)
end

end)

-- Done

