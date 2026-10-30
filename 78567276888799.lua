local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/FoxVukOff/FoxHub/refs/heads/main/ui.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local screenGui, mainFrame, header = ui.createWindow("FoxHubSellGui", "🦊 FoxHub - Sell Veritys", UDim2.new(0, 360, 0, 520))
ui.addCloseButton(header, mainFrame, screenGui)

local container = ui.createScrollingFrame(mainFrame, 460)

local row0, sw0, circ0 = ui.createToggleRow(container, "Auto Tap", 1)

local tapWhitelist = {1, 2, 3, 4}
local tapDropdownVisible = false
local tapDropdownFrame = nil

local function toggleTapDropdown()
    tapDropdownVisible = not tapDropdownVisible
    if tapDropdownVisible and not tapDropdownFrame then
        tapDropdownFrame = ui.createDropdown(
            container,
            "Tap Whitelist",
            {"#1 (Verity Stand)", "#2 (Verity Truck)", "#3 (Verity Shop)", "#4 (Verity Depot)"},
            true,
            tapWhitelist,
            2,
            function(selection)
                tapWhitelist = {}
                for _, idx in ipairs(selection) do
                    table.insert(tapWhitelist, idx)
                end
            end
        )
    elseif tapDropdownFrame then
        tapDropdownFrame.Visible = tapDropdownVisible
    end
end

ui.createSettingsRow(container, "Tap Settings", 2, toggleTapDropdown)

local row1, sw1, circ1 = ui.createToggleRow(container, "Auto Upgrade", 3)

local upgradeWhitelist = {1, 2, 3, 4}
local upgradeDropdownVisible = false
local upgradeDropdownFrame = nil

local function toggleUpgradeDropdown()
    upgradeDropdownVisible = not upgradeDropdownVisible
    if upgradeDropdownVisible and not upgradeDropdownFrame then
        upgradeDropdownFrame = ui.createDropdown(
            container,
            "Upgrade Whitelist",
            {"#1 (Verity Stand)", "#2 (Verity Truck)", "#3 (Verity Shop)", "#4 (Verity Depot)"},
            true,
            upgradeWhitelist,
            4,
            function(selection)
                upgradeWhitelist = {}
                for _, idx in ipairs(selection) do
                    table.insert(upgradeWhitelist, idx)
                end
            end
        )
    elseif upgradeDropdownFrame then
        upgradeDropdownFrame.Visible = upgradeDropdownVisible
    end
end

ui.createSettingsRow(container, "Upgrade Settings", 4, toggleUpgradeDropdown)

local row2, sw2, circ2 = ui.createToggleRow(container, "Auto Dealer", 5)

local activeTap = false
local activeUpgrade = false
local activeDealer = false

sw0.MouseButton1Click:Connect(function()
    ui.spawnConfetti(sw0)
    activeTap = not activeTap
    ui.setToggleState(activeTap, sw0, circ0)
end)
sw1.MouseButton1Click:Connect(function()
    ui.spawnConfetti(sw1)
    activeUpgrade = not activeUpgrade
    ui.setToggleState(activeUpgrade, sw1, circ1)
end)
sw2.MouseButton1Click:Connect(function()
    ui.spawnConfetti(sw2)
    activeDealer = not activeDealer
    ui.setToggleState(activeDealer, sw2, circ2)
end)

-- Auto Tap Logic (slower, sequential)
task.spawn(function()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local tapEvent = remotes and remotes:FindFirstChild("Tap")
    
    while true do
        if activeTap and tapEvent then
            for _, id in ipairs(tapWhitelist) do
                if not activeTap then break end
                if tapEvent then
                    pcall(function() tapEvent:FireServer(id) end)
                end
                task.wait(0.4)
            end
            if #tapWhitelist == 0 then
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

-- Auto Upgrade Logic (sequential based on whitelist)
task.spawn(function()
    while true do
        if activeUpgrade then
            local upgradeEvent = ReplicatedStorage.Remotes:FindFirstChild("Upgrade")
            if upgradeEvent then
                for _, id in ipairs(upgradeWhitelist) do
                    if not activeUpgrade then break end
                    pcall(function() upgradeEvent:FireServer(id, 1) end)
                    task.wait(0.5)
                end
                if #upgradeWhitelist == 0 then
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