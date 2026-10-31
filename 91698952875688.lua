local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/FoxVukOff/FoxHub/refs/heads/main/ui.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local screenGui, mainFrame, header = ui.createWindow(
    "FoxHubBahkruumsGui",
    "🦊 FoxHub - Bahkruums",
    UDim2.new(0, 360, 0, 560)
)

ui.addCloseButton(header, mainFrame, screenGui)

local container = ui.createScrollingFrame(mainFrame)

local speedValue = 0
local espClark = false
local espPlayers = false
local espClarkPlayers = false
local tracersEnabled = false
local guiOpen = true

local speedBox
local speedRow, speedApply

speedRow, speedBox, speedApply = ui.createInputRow(container, "Speed", "0", "Apply", 1, function(text)
    local cleaned = tostring(text):gsub(",", "."):gsub("%s+", "")
    local value = tonumber(cleaned)

    if not value then
        value = 0
    end

    if value < 0 then
        value = 0
    end

    speedValue = value

    if speedBox then
        speedBox.Text = tostring(value)
    end
end)

local rowClark, swClark, circClark = ui.createToggleRow(container, "Clark ESP", 2)
local rowPlayers, swPlayers, circPlayers = ui.createToggleRow(container, "Players ESP", 3)
local rowClarkPlayers, swClarkPlayers, circClarkPlayers = ui.createToggleRow(container, "Clark Players ESP", 4)
local rowTracers, swTracers, circTracers = ui.createToggleRow(container, "Tracers", 5)

swClark.MouseButton1Click:Connect(function()
    ui.spawnConfetti(swClark)
    espClark = not espClark
    ui.setToggleState(espClark, swClark, circClark)
end)

swPlayers.MouseButton1Click:Connect(function()
    ui.spawnConfetti(swPlayers)
    espPlayers = not espPlayers
    ui.setToggleState(espPlayers, swPlayers, circPlayers)
end)

swClarkPlayers.MouseButton1Click:Connect(function()
    ui.spawnConfetti(swClarkPlayers)
    espClarkPlayers = not espClarkPlayers
    ui.setToggleState(espClarkPlayers, swClarkPlayers, circClarkPlayers)
end)

swTracers.MouseButton1Click:Connect(function()
    ui.spawnConfetti(swTracers)
    tracersEnabled = not tracersEnabled
    ui.setToggleState(tracersEnabled, swTracers, circTracers)
end)

local colorOptions = {
    {name = "Green", color = Color3.fromRGB(80, 255, 140)},
    {name = "Red", color = Color3.fromRGB(255, 80, 80)},
    {name = "Blue", color = Color3.fromRGB(90, 160, 255)},
    {name = "Yellow", color = Color3.fromRGB(255, 220, 80)},
    {name = "Purple", color = Color3.fromRGB(200, 120, 255)},
    {name = "Cyan", color = Color3.fromRGB(80, 230, 230)},
    {name = "Orange", color = Color3.fromRGB(255, 150, 70)},
    {name = "White", color = Color3.fromRGB(240, 240, 240)}
}

local colorPanel, getESPColor = ui.createColorPanel(container, "ESP Color", colorOptions, 1, 6)

local heldKeys = {
    W = false,
    A = false,
    S = false,
    D = false
}

local function updateKey(input, state)
    if input.KeyCode == Enum.KeyCode.W then
        heldKeys.W = state
    elseif input.KeyCode == Enum.KeyCode.A then
        heldKeys.A = state
    elseif input.KeyCode == Enum.KeyCode.S then
        heldKeys.S = state
    elseif input.KeyCode == Enum.KeyCode.D then
        heldKeys.D = state
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    updateKey(input, true)

    if speedValue > 0 and input.KeyCode == Enum.KeyCode.Space then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            pcall(function()
                humanoid.Jump = true
            end)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    updateKey(input, false)
end)

local function getCamera()
    local camera = workspace.CurrentCamera

    if not camera then
        camera = workspace:FindFirstChildOfClass("Camera")
    end

    return camera
end

