local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local ui = {}

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function ui.spawnConfetti(parentGui)
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

function ui.applyHoverEffect(frame, defaultColor, hoverColor)
    frame.MouseEnter:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    frame.MouseLeave:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
    end)
end

function ui.createWindow(guiName, titleText, windowSize)
    if playerGui:FindFirstChild(guiName) then
        playerGui[guiName]:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = guiName
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = windowSize
    mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2 + 10)
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

    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(mainStroke, TweenInfo.new(0.4), {Transparency = 0.2}):Play()

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
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(240, 240, 255)
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    return screenGui, mainFrame, header
end

function ui.addCloseButton(header, mainFrame, screenGui)
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

    closeBtn.MouseButton1Click:Connect(function()
        ui.spawnConfetti(closeBtn)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        screenGui:Destroy()
    end)

    ui.applyHoverEffect(closeBtn, Color3.fromRGB(30, 30, 40), Color3.fromRGB(50, 50, 65))
    
    return closeBtn
end

function ui.createScrollingFrame(mainFrame, canvasSize)
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -20, 1, -58)
    container.Position = UDim2.new(0, 10, 0, 50)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.CanvasSize = UDim2.new(0, 0, 0, canvasSize)
    container.ScrollBarThickness = 3
    container.Parent = mainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = container

    return container
end

function ui.createToggleRow(container, name, order)
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

    ui.applyHoverEffect(row, Color3.fromRGB(18, 18, 24), Color3.fromRGB(24, 24, 34))

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

function ui.setToggleState(state, switchBg, circle)
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

return ui