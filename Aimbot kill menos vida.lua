-- ==========================================================
-- GRAVEL.CC | COMBAT SCRIPT (FOCO RESTRITO A HP 1% A 20%)
-- Autor: @thalisson.ths
-- ==========================================================

-- [ SEÇÃO 1: SERVIÇOS E VARIÁVEIS GLOBAIS ] -----------------
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Remove menus anteriores se já existirem
pcall(function()
    if CoreGui:FindFirstChild("GravelCombatMasterGui") then CoreGui.GravelCombatMasterGui:Destroy() end
    if CoreGui:FindFirstChild("GravelBlacklistGui") then CoreGui.GravelBlacklistGui:Destroy() end
    if CoreGui:FindFirstChild("GravelTargetNotifyGui") then CoreGui.GravelTargetNotifyGui:Destroy() end
end)

-- [ SEÇÃO 2: CONFIGURAÇÕES DO COMBATE E PERSISTÊNCIA ] ------
local combatSettings = {
    aimbotEnabled = false,
    wallCheck = true,
    fovRadius = 180,
    showFovCircle = true,
    smoothness = 0.20,
    aimMode = 1,              -- 1 = Menor HP (Somente 1% a 20%), 2 = Mais Próximo, 3 = Normal, 4 = Só Lista Negra
    predictionStrength = 0.1, -- Predict
    maxDistance = 200,
    
    showTargetInfo = true,    -- ESP Notificação ao olhar para o player
    criticalHpPercent = 20,   -- Limite máximo para considerar HP crítico (1% a 20%)

    espBoxSize = 36,     
    espTextSize = 10     
}

local CONFIG_FILE = "GravelConfig_thalisson.json"
local HttpService = game:GetService("HttpService")

local function saveSettings()
    pcall(function()
        if writefile then
            local data = HttpService:JSONEncode(combatSettings)
            writefile(CONFIG_FILE, data)
        end
    end)
end

local function loadSettings()
    pcall(function()
        if readfile and isfile and isfile(CONFIG_FILE) then
            local content = readfile(CONFIG_FILE)
            local data = HttpService:JSONDecode(content)
            for k, v in pairs(data) do
                combatSettings[k] = v
            end
        end
    end)
end
loadSettings()

-- [ SEÇÃO 3: SISTEMA DE LISTA NEGRA ] -----------------------
local blackList = {}

local function isBlacklisted(playerName)
    for _, name in ipairs(blackList) do
        if string.lower(name) == string.lower(playerName) then
            return true
        end
    end
    return false
end

-- ==========================================================
-- [ SEÇÃO 4: INTERFACE GRÁFICA PRINCIPAL (MENU COM SCROLL) ]
-- ==========================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GravelCombatMasterGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = player:WaitForChild("PlayerGui") end

local mainWindow = Instance.new("Frame")
mainWindow.Size = UDim2.fromOffset(260, 330)
mainWindow.Position = UDim2.new(0.05, 0, 0.15, 0)
mainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainWindow.Active = true
mainWindow.Draggable = true
mainWindow.Parent = screenGui

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(180, 50, 255)
mainStroke.Thickness = 2
mainStroke.Parent = mainWindow

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainWindow

-- Título com o seu @
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -55, 0, 30)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "GRAVEL | @thalisson.ths"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 10
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainWindow

-- Contador de FPS em tempo real
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.fromOffset(45, 20)
fpsLabel.Position = UDim2.new(1, -78, 0, 5)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 60"
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
fpsLabel.TextSize = 9
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
fpsLabel.Parent = mainWindow

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.fromOffset(22, 22)
minimizeBtn.Position = UDim2.new(1, -28, 0, 4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 11
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = mainWindow

local minCorner = Instance.new("UICorner") minCorner.CornerRadius = UDim.new(0, 4) minCorner.Parent = minimizeBtn

local mainScroll = Instance.new("ScrollingFrame")
mainScroll.Size = UDim2.new(1, -10, 1, -35)
mainScroll.Position = UDim2.new(0, 5, 0, 32)
mainScroll.BackgroundTransparency = 1
mainScroll.BorderSizePixel = 0
mainScroll.CanvasSize = UDim2.new(0, 0, 0, 340)
mainScroll.Parent = mainWindow

local mainListLayout = Instance.new("UIListLayout")
mainListLayout.Parent = mainScroll
mainListLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainListLayout.Padding = UDim.new(0, 6)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainWindow.Size = UDim2.fromOffset(260, 34)
        mainScroll.Visible = false
        minimizeBtn.Text = "+"
    else
        mainWindow.Size = UDim2.fromOffset(260, 330)
        mainScroll.Visible = true
        minimizeBtn.Text = "-"
    end
end)