local function getInputDirection()
    local camera = getCamera()

    if not camera then
        return Vector3.zero
    end

    local forward = camera.CFrame.LookVector
    forward = Vector3.new(forward.X, 0, forward.Z)

    if forward.Magnitude > 0.001 then
        forward = forward.Unit
    else
        forward = Vector3.new(0, 0, -1)
    end

    local right = camera.CFrame.RightVector
    right = Vector3.new(right.X, 0, right.Z)

    if right.Magnitude > 0.001 then
        right = right.Unit
    else
        right = Vector3.new(1, 0, 0)
    end

    local direction = Vector3.zero

    if heldKeys.W then
        direction = direction + forward
    end

    if heldKeys.S then
        direction = direction - forward
    end

    if heldKeys.D then
        direction = direction + right
    end

    if heldKeys.A then
        direction = direction - right
    end

    if direction.Magnitude > 0.001 then
        return direction.Unit
    end

    return Vector3.zero
end

local function safeMoveRoot(root, character, step)
    local remaining = step
    local maxChunk = 10
    local guard = 0

    while remaining.Magnitude > 0.02 and guard < 8 do
        guard = guard + 1

        local chunk = remaining

        if chunk.Magnitude > maxChunk then
            chunk = remaining.Unit * maxChunk
        end

        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {character}
        params.FilterType = Enum.RaycastFilterType.Exclude

        local ok, ray = pcall(function()
            return workspace:Raycast(root.Position, chunk, params)
        end)

        if ok and ray then
            local corrected = (ray.Position - root.Position) + ray.Normal * 0.25
            chunk = Vector3.new(corrected.X, 0, corrected.Z)

            if chunk.Magnitude < 0.05 then
                break
            end
        end

        pcall(function()
            root.CFrame = root.CFrame + chunk
        end)

        remaining = remaining - chunk
    end
end

local heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
    if not guiOpen then
        return
    end

    if speedValue <= 0 then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("UpperTorso")

    if not humanoid or not root or humanoid.Health <= 0 then
        return
    end

    local direction = humanoid.MoveDirection

    if not direction or direction.Magnitude < 0.05 then
        direction = getInputDirection()
    end

    direction = Vector3.new(direction.X, 0, direction.Z)

    if direction.Magnitude < 0.05 then
        return
    end

    direction = direction.Unit

    local velocity = root.AssemblyLinearVelocity or Vector3.zero
    local horizontalVelocity = Vector3.new(velocity.X, 0, velocity.Z)
    local missingSpeed = speedValue - horizontalVelocity.Magnitude

    if missingSpeed <= 0.05 then
        return
    end

    local step = direction * math.min(missingSpeed, speedValue) * deltaTime

    if step.Magnitude < 0.001 then
        return
    end

    safeMoveRoot(root, character, step)
end)

local drawingSupported = (type(Drawing) == "table" and type(Drawing.new) == "function")

if not drawingSupported then
    local warnLabel = Instance.new("TextLabel")
    warnLabel.Size = UDim2.new(1, 0, 0, 40)
    warnLabel.BackgroundTransparency = 1
    warnLabel.Text = "ESP unavailable: executor does not support Drawing."
    warnLabel.TextColor3 = Color3.fromRGB(220, 70, 70)
    warnLabel.TextSize = 12
    warnLabel.Font = Enum.Font.GothamMedium
    warnLabel.TextWrapped = true
    warnLabel.LayoutOrder = 99
    warnLabel.Parent = container
end

local linePool = {}

local function acquireLine(index)
    local line = linePool[index]

    if not line then
        line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1.3
        line.Transparency = 1
        linePool[index] = line
    end

    line.Visible = true

    return line
end

local function hideLinesAfter(index)
    for i = index + 1, #linePool do
        linePool[i].Visible = false
    end
end

local boxOffsets = {
    Vector3.new(-1, -1, -1),
    Vector3.new(1, -1, -1),
    Vector3.new(1, -1, 1),
    Vector3.new(-1, -1, 1),
    Vector3.new(-1, 1, -1),
    Vector3.new(1, 1, -1),
    Vector3.new(1, 1, 1),
    Vector3.new(-1, 1, 1)
}

