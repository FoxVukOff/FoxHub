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

    for i = 1, 18 do
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

        local tween = TweenService:Create(
            particle,
            TweenInfo.new(math.random(50, 90) / 100, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {
                Position = UDim2.new(0, targetX, 0, targetY),
                Rotation = math.random(-360, 360),
                BackgroundTransparency = 1
            }
        )

        tween:Play()

        tween.Completed:Connect(function()
            particle:Destroy()
        end)
    end
end

function ui.applyHoverEffect(frame, defaultColor, hoverColor)
    frame.MouseEnter:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            BackgroundColor3 = hoverColor
        }):Play()
    end)

    frame.MouseLeave:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            BackgroundColor3 = defaultColor
        }):Play()
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
    mainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2 + 10)
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
        Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2),
        BackgroundTransparency = 0
    }):Play()

    TweenService:Create(mainStroke, TweenInfo.new(0.5), {
        Transparency = 0.3
    }):Play()

    TweenService:Create(shadowFrame, TweenInfo.new(0.6), {
        BackgroundTransparency = 0.6
    }):Play()

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

function ui.createScrollingFrame(mainFrame)
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -24, 1, -62)
    container.Position = UDim2.new(0, 12, 0, 54)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
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
        TweenService:Create(switchBg, bgTweenInfo, {
            BackgroundColor3 = Color3.fromRGB(60, 200, 100)
        }):Play()

        TweenService:Create(circle, circTweenInfo, {
            Position = UDim2.new(1, -25, 0.5, -11)
        }):Play()
    else
        TweenService:Create(switchBg, bgTweenInfo, {
            BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        }):Play()

        TweenService:Create(circle, circTweenInfo, {
            Position = UDim2.new(0, 3, 0.5, -11)
        }):Play()
    end
end

function ui.createSubToggleRow(container, name, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = row

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(55, 55, 75)
    stroke.Transparency = 0.65
    stroke.Parent = row

    ui.applyHoverEffect(row, Color3.fromRGB(24, 24, 32), Color3.fromRGB(31, 31, 42))

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(205, 205, 225)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 46, 0, 24)
    switchBg.Position = UDim2.new(1, -58, 0.5, -12)
    switchBg.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    switchBg.BorderSizePixel = 0
    switchBg.Text = ""
    switchBg.AutoButtonColor = false
    switchBg.Parent = row

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBg

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = UDim2.new(0, 3, 0.5, -9)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = switchBg

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    return row, switchBg, circle
end

function ui.setSubToggleState(state, switchBg, circle)
    local bgTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local circTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    if state then
        TweenService:Create(switchBg, bgTweenInfo, {
            BackgroundColor3 = Color3.fromRGB(60, 200, 100)
        }):Play()

        TweenService:Create(circle, circTweenInfo, {
            Position = UDim2.new(1, -21, 0.5, -9)
        }):Play()
    else
        TweenService:Create(switchBg, bgTweenInfo, {
            BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        }):Play()

        TweenService:Create(circle, circTweenInfo, {
            Position = UDim2.new(0, 3, 0.5, -9)
        }):Play()
    end
end

