repeat wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local plr = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SoulGuitarAutoGUI"
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 150)
MainFrame.Position = UDim2.new(0, 20, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.BackgroundTransparency = 0.1

-- UI Corner
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Logo
local Logo = Instance.new("TextLabel", MainFrame)
Logo.Text = "🎸 Skull Guitar"
Logo.Size = UDim2.new(1, 0, 0, 40)
Logo.TextColor3 = Color3.fromRGB(50, 50, 50)
Logo.BackgroundTransparency = 1
Logo.Font = Enum.Font.FredokaOne
Logo.TextScaled = true

-- Toggle Button
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.1, 0, 0, 60)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "Soul Guitar: OFF"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextScaled = true

local ToggleUICorner = Instance.new("UICorner", ToggleBtn)
ToggleUICorner.CornerRadius = UDim.new(0, 8)

-- Logic
local enabled = false

function TPToHauntedCastle()
    if game.PlaceId ~= 1451439645 then
        TeleportService:Teleport(1451439645)
    end
end

function StartSoulGuitarQuest()
    local args = {
        [1] = "StartQuest",
        [2] = "Soul Guitar",
        [3] = 1
    }
    ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
end

function CompleteSoulPuzzle()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ClickDetector") and v.Parent.Name == "SoulObject" then
            fireclickdetector(v)
            wait(0.2)
        end
    end
end

-- Loop
spawn(function()
    while wait(2) do
        if enabled then
            TPToHauntedCastle()
            wait(3)
            StartSoulGuitarQuest()
            wait(3)
            CompleteSoulPuzzle()
        end
    end
end)

-- Toggle Button Logic
ToggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    ToggleBtn.Text = enabled and "Soul Guitar: ON" or "Soul Guitar: OFF"
    ToggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 0, 0)
end)
