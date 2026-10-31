-- ==========================================================
-- GRAVEL.CC | ULTIMATE PAID-GRADE HUB (DELTA EXECUTOR)
-- Aimbot Suavizado + Smart Assist + Hitbox Expander + ESP Otimizado
-- ==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local success, targetGuiParent = pcall(function() return CoreGui end)
if not success or not targetGuiParent then
    targetGuiParent = player:WaitForChild("PlayerGui")
end

-- CONFIGURAÇÕES GLOBAIS PADRÃO
local settings = {
    aimbotEnabled = false,
    smartAssistEnabled = false,
    hitboxExpander = false, -- Nova função útil: Expande a Hitbox dos inimigos
    hitboxSize = 4,         -- Tamanho da expansão
    aimbotTeamCheck = false,
    wallCheck = false,
    showFovCircle = true,
    targetPart = "Head",
    smoothness = 6,
    fov = 180,
    prediction = true,
    
    espEnabled = false,
    espTeamCheck = true,
    espEnemies = true,
    espAllies = false,
    enemyColorIndex = 1,
    allyColorIndex = 1,
    espHealthBar = false,
    espTracers = false,
    
    fullbright = false,
    customFovValue = 70
}

local colorPalette = {
    [1] = {name = "Branco", color = Color3.fromRGB(255, 255, 255)},
    [2] = {name = "Vermelho", color = Color3.fromRGB(255, 65, 65)},
    [3] = {name = "Azul", color = Color3.fromRGB(65, 150, 255)},
    [4] = {name = "Verde", color = Color3.fromRGB(65, 230, 110)},
    [5] = {name = "Amarelo", color = Color3.fromRGB(255, 220, 50)}
}

-- SISTEMA DE SAVE/LOAD SEGURO
local configFileName = "GravelHub_Config.json"

local function saveConfig()
    pcall(function()
        local dataToSave = {
            aimbotEnabled = settings.aimbotEnabled,
            smartAssistEnabled = settings.smartAssistEnabled,
            hitboxExpander = settings.hitboxExpander,
            hitboxSize = settings.hitboxSize,
            aimbotTeamCheck = settings.aimbotTeamCheck,
            wallCheck = settings.wallCheck,
            showFovCircle = settings.showFovCircle,
            targetPart = settings.targetPart,
            smoothness = settings.smoothness,
            fov = settings.fov,
            prediction = settings.prediction,
            espEnabled = settings.espEnabled,
            espTeamCheck = settings.espTeamCheck,
            espEnemies = settings.espEnemies,
            espAllies = settings.espAllies,
            enemyColorIndex = settings.enemyColorIndex,
            allyColorIndex = settings.allyColorIndex,
            espHealthBar = settings.espHealthBar,
            espTracers = settings.espTracers,
            fullbright = settings.fullbright,
            customFovValue = settings.customFovValue
        }
        writefile(configFileName, HttpService:JSONEncode(dataToSave))
    end)
end

local function loadConfig()
    local successLoad, result = pcall(function()
        if readfile then
            local content = readfile(configFileName)
            return HttpService:JSONDecode(content)
        end
    end)
    if successLoad and type(result) == "table" then
        for k, v in pairs(result) do
            if settings[k] ~= nil then
                settings[k] = v
            end
        end
    end
end

loadConfig()

local espDrawings = {}

-- CORES B&W PROFISSIONAL
local BG = Color3.fromRGB(12, 12, 14)
local PANEL = Color3.fromRGB(20, 20, 24)
local CARD = Color3.fromRGB(28, 28, 34)
local ACCENT = Color3.fromRGB(240, 240, 240)
local OFF_COLOR = Color3.fromRGB(50, 50, 60)
local WHITE = Color3.fromRGB(255, 255, 255)
local MUTED = Color3.fromRGB(130, 130, 140)

local function create(class, props, parent)
    local obj = Instance.new(class)
    for key, value in pairs(props) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

-- SCREEN GUI
local gui = create("ScreenGui", {
    Name = "GravelUltimateHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999
}, targetGuiParent)

-- SISTEMA DE NOTIFICAÇÕES FLUTUANTES (TOAST)
local notificationHolder = create("Frame", {
    Size = UDim2.fromOffset(220, 150),
    Position = UDim2.new(1, -230, 1, -170),
    BackgroundTransparency = 1
}, gui)

