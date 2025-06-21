-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedzHubStylish"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Toggle Logo Button (top-left)
local LogoButton = Instance.new("TextButton")
LogoButton.Size = UDim2.new(0, 50, 0, 50)
LogoButton.Position = UDim2.new(0, 10, 0, 10)
LogoButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
LogoButton.Text = "RZ"
LogoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoButton.Font = Enum.Font.GothamBold
LogoButton.TextSize = 20
LogoButton.Parent = ScreenGui

-- Main Frame (Hidden by default)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 360)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Redz Hub Replica"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- X Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

LogoButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Content Area
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 4
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ContentFrame

-- Toggle Button Factory
local function CreateToggle(name, default)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	frame.BorderSizePixel = 0
	frame.Parent = ContentFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(60, 60, 60)
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local toggleButton = Instance.new("TextButton")
	toggleButton.Size = UDim2.new(0, 70, 0, 30)
	toggleButton.Position = UDim2.new(1, -80, 0.5, -15)
	toggleButton.BackgroundColor3 = default and Color3.fromRGB(20, 170, 20) or Color3.fromRGB(200, 40, 40)
	toggleButton.Text = default and "ON" or "OFF"
	toggleButton.Font = Enum.Font.GothamBold
	toggleButton.TextSize = 18
	toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleButton.AutoButtonColor = false
	toggleButton.Parent = frame

	local toggled = default

	toggleButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		toggleButton.Text = toggled and "ON" or "OFF"
		TweenService:Create(toggleButton, TweenInfo.new(0.25), {
			BackgroundColor3 = toggled and Color3.fromRGB(20, 170, 20) or Color3.fromRGB(200, 40, 40)
		}):Play()
	end)

	return frame, function() return toggled end
end

-- Create Feature Toggles
local toggles = {}

toggles.autoQuestFrame, toggles.isAutoQuest = CreateToggle("Auto Quest Accept", false)
toggles.autoFarmFrame, toggles.isAutoFarm = CreateToggle("Auto Farm", false)
toggles.autoEquipFrame, toggles.isAutoEquip = CreateToggle("Auto Equip Weapon", true)
toggles.autoAttackFrame, toggles.isAutoAttack = CreateToggle("Auto Attack", false)
toggles.autoTeleportFrame, toggles.isAutoTeleport = CreateToggle("Teleport to Haunted Castle", false)
toggles.autoCollectFrame, toggles.isAutoCollect = CreateToggle("Collect Drops / Chests", false)

-- Feature Logic (Placeholder Functions)
local function teleportToHauntedCastle()
	local targetCFrame = CFrame.new(1440, 45, -1765)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = targetCFrame
	end
end

local function acceptQuest()
	local questEvent = ReplicatedStorage:FindFirstChild("QuestRemoteEvent")
	if questEvent then
		questEvent:FireServer()
	end
end

local function farmMobs()
	-- Add auto-farming logic here
end

local function equipWeapon()
	local backpack = player:FindFirstChild("Backpack")
	if not backpack then return end
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") then
			player.Character.Humanoid:EquipTool(tool)
			break
		end
	end
end

local function autoAttack()
	-- Add your auto-attack logic here
end

local function collectRewards()
	-- Add drop/chest collection logic here
end

-- Main Loop
RunService.Heartbeat:Connect(function()
	if toggles.isAutoTeleport() then teleportToHauntedCastle() end
	if toggles.isAutoQuest() then acceptQuest() end
	if toggles.isAutoEquip() then equipWeapon() end
	if toggles.isAutoFarm() then farmMobs() end
	if toggles.isAutoAttack() then autoAttack() end
	if toggles.isAutoCollect() then collectRewards() end
end)
