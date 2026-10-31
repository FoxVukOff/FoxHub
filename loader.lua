local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/FoxVukOff/FoxHub/refs/heads/main/ui.lua"))()
local TweenService = game:GetService("TweenService")

local screenGui, mainFrame, header = ui.createWindow("FoxHubLoaderGui", "🦊 FoxHub - Loader", UDim2.new(0, 340, 0, 190))

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 40)
statusLabel.Position = UDim2.new(0, 20, 0, 62)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Checking game database..."
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, -40, 0, 6)
barBg.Position = UDim2.new(0, 20, 1, -40)
barBg.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
barBg.BorderSizePixel = 0
barBg.Parent = mainFrame

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(50, 195, 90)
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

local barGradient = Instance.new("UIGradient")
barGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 170, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 235, 140))
})
barGradient.Parent = barFill

task.spawn(function()
    TweenService:Create(barFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.6, 0, 1, 0)
    }):Play()

    task.wait(1)

    local supportedGames = {
        [78567276888799] = "78567276888799.lua",
        [91698952875688] = "91698952875688.lua"
    }

    local scriptFile = supportedGames[game.PlaceId]

    if scriptFile then
        statusLabel.Text = "Game found! Loading script..."

        TweenService:Create(barFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0)
        }):Play()

        task.wait(0.6)

        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()

        task.wait(0.3)
        screenGui:Destroy()

        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FoxVukOff/FoxHub/refs/heads/main/" .. scriptFile))()
        end)

        if not success then
            warn("FoxHub Error executing script: " .. tostring(err))
        end
    else
        statusLabel.Text = "Current game is not in the database! Closing in 5 seconds..."
        statusLabel.TextColor3 = Color3.fromRGB(220, 70, 70)

        barGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 40, 40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 90, 90))
        })

        TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0)
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