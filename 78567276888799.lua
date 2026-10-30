local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/FoxVukOff/FoxHub/refs/heads/main/ui.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local screenGui, mainFrame, header = ui.createWindow("FoxHubSellGui", "🦊 FoxHub - Sell Veritys", UDim2.new(0, 360, 0, 540))
ui.addCloseButton(header, mainFrame, screenGui)

local container = ui.createScrollingFrame(mainFrame)

local whitelistOptions = {"#1 (Verity Stand)", "#2 (Verity Truck)", "#3 (Verity Shop)", "#4 (Verity Depot)"}

-- Auto Tap + whitelist
local rowTap, swTap, circTap = ui.createToggleRow(container, "Auto Tap", 1)
local getTapSelection = ui.createWhitelistPanel(container, "Tap Whitelist", whitelistOptions, {1, 2, 3, 4}, 2)

-- Auto Upgrade + whitelist
local rowUpg, swUpg, circUpg = ui.createToggleRow(container, "Auto Upgrade", 3)
local getUpgradeSelection = ui.createWhitelistPanel(container, "Upgrade Whitelist", whitelistOptions, {1, 2, 3, 4}, 4)

-- Auto Dealer
local rowDealer, swDealer, circDealer = ui.createToggleRow(container, "Auto Dealer", 5)

local activeTap = false
local activeUpgrade = false
local activeDealer = false

swTap.MouseButton1Click:Connect(function()
    ui.spawnConfetti(swTap)
    activeTap = not activeTap
    ui.setToggleState(activeTap, swTap, circTap)
end)

swUpg.MouseButton1Click:Connect(function()
    ui.spawnConfetti(swUpg)
    activeUpgrade = not activeUpgrade
    ui.setToggleState(activeUpgrade, swUpg, circUpg)
end)

swDealer.MouseButton1Click:Connect(function()
    ui.spawnConfetti(swDealer)
    activeDealer = not activeDealer
    ui.setToggleState(activeDealer, swDealer, circDealer)
end)

-- Auto Tap Logic (slower, sequential, whitelist-based)
task.spawn(function()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local tapEvent = remotes and remotes:FindFirstChild("Tap")

    while true do
        if activeTap and tapEvent then
            local sel = {}
            for _, v in ipairs(getTapSelection()) do table.insert(sel, v) end
            if #sel > 0 then
                for _, id in ipairs(sel) do
                    if not activeTap then break end
                    pcall(function() tapEvent:FireServer(id) end)
                    task.wait(0.4)
                end
            else
                task.wait(0.5)
            end
        else
            if not tapEvent then
                remotes = ReplicatedStorage:FindFirstChild("Remotes")
                tapEvent = remotes and remotes:FindFirstChild("Tap")
            end
            task.wait(0.3)
        end
    end
end)

-- Auto Upgrade Logic (sequential, whitelist-based)
task.spawn(function()
    while true do
        if activeUpgrade then
            local upgradeEvent = ReplicatedStorage.Remotes:FindFirstChild("Upgrade")
            if upgradeEvent then
                local sel = {}
                for _, v in ipairs(getUpgradeSelection()) do table.insert(sel, v) end
                if #sel > 0 then
                    for _, id in ipairs(sel) do
                        if not activeUpgrade then break end
                        pcall(function() upgradeEvent:FireServer(id, 1) end)
                        task.wait(0.5)
                    end
                else
                    task.wait(0.5)
                end
            else
                task.wait(0.5)
            end
        else
            task.wait(0.3)
        end
    end
end)

-- Auto Dealer Logic Pipeline (Fully bug-proofed)
task.spawn(function()
    while true do
        if activeDealer then
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local dealEvent = remotes and remotes:FindFirstChild("Deal")
            local dealChoiceEvent = remotes and remotes:FindFirstChild("DealChoice")

            if dealEvent and dealChoiceEvent then
                local success, err = pcall(function()
                    local capturedId = nil
                    local connection

                    connection = dealEvent.OnClientEvent:Connect(function(data)
                        if type(data) == "table" and data.Id then
                            capturedId = data.Id
                        end
                    end)

                    local timeout = 15
                    local elapsed = 0

                    while activeDealer and not capturedId and elapsed < timeout do
                        task.wait(0.1)
                        elapsed = elapsed + 0.1
                    end

                    if connection then
                        connection:Disconnect()
                        connection = nil
                    end

                    if not activeDealer or not capturedId then
                        return
                    end

                    for i = 1, 2 do
                        if not activeDealer then return end
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
                end)

                if not success then
                    warn("FoxHub Auto Dealer Error:", err)
                    task.wait(2)
                end
            else
                task.wait(1)
            end
        else
            task.wait(0.2)
        end
    end
end)