-- [ SEÇÃO 5: COMPONENTES DO MENU PRINCIPAL ] --------------

local function createSwitch(name, getter, setter)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 24)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = mainScroll
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 5) corner.Parent = btn

    local function updateVisual()
        if getter() then
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            btn.Text = name .. ": [ LIGADO ]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.Text = name .. ": [ DESLIGADO ]"
        end
    end
    updateVisual()

    btn.MouseButton1Click:Connect(function()
        setter(not getter())
        updateVisual()
        saveSettings()
    end)
    return btn
end

local function createSlider(name, min, max, step, getter, setter, formatStr)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 38)
    frame.BackgroundTransparency = 1
    frame.Parent = mainScroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 14)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 8
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local function updateLabel()
        local val = getter()
        if formatStr == "%%" then
            label.Text = string.format("%s: %d%%", name, val)
        else
            label.Text = string.format("%s: " .. formatStr, name, val)
        end
    end
    updateLabel()

    local downBtn = Instance.new("TextButton")
    downBtn.Size = UDim2.new(0.5, -3, 0, 20)
    downBtn.Position = UDim2.new(0, 0, 0, 16)
    downBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    downBtn.Text = "◄ MENOS"
    downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    downBtn.TextSize = 8
    downBtn.Font = Enum.Font.GothamBold
    downBtn.Parent = frame
    local c1 = Instance.new("UICorner") c1.CornerRadius = UDim.new(0, 4) c1.Parent = downBtn

    local upBtn = Instance.new("TextButton")
    upBtn.Size = UDim2.new(0.5, -3, 0, 20)
    upBtn.Position = UDim2.new(0.5, 3, 0, 16)
    upBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    upBtn.Text = "MAIS ►"
    upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    upBtn.TextSize = 8
    upBtn.Font = Enum.Font.GothamBold
    upBtn.Parent = frame
    local c2 = Instance.new("UICorner") c2.CornerRadius = UDim.new(0, 4) c2.Parent = upBtn

    downBtn.MouseButton1Click:Connect(function()
        local newVal = math.clamp(getter() - step, min, max)
        setter(newVal)
        updateLabel()
        saveSettings()
    end)

    upBtn.MouseButton1Click:Connect(function()
        local newVal = math.clamp(getter() + step, min, max)
        setter(newVal)
        updateLabel()
        saveSettings()
    end)
end

createSwitch("AIMBOT", function() return combatSettings.aimbotEnabled end, function(v) combatSettings.aimbotEnabled = v end)

local toggleFocusBtn = Instance.new("TextButton")
toggleFocusBtn.Size = UDim2.new(1, -6, 0, 24)
toggleFocusBtn.BackgroundColor3 = Color3.fromRGB(30, 100, 200)
toggleFocusBtn.Text = "FOCO: HP CRÍTICO (1-20%)"
toggleFocusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleFocusBtn.TextSize = 9
toggleFocusBtn.Font = Enum.Font.GothamBold
toggleFocusBtn.Parent = mainScroll
local cFocus = Instance.new("UICorner") cFocus.CornerRadius = UDim.new(0, 5) cFocus.Parent = toggleFocusBtn

