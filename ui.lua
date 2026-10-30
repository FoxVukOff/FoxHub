local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local ui = {}

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function ui.spawnConfetti(parentGui)
    local mouse = player:GetMouse()
    local colors = {
        Color3.fromRGB(255, 80, 120),
        Color3.fromRGB(80, 200, 255),
        Color3.fromRGB(255, 220, 80),
        Color3.fromRGB(120, 255, 150),
        Color3.fromRGB(200, 120, 255)
    }
    local count = 18
    for i = 1, count do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(4, 8), 0, math.random(10, 20))
        particle.BackgroundColor3 = colors[math.random(1, #colors)]
        particle.BorderSizePixel = 0
        particle.ZIndex = 20
        local pCorner = Instance.new("UICorner")
        pCorner.CornerRadius = UDim.new(0, 3)
        pCorner.Parent = particle
        local absPos = parentGui.AbsolutePosition
        local startX = mouse.X - absPos.X
        local startY = mouse.Y - absPos.Y
        particle.Position = UDim2.new(0, startX, 0, startY)
        particle.Parent = parentGui
        local angle = math.rad(math.random(0, 360))
        local speed = math.random(40, 100)
        local targetX = startX + math.cos(angle) * speed
        local targetY = startY + math.sin(angle) * speed + math.random(30, 70)
        local tweenInfo = TweenInfo.new(math.random(50, 90) / 100, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local tween = TweenService:Create(particle, tweenInfo, {
            Position = UDim2.new(0, targetX, 0, targetY),
            Rotation = math.random(-360, 360),
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
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = hoverColor}):Play()
    end)
    frame.MouseLeave:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = defaultColor}):Play()
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
    mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(80, 80, 110)
    mainStroke.Transparency = 1
    mainStroke.Thickness = 1
    mainStroke.Parent = mainFrame

    -- Shadow effect via gradient-like background
    local shadowFrame = Instance.new("Frame")
    shadowFrame.Size = UDim2.new(1, 20, 1, 20)
    shadowFrame.Position = UDim2.new(0, -10, 0, -10)
    shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadowFrame.BackgroundTransparency = 1
    shadowFrame.BorderSizePixel = 0
    shadowFrame.ZIndex = -1
    shadowFrame.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 20)
    shadowCorner.Parent = shadowFrame

    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(mainStroke, TweenInfo.new(0.5), {Transparency = 0.3}):Play()
    TweenService:Create(shadowFrame, TweenInfo.new(0.6), {BackgroundTransparency = 0.6}):Play()

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 46)
    header.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 16)
    headerCorner.Parent = header

    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 26))
    })
    headerGradient.Rotation = 45
    headerGradient.Parent = header

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 12)
    headerFix.Position = UDim2.new(0, 0, 1, -12)
    headerFix.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(240, 240, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 220))
    })
    titleGradient.Parent = title

    return screenGui, mainFrame, header
end

function ui.addCloseButton(header, mainFrame, screenGui)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 90)
    closeBtn.BackgroundTransparency = 0.8
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        ui.spawnConfetti(closeBtn)
        TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.35)
        screenGui:Destroy()
    end)

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 30, 0, 30)
        }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.8,
            Size = UDim2.new(0, 28, 0, 28)
        }):Play()
    end)
    
    return closeBtn
end

function ui.createScrollingFrame(mainFrame, canvasSize)
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -24, 1, -62)
    container.Position = UDim2.new(0, 12, 0, 54)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.CanvasSize = UDim2.new(0, 0, 0, canvasSize)
    container.ScrollBarThickness = 3
    container.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
    container.Parent = mainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = container

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = container

    -- Auto-resize canvas
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end)

    return container
end

function ui.createToggleRow(container, name, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = row

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 70)
    stroke.Transparency = 0.5
    stroke.Parent = row

    ui.applyHoverEffect(row, Color3.fromRGB(20, 20, 28), Color3.fromRGB(28, 28, 38))

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 56, 0, 28)
    switchBg.Position = UDim2.new(1, -68, 0.5, -14)
    switchBg.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    switchBg.BorderSizePixel = 0
    switchBg.Text = ""
    switchBg.AutoButtonColor = false
    switchBg.Parent = row

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBg

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 22, 0, 22)
    circle.Position = UDim2.new(0, 3, 0.5, -11)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = switchBg

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    return row, switchBg, circle
end

