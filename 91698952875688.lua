local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/FoxVukOff/FoxHub/refs/heads/main/ui.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local screenGui, mainFrame, header = ui.createWindow(
    "FoxHubBahkruumsGui",
    "🦊 FoxHub - Bahkruums",
    UDim2.new(0, 360, 0, 640)
)

ui.addCloseButton(header, mainFrame, screenGui)

local container = ui.createScrollingFrame(mainFrame)

local speedValue = 0
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

local clarkPanel, clarkState, getClarkColor = ui.createEspPanel(container, "Clark ESP", colorOptions, 2, 2)
local playersPanel, playersState, getPlayersColor = ui.createEspPanel(container, "Players ESP", colorOptions, 1, 3)
local clarkPlayersPanel, clarkPlayersState, getClarkPlayersColor = ui.createEspPanel(container, "Clark Players ESP", colorOptions, 5, 4)

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
    local maxChunk = 20
    local guard = 0

    while remaining.Magnitude > 0.02 and guard < 12 do
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

local drawingSupported = false
local triangleSupported = false

pcall(function()
    local testLine = Drawing.new("Line")
    testLine.Visible = false
    drawingSupported = true

    pcall(function()
        local testTriangle = Drawing.new("Triangle")
        testTriangle.Visible = false
        triangleSupported = true
    end)
end)

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
local trianglePool = {}

local currentLineIndex = 0
local currentTriangleIndex = 0

local function acquireLine(index)
    local line = linePool[index]

    if not line then
        line = Drawing.new("Line")
        line.Visible = false
        linePool[index] = line
    end

    line.Visible = true

    return line
end

local function acquireTriangle(index)
    local triangle = trianglePool[index]

    if not triangle then
        triangle = Drawing.new("Triangle")
        triangle.Visible = false
        trianglePool[index] = triangle
    end

    triangle.Visible = true

    return triangle
end

local function hideLinesAfter(index)
    for i = index + 1, #linePool do
        linePool[i].Visible = false
    end
end

local function hideTrianglesAfter(index)
    for i = index + 1, #trianglePool do
        trianglePool[i].Visible = false
    end
end

local function acquireCurrentLine()
    currentLineIndex = currentLineIndex + 1
    return acquireLine(currentLineIndex)
end

local function acquireCurrentTriangle()
    currentTriangleIndex = currentTriangleIndex + 1
    return acquireTriangle(currentTriangleIndex)
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

local boxFaces = {
    {1, 2, 3, 4},
    {5, 6, 7, 8},
    {1, 2, 6, 5},
    {2, 3, 7, 6},
    {3, 4, 8, 7},
    {4, 1, 5, 8}
}

local function getScreenCorners(cf, size, camera)
    local half = size * 0.5
    local screenPoints = {}

    for i, offset in ipairs(boxOffsets) do
        local worldPosition = (cf * CFrame.new(
            half.X * offset.X,
            half.Y * offset.Y,
            half.Z * offset.Z
        )).Position

        local viewport = camera:WorldToViewportPoint(worldPosition)

        if viewport.Z <= 0 then
            return nil
        end

        screenPoints[i] = Vector2.new(viewport.X, viewport.Y)
    end

    return screenPoints
end

local function drawPartHighlight(part, camera, color, useFill)
    if not part or not part.Parent then
        return
    end

    local size = part.Size

    if not size or size.Magnitude <= 0 then
        return
    end

    local screenPoints = getScreenCorners(part.CFrame, size, camera)

    if not screenPoints then
        return
    end

    if useFill then
        for _, face in ipairs(boxFaces) do
            local a = screenPoints[face[1]]
            local b = screenPoints[face[2]]
            local c = screenPoints[face[3]]
            local d = screenPoints[face[4]]

            local tri1 = acquireCurrentTriangle()
            tri1.PointA = a
            tri1.PointB = b
            tri1.PointC = c
            tri1.Color = color
            tri1.Transparency = 0.42

            local tri2 = acquireCurrentTriangle()
            tri2.PointA = a
            tri2.PointB = c
            tri2.PointC = d
            tri2.Color = color
            tri2.Transparency = 0.42
        end
    end

    for _, edge in ipairs(boxEdges) do
        local line = acquireCurrentLine()
        line.From = screenPoints[edge[1]]
        line.To = screenPoints[edge[2]]
        line.Color = color
        line.Thickness = 1.5
        line.Transparency = 1
    end
end

local function getObjectBoundingData(object)
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

local function drawBoundingBox(object, camera, color)
    local cf, size = getObjectBoundingData(object)

    if not cf or not size or size.Magnitude <= 0 then
        return
    end

    local screenPoints = getScreenCorners(cf, size, camera)

    if not screenPoints then
        return
    end

    for _, edge in ipairs(boxEdges) do
        local line = acquireCurrentLine()
        line.From = screenPoints[edge[1]]
        line.To = screenPoints[edge[2]]
        line.Color = color
        line.Thickness = 1.1
        line.Transparency = 1
    end