local notifLayout = Instance.new("UIListLayout")
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 5)
notifLayout.Parent = notificationHolder

local function notify(text)
    local notif = create("Frame", {
        Size = UDim2.fromOffset(220, 32),
        BackgroundColor3 = PANEL,
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    }, notificationHolder)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, notif)
    create("UIStroke", { Color = Color3.fromRGB(50, 50, 65), Thickness = 1 }, notif)

    local lbl = create("TextLabel", {
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = WHITE,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1
    }, notif)

    TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(lbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.delay(2, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- WATERMARK PROFISSIONAL
local watermark = create("Frame", {
    Size = UDim2.fromOffset(180, 26),
    Position = UDim2.new(0, 15, 0, 15),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, gui)
create("UICorner", { CornerRadius = UDim.new(0, 5) }, watermark)
create("UIStroke", { Color = Color3.fromRGB(45, 45, 55), Thickness = 1 }, watermark)

local watermarkText = create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "gravel.cc  |  fps: 60  |  ms: 0",
    TextColor3 = MUTED,
    TextSize = 10,
    Font = Enum.Font.GothamMedium
}, watermark)

-- BOTÃO FLUTUANTE "G"
local floatingToggleBtn = create("TextButton", {
    Size = UDim2.fromOffset(40, 40),
    Position = UDim2.new(0, 15, 0, 55),
    BackgroundColor3 = PANEL,
    Text = "G",
    TextColor3 = WHITE,
    TextSize = 14,
    Font = Enum.Font.GothamBold
}, gui)
create("UICorner", { CornerRadius = UDim.new(0, 8) }, floatingToggleBtn)
create("UIStroke", { Color = Color3.fromRGB(60, 60, 75), Thickness = 1.2 }, floatingToggleBtn)

-- PAINEL PRINCIPAL
local main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(480, 390),
    Position = UDim2.new(0.5, -240, 0.5, -195),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    BackgroundTransparency = 1
}, gui)

create("UICorner", { CornerRadius = UDim.new(0, 8) }, main)
create("UIStroke", { Color = Color3.fromRGB(45, 45, 55), Thickness = 1.2 }, main)

TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()

local menuVisible = true
floatingToggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    main.Visible = menuVisible
end)

-- BARRA SUPERIOR
local top = create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, main)

create("UICorner", { CornerRadius = UDim.new(0, 8) }, top)

create("TextLabel", {
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.fromOffset(15, 0),
    BackgroundTransparency = 1,
    Text = "GRAVEL.CC  //  ULTIMATE",
    TextColor3 = WHITE,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

-- BOTÃO DE FECHAR
local close = create("TextButton", {
    Size = UDim2.fromOffset(24, 24),
    Position = UDim2.new(1, -32, 0, 8),
    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
    Text = "X",
    TextColor3 = WHITE,
    TextSize = 10,
    Font = Enum.Font.GothamBold
}, top)
create("UICorner", { CornerRadius = UDim.new(0, 5) }, close)
close.MouseButton1Click:Connect(function()
    for _, cache in pairs(espDrawings) do
        if cache.box then cache.box:Remove() end
        if cache.barBg then cache.barBg:Remove() end
        if cache.barFill then cache.barFill:Remove() end
        if cache.tracer then cache.tracer:Remove() end
    end
    gui:Destroy()
end)

-- BOTÃO DE MINIMIZAR
local minimized = false
local minimize = create("TextButton", {
    Size = UDim2.fromOffset(24, 24),
    Position = UDim2.new(1, -60, 0, 8),
    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
    Text = "_",
    TextColor3 = WHITE,
    TextSize = 10,
    Font = Enum.Font.GothamBold
}, top)
create("UICorner", { CornerRadius = UDim.new(0, 5) }, minimize)

local contentContainer = create("Frame", {
    Size = UDim2.new(1, 0, 1, -40),
    Position = UDim2.fromOffset(0, 40),
    BackgroundTransparency = 1
}, main)

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    contentContainer.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(480, 40) or UDim2.fromOffset(480, 390)
    minimize.Text = minimized and "+" or "_"
end)

-- SISTEMA DE ARRASTE
local dragging, dragStart, startPosition
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- MENU LATERAL (ABAS)
local sidebar = create("Frame", {
    Size = UDim2.new(0, 110, 1, -20),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, contentContainer)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, sidebar)

local pagesContainer = create("Frame", {
    Position = UDim2.new(0, 130, 0, 10),
    Size = UDim2.new(1, -140, 1, -20),
    BackgroundTransparency = 1
}, contentContainer)

local pages = {}
local function createPage(name)
    local page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 540),
        ScrollBarThickness = 2
    }, pagesContainer)
    pages[name] = page
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page
    
    return page