toggleFocusBtn.MouseButton1Click:Connect(function()
    combatSettings.aimMode = combatSettings.aimMode + 1
    if combatSettings.aimMode > 4 then combatSettings.aimMode = 1 end

    if combatSettings.aimMode == 1 then
        toggleFocusBtn.BackgroundColor3 = Color3.fromRGB(30, 100, 200)
        toggleFocusBtn.Text = "FOCO: HP CRÍTICO (1-20%)"
    elseif combatSettings.aimMode == 2 then
        toggleFocusBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 30)
        toggleFocusBtn.Text = "FOCO: DISTÂNCIA"
    elseif combatSettings.aimMode == 3 then
        toggleFocusBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 200)
        toggleFocusBtn.Text = "FOCO: NORMAL"
    else
        toggleFocusBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        toggleFocusBtn.Text = "FOCO: SÓ LISTA NEGRA"
    end
    saveSettings()
end)

createSlider("RAIO DO FOV", 50, 500, 25, function() return combatSettings.fovRadius end, function(v) combatSettings.fovRadius = v end, "%.0f px")
createSlider("SUAVIDADE (AIM)", 0.02, 0.50, 0.02, function() return combatSettings.smoothness end, function(v) combatSettings.smoothness = v end, "%.2f")
createSlider("TAMANHO CAIXA ESP", 16, 80, 4, function() return combatSettings.espBoxSize end, function(v) combatSettings.espBoxSize = v end, "%.0f px")
createSlider("VIDA CRÍTICA (%)", 1, 20, 1, function() return combatSettings.criticalHpPercent end, function(v) combatSettings.criticalHpPercent = v end, "%%")

createSwitch("CÍRCULO FOV NA TELA", function() return combatSettings.showFovCircle end, function(v) combatSettings.showFovCircle = v end)
createSwitch("ESP NOTIFICAÇÃO (AO OLHAR)", function() return combatSettings.showTargetInfo end, function(v) combatSettings.showTargetInfo = v end)


-- ==========================================================
-- [ SEÇÃO 6: JANELA FLUTUANTE DA LISTA NEGRA COM MINIMIZAR ] -
-- ==========================================================
local blacklistGui = Instance.new("ScreenGui")
blacklistGui.Name = "GravelBlacklistGui"
blacklistGui.ResetOnSpawn = false
blacklistGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() blacklistGui.Parent = CoreGui end)
if not blacklistGui.Parent then blacklistGui.Parent = player:WaitForChild("PlayerGui") end

local blackWindow = Instance.new("Frame")
blackWindow.Size = UDim2.fromOffset(240, 200)
blackWindow.Position = UDim2.new(0.05, 0, 0.54, 0)
blackWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
blackWindow.Active = true
blackWindow.Draggable = true
blackWindow.Parent = blacklistGui

local blackStroke = Instance.new("UIStroke")
blackStroke.Color = Color3.fromRGB(220, 50, 50)
blackStroke.Thickness = 2
blackStroke.Parent = blackWindow

local blackCorner = Instance.new("UICorner")
blackCorner.CornerRadius = UDim.new(0, 10)
blackCorner.Parent = blackWindow

local blackTitle = Instance.new("TextLabel")
blackTitle.Size = UDim2.new(1, -30, 0, 26)
blackTitle.Position = UDim2.new(0, 8, 0, 0)
blackTitle.BackgroundTransparency = 1
blackTitle.Text = "LISTA NEGRA (ALVOS)"
blackTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
blackTitle.TextSize = 10
blackTitle.Font = Enum.Font.GothamBold
blackTitle.TextXAlignment = Enum.TextXAlignment.Left
blackTitle.Parent = blackWindow

-- Botão de Minimizar da Lista Negra
local blackMinBtn = Instance.new("TextButton")
blackMinBtn.Size = UDim2.fromOffset(20, 20)
blackMinBtn.Position = UDim2.new(1, -26, 0, 3)
blackMinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
blackMinBtn.Text = "-"
blackMinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
blackMinBtn.TextSize = 10
blackMinBtn.Font = Enum.Font.GothamBold
blackMinBtn.Parent = blackWindow

local bMinCorner = Instance.new("UICorner") bMinCorner.CornerRadius = UDim.new(0, 4) bMinCorner.Parent = blackMinBtn

local playersScroll = Instance.new("ScrollingFrame")
playersScroll.Size = UDim2.new(1, -10, 1, -32)
playersScroll.Position = UDim2.new(0, 5, 0, 28)
playersScroll.BackgroundTransparency = 1
playersScroll.BorderSizePixel = 0
playersScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
playersScroll.Parent = blackWindow

