repeat wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SoulGuitarGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 140)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Frame)
Title.Text = "🎸 Skull Guitar"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.FredokaOne
Title.TextScaled = true

local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(0.8, 0, 0, 40)
Toggle.Position = UDim2.new(0.1, 0, 0, 60)
Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Font = Enum.Font.GothamBold
Toggle.Text = "Soul Guitar: OFF"
Toggle.TextScaled = true

local ToggleCorner = Instance.new("UICorner", Toggle)
ToggleCorner.CornerRadius = UDim.new(0, 8)

-- Script Logic
local enabled = false

local function StartSoulQuest()
    local success, err = pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "Soul Guitar", 1)
    end)
    if not success then warn("Quest error:", err) end
end

local function SolveSoulPuzzle()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ClickDetector") and v.Parent.Name:lower():find("soul") then
            pcall(function()
                fireclickdetector(v)
            end)
            wait(0.2)
        end
    end
end

-- Button Toggle
Toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    Toggle.Text = enabled and "Soul Guitar: ON" or "Soul Guitar: OFF"
    Toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 0, 0)

    if enabled then
        spawn(function()
            while enabled do
                StartSoulQuest()
                wait(2)
                SolveSoulPuzzle()
                wait(5)
            end
        end)
    end
end)