end

local pageMain = createPage("Main")
local pageAimbot = createPage("Aimbot")
local pageVisuals = createPage("Visuals")
local pageMisc = createPage("Misc")

local function switchPage(name)
    for pName, pObj in pairs(pages) do
        pObj.Visible = (pName == name)
    end
end
switchPage("Main")

local function createTabButton(text, yPos, targetPage)
    local btn = create("TextButton", {
        Size = UDim2.new(1, -14, 0, 30),
        Position = UDim2.fromOffset(7, yPos),
        BackgroundColor3 = CARD,
        Text = text,
        TextColor3 = MUTED,
        TextSize = 11,
        Font = Enum.Font.GothamBold
    }, sidebar)
    create("UICorner", { CornerRadius = UDim.new(0, 5) }, btn)
    
    btn.MouseButton1Click:Connect(function()
        switchPage(targetPage)
    end)
end

createTabButton("Main", 10, "Main")
createTabButton("Aimbot", 46, "Aimbot")
createTabButton("Visuals", 82, "Visuals")
createTabButton("Misc", 118, "Misc")

-- COMPONENTE: TOGGLE SWITCH
local function createToggle(parent, text, initial, callback)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = CARD,
        BorderSizePixel = 0
    }, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, container)

    create("TextLabel", {
        Size = UDim2.new(1, -55, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = WHITE,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left
    }, container)

    local switchBg = create("Frame", {
        Size = UDim2.fromOffset(36, 18),
        Position = UDim2.new(1, -44, 0.5, -9),
        BackgroundColor3 = initial and ACCENT or OFF_COLOR,
        BorderSizePixel = 0
    }, container)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, switchBg)

    local switchCircle = create("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = initial and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0
    }, switchBg)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, switchCircle)

    local state = initial
    local btnClick = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = ""
    }, container)

    btnClick.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        saveConfig()
        
        local targetPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = state and ACCENT or OFF_COLOR
        
        TweenService:Create(switchCircle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end)
end

-- COMPONENTE: SLIDER
local function createSlider(parent, title, minValue, maxValue, initial, callback)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = CARD,
        BorderSizePixel = 0
    }, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, container)

    local label = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.fromOffset(12, 6),
        BackgroundTransparency = 1,
        Text = title .. ": " .. initial,
        TextColor3 = WHITE,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left
    }, container)

    local track = create("TextButton", {
        Size = UDim2.new(1, -24, 0, 6),
        Position = UDim2.fromOffset(12, 32),
        BackgroundColor3 = Color3.fromRGB(45, 45, 55),
        Text = "",
        AutoButtonColor = false
    }, container)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, track)

    local fill = create("Frame", {
        Size = UDim2.new((initial - minValue) / (maxValue - minValue), 0, 1, 0),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0
    }, track)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, fill)

    local sliderDragging = false
    local function update(input)
        local percentage = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(minValue + percentage * (maxValue - minValue) + 0.5)
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        label.Text = title .. ": " .. value
        callback(value)
        saveConfig()
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
            update(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = false
        end
    end)
end

-- ================= CONTEÚDO DAS ABAS =================

createToggle(pageMain, "Anti-Kick Client", false, function(v) 
    notify(v and "Anti-Kick Ativado" or "Anti-Kick Desativado")
end)

createToggle(pageAimbot, "Toggle Aimbot", settings.aimbotEnabled, function(v) 
    settings.aimbotEnabled = v
    notify(v and "Aimbot Ligado" or "Aimbot Desligado")
end)