function ui.createWhitelistPanel(container, caption, options, defaultSelection, order, onChange)
    local panel = Instance.new("Frame")
    panel.Name = "WhitelistPanel"
    panel.Size = UDim2.new(1, 0, 0, 0)
    panel.AutomaticSize = Enum.AutomaticSize.Y
    panel.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    panel.BackgroundTransparency = 0.35
    panel.BorderSizePixel = 0
    panel.LayoutOrder = order
    panel.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = panel

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 62)
    stroke.Transparency = 0.65
    stroke.Parent = panel

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = panel

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = panel

    local captionRow = Instance.new("Frame")
    captionRow.Size = UDim2.new(1, 0, 0, 16)
    captionRow.BackgroundTransparency = 1
    captionRow.LayoutOrder = 0
    captionRow.Parent = panel

    local captionLabel = Instance.new("TextLabel")
    captionLabel.Size = UDim2.new(0.6, 0, 1, 0)
    captionLabel.Position = UDim2.new(0, 2, 0, 0)
    captionLabel.BackgroundTransparency = 1
    captionLabel.Text = caption
    captionLabel.TextColor3 = Color3.fromRGB(150, 150, 175)
    captionLabel.TextSize = 11
    captionLabel.Font = Enum.Font.GothamMedium
    captionLabel.TextXAlignment = Enum.TextXAlignment.Left
    captionLabel.Parent = captionRow

    local countLabel = Instance.new("TextLabel")
    countLabel.Size = UDim2.new(0.4, 0, 1, 0)
    countLabel.Position = UDim2.new(0.6, 0, 0, 0)
    countLabel.BackgroundTransparency = 1
    countLabel.Text = ""
    countLabel.TextColor3 = Color3.fromRGB(120, 120, 145)
    countLabel.TextSize = 10
    countLabel.Font = Enum.Font.Gotham
    countLabel.TextXAlignment = Enum.TextXAlignment.Right
    countLabel.Parent = captionRow

    local grid = Instance.new("Frame")
    grid.Size = UDim2.new(1, 0, 0, 0)
    grid.AutomaticSize = Enum.AutomaticSize.Y
    grid.BackgroundTransparency = 1
    grid.LayoutOrder = 1
    grid.Parent = panel

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0.5, -4, 0, 34)
    gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = grid

    local selection = {}

    for _, idx in ipairs(defaultSelection or {}) do
        table.insert(selection, idx)
    end

    local cells = {}

    local function updateVisuals()
        countLabel.Text = #selection .. "/" .. #options

        for i, cellData in ipairs(cells) do
            local selected = table.find(selection, i) ~= nil

            cellData.check.Text = selected and "✓" or ""

            TweenService:Create(cellData.button, TweenInfo.new(0.2), {
                BackgroundColor3 = selected and Color3.fromRGB(38, 38, 56) or Color3.fromRGB(24, 24, 32),
                BackgroundTransparency = selected and 0.15 or 0.45
            }):Play()

            TweenService:Create(cellData.label, TweenInfo.new(0.2), {
                TextColor3 = selected and Color3.fromRGB(215, 215, 235) or Color3.fromRGB(150, 150, 170)
            }):Play()
        end
    end

    for i, option in ipairs(options) do
        local cell = Instance.new("TextButton")
        cell.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        cell.BackgroundTransparency = 0.45
        cell.BorderSizePixel = 0
        cell.AutoButtonColor = false
        cell.Text = ""
        cell.LayoutOrder = i
        cell.Parent = grid

        local cellCorner = Instance.new("UICorner")
        cellCorner.CornerRadius = UDim.new(0, 8)
        cellCorner.Parent = cell

        local check = Instance.new("TextLabel")
        check.Size = UDim2.new(0, 18, 1, 0)
        check.Position = UDim2.new(0, 8, 0, 0)
        check.BackgroundTransparency = 1
        check.Text = ""
        check.TextColor3 = Color3.fromRGB(80, 220, 120)
        check.TextSize = 13
        check.Font = Enum.Font.GothamBold
        check.Parent = cell

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -30, 1, 0)
        label.Position = UDim2.new(0, 26, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = option
        label.TextColor3 = Color3.fromRGB(150, 150, 170)
        label.TextSize = 11
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.Parent = cell

        table.insert(cells, {
            button = cell,
            check = check,
            label = label
        })

        cell.MouseButton1Click:Connect(function()
            local idx = table.find(selection, i)

            if idx then
                table.remove(selection, idx)
            else
                table.insert(selection, i)
            end

            updateVisuals()

            if onChange then
                onChange(selection)
            end
        end)

        cell.MouseEnter:Connect(function()
            if not table.find(selection, i) then
                TweenService:Create(cell, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.25
                }):Play()
            end
        end)

        cell.MouseLeave:Connect(function()
            if not table.find(selection, i) then
                TweenService:Create(cell, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.45
                }):Play()
            end
        end)
    end

    updateVisuals()

    return panel, function()
        return selection
    end
end

function ui.createInputRow(container, name, defaultText, buttonText, order, onApply)
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
    label.Size = UDim2.new(0.55, -12, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 70, 0, 28)
    textBox.Position = UDim2.new(1, -172, 0.5, -14)
    textBox.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    textBox.BorderSizePixel = 0
    textBox.Text = defaultText
    textBox.PlaceholderText = "0"
    textBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 130)
    textBox.TextColor3 = Color3.fromRGB(220, 220, 240)
    textBox.TextSize = 12
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.TextXAlignment = Enum.TextXAlignment.Center
    textBox.Parent = row

    local textCorner = Instance.new("UICorner")
    textCorner.CornerRadius = UDim.new(0, 8)
    textCorner.Parent = textBox

    local textStroke = Instance.new("UIStroke")
    textStroke.Color = Color3.fromRGB(45, 45, 62)
    textStroke.Transparency = 0.35
    textStroke.Parent = textBox

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 76, 0, 28)
    button.Position = UDim2.new(1, -88, 0.5, -14)
    button.BackgroundColor3 = Color3.fromRGB(50, 195, 90)
    button.BackgroundTransparency = 0.16
    button.BorderSizePixel = 0
    button.Text = buttonText
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = row

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.16
        }):Play()
    end)

    button.MouseButton1Click:Connect(function()
        ui.spawnConfetti(button)

        if onApply then
            onApply(textBox.Text)
        end
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and onApply then
            onApply(textBox.Text)
        end
    end)

    return row, textBox, button