function ui.setToggleState(state, switchBg, circle)
    local bgTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local circTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    if state then
        TweenService:Create(switchBg, bgTweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 200, 100)}):Play()
        TweenService:Create(circle, circTweenInfo, {Position = UDim2.new(1, -25, 0.5, -11)}):Play()
    else
        TweenService:Create(switchBg, bgTweenInfo, {BackgroundColor3 = Color3.fromRGB(180, 50, 50)}):Play()
        TweenService:Create(circle, circTweenInfo, {Position = UDim2.new(0, 3, 0.5, -11)}):Play()
    end
end

function ui.createSettingsRow(container, name, order, onClick)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    row.BackgroundTransparency = 0.4
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = row

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 24, 1, 0)
    icon.Position = UDim2.new(0, 12, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "⚙"
    icon.TextColor3 = Color3.fromRGB(140, 140, 180)
    icon.TextSize = 14
    icon.Font = Enum.Font.Gotham
    icon.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(170, 170, 200)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 24, 1, 0)
    arrow.Position = UDim2.new(1, -32, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(140, 140, 180)
    arrow.TextSize = 12
    arrow.Font = Enum.Font.GothamBold
    arrow.Rotation = 0
    arrow.Parent = btn

    btn.MouseButton1Click:Connect(function()
        onClick()
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 42)}):Play()
        TweenService:Create(icon, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 255)}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 90}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 28)}):Play()
        TweenService:Create(icon, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(140, 140, 180)}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
    end)

    return row, arrow
end