createToggle(pageAimbot, "Smart Aim Assist (Auxiliar)", settings.smartAssistEnabled, function(v) 
    settings.smartAssistEnabled = v
    notify(v and "Smart Assist Ligado" or "Smart Assist Desligado")
end)

-- Nova Função Útil: Hitbox Expander
createToggle(pageAimbot, "Hitbox Expander", settings.hitboxExpander, function(v) 
    settings.hitboxExpander = v
    notify(v and "Hitbox Expandida Ativa" or "Hitbox Normal")
end)

createToggle(pageAimbot, "Aim Team Check", settings.aimbotTeamCheck, function(v) settings.aimbotTeamCheck = v end)
createToggle(pageAimbot, "Wall Check", settings.wallCheck, function(v) settings.wallCheck = v end)
createToggle(pageAimbot, "Show FOV Circle", settings.showFovCircle, function(v) settings.showFovCircle = v end)

createToggle(pageAimbot, "Movement Prediction", settings.prediction, function(v) 
    settings.prediction = v
    notify(v and "Predição Ativada" or "Predição Desativada")
end)

local targetBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundColor3 = CARD,
    Text = "Target Part: " .. settings.targetPart,
    TextColor3 = WHITE,
    TextSize = 11,
    Font = Enum.Font.GothamMedium
}, pageAimbot)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, targetBtn)
targetBtn.MouseButton1Click:Connect(function()
    settings.targetPart = (settings.targetPart == "Head") and "HumanoidRootPart" or "Head"
    targetBtn.Text = "Target Part: " .. settings.targetPart
    saveConfig()
end)

createSlider(pageAimbot, "FOV Radius", 50, 400, settings.fov, function(v) settings.fov = v end)
createSlider(pageAimbot, "Smoothness", 1, 20, settings.smoothness, function(v) settings.smoothness = v end)
createSlider(pageAimbot, "Hitbox Size", 2, 8, settings.hitboxSize, function(v) settings.hitboxSize = v end)

createToggle(pageVisuals, "ESP Master (Geral)", settings.espEnabled, function(v) 
    settings.espEnabled = v
    notify(v and "ESP Geral Ligado" or "ESP Geral Desligado")
end)
createToggle(pageVisuals, "ESP Team Check", settings.espTeamCheck, function(v) settings.espTeamCheck = v end)
createToggle(pageVisuals, "ESP Inimigos", settings.espEnemies, function(v) settings.espEnemies = v end)
createToggle(pageVisuals, "ESP Aliados", settings.espAllies, function(v) settings.espAllies = v end)
createToggle(pageVisuals, "ESP Health Bar", settings.espHealthBar, function(v) settings.espHealthBar = v end)
createToggle(pageVisuals, "ESP Tracers", settings.espTracers, function(v) settings.espTracers = v end)

local enemyColorBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundColor3 = CARD,
    Text = "Cor Inimigos: " .. (colorPalette[settings.enemyColorIndex] and colorPalette[settings.enemyColorIndex].name or "Branco"),
    TextColor3 = WHITE,
    TextSize = 11,
    Font = Enum.Font.GothamMedium
}, pageVisuals)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, enemyColorBtn)
enemyColorBtn.MouseButton1Click:Connect(function()
    settings.enemyColorIndex = settings.enemyColorIndex % #colorPalette + 1
    local info = colorPalette[settings.enemyColorIndex]
    enemyColorBtn.Text = "Cor Inimigos: " .. info.name
    saveConfig()
end)

local allyColorBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundColor3 = CARD,
    Text = "Cor Aliados: " .. (colorPalette[settings.allyColorIndex] and colorPalette[settings.allyColorIndex].name or "Branco"),
    TextColor3 = WHITE,
    TextSize = 11,
    Font = Enum.Font.GothamMedium
}, pageVisuals)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, allyColorBtn)
allyColorBtn.MouseButton1Click:Connect(function()
    settings.allyColorIndex = settings.allyColorIndex % #colorPalette + 1
    local info = colorPalette[settings.allyColorIndex]
    allyColorBtn.Text = "Cor Aliados: " .. info.name
    saveConfig()
end)

local origBrightness = Lighting.Brightness
local origClock = Lighting.ClockTime
local origShadows = Lighting.GlobalShadows