end

function ui.createColorSelector(container, caption, colors, defaultIndex, order)
    if not colors or #colors == 0 then
        colors = {
            {
                name = "White",
                color = Color3.fromRGB(240, 240, 240)
            }
        }
    end

    local selector = Instance.new("Frame")
    selector.Name = "ColorSelector"
    selector.Size = UDim2.new(1, 0, 0, 0)
    selector.AutomaticSize = Enum.AutomaticSize.Y
    selector.BackgroundTransparency = 1
    selector.BorderSizePixel = 0
    selector.LayoutOrder = order
    selector.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = selector

    local captionRow = Instance.new("Frame")
    captionRow.Size = UDim2.new(1, 0, 0, 16)
    captionRow.BackgroundTransparency = 1
    captionRow.LayoutOrder = 0
    captionRow.Parent = selector

    local captionLabel = Instance.new("TextLabel")
    captionLabel.Size = UDim2.new(0.6, 0, 1, 0)
    captionLabel.Position = UDim2.new(0, 2, 0, 0)
    captionLabel.BackgroundTransparency = 1
    captionLabel.Text = caption
    captionLabel.TextColor3 = Color3.fromRGB(150, 150, 175)
    captionLabel.TextSize = 11
    captionLabel.Font = Enum.Font.GothamMedium
    captionLabel.TextXAlignment = Enum.TextXAlignment.Left
    captionLabel.Parent = captionRow

    local stateLabel = Instance.new("TextLabel")
    stateLabel.Size = UDim2.new(0.4, 0, 1, 0)
    stateLabel.Position = UDim2.new(0.6, 0, 0, 0)
    stateLabel.BackgroundTransparency = 1
    stateLabel.Text = ""
    stateLabel.TextColor3 = Color3.fromRGB(120, 120, 145)
    stateLabel.TextSize = 10
    stateLabel.Font = Enum.Font.Gotham
    stateLabel.TextXAlignment = Enum.TextXAlignment.Right
    stateLabel.Parent = captionRow

    local grid = Instance.new("Frame")
    grid.Size = UDim2.new(1, 0, 0, 0)
    grid.AutomaticSize = Enum.AutomaticSize.Y
    grid.BackgroundTransparency = 1
    grid.LayoutOrder = 1
    grid.Parent = selector

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0.25, -6, 0, 28)
    gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = grid

    local selected = defaultIndex or 1

    if selected < 1 then
        selected = 1
    end

    if selected > #colors then
        selected = #colors
    end

    local cells = {}

    local function getEntry(index)
        local entry = colors[index]

        if typeof(entry) == "Color3" then
            return {
                name = "Color " .. index,
                color = entry
            }
        end

        return {
            name = entry.name or ("Color " .. index),
            color = entry.color or Color3.new(1, 1, 1)
        }
    end

    local function updateVisuals()
        local entry = getEntry(selected)
        stateLabel.Text = entry.name

        for i, cellData in ipairs(cells) do
            local isSelected = (i == selected)

            cellData.check.Text = isSelected and "✓" or ""

            TweenService:Create(cellData.button, TweenInfo.new(0.18), {
                BackgroundTransparency = isSelected and 0 or 0.28
            }):Play()

            TweenService:Create(cellData.stroke, TweenInfo.new(0.18), {
                Transparency = isSelected and 0 or 0.55,
                Thickness = isSelected and 1.6 or 1
            }):Play()
        end
    end

    for i = 1, #colors do
        local entry = getEntry(i)

        local cell = Instance.new("TextButton")
        cell.BackgroundColor3 = entry.color
        cell.BackgroundTransparency = 0.28
        cell.BorderSizePixel = 0
        cell.AutoButtonColor = false
        cell.Text = ""
        cell.LayoutOrder = i
        cell.Parent = grid

        local cellCorner = Instance.new("UICorner")
        cellCorner.CornerRadius = UDim.new(0, 8)
        cellCorner.Parent = cell

        local cellStroke = Instance.new("UIStroke")
        cellStroke.Color = Color3.fromRGB(235, 235, 255)
        cellStroke.Thickness = 1
        cellStroke.Transparency = 0.55
        cellStroke.Parent = cell

        local brightness = (entry.color.R * 0.299) + (entry.color.G * 0.587) + (entry.color.B * 0.114)

        local check = Instance.new("TextLabel")
        check.Size = UDim2.new(1, 0, 1, 0)
        check.BackgroundTransparency = 1
        check.Text = ""
        check.TextColor3 = brightness > 0.62 and Color3.fromRGB(15, 15, 20) or Color3.fromRGB(245, 245, 255)
        check.TextSize = 14
        check.Font = Enum.Font.GothamBold
        check.Parent = cell

        table.insert(cells, {
            button = cell,
            stroke = cellStroke,
            check = check
        })

        cell.MouseButton1Click:Connect(function()
            selected = i
            updateVisuals()
        end)

        cell.MouseEnter:Connect(function()
            if i ~= selected then
                TweenService:Create(cell, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.12
                }):Play()
            end
        end)

        cell.MouseLeave:Connect(function()
            if i ~= selected then
                TweenService:Create(cell, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.28
                }):Play()
            end
        end)
    end

    updateVisuals()

    return selector, function()
        return getEntry(selected).color
    end
