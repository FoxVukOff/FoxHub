local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("FoxHubLobbyGui") then
    playerGui.FoxHubLobbyGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FoxHubLobbyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 220)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -110)
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
    Position = UDim2.new(0.5, -170, 0.5, -120),
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
title.Text = "🦊 FoxHub - DONT SPLASH LOBBY"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

-- White Confetti Effect
local function spawnConfetti(parentGui)
    local mouse = player:GetMouse()
    local count = 10
    
    for i = 1, count do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(4, 8), 0, math.random(8, 16))
        particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        particle.BorderSizePixel = 0
        particle.ZIndex = 20
        
        local pCorner = Instance.new("UICorner")
        pCorner.CornerRadius = UDim.new(0, 2)
        pCorner.Parent = particle
        
        local absPos = parentGui.AbsolutePosition
        local startX = mouse.X - absPos.X
        local startY = mouse.Y - absPos.Y
        
        particle.Position = UDim2.new(0, startX, 0, startY)
        particle.Parent = parentGui
        
        local angle = math.rad(math.random(0, 360))
        local speed = math.random(30, 80)
        local targetX = startX + math.cos(angle) * speed
        local targetY = startY + math.sin(angle) * speed + math.random(20, 50)
        
        local tweenInfo = TweenInfo.new(math.random(30, 50) / 100, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(particle, tweenInfo, {
            Position = UDim2.new(0, targetX, 0, targetY),
            Rotation = math.random(-180, 180),
            BackgroundTransparency = 1
        })
        
        tween:Play()
        tween.Completed:Connect(function()
            particle:Destroy()
        end)
    end
end

-- Info Message Label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -40, 1, -60)
infoLabel.Position = UDim2.new(0, 20, 0, 50)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Please execute the script inside the game, not in the lobby!"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
infoLabel.TextSize = 13
infoLabel.Font = Enum.Font.GothamMedium
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.TextYAlignment = Enum.TextYAlignment.Center
infoLabel.Parent = mainFrame

-- Close Button Handler
closeBtn.MouseButton1Click:Connect(function()
    spawnConfetti(closeBtn)
    
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.3)
    screenGui:Destroy()
end)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
end)