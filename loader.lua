local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("FoxHubLoaderGui") then
    playerGui.FoxHubLoaderGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FoxHubLoaderGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Loader Window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 180)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
mainFrame.BackgroundTransparency = 1
mainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 80)
mainStroke.Transparency = 1
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Open Animation
TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -160, 0.5, -100),
    BackgroundTransparency = 0
}):Play()
TweenService:Create(mainStroke, TweenInfo.new(0.4), {Transparency = 0.2}):Play()

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 10)
headerFix.Position = UDim2.new(0, 0, 1, -10)
headerFix.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🦊 FOXHUB LOADER"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 40)
statusLabel.Position = UDim2.new(0, 20, 0, 65)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Checking game database..."
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame

-- Progress Bar Background
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, -40, 0, 6)
barBg.Position = UDim2.new(0, 20, 1, -45)
barBg.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
barBg.BorderSizePixel = 0
barBg.Parent = mainFrame

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = barBg

-- Progress Bar Fill
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(50, 195, 90)
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

-- Execute Logic
task.spawn(function()
    TweenService:Create(barFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.6, 0, 1, 0)
    }):Play()
    
    task.wait(1)
    
    -- Game Database mapping
    local supportedGames = {
        [78567276888799] = "78567276888799.lua",
        [119958473240233] = "119958473240233.lua",
        [139386728420706] = "139386728420706.lua"
    }
    
    local scriptFile = supportedGames[game.PlaceId]
    
    if scriptFile then
        statusLabel.Text = "Game found! Loading script..."
        TweenService:Create(barFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(50, 195, 90)
        }):Play()
        
        task.wait(0.6)
        
        -- Close loader gui gracefully
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        screenGui:Destroy()
        
        -- Run the target script dynamically
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FoxVukOff/FoxHub/refs/heads/main/" .. scriptFile))()
        end)
        
        if not success then
            warn("FoxHub Error executing script: " .. tostring(err))
        end
    else
        statusLabel.Text = "Current game is not in the database! Closing in 5 seconds..."
        statusLabel.TextColor3 = Color3.fromRGB(220, 70, 70)
        
        TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        }):Play()
        
        for i = 5, 1, -1 do
            statusLabel.Text = "Current game is not in the database! Closing in " .. i .. "s..."
            task.wait(1)
        end
        
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        screenGui:Destroy()
    end
end)