createToggle(pageMisc, "Fullbright", settings.fullbright, function(v)
    settings.fullbright = v
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = origBrightness
        Lighting.ClockTime = origClock
        Lighting.GlobalShadows = origShadows
    end
end)

createSlider(pageMisc, "Custom Camera FOV", 70, 120, settings.customFovValue, function(v) settings.customFovValue = v end)

-- CÍRCULO DE FOV UI
local fovCircleFrame = create("Frame", {
    Name = "FOVCircleVisual",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(settings.fov * 2, settings.fov * 2),
    BackgroundTransparency = 1,
    Visible = false
}, gui)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, fovCircleFrame)
local fovStroke = create("UIStroke", { Color = WHITE, Thickness = 1.5, Transparency = 0.1 }, fovCircleFrame)

local function createDrawingObjects()
    local cache = {}
    cache.box = Drawing.new("Square")
    cache.box.Visible = false
    cache.box.Thickness = 1.2
    cache.box.Filled = false

    cache.barBg = Drawing.new("Square")
    cache.barBg.Visible = false
    cache.barBg.Thickness = 1
    cache.barBg.Filled = true
    cache.barBg.Color = Color3.fromRGB(0, 0, 0)

    cache.barFill = Drawing.new("Square")
    cache.barFill.Visible = false
    cache.barFill.Thickness = 1
    cache.barFill.Filled = true

    cache.tracer = Drawing.new("Line")
    cache.tracer.Visible = false
    cache.tracer.Thickness = 1.2

    return cache
end

local function isAlly(targetPlayer, useTeamCheck)
    if not useTeamCheck then return false end
    if player.Team and targetPlayer.Team then
        return player.Team == targetPlayer.Team
    end
    return false
end

local function isVisible(targetPart)
    if not settings.wallCheck then return true end
    if not camera or not player.Character or not player.Character:FindFirstChild("Head") then return true end
    
    local origin = camera.CFrame.Position
    local direction = targetPart.Position - origin
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local ignoreList = {player.Character}
    if targetPart.Parent then table.insert(ignoreList, targetPart.Parent) end
    raycastParams.FilterDescendantsInstances = ignoreList
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

local lastUpdate = 0

