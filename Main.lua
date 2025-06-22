-- // GUI & Core Loader // --
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

-- // GUI Elements // --
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AALUKACHALU_GUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIGrid = Instance.new("UIGridLayout", MainFrame)
UIGrid.CellSize = UDim2.new(0.48, 0, 0.25, 0)
UIGrid.CellPadding = UDim2.new(0.02, 0, 0.05, 0)

-- // Helper to Create Buttons // --
local function createButton(name, callback, colorOff, colorOn)
	local btn = Instance.new("TextButton", MainFrame)
	btn.Name = name
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.BackgroundColor3 = colorOff
	btn.AutoButtonColor = false
	
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 8)

	local toggled = false
	btn.MouseButton1Click:Connect(function()
		toggled = not toggled
		btn.BackgroundColor3 = toggled and colorOn or colorOff
		pcall(function() callback(toggled) end)
	end)

	return btn
end

-- // Teleport Function // --
local function tweenTo(position)
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local goal = {}
		goal.CFrame = CFrame.new(position)
		TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), goal):Play()
	end
end

-- // Auto Quest Toggle // --
createButton("Auto Quest", function(on)
	if on then
		print("Auto Quest: ON")
		-- Add your quest code
	else
		print("Auto Quest: OFF")
	end
end, Color3.fromRGB(200, 0, 0), Color3.fromRGB(0, 255, 100))

-- // Auto Farm Toggle // --
createButton("Auto Farm", function(on)
	if on then
		print("Auto Farm: ON")
		-- Add auto farm code
	else
		print("Auto Farm: OFF")
	end
end, Color3.fromRGB(200, 0, 0), Color3.fromRGB(0, 255, 100))

-- // Auto Chest Toggle // --
createButton("Auto Chests", function(on)
	if on then
		print("Auto Chest: ON")
		-- Chest farming code
	else
		print("Auto Chest: OFF")
	end
end, Color3.fromRGB(200, 0, 0), Color3.fromRGB(0, 255, 100))

-- // Auto Attack Toggle // --
createButton("Auto Attack", function(on)
	if on then
		print("Auto Attack: ON")
		-- Auto click or attack
	else
		print("Auto Attack: OFF")
	end
end, Color3.fromRGB(200, 0, 0), Color3.fromRGB(0, 255, 100))

-- // Melee Selector // --
local tools = {}
for _, v in ipairs(player.Backpack:GetChildren()) do
	if v:IsA("Tool") then table.insert(tools, v.Name) end
end

local dropdown = Instance.new("TextButton", MainFrame)
dropdown.Text = "Select Melee"
dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.Font = Enum.Font.Gotham
dropdown.TextScaled = true
local dropCorner = Instance.new("UICorner", dropdown)
dropCorner.CornerRadius = UDim.new(0, 8)

dropdown.MouseButton1Click:Connect(function()
	print("Tools:", tools)
end)

-- // Teleport Button // --
createButton("Teleport Haunted", function()
	tweenTo(Vector3.new(-9542, 140, 5762)) -- Haunted Castle location
end, Color3.fromRGB(50, 50, 255), Color3.fromRGB(100, 255, 255))

-- // Add Sea-Based Island Teleport Later // --

-- // Dynamic Script Execution (your provided logic) // --
local Scripts = {
	{
		GameId = game.GameId,
		Path = "Skull.lua"
	}
}

local function fetcher()
	local Url = "https://raw.githubusercontent.com/aryan777byte/AALUKACHALU/main/Main.lua"
	local raw = game:HttpGet(Url)
	local execute, error = loadstring(raw)
	if type(execute) ~= "function" then
		warn(`[2] [Executor] syntax error at {Url}\n>>{error}<<`)
	else
		return execute
	end
end

local function IsPlace(Data)
	if Data.PlacesIds and table.find(Data.PlacesIds, game.PlaceId) then
		return true
	elseif Data.GameId and game.GameId == Data.GameId then
		return true
	end
	return false
end

for _, Data in Scripts do
	if IsPlace(Data) then
		return fetcher()()
	end
end