function ui.createDropdown(container, label, options, isMultiSelect, defaultSelection, order, onChange)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 52)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.LayoutOrder = order
    dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    dropdownFrame.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = dropdownFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 70)
    stroke.Transparency = 0.5
    stroke.Parent = dropdownFrame
    
    -- Header button
    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 52)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.AutoButtonColor = false
    headerBtn.Parent = dropdownFrame
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.4, 0, 1, 0)
    labelText.Position = UDim2.new(0, 16, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(220, 220, 240)
    labelText.TextSize = 13
    labelText.Font = Enum.Font.GothamMedium
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = headerBtn
    
    local valueText = Instance.new("TextLabel")
    valueText.Size = UDim2.new(0.4, 0, 1, 0)
    valueText.Position = UDim2.new(0.4, 0, 0, 0)
    valueText.BackgroundTransparency = 1
    valueText.Text = "None"
    valueText.TextColor3 = Color3.fromRGB(140, 140, 170)
    valueText.TextSize = 11
    valueText.Font = Enum.Font.Gotham
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.TextTruncate = Enum.TextTruncate.AtEnd
    valueText.Parent = headerBtn
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 24, 1, 0)
    arrow.Position = UDim2.new(1, -32, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(140, 140, 170)
    arrow.TextSize = 12
    arrow.Font = Enum.Font.GothamBold
    arrow.Rotation = 0
    arrow.Parent = headerBtn
    
    -- Panel
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(1, -16, 0, 0)
    panel.Position = UDim2.new(0, 8, 0, 52)
    panel.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Visible = false
    panel.Parent = dropdownFrame
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 10)
    panelCorner.Parent = panel
    
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(50, 50, 70)
    panelStroke.Transparency = 0.3
    panelStroke.Parent = panel
    
    local panelLayout = Instance.new("UIListLayout")
    panelLayout.SortOrder = Enum.SortOrder.LayoutOrder
    panelLayout.Padding = UDim.new(0, 4)
    panelLayout.Parent = panel
    
    local panelPadding = Instance.new("UIPadding")
    panelPadding.PaddingTop = UDim.new(0, 8)
    panelPadding.PaddingBottom = UDim.new(0, 8)
    panelPadding.PaddingLeft = UDim.new(0, 8)
    panelPadding.PaddingRight = UDim.new(0, 8)
    panelPadding.Parent = panel
    
    local isOpen = false
    local selection = defaultSelection or {}
    if not isMultiSelect and type(selection) ~= "table" and selection then
        selection = {selection}
    end
    
    local optionButtons = {}
    
    local function updateValueText()
        local labels = {}
        for _, opt in ipairs(options) do
            local idx = tonumber(string.match(opt, "^#(%d+)"))
            if idx and table.find(selection, idx) then
                table.insert(labels, opt)
            elseif table.find(selection, opt) then
                table.insert(labels, opt)
            end
        end
        if #labels == 0 then
            valueText.Text = "None"
        elseif #labels <= 2 then
            valueText.Text = table.concat(labels, ", ")
        else
            valueText.Text = string.format("%d selected", #labels)
        end
    end
    
    for i, option in ipairs(options) do
        local isSelected = table.find(selection, i) ~= nil
        
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 36)
        optBtn.BackgroundColor3 = isSelected and Color3.fromRGB(35, 35, 55) or Color3.fromRGB(22, 22, 32)
        optBtn.BorderSizePixel = 0
        optBtn.Text = ""
        optBtn.LayoutOrder = i
        optBtn.AutoButtonColor = false
        optBtn.Parent = panel
        
        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 8)
        optCorner.Parent = optBtn
        
        local optLabel = Instance.new("TextLabel")
        optLabel.Size = UDim2.new(1, -50, 1, 0)
        optLabel.Position = UDim2.new(0, 14, 0, 0)
        optLabel.BackgroundTransparency = 1
        optLabel.Text = option
        optLabel.TextColor3 = Color3.fromRGB(210, 210, 230)
        optLabel.TextSize = 12
        optLabel.Font = Enum.Font.Gotham
        optLabel.TextXAlignment = Enum.TextXAlignment.Left
        optLabel.Parent = optBtn
        
        local check = Instance.new("TextLabel")
        check.Size = UDim2.new(0, 24, 1, 0)
        check.Position = UDim2.new(1, -36, 0, 0)
        check.BackgroundTransparency = 1
        check.Text = isSelected and "✓" or ""
        check.TextColor3 = Color3.fromRGB(80, 220, 120)
        check.TextSize = 16
        check.Font = Enum.Font.GothamBold
        check.Parent = optBtn
        
        optBtn.MouseButton1Click:Connect(function()
            if isMultiSelect then
                local idx = table.find(selection, i)
                if idx then
                    table.remove(selection, idx)
                    TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 32)}):Play()
                    check.Text = ""
                else
                    table.insert(selection, i)
                    TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}):Play()
                    check.Text = "✓"
                end
            else
                selection = {i}
                for j, btnData in ipairs(optionButtons) do
                    TweenService:Create(btnData.button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 32)}):Play()
                    btnData.check.Text = ""
                end
                TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}):Play()
                check.Text = "✓"
            end
            updateValueText()
            if onChange then onChange(selection) end
        end)
        
        optBtn.MouseEnter:Connect(function()
            if not table.find(selection, i) then
                TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 42)}):Play()
            end
        end)
        optBtn.MouseLeave:Connect(function()
            if not table.find(selection, i) then
                TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 32)}):Play()
            end
        end)
        
        table.insert(optionButtons, {button = optBtn, check = check})
    end
    
    panelLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isOpen then
            panel.Size = UDim2.new(1, -16, 0, panelLayout.AbsoluteContentSize.Y + 16)
        end
    end)
    
    updateValueText()
    
    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            panel.Visible = true
            TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -16, 0, panelLayout.AbsoluteContentSize.Y + 16)
            }):Play()
            TweenService:Create(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Rotation = 180}):Play()
            TweenService:Create(dropdownFrame, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(24, 24, 34)
            }):Play()
        else
            TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(1, -16, 0, 0)
            }):Play()
            TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 0}):Play()
            TweenService:Create(dropdownFrame, TweenInfo.new(0.25), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 28)
            }):Play()
            task.delay(0.25, function()
                if not isOpen then
                    panel.Visible = false
                end
            end)
        end
    end)
    
    headerBtn.MouseEnter:Connect(function()
        if not isOpen then
            TweenService:Create(dropdownFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(26, 26, 36)
            }):Play()
        end
    end)
    headerBtn.MouseLeave:Connect(function()
        if not isOpen then
            TweenService:Create(dropdownFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 28)
            }):Play()
        end
    end)
    
    return dropdownFrame, function() return selection end
end

return ui