end

local function drawTracer(object, camera, color)
    local cf, size = getObjectBoundingData(object)

    if not cf or not size or size.Magnitude <= 0 then
        return
    end

    local bottomPosition = (cf * CFrame.new(0, -size.Y / 2, 0)).Position
    local bottomViewport = camera:WorldToViewportPoint(bottomPosition)

    if bottomViewport.Z <= 0 then
        return
    end

    local viewportSize = camera.ViewportSize

    local line = acquireCurrentLine()
    line.From = Vector2.new(viewportSize.X * 0.5, viewportSize.Y)
    line.To = Vector2.new(bottomViewport.X, bottomViewport.Y)
    line.Color = color
    line.Thickness = 1.3
    line.Transparency = 1
end

local partCache = {}

local function getObjectParts(object, maxParts)
    if not object or not object.Parent then
        return {}
    end

    local now = tick()
    local cached = partCache[object]

    if cached and cached.time > now - 0.75 then
        return cached.parts
    end

    local parts = {}

    if object:IsA("BasePart") then
        table.insert(parts, object)
    elseif object:IsA("Model") then
        for _, desc in ipairs(object:GetDescendants()) do
            if #parts >= maxParts then
                break
            end

            if desc:IsA("BasePart") then
                local ok, transparency = pcall(function()
                    return desc.Transparency
                end)

                if ok and transparency < 0.95 then
                    table.insert(parts, desc)
                end
            end
        end
    end

    partCache[object] = {
        parts = parts,
        time = now
    }

    return parts
end

local function getClarkTargets()
    local targets = {}
    local liveAI = workspace:FindFirstChild("LiveAI")
    local clark = liveAI and liveAI:FindFirstChild("Clark")

    if clark then
        table.insert(targets, clark)
    end

    return targets
end

local function getLiveTargets()
    local targets = {}
    local live = workspace:FindFirstChild("Live")

    if live then
        for _, child in ipairs(live:GetChildren()) do
            if child:IsA("Model") or child:IsA("BasePart") then
                table.insert(targets, child)
            end
        end
    end

    return targets
end

local function getLiveClarkTargets()
    local targets = {}
    local liveClark = workspace:FindFirstChild("LiveClark")

    if liveClark then
        for _, child in ipairs(liveClark:GetChildren()) do
            if child:IsA("Model") or child:IsA("BasePart") then
                table.insert(targets, child)
            end
        end
    end

    return targets
end

local categories = {
    {
        state = clarkState,
        getColor = getClarkColor,
        getTargets = getClarkTargets,
        maxParts = 70,
        maxFillParts = 20
    },
    {
        state = playersState,
        getColor = getPlayersColor,
        getTargets = getLiveTargets,
        maxParts = 35,
        maxFillParts = 14
    },
    {
        state = clarkPlayersState,
        getColor = getClarkPlayersColor,
        getTargets = getLiveClarkTargets,
        maxParts = 35,
        maxFillParts = 14
    }
}

local renderConnection = RunService.RenderStepped:Connect(function()
    if not guiOpen then
        hideLinesAfter(0)
        hideTrianglesAfter(0)
        return
    end

    if not drawingSupported then
        hideLinesAfter(0)
        hideTrianglesAfter(0)
        return
    end

    local camera = getCamera()

    if not camera then
        hideLinesAfter(0)
        hideTrianglesAfter(0)
        return
    end

    currentLineIndex = 0
    currentTriangleIndex = 0

    for _, category in ipairs(categories) do
        if category.state.enabled then
            local color = category.getColor()
            local targets = category.getTargets()

            for _, object in ipairs(targets) do
                if category.state.model then
                    local parts = getObjectParts(object, category.maxParts)
                    local useFill = triangleSupported and #parts <= category.maxFillParts

                    for _, part in ipairs(parts) do
                        drawPartHighlight(part, camera, color, useFill)
                    end
                end

                if category.state.boxes then
                    drawBoundingBox(object, camera, color)
                end

                if category.state.tracers then
                    drawTracer(object, camera, color)
                end
            end
        end
    end

    hideLinesAfter(currentLineIndex)
    hideTrianglesAfter(currentTriangleIndex)
end)

pcall(function()
    screenGui.Destroying:Connect(function()
        guiOpen = false
        speedValue = 0

        if heartbeatConnection then
            heartbeatConnection:Disconnect()
        end

        if renderConnection then
            renderConnection:Disconnect()
        end

        hideLinesAfter(0)
        hideTrianglesAfter(0)
    end)
end)