local blListLayout = Instance.new("UIListLayout")
blListLayout.Parent = playersScroll
blListLayout.SortOrder = Enum.SortOrder.LayoutOrder
blListLayout.Padding = UDim.new(0, 4)

local blackMinimized = false
blackMinBtn.MouseButton1Click:Connect(function()
    blackMinimized = not blackMinimized
    if blackMinimized then
        blackWindow.Size = UDim2.fromOffset(240, 30)
        playersScroll.Visible = false
        blackMinBtn.Text = "+"
    else
        blackWindow.Size = UDim2.fromOffset(240, 200)
        playersScroll.Visible = true
        blackMinBtn.Text = "-"
    end
end)

local function updatePlayerUIList()
    for _, child in ipairs(playersScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            count = count + 1
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, -4, 0, 22)
            pBtn.TextSize = 9
            pBtn.Font = Enum.Font.Gotham
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            local isBlack = isBlacklisted(p.Name)
            if isBlack then
                pBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
                pBtn.Text = "[MARCADO] " .. p.Name
            else
                pBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                pBtn.Text = p.Name
            end

            pBtn.MouseButton1Click:Connect(function()
                if isBlacklisted(p.Name) then
                    for i, name in ipairs(blackList) do
                        if string.lower(name) == string.lower(p.Name) then
                            table.remove(blackList, i)
                        end
                    end
                else
                    table.insert(blackList, p.Name)
                end
                updatePlayerUIList()
            end)

            pBtn.Parent = playersScroll
        end
    end
    playersScroll.CanvasSize = UDim2.new(0, 0, 0, count * 26)
end

Players.PlayerAdded:Connect(updatePlayerUIList)
Players.PlayerRemoving:Connect(updatePlayerUIList)
task.spawn(updatePlayerUIList)


-- ==========================================================
-- [ SEÇÃO 7: ESP NOTIFICAÇÃO (VERMELHO E COMPACTO) ] --------
-- ==========================================================
local notifyGui = Instance.new("ScreenGui")
notifyGui.Name = "GravelTargetNotifyGui"
notifyGui.ResetOnSpawn = false
notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() notifyGui.Parent = CoreGui end)
if not notifyGui.Parent then notifyGui.Parent = player:WaitForChild("PlayerGui") end

local notifyCard = Instance.new("Frame")
notifyCard.Size = UDim2.fromOffset(220, 68)
notifyCard.Position = UDim2.new(0.5, -110, 0.08, 0)
notifyCard.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
notifyCard.Visible = false
notifyCard.Parent = notifyGui

local notifyStroke = Instance.new("UIStroke")
notifyStroke.Color = Color3.fromRGB(255, 30, 30)
notifyStroke.Thickness = 2
notifyStroke.Parent = notifyCard

local notifyCorner = Instance.new("UICorner")
notifyCorner.CornerRadius = UDim.new(0, 6)
notifyCorner.Parent = notifyCard

local targetNameLabel = Instance.new("TextLabel")
targetNameLabel.Size = UDim2.new(1, -10, 0, 18)
targetNameLabel.Position = UDim2.new(0, 5, 0, 3)
targetNameLabel.BackgroundTransparency = 1
targetNameLabel.Text = "NOME DO ALVO"
targetNameLabel.TextColor3 = Color3.fromRGB(255, 30, 30)
targetNameLabel.TextSize = 10
targetNameLabel.Font = Enum.Font.GothamBold
targetNameLabel.TextXAlignment = Enum.TextXAlignment.Left
targetNameLabel.Parent = notifyCard

local targetDetailsLabel = Instance.new("TextLabel")
targetDetailsLabel.Size = UDim2.new(1, -10, 0, 18)
targetDetailsLabel.Position = UDim2.new(0, 5, 0, 20)
targetDetailsLabel.BackgroundTransparency = 1
targetDetailsLabel.Text = "HP: 100/100 (100%) | 7 HITS | SORTE: 50%"
targetDetailsLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
targetDetailsLabel.TextSize = 9
targetDetailsLabel.Font = Enum.Font.GothamBold
targetDetailsLabel.TextXAlignment = Enum.TextXAlignment.Left
targetDetailsLabel.Parent = notifyCard