end

function ui.createEspPanel(container, title, colorOptions, defaultColorIndex, order)
    local wrapper = Instance.new("Frame")
    wrapper.Name = "EspPanelWrapper"
    wrapper.Size = UDim2.new(1, 0, 0, 0)
    wrapper.AutomaticSize = Enum.AutomaticSize.Y
    wrapper.BackgroundTransparency = 1
    wrapper.BorderSizePixel = 0
    wrapper.LayoutOrder = order
    wrapper.Parent = container

    local wrapperLayout = Instance.new("UIListLayout")
    wrapperLayout.SortOrder = Enum.SortOrder.LayoutOrder
    wrapperLayout.Padding = UDim.new(0, 8)
    wrapperLayout.Parent = wrapper

    local state = {
        enabled = false,
        model = true,
        boxes = false,
        tracers = false
    }

    local mainRow, mainSwitch, mainCircle = ui.createToggleRow(wrapper, title, 0)

    local options = Instance.new("Frame")
    options.Name = "EspOptions"
    options.Size = UDim2.new(1, 0, 0, 0)
    options.AutomaticSize = Enum.AutomaticSize.Y
    options.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    options.BackgroundTransparency = 0.35
    options.BorderSizePixel = 0
    options.LayoutOrder = 1
    options.Parent = wrapper

    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 12)
    optionsCorner.Parent = options

    local optionsStroke = Instance.new("UIStroke")
    optionsStroke.Color = Color3.fromRGB(45, 45, 62)
    optionsStroke.Transparency = 0.7
    optionsStroke.Parent = options

    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Padding = UDim.new(0, 8)
    optionsLayout.Parent = options

    local optionsPadding = Instance.new("UIPadding")
    optionsPadding.PaddingTop = UDim.new(0, 10)
    optionsPadding.PaddingBottom = UDim.new(0, 10)
    optionsPadding.PaddingLeft = UDim.new(0, 10)
    optionsPadding.PaddingRight = UDim.new(0, 10)
    optionsPadding.Parent = options

    local modelRow, modelSwitch, modelCircle = ui.createSubToggleRow(options, "Model", 0)
    local boxesRow, boxesSwitch, boxesCircle = ui.createSubToggleRow(options, "Boxes", 1)
    local tracersRow, tracersSwitch, tracersCircle = ui.createSubToggleRow(options, "Tracers", 2)
    local colorSelector, getColor = ui.createColorSelector(options, "Color", colorOptions, defaultColorIndex, 3)

    ui.setToggleState(state.enabled, mainSwitch, mainCircle)
    ui.setSubToggleState(state.model, modelSwitch, modelCircle)
    ui.setSubToggleState(state.boxes, boxesSwitch, boxesCircle)
    ui.setSubToggleState(state.tracers, tracersSwitch, tracersCircle)

    mainSwitch.MouseButton1Click:Connect(function()
        state.enabled = not state.enabled
        ui.spawnConfetti(mainSwitch)
        ui.setToggleState(state.enabled, mainSwitch, mainCircle)
    end)

    modelSwitch.MouseButton1Click:Connect(function()
        state.model = not state.model
        ui.spawnConfetti(modelSwitch)
        ui.setSubToggleState(state.model, modelSwitch, modelCircle)
    end)

    boxesSwitch.MouseButton1Click:Connect(function()
        state.boxes = not state.boxes
        ui.spawnConfetti(boxesSwitch)
        ui.setSubToggleState(state.boxes, boxesSwitch, boxesCircle)
    end)

    tracersSwitch.MouseButton1Click:Connect(function()
        state.tracers = not state.tracers
        ui.spawnConfetti(tracersSwitch)
        ui.setSubToggleState(state.tracers, tracersSwitch, tracersCircle)
    end)

    return wrapper, state, getColor
end

return ui