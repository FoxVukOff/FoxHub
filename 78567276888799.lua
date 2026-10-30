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
            task.spawn(function() pcall(function() tapEvent:FireServer(1) end) end)
            task.spawn(function() pcall(function() tapEvent:FireServer(2) end) end)
            task.spawn(function() pcall(function() tapEvent:FireServer(3) end) end)
            task.spawn(function() pcall(function() tapEvent:FireServer(4) end) end)
            task.wait(0.1)
        else
            if not tapEvent then
                remotes = ReplicatedStorage:FindFirstChild("Remotes")
                tapEvent = remotes and remotes:FindFirstChild("Tap")
            end
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

-- Auto Dealer Logic Pipeline (Fully bug-proofed)
task.spawn(function()
    while true do
        if activeDealer then
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local dealEvent = remotes and remotes:FindFirstChild("Deal")
            local dealChoiceEvent = remotes and remotes:FindFirstChild("DealChoice")
            
            if dealEvent and dealChoiceEvent then
                -- Весь процесс одной сделки обёрнут в pcall, чтобы ошибки не убивали поток
                local success, err = pcall(function()
                    local capturedId = nil
                    local connection
                    
                    connection = dealEvent.OnClientEvent:Connect(function(data)
                        if type(data) == "table" and data.Id then
                            capturedId = data.Id
                        end
                    end)
                    
                    -- Ждём сделку с таймаутом 15 секунд
                    local timeout = 15
                    local elapsed = 0
                    
                    while activeDealer and not capturedId and elapsed < timeout do
                        task.wait(0.1)
                        elapsed = elapsed + 0.1
                    end
                    
                    -- ВАЖНО: Отключаем listener, чтобы не было утечки памяти и повторных срабатываний
                    if connection then
                        connection:Disconnect()
                        connection = nil
                    end
                    
                    -- Если выключили функцию или вышел таймаут — просто прерываем текущую итерацию
                    -- (return внутри pcall просто завершит функцию, а внешний цикл продолжит работать!)
                    if not activeDealer or not capturedId then
                        return
                    end
                    
                    -- Просим "more" два раза
                    for i = 1, 2 do
                        if not activeDealer then return end
                        pcall(function()
                            dealChoiceEvent:FireServer(capturedId, "more")
                        end)
                        task.wait(1)
                    end
                    
                    -- Принимаем сделку
                    if activeDealer then
                        pcall(function()
                            dealChoiceEvent:FireServer(capturedId, "accept")
                        end)
                    end
                    
                    task.wait(1) -- Пауза перед поиском следующей сделки
                end)
                
                if not success then
                    warn("FoxHub Auto Dealer Error:", err)
                    task.wait(2) -- Пауза после ошибки, чтобы не спамить в консоль
                end
            else
                task.wait(1) -- Ждём, пока ивенты прогрузятся в ReplicatedStorage
            end
        else
            task.wait(0.2)
        end
    end
end)