local hotbarTextLabel = Instance.new("TextLabel")
hotbarTextLabel.Size = UDim2.new(1, -10, 0, 22)
hotbarTextLabel.Position = UDim2.new(0, 5, 0, 40)
hotbarTextLabel.BackgroundTransparency = 1
hotbarTextLabel.Text = "ITENS: [NENHUM]"
hotbarTextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
hotbarTextLabel.TextSize = 10
hotbarTextLabel.Font = Enum.Font.GothamBold
hotbarTextLabel.TextXAlignment = Enum.TextXAlignment.Left
hotbarTextLabel.Parent = notifyCard


-- ==========================================================
-- [ SEÇÃO 8: OBJETOS DE DESENHO E FUNÇÕES AUXILIARES ] -----
-- ==========================================================
if not Drawing then return end

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1.5
fovCircle.NumSides = 64
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(180, 50, 255)

local espCache = {}
local enemyLastHealth = {}
local enemyDetectedDamage = {}
local lastPositions = {}
local lastTickTime = tick()
local frameCount = 0
local fpsTimer = 0

local function createBoxObject()
    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 1
    box.Filled = false
    box.Color = Color3.fromRGB(0, 255, 0)
    return box
end

local function hideBox(box)
    if box then box.Visible = false end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then espCache[p] = createBoxObject() end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= player then espCache[p] = createBoxObject() end
end)

Players.PlayerRemoving:Connect(function(p)
    if espCache[p] then
        pcall(function() espCache[p]:Remove() end)
        espCache[p] = nil
        enemyLastHealth[p] = nil
        enemyDetectedDamage[p] = nil
        lastPositions[p] = nil
    end
end)

local function getFallbackDamage()
    local fallback = 15
    pcall(function()
        if player.Character then
            for _, tool in ipairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = string.lower(tool.Name)
                    if string.find(name, "sniper") or string.find(name, "awp") then
                        fallback = 100
                    elseif string.find(name, "shotgun") then
                        fallback = 35
                    end
                end
            end
        end
    end)
    return fallback
end

local function isVisible(targetPart)
    if not camera or not player.Character or not player.Character:FindFirstChild("Head") then return true end
    local origin = camera.CFrame.Position
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local ignoreList = {player.Character}
    if targetPart.Parent then table.insert(ignoreList, targetPart.Parent) end
    raycastParams.FilterDescendantsInstances = ignoreList
    local result = Workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

local function getHotbarItems(pChar)
    local items = {}
    pcall(function()
        for _, item in ipairs(pChar:GetChildren()) do
            if item:IsA("Tool") then table.insert(items, item.Name) end
        end
        local p = Players:GetPlayerFromCharacter(pChar)
        if p and p:FindFirstChild("Backpack") then
            for _, item in ipairs(p.Backpack:GetChildren()) do
                if item:IsA("Tool") then table.insert(items, item.Name) end
            end
        end
    end)
    if #items > 0 then return table.concat(items, ", ") else return "NENHUM" end
end

local function getPlayerLuck(p)
    local luckVal = 0
    pcall(function()
        if p:FindFirstChild("leaderstats") then
            for _, stat in ipairs(p.leaderstats:GetChildren()) do
                local name = string.lower(stat.Name)
                if string.find(name, "sorte") or string.find(name, "luck") then
                    luckVal = stat.Value
                end
            end
        end
        if luckVal == 0 and p:FindFirstChild("PlayerStats") then
            for _, stat in ipairs(p.PlayerStats:GetChildren()) do
                local name = string.lower(stat.Name)
                if string.find(name, "sorte") or string.find(name, "luck") then
                    luckVal = stat.Value
                end
            end
        end
    end)
    if luckVal == 0 then
        local luckSeed = (p.UserId + math.floor(tick() / 10)) % 1000
        luckVal = (luckSeed % 80) + 20
    end
    return luckVal
end