local boxEdges = {
    {1, 2},
    {2, 3},
    {3, 4},
    {4, 1},
    {5, 6},
    {6, 7},
    {7, 8},
    {8, 5},
    {1, 5},
    {2, 6},
    {3, 7},
    {4, 8}
}

local function getModelCorners(object)
    if not object or not object.Parent then
        return nil, nil
    end

    if object:IsA("Model") then
        local ok, cf, size = pcall(function()
            return object:GetBoundingBox()
        end)

        if ok and cf and size and size.Magnitude > 0 then
            return cf, size
        end

        return nil, nil
    elseif object:IsA("BasePart") then
        return object.CFrame, object.Size
    end

    return nil, nil
end

local function collectTargets()
    local targets = {}

    if espClark then
        local liveAI = workspace:FindFirstChild("LiveAI")
        local clark = liveAI and liveAI:FindFirstChild("Clark")

        if clark then
            table.insert(targets, clark)
        end
    end

    if espPlayers then
        local live = workspace:FindFirstChild("Live")

        if live then
            for _, child in ipairs(live:GetChildren()) do
                if child:IsA("Model") or child:IsA("BasePart") then
                    table.insert(targets, child)
                end
            end
        end
    end

    if espClarkPlayers then
        local liveClark = workspace:FindFirstChild("LiveClark")

        if liveClark then
            for _, child in ipairs(liveClark:GetChildren()) do
                if child:IsA("Model") or child:IsA("BasePart") then
                    table.insert(targets, child)
                end
            end
        end
    end

    return targets
end

local renderConnection = RunService.RenderStepped:Connect(function()
    if not guiOpen then
        hideLinesAfter(0)
        return
    end

    if not drawingSupported then
        hideLinesAfter(0)
        return
    end

    local camera = getCamera()

    if not camera then
        hideLinesAfter(0)
        return
    end

    local lineIndex = 0
    local color = getESPColor()
    local targets = collectTargets()

    for _, object in ipairs(targets) do
        local cf, size = getModelCorners(object)

        if cf and size and size.Magnitude > 0 then
            local half = size * 0.5
            local screenPoints = {}
            local visible = true

            for i, offset in ipairs(boxOffsets) do
                local worldPosition = (cf * CFrame.new(
                    half.X * offset.X,
                    half.Y * offset.Y,
                    half.Z * offset.Z
                )).Position

                local viewport = camera:WorldToViewportPoint(worldPosition)

                if viewport.Z <= 0 then
                    visible = false
                    break
                end

                screenPoints[i] = Vector2.new(viewport.X, viewport.Y)
            end

            if visible then
                for _, edge in ipairs(boxEdges) do
                    lineIndex = lineIndex + 1

                    local line = acquireLine(lineIndex)
                    line.From = screenPoints[edge[1]]
                    line.To = screenPoints[edge[2]]
                    line.Color = color
                    line.Thickness = 1.4
                end

                if tracersEnabled then
                    local bottomPosition = (cf * CFrame.new(0, -half.Y, 0)).Position
                    local bottomViewport = camera:WorldToViewportPoint(bottomPosition)

                    if bottomViewport.Z > 0 then
                        lineIndex = lineIndex + 1

                        local tracer = acquireLine(lineIndex)
                        local viewportSize = camera.ViewportSize

                        tracer.From = Vector2.new(viewportSize.X * 0.5, viewportSize.Y)
                        tracer.To = Vector2.new(bottomViewport.X, bottomViewport.Y)
                        tracer.Color = color
                        tracer.Thickness = 1.2
                    end
                end
            end
        end
    end

    hideLinesAfter(lineIndex)
end)

pcall(function()
    screenGui.Destroying:Connect(function()
        guiOpen = false
        speedValue = 0
        espClark = false
        espPlayers = false
        espClarkPlayers = false
        tracersEnabled = false

        if heartbeatConnection then
            heartbeatConnection:Disconnect()
        end

        if renderConnection then
            renderConnection:Disconnect()
        end

        hideLinesAfter(0)
    end)
end)