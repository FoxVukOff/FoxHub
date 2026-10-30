local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/FoxVukOff/FoxHub/refs/heads/main/ui.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local screenGui, mainFrame, header = ui.createWindow("FoxHubSellGui", "🦊 FoxHub - Sell Veritys", UDim2.new(0, 340, 0, 420))
ui.addCloseButton(header, mainFrame, screenGui)

local container = ui.createScrollingFrame(mainFrame, 380)

local row0, sw0, circ0 = ui.createToggleRow(container, "Auto Tap", 1)
local row1, sw1, circ1 = ui.createToggleRow(container, "Auto Upgrade #1", 2)
local row2, sw2, circ2 = ui.createToggleRow(container, "Auto Upgrade #2", 3)
local row3, sw3, circ3 = ui.createToggleRow(container, "Auto Upgrade #3", 4)
local row4, sw4, circ4 = ui.createToggleRow(container, "Auto Upgrade #4", 5)
local row5, sw5, circ5 = ui.createToggleRow(container, "Auto Dealer", 6)

local activeTap = false
local active1, active2, active3, active4, activeDealer = false, false, false, false, false

sw0.MouseButton1Click:Connect(function()
    ui.spawnConfetti(sw0)
    activeTap = not activeTap
    ui.setToggleState(activeTap, sw0, circ0)
end)
sw1.MouseButton1Click:Connect(function()
    ui.spawnConfetti(sw1)
    active1 = not active1
    ui.setToggleState(active1, sw1, circ1)
end)
sw2.MouseButton1Click:Connect(function()
    ui.spawnConfetti(sw2)
    active2 = not active2
    ui.setToggleState(active2, sw2, circ2)
end)
sw3.MouseButton1Click:Connect(function()
    ui.spawnConfetti(sw3)
    active3 = not active3
    ui.setToggleState(active3, sw3, circ3)
end)
sw4.MouseButton1Click:Connect(function()
    ui.spawnConfetti(sw4)
    active4 = not active4
    ui.setToggleState(active4, sw4, circ4)
end)
sw5.MouseButton1Click:Connect(function()
    ui.spawnConfetti(sw5)
    activeDealer = not activeDealer
    ui.setToggleState(activeDealer, sw5, circ5)
end)

-- Auto Tap Logic Pipeline
task.spawn(function()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local tapEvent = remotes and remotes:FindFirstChild("Tap")
    
    while true do
        if activeTap and tapEvent then
            -- Спамим 4 запроса одновременно через task.spawn, чтобы не блокировать основной поток
            task.spawn(function() pcall(function() tapEvent:FireServer(1) end) end)
            task.spawn(function() pcall(function() tapEvent:FireServer(2) end) end)
            task.spawn(function() pcall(function() tapEvent:FireServer(3) end) end)
            task.spawn(function() pcall(function() tapEvent:FireServer(4) end) end)
            
            -- Задержка 0.1с (10 итераций в сек = 40 запросов/сек). Не лагает, но очень быстро.
            task.wait(0.1)
        else
            task.wait(0.2)
        end
    end
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
                
                local timeout = 10
                local elapsed = 0
                while activeDealer and not capturedId and elapsed < timeout do
                    task.wait(0.1)
                    elapsed = elapsed + 0.1
                end
                
                if not activeDealer then
                    if connection then connection:Disconnect() end
                    break
                end
                if not capturedId then
                    if connection then connection:Disconnect() end
                    task.wait(1)
                    continue
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