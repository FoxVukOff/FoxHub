local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("FoxHubGui") then
    playerGui.FoxHubGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FoxHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Window
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 360)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -160)
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
    Position = UDim2.new(0.5, -170, 0.5, -180),
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
title.Text = "🦊 FoxHub - Sell Veritys"
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

-- Scrolling Frame Container
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -58)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.CanvasSize = UDim2.new(0, 0, 0, 315)
container.ScrollBarThickness = 3
container.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = container

local function applyHoverEffect(frame, defaultColor, hoverColor)
    frame.MouseEnter:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    frame.MouseLeave:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
    end)
end

local function createToggleRow(name, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = row

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Transparency = 0.4
    stroke.Parent = row

    applyHoverEffect(row, Color3.fromRGB(18, 18, 24), Color3.fromRGB(24, 24, 34))

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(210, 210, 230)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 52, 0, 26)
    switchBg.Position = UDim2.new(1, -64, 0.5, -13)
    switchBg.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    switchBg.BorderSizePixel = 0
    switchBg.Text = ""
    switchBg.Parent = row

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBg

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = UDim2.new(0, 3, 0.5, -10)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = switchBg

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    return row, switchBg, circle
end

local row1, sw1, circ1 = createToggleRow("Auto Upgrade #1", 1)
local row2, sw2, circ2 = createToggleRow("Auto Upgrade #2", 2)
local row3, sw3, circ3 = createToggleRow("Auto Upgrade #3", 3)
local row4, sw4, circ4 = createToggleRow("Auto Upgrade #4", 4)
local row5, sw5, circ5 = createToggleRow("Auto Dealer", 5)

local function setToggleState(state, switchBg, circle)
    local bgTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local circTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    if state then
        TweenService:Create(switchBg, bgTweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 195, 90)}):Play()
        TweenService:Create(circle, circTweenInfo, {Position = UDim2.new(1, -23, 0.5, -10)}):Play()
    else
        TweenService:Create(switchBg, bgTweenInfo, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
        TweenService:Create(circle, circTweenInfo, {Position = UDim2.new(0, 3, 0.5, -10)}):Play()
    end
end

local active1, active2, active3, active4, activeDealer = false, false, false, false, false

sw1.MouseButton1Click:Connect(function()
    spawnConfetti(sw1)
    active1 = not active1
    setToggleState(active1, sw1, circ1)
end)

sw2.MouseButton1Click:Connect(function()
    spawnConfetti(sw2)
    active2 = not active2
    setToggleState(active2, sw2, circ2)
end)

sw3.MouseButton1Click:Connect(function()
    spawnConfetti(sw3)
    active3 = not active3
    setToggleState(active3, sw3, circ3)
end)

sw4.MouseButton1Click:Connect(function()
    spawnConfetti(sw4)
    active4 = not active4
    setToggleState(active4, sw4, circ4)
end)

sw5.MouseButton1Click:Connect(function()
    spawnConfetti(sw5)
    activeDealer = not activeDealer
    setToggleState(activeDealer, sw5, circ5)
end)

-- Guaranteed sequential round-robin loop for all active upgraders
task.spawn(function()
    while true do
        local upgradeEvent = ReplicatedStorage.Remotes:FindFirstChild("Upgrade")
        local firedAny = false
        
        if upgradeEvent then
            if active1 then
                pcall(function() upgradeEvent:FireServer(1, 1) end)
                firedAny = true
            end
            if active2 then
                pcall(function() upgradeEvent:FireServer(2, 1) end)
                firedAny = true
            end
            if active3 then
                pcall(function() upgradeEvent:FireServer(3, 1) end)
                firedAny = true
            end
            if active4 then
                pcall(function() upgradeEvent:FireServer(4, 1) end)
                firedAny = true
            end
        end
        
        if firedAny then
            task.wait(0.05)
        else
            task.wait(0.2)
        end
    end
end)

-- Auto Dealer Logic Pipeline
task.spawn(function()
    while true do
        if activeDealer then
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local dealEvent = remotes and remotes:FindFirstChild("Deal")
            local dealChoiceEvent = remotes and remotes:FindFirstChild("DealChoice")
            
            if dealEvent and dealChoiceEvent then
                local capturedId = nil
                local connection
                
                connection = dealEvent.OnClientEvent:Connect(function(data)
                    if type(data) == "table" and data.Id then
                        capturedId = data.Id
                        if connection then
                            connection:Disconnect()
                            connection = nil
                        end
                    end
                end)
                
                while activeDealer and not capturedId do
                    task.wait(0.1)
                end
                
                if not activeDealer then
                    if connection then connection:Disconnect() end
                    break
                end
                
                for i = 1, 2 do
                    if not activeDealer then break end
                    pcall(function()
                        dealChoiceEvent:FireServer(capturedId, "more")
                    end)
                    task.wait(1)
                end
                
                if activeDealer then
                    pcall(function()
                        dealChoiceEvent:FireServer(capturedId, "accept")
                    end)
                end
                
                task.wait(1)
            else
                task.wait(1)
            end
        else
            task.wait(0.2)
        end
    end
end)

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