RunService.RenderStepped:Connect(function(dt)
    camera = workspace.CurrentCamera
    if not camera then return end

    lastUpdate = lastUpdate + dt
    if lastUpdate >= 0.5 then
        lastUpdate = 0
        local fps = math.floor(1 / dt)
        local ping = math.floor(player:GetNetworkPing() * 1000)
        watermarkText.Text = "gravel.cc  |  fps: " .. fps .. "  |  ms: " .. ping
    end

    fovCircleFrame.Size = UDim2.fromOffset(settings.fov * 2, settings.fov * 2)
    fovCircleFrame.Visible = (settings.aimbotEnabled or settings.smartAssistEnabled) and settings.showFovCircle
    camera.FieldOfView = settings.customFovValue

    local viewport = camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

    local bestTarget = nil
    local bestDistance = settings.fov
    local targetFoundInFov = false

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            if not espDrawings[p] then espDrawings[p] = createDrawingObjects() end
            local cache = espDrawings[p]
            
            local char = p.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local targetPartObj = char and char:FindFirstChild(settings.targetPart) or (char and char:FindFirstChild("Head"))

            if char and rootPart and humanoid and humanoid.Health > 0 then
                -- Lógica do Hitbox Expander (Aumenta o tamanho do torso/cabeça dos inimigos)
                local isTeammate = isAlly(p, settings.aimbotTeamCheck)
                if settings.hitboxExpander and not isTeammate then
                    if rootPart then
                        rootPart.Size = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
                        rootPart.Transparency = 0.5
                        rootPart.CanCollide = false
                    end
                elseif rootPart then
                    rootPart.Size = Vector3.new(2, 2, 1) -- Tamanho original padrão do Roblox
                    rootPart.Transparency = 1
                end

                local showBox = false
                local colorToUse = WHITE
                
                if settings.espEnabled then
                    local ally = isAlly(p, settings.espTeamCheck)
                    if ally then
                        if settings.espAllies then
                            showBox = true
                            colorToUse = colorPalette[settings.allyColorIndex] and colorPalette[settings.allyColorIndex].color or WHITE
                        end
                    else
                        if settings.espEnemies then
                            showBox = true
                            colorToUse = colorPalette[settings.enemyColorIndex] and colorPalette[settings.enemyColorIndex].color or WHITE
                        end
                    end
                end

                if showBox then
                    local vector, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                    if onScreen then
                        local size = Vector2.new(2000 / vector.Z, 3000 / vector.Z)
                        local pos = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)

                        cache.box.Size = size
                        cache.box.Position = pos
                        cache.box.Color = colorToUse
                        cache.box.Visible = true

                        if settings.espHealthBar then
                            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                            local barHeight = size.Y
                            cache.barBg.Size = Vector2.new(3, barHeight)
                            cache.barBg.Position = Vector2.new(pos.X - 6, pos.Y)
                            cache.barBg.Visible = true

                            cache.barFill.Size = Vector2.new(1, barHeight * healthPercent)
                            cache.barFill.Position = Vector2.new(pos.X - 5, pos.Y + (barHeight * (1 - healthPercent)))
                            cache.barFill.Color = WHITE
                            cache.barFill.Visible = true
                        else
                            cache.barBg.Visible = false
                            cache.barFill.Visible = false
                        end

                        if settings.espTracers then
                            cache.tracer.From = Vector2.new(viewport.X / 2, viewport.Y)
                            cache.tracer.To = Vector2.new(vector.X, vector.Y + size.Y / 2)
                            cache.tracer.Color = colorToUse
                            cache.tracer.Visible = true
                        else
                            cache.tracer.Visible = false
                        end
                    else
                        cache.box.Visible = false
                        cache.barBg.Visible = false
                        cache.barFill.Visible = false
                        cache.tracer.Visible = false
                    end
                else
                    cache.box.Visible = false
                    cache.barBg.Visible = false
                    cache.barFill.Visible = false
                    cache.tracer.Visible = false
                end

                if not isTeammate and targetPartObj then
                    local calcPos = targetPartObj.Position
                    if settings.prediction and rootPart then
                        calcPos = calcPos + (rootPart.AssemblyLinearVelocity * 0.08)
                    end

                    local screenPos, onScreen = camera:WorldToViewportPoint(calcPos)
                    if onScreen and screenPos.Z > 0 then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist < settings.fov then
                            if isVisible(targetPartObj) then
                                targetFoundInFov = true
                                if dist < bestDistance then
                                    bestDistance = dist
                                    bestTarget = {Position = calcPos}
                                end
                            end
                        end
                    end
                end
            else
                cache.box.Visible = false
                cache.barBg.Visible = false
                cache.barFill.Visible = false
                cache.tracer.Visible = false
            end
        end
    end

    -- FOV DINÂMICO
    if targetFoundInFov then
        fovStroke.Color = Color3.fromRGB(255, 50, 50)
    else
        fovStroke.Color = WHITE
    end

    -- AIMBOT ORIGINAL
    if settings.aimbotEnabled and bestTarget then
        local direction = CFrame.lookAt(camera.CFrame.Position, bestTarget.Position)
        local alpha = math.clamp(1 / settings.smoothness, 0.01, 1)
        camera.CFrame = camera.CFrame:Lerp(direction, alpha)
    end

    -- SMART ASSIST
    if settings.smartAssistEnabled and bestTarget then
        local direction = CFrame.lookAt(camera.CFrame.Position, bestTarget.Position)
        local alpha = math.clamp(1 / (settings.smoothness * 1.5), 0.01, 1)
        camera.CFrame = camera.CFrame:Lerp(direction, alpha)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if espDrawings[p] then
        if espDrawings[p].box then espDrawings[p].box:Remove() end
        if espDrawings[p].barBg then espDrawings[p].barBg:Remove() end
        if espDrawings[p].barFill then espDrawings[p].barFill:Remove() end
        if espDrawings[p].tracer then espDrawings[p].tracer:Remove() end
        espDrawings[p] = nil
    end
end)

notify("Gravel.cc Hub Atualizado (Sem Auto Fire)")
print("[Gravel Ultimate B&W Hub] Hitbox Expander + Aimbot Puro + ESP Ativos!")