-- ==========================================================
-- [ SEÇÃO 9: LOOP PRINCIPAL (RENDERSTEPPED) ] --------------
-- ==========================================================
RunService.RenderStepped:Connect(function()
    pcall(function()
        camera = workspace.CurrentCamera
        if not camera then return end

        frameCount = frameCount + 1
        fpsTimer = fpsTimer + RunService.RenderStepped:Wait()
        if fpsTimer >= 1 then
            fpsLabel.Text = "FPS: " .. tostring(math.floor(frameCount / fpsTimer))
            frameCount = 0
            fpsTimer = 0
        end

        local viewport = camera.ViewportSize
        local screenCenter = Vector2.new(viewport.X / 2, viewport.Y / 2)

        if fovCircle then
            if combatSettings.aimbotEnabled and combatSettings.showFovCircle then
                fovCircle.Position = screenCenter
                fovCircle.Radius = combatSettings.fovRadius
                fovCircle.Visible = true
            else
                fovCircle.Visible = false
            end
        end

        local currentTime = tick()
        local deltaTime = currentTime - lastTickTime
        lastTickTime = currentTime

        local focusedTarget = nil
        local closestToCenterForNotify = 999999

        -- ------------------------------------------------------
        -- SUB-SEÇÃO 9.1: PROCESSAMENTO DO ESP COM PISCAR CRÍTICO
        -- ------------------------------------------------------
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                if not espCache[p] then espCache[p] = createBoxObject() end
                local box = espCache[p]
                local char = p.Character
                local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                local headPart = char and char:FindFirstChild("Head")
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")

                if char and rootPart and headPart and humanoid and humanoid.Health > 0 then
                    local isTeammate = (player.Team and p.Team and player.Team == p.Team)

                    if not isTeammate then
                        local currentHp = humanoid.Health
                        local maxHp = humanoid.MaxHealth
                        local hpPercent = math.clamp(currentHp / maxHp, 0, 1)
                        local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
                        local vector, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                        
                        if distance > combatSettings.maxDistance or not onScreen or vector.Z <= 0 then
                            hideBox(box)
                        else
                            local blacklisted = isBlacklisted(p.Name)
                            
                            if not enemyLastHealth[p] then enemyLastHealth[p] = currentHp end
                            local healthDifference = enemyLastHealth[p] - currentHp
                            if healthDifference > 0 and healthDifference <= 100 then enemyDetectedDamage[p] = healthDifference end
                            enemyLastHealth[p] = currentHp

                            local effectiveDamage = enemyDetectedDamage[p] or getFallbackDamage()
                            if effectiveDamage <= 0 then effectiveDamage = 15 end
                            local hitsNeeded = math.ceil(currentHp / effectiveDamage)

                            local espColor = Color3.fromRGB(0, 255, 0)
                            local critThreshold = combatSettings.criticalHpPercent / 100

                            if blacklisted then
                                espColor = Color3.fromRGB(255, 30, 30)
                            elseif hpPercent <= critThreshold then
                                local flash = math.floor(currentTime * 6) % 2 == 0
                                espColor = flash and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 255, 0)
                            end
                            box.Color = espColor

                            local fixedWidth = combatSettings.espBoxSize * 0.75
                            local fixedHeight = combatSettings.espBoxSize * 1.5
                            local pos = Vector2.new(vector.X - fixedWidth / 2, vector.Y - fixedHeight / 2)

                            box.Size = Vector2.new(fixedWidth, fixedHeight)
                            box.Position = pos
                            box.Visible = true

                            local distToScreenCenter = (Vector2.new(vector.X, vector.Y) - screenCenter).Magnitude
                            if distToScreenCenter < 85 and distToScreenCenter < closestToCenterForNotify then
                                closestToCenterForNotify = distToScreenCenter
                                focusedTarget = {playerObj = p, charObj = char, hum = humanoid, hp = currentHp, maxHp = maxHp, hpPct = hpPercent, hits = hitsNeeded}
                            end
                        end
                    else
                        hideBox(box)
                    end
                else
                    if espCache[p] then hideBox(espCache[p]) end
                    enemyLastHealth[p] = nil
                    enemyDetectedDamage[p] = nil
                end
            end
        end

        if combatSettings.showTargetInfo and focusedTarget then
            local p = focusedTarget.playerObj
            local luckVal = getPlayerLuck(p)
            local itemsStr = getHotbarItems(focusedTarget.charObj)

            targetNameLabel.Text = string.upper(p.DisplayName or p.Name)
            targetDetailsLabel.Text = string.format("HP: %d/%d (%d%%) | %d HITS | SORTE: %d%%", 
                math.floor(focusedTarget.hp), 
                math.floor(focusedTarget.maxHp), 
                math.floor(focusedTarget.hpPct * 100), 
                focusedTarget.hits,
                luckVal
            )
            hotbarTextLabel.Text = "ITENS: [" .. string.upper(itemsStr) .. "]"
            notifyCard.Visible = true
        else
            notifyCard.Visible = false
        end

        -- ------------------------------------------------------
        -- SUB-SEÇÃO 9.2: PROCESSAMENTO DO AIMBOT (HP CRÍTICO RESTRITO 1% A 20%)
        -- ------------------------------------------------------
        if combatSettings.aimbotEnabled then
            local bestTarget = nil
            local bestMetric = 999999

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then
                    local char = p.Character
                    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                    local headPart = char and char:FindFirstChild("Head")
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")

                    if char and rootPart and headPart and humanoid and humanoid.Health > 0 then
                        local isTeammate = (player.Team and p.Team and player.Team == p.Team)

                        if not isTeammate then
                            local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
                            local blacklisted = isBlacklisted(p.Name)
                            
                            local screenPos, onScreenHead = camera:WorldToViewportPoint(headPart.Position)
                            local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude

                            if distance <= combatSettings.maxDistance and onScreenHead and screenPos.Z > 0 and distToCenter <= combatSettings.fovRadius then
                                
                                local passesWall = not combatSettings.wallCheck or isVisible(headPart)
                                
                                if passesWall then
                                    local currentHp = humanoid.Health
                                    local maxHp = humanoid.MaxHealth
                                    local hpPercent = math.clamp(currentHp / maxHp, 0, 1)

                                    if not lastPositions[p] then lastPositions[p] = rootPart.Position end
                                    local velocity = (rootPart.Position - lastPositions[p]) / math.clamp(deltaTime, 0.01, 0.1)
                                    lastPositions[p] = rootPart.Position

                                    local predictedHeadPos = headPart.Position + (velocity * combatSettings.predictionStrength)

                                    local metric = 999999
                                    local validTarget = true
                                    local critThreshold = combatSettings.criticalHpPercent / 100

                                    if combatSettings.aimMode == 4 then
                                        if blacklisted then metric = distToCenter else validTarget = false end
                                    else
                                        if blacklisted then
                                            metric = -1000 
                                        elseif combatSettings.aimMode == 1 then
                                            -- MODO MENOR HP: SÓ FOCA SE ESTIVER DENTRO DA FAIXA CRÍTICA (1% A 20%)
                                            if hpPercent <= critThreshold then
                                                metric = hpPercent -- Prioriza os mais críticos dentro da faixa
                                            else
                                                validTarget = false -- Ignora totalmente quem tiver acima da vida crítica (ex: 21% a 100%)
                                            end
                                        elseif combatSettings.aimMode == 2 then
                                            metric = distToCenter -- Mais próximo
                                        else
                                            metric = 1 -- Normal
                                        end
                                    end

                                    if validTarget and metric < bestMetric then
                                        bestMetric = metric
                                        bestTarget = predictedHeadPos
                                    end
                                end
                            end
                        end
                    else
                        lastPositions[p] = nil
                    end
                end
            end

            if bestTarget then
                local camPos = camera.CFrame.Position
                local targetCFrame = CFrame.lookAt(camPos, bestTarget, Vector3.yAxis)
                camera.CFrame = camera.CFrame:Lerp(targetCFrame, combatSettings.smoothness)
            end
        end
    end)
end)

print("[Gravel] Script Oficial @thalisson.ths Atualizado com Foco Crítico Restrito!")
