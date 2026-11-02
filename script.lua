-- ==========================================================
-- GRAVEL.CC | ULTIMATE UNIVERSAL EDITION [LORDTHS EDITION - V58.01]
-- ==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local success, targetGuiParent = pcall(function() return CoreGui end)
if not success or not targetGuiParent then
    targetGuiParent = player:WaitForChild("PlayerGui")
end

local settings = {
    -- AIMBOT PADRÃO
    aimbotEnabled = false,
    smartAssistEnabled = false,
    aimbotTeamCheck = true,
    wallCheck = false,
    showFovCircle = true,
    targetPart = "Head",
    smoothness = 4.0,
    fov = 200,
    prediction = true,
    
    -- DYNAMIC FOV
    dynamicFov = false,
    dynBaseSize = 120,
    dynSizeClose = 200,
    dynSizeFar = 30,
    dynMaxDist = 120,
    dynOffsetX = 0,
    dynOffsetY = 0,

    -- AIMBOT DINÂMICO
    dynamicAimEnabled = false,
    dynamicAimFov = 150,
    showDynamicAimFov = true,
    dynAimCloseSmooth = 1.2,
    dynAimMediumSmooth = 4.0,
    dynAimFarSmooth = 12.0,

    -- ALERTA PULSANTE
    pulseAlertEnabled = false,

    targetHudEnabled = true,
    antiRecoilEnabled = false,
    
    -- ESP AIM
    independentEspAim = false,
    showEspAimFovCircle = true,
    espAimFov = 150,

    triggerbotEnabled = false,
    hitboxExpander = false,
    hitboxSize = 6.0,

    espEnabled = false,
    espTeamCheck = true,
    espEnemies = true,
    espAllies = false,
    espHealthBar = true,
    espNameTag = true,
    espDistance = true,

    partHeadEnabled = false,
    partTorsoEnabled = false,
    partArmsEnabled = false,
    partLegsEnabled = false,

    espHandItemEnabled = false,

    -- RADAR TÁTICO & ESP POR APROXIMAÇÃO INDEPENDENTE
    radarAdvancedEnabled = false, 
    radarEspProximityEnabled = true,
    radarProximityRange = 200, 
    radarLoSAlert = true,     

    lootEspEnabled = false,
    lootMaxDistance = 100,
    lootBoxEnabled = true,
    lootLineEnabled = true,
    lootNameEnabled = true,

    crosshairEnabled = false,
    fullbright = false,
    customFovValue = 70,
    thirdPerson = false,
    bhop = false,
    
    wallHackEnabled = false,
    noclipEnabled = false,
    universalCrosshairDot = true,
    
    lockedTargetName = "",
    fontSize = 11,

    -- CORES CUSTOMIZÁVEIS
    colors = {
        enemy = {255, 50, 50},
        ally = {50, 150, 255},
        bodyParts = {255, 50, 50},
        espHand = {255, 220, 50},
        espAim = {180, 50, 255},
        fovCircle = {240, 240, 240},
        dynAimFovCircle = {255, 220, 50},
        espAimFovCircle = {180, 50, 255},
        radarBlip = {255, 50, 50},
        radarBoxOverride = {255, 140, 0},
        loot = {255, 220, 50},
        crosshair = {240, 240, 240}
    }
}

local configFileName = "GravelHub_LordthsConfigV58.json"

local function getRGB(colorTable)
    return Color3.fromRGB(colorTable[1], colorTable[2], colorTable[3])
end

local function saveConfig()
    pcall(function()
        if writefile then
            writefile(configFileName, HttpService:JSONEncode(settings))
        end
    end)
end

local function loadConfig()
    pcall(function()
        if readfile and isfile and isfile(configFileName) then
            local content = readfile(configFileName)
            local data = HttpService:JSONDecode(content)
            if type(data) == "table" then
                for k, v in pairs(data) do
                    if settings[k] ~= nil then settings[k] = v end
                end
            end
        end
    end)
end

loadConfig()

local function create(class, props, parent)
    local obj = Instance.new(class)
    for key, value in pairs(props) do
        pcall(function() obj[key] = value end)
    end
    obj.Parent = parent
    return obj
end

pcall(function()
    if targetGuiParent:FindFirstChild("GravelMasterLordthsEditionV58") then
        targetGuiParent.GravelMasterLordthsEditionV58:Destroy()
    end
end)

local gui = create("ScreenGui", {
    Name = "GravelMasterLordthsEditionV58",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999
}, targetGuiParent)

local main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(580, 420),
    Position = UDim2.new(0.5, -290, 0.5, -210),
    BackgroundColor3 = Color3.fromRGB(10, 10, 10),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 10
}, gui)
create("UICorner", { CornerRadius = UDim.new(0, 8) }, main)
create("UIStroke", { Color = Color3.fromRGB(45, 45, 45), Thickness = 1.2 }, main)

-- POPUP FLUTUANTE DE INFO
local infoPopup = create("Frame", {
    Name = "InfoPopup",
    Size = UDim2.fromOffset(280, 130),
    Position = UDim2.new(0.5, -140, 0.5, -65),
    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 50000
}, gui)
create("UICorner", { CornerRadius = UDim.new(0, 8) }, infoPopup)
create("UIStroke", { Color = Color3.fromRGB(180, 50, 255), Thickness = 1.5 }, infoPopup)

local infoTitleLabel = create("TextLabel", {
    Size = UDim2.new(1, -40, 0, 28),
    Position = UDim2.fromOffset(12, 6),
    BackgroundTransparency = 1,
    Text = "INFORMAÇÃO DA FUNÇÃO",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 50001
}, infoPopup)

local infoCloseBtn = create("TextButton", {
    Size = UDim2.fromOffset(24, 24),
    Position = UDim2.new(1, -30, 0, 8),
    BackgroundColor3 = Color3.fromRGB(180, 50, 50),
    BackgroundTransparency = 0.2,
    Text = "X",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    ZIndex = 50002
}, infoPopup)
create("UICorner", { CornerRadius = UDim.new(0, 5) }, infoCloseBtn)
create("UIStroke", { Color = Color3.fromRGB(220, 80, 80), Thickness = 1 }, infoPopup)

local infoDescLabel = create("TextLabel", {
    Size = UDim2.new(1, -24, 1, -45),
    Position = UDim2.fromOffset(12, 36),
    BackgroundTransparency = 1,
    Text = "Descrição detalhada da função aparecerá aqui.",
    TextColor3 = Color3.fromRGB(200, 200, 200),
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    ZIndex = 50001
}, infoPopup)

infoCloseBtn.MouseButton1Click:Connect(function() infoPopup.Visible = false end)
local function showInfoPopup(title, description)
    infoTitleLabel.Text = "INFO: " .. string.upper(title)
    infoDescLabel.Text = description
    infoPopup.Visible = true
end

local loadingScreen = create("Frame", {
    Size = UDim2.fromOffset(380, 190),
    Position = UDim2.new(0.5, -190, 0.5, -95),
    BackgroundColor3 = Color3.fromRGB(10, 10, 10),
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    ZIndex = 60000
}, gui)
create("UICorner", { CornerRadius = UDim.new(0, 8) }, loadingScreen)
create("UIStroke", { Color = Color3.fromRGB(50, 50, 50), Thickness = 1.2 }, loadingScreen)

create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.fromOffset(0, 30),
    BackgroundTransparency = 1,
    Text = "GRAVEL.CC // ULTIMATE",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 60001
}, loadingScreen)

create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.fromOffset(0, 60),
    BackgroundTransparency = 1,
    Text = "Carregando Lordths Edition V58.01...",
    TextColor3 = Color3.fromRGB(130, 130, 130),
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 60001
}, loadingScreen)

local loadBarBg = create("Frame", {
    Size = UDim2.fromOffset(320, 6),
    Position = UDim2.new(0.5, -160, 0, 115),
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    BorderSizePixel = 0,
    ZIndex = 60001
}, loadingScreen)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, loadBarBg)

local loadBarFill = create("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(240, 240, 240),
    BorderSizePixel = 0,
    ZIndex = 60002
}, loadBarBg)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, loadBarFill)

local menuVisible = true
local function toggleMenu()
    menuVisible = not menuVisible
    main.Visible = menuVisible
    if not menuVisible then infoPopup.Visible = false end
end

task.spawn(function()
    pcall(function()
        TweenService:Create(loadBarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0.5, 0, 1, 0)}):Play()
        task.wait(0.3)
        TweenService:Create(loadBarFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(0.3)
    end)
    loadingScreen:Destroy()
    menuVisible = true
    main.Visible = true
end)

-- NOTIFICAÇÕES
local hudContainer = create("Frame", {
    Size = UDim2.fromOffset(230, 64),
    Position = UDim2.new(0, 15, 0, 15),
    BackgroundTransparency = 1,
    ZIndex = 30
}, gui)

local watermark = create("Frame", {
    Size = UDim2.fromOffset(230, 28),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ZIndex = 31
}, hudContainer)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, watermark)
create("UIStroke", { Color = Color3.fromRGB(50, 50, 50), Thickness = 1 }, watermark)

local watermarkLabel = create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "gravel.cc (LORDths) | fps: -- | ms: --",
    TextColor3 = Color3.fromRGB(220, 220, 220),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    ZIndex = 32
}, watermark)

local notificationPill = create("Frame", {
    Size = UDim2.fromOffset(230, 0),
    Position = UDim2.new(0, 0, 0, 32),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 29
}, hudContainer)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, notificationPill)
local notifStroke = create("UIStroke", { Color = Color3.fromRGB(50, 255, 100), Thickness = 1.2 }, notificationPill)

local notifTextLabel = create("TextLabel", {
    Size = UDim2.new(1, -12, 1, 0),
    Position = UDim2.fromOffset(6, 0),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextWrapped = true,
    ZIndex = 30
}, notificationPill)

local activeNotifTween = nil
local function notify(text, alertType)
    pcall(function() if activeNotifTween then activeNotifTween:Cancel() end end)

    local strokeColor = Color3.fromRGB(50, 255, 100)
    if alertType == "amarelo" then strokeColor = Color3.fromRGB(255, 220, 50)
    elseif alertType == "vermelho" then strokeColor = Color3.fromRGB(255, 50, 50) end

    notifStroke.Color = strokeColor
    notifTextLabel.Text = text

    local openTween = TweenService:Create(notificationPill, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(230, 30)})
    openTween:Play()
    activeNotifTween = openTween

    task.delay(3.5, function()
        if notificationPill and notificationPill.AbsoluteSize.Y > 0 then
            local closeTween = TweenService:Create(notificationPill, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.fromOffset(230, 0)})
            closeTween:Play()
        end
    end)
end

local fpsFrames, fpsTime = 0, 0
RunService.RenderStepped:Connect(function(dt)
    fpsFrames = fpsFrames + 1
    fpsTime = fpsTime + dt
    if fpsTime >= 0.5 then
        local currentFps = math.floor(fpsFrames / fpsTime)
        local currentPing = 0
        pcall(function() currentPing = math.floor(player:GetNetworkPing() * 1000) end)
        watermarkLabel.Text = string.format("gravel.cc (LORDths) | fps: %d | ms: %d", currentFps, currentPing)
        fpsFrames, fpsTime = 0, 0
    end
end)

-- BOTÃO FLUTUANTE THS
local floatingToggleBtn = create("TextButton", {
    Size = UDim2.fromOffset(45, 45),
    Position = UDim2.new(0, 15, 0, 90),
    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
    BackgroundTransparency = 0.2,
    Text = "THS",
    TextColor3 = Color3.fromRGB(255, 50, 50),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    ZIndex = 40
}, gui)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, floatingToggleBtn)
create("UIStroke", { Color = Color3.fromRGB(180, 50, 255), Thickness = 1.5 }, floatingToggleBtn)

local btnDragging, btnDragStart, btnStartPos, btnMoved = false, nil, nil, false
floatingToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true; btnDragStart = input.Position; btnStartPos = floatingToggleBtn.Position; btnMoved = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        if delta.Magnitude > 5 then btnMoved = true end
        floatingToggleBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then btnDragging = false end
end)
floatingToggleBtn.MouseButton1Click:Connect(function() if not btnMoved then toggleMenu() end end)

local top = create("Frame", {
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    ZIndex = 11
}, main)
create("UICorner", { CornerRadius = UDim.new(0, 8) }, top)
create("UIStroke", { Color = Color3.fromRGB(40, 40, 40), Thickness = 0.8 }, top)

create("TextLabel", {
    Size = UDim2.new(1, -90, 1, 0),
    Position = UDim2.fromOffset(15, 0),
    BackgroundTransparency = 1,
    Text = "GRAVEL.CC  //  LORDTHS EDITION",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12
}, top)

local scriptActive = true
local close = create("TextButton", {
    Size = UDim2.fromOffset(22, 22),
    Position = UDim2.new(1, -28, 0, 6),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 0.2,
    Text = "X",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    ZIndex = 12
}, top)
create("UICorner", { CornerRadius = UDim.new(0, 5) }, close)

close.MouseButton1Click:Connect(function()
    scriptActive = false
    gui:Destroy()
end)

local dragging, dragStart, startPosition
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPosition = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local tabScroll = create("ScrollingFrame", {
    Size = UDim2.new(1, -20, 0, 36),
    Position = UDim2.fromOffset(10, 40),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0, 700, 0, 0),
    ScrollBarThickness = 2,
    ScrollingDirection = Enum.ScrollingDirection.X,
    ZIndex = 11
}, main)

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabScroll

local pagesContainer = create("Frame", {
    Position = UDim2.fromOffset(8, 82),
    Size = UDim2.new(1, -16, 1, -90),
    BackgroundTransparency = 1,
    ZIndex = 11
}, main)

local pages = {}
local tabButtons = {}

local function createPage(name)
    local page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 1500),
        ScrollBarThickness = 2,
        ZIndex = 11
    }, pagesContainer)
    pages[name] = page
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page
    return page
end

local pageCombat = createPage("Combate")
local pageVisuals = createPage("Visuals ESP")
local pageRadarWorld = createPage("Radar & Mundo")
local pageColors = createPage("Cores Globais")
local pageTools = createPage("Ferramentas")

local function switchPage(targetName)
    for pName, pObj in pairs(pages) do pObj.Visible = (pName == targetName) end
    for name, btn in pairs(tabButtons) do
        if name == targetName then
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.TextColor3 = Color3.fromRGB(240, 240, 240)
        else
            btn.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
            btn.TextColor3 = Color3.fromRGB(160, 160, 160)
        end
    end
end
switchPage("Combate")

local function createTabButton(text, targetPage)
    local btn = create("TextButton", {
        Size = UDim2.fromOffset(110, 30),
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        Text = text,
        TextColor3 = Color3.fromRGB(160, 160, 160),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        ZIndex = 12
    }, tabScroll)
    create("UICorner", { CornerRadius = UDim.new(0, 5) }, btn)
    create("UIStroke", { Color = Color3.fromRGB(35, 35, 35), Thickness = 1 }, btn)
    tabButtons[targetPage] = btn
    btn.MouseButton1Click:Connect(function() switchPage(targetPage) end)
end

createTabButton("Combate", "Combate")
createTabButton("Visuals ESP", "Visuals ESP")
createTabButton("Radar & Mundo", "Radar & Mundo")
createTabButton("Cores Globais", "Cores Globais")
createTabButton("Ferramentas", "Ferramentas")

-- GAVETAS EXPANSIVAS
local function createDrawer(parent, drawerTitle, infoText)
    local drawerContainer = create("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 12
    }, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, drawerContainer)
    create("UIStroke", { Color = Color3.fromRGB(45, 45, 45), Thickness = 1 }, drawerContainer)

    local header = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 1,
        Text = "  [+] GAVETA: " .. drawerTitle,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13
    }, drawerContainer)

    local infoBtn = create("TextButton", {
        Size = UDim2.fromOffset(40, 24),
        Position = UDim2.new(1, -46, 0, 7),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = "INFO",
        TextColor3 = Color3.fromRGB(200, 150, 255),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        ZIndex = 14
    }, drawerContainer)
    create("UICorner", { CornerRadius = UDim.new(0, 4) }, infoBtn)
    infoBtn.MouseButton1Click:Connect(function() showInfoPopup(drawerTitle, infoText) end)

    local contentHolder = create("Frame", {
        Size = UDim2.new(1, -16, 0, 0),
        Position = UDim2.fromOffset(8, 42),
        BackgroundTransparency = 1,
        ZIndex = 13
    }, drawerContainer)

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.Parent = contentHolder

    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        local targetHeight = contentLayout.AbsoluteContentSize.Y + 50
        if isOpen then
            header.Text = "  [-] GAVETA: " .. drawerTitle
            TweenService:Create(drawerContainer, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
        else
            header.Text = "  [+] GAVETA: " .. drawerTitle
            TweenService:Create(drawerContainer, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, 38)}):Play()
        end
    end)

    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isOpen then drawerContainer.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 50) end
    end)

    return contentHolder
end

-- TOGGLE BLINDADO
local function createToggle(parent, text, infoText, initial, callback)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 14
    }, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, container)
    create("UIStroke", { Color = Color3.fromRGB(30, 30, 30), Thickness = 1 }, container)

    create("TextLabel", {
        Size = UDim2.new(1, -95, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = settings.fontSize,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15
    }, container)

    local infoBtn = create("TextButton", {
        Size = UDim2.fromOffset(36, 20),
        Position = UDim2.new(1, -84, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Text = "INFO",
        TextColor3 = Color3.fromRGB(200, 150, 255),
        TextSize = 8,
        Font = Enum.Font.GothamBold,
        ZIndex = 18
    }, container)
    create("UICorner", { CornerRadius = UDim.new(0, 4) }, infoBtn)
    infoBtn.MouseButton1Click:Connect(function() showInfoPopup(text, infoText) end)

    local switchBg = create("TextButton", {
        Size = UDim2.fromOffset(36, 18),
        Position = UDim2.new(1, -44, 0.5, -9),
        BackgroundColor3 = initial and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0, Text = "", ZIndex = 16
    }, container)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, switchBg)

    local switchCircle = create("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = initial and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BorderSizePixel = 0, ZIndex = 17
    }, switchBg)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, switchCircle)

    local state = initial
    switchBg.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        saveConfig()
        local targetPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = state and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(20, 20, 20)
        TweenService:Create(switchCircle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end)
end

-- SLIDER COM SUPORTE TOTAL DE TOQUE
local function createSlider(parent, title, infoText, minValue, maxValue, initial, isDecimal, callback)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0, ZIndex = 14
    }, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, container)
    create("UIStroke", { Color = Color3.fromRGB(30, 30, 30), Thickness = 1 }, container)

    create("TextLabel", {
        Size = UDim2.new(1, -115, 0, 22),
        Position = UDim2.fromOffset(12, 6),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = settings.fontSize,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 15
    }, container)

    local infoBtn = create("TextButton", {
        Size = UDim2.fromOffset(36, 18),
        Position = UDim2.new(1, -110, 0, 8),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Text = "INFO",
        TextColor3 = Color3.fromRGB(200, 150, 255),
        TextSize = 8, Font = Enum.Font.GothamBold, ZIndex = 18
    }, container)
    create("UICorner", { CornerRadius = UDim.new(0, 4) }, infoBtn)
    infoBtn.MouseButton1Click:Connect(function() showInfoPopup(title, infoText) end)

    local valBox = create("TextBox", {
        Size = UDim2.fromOffset(55, 20),
        Position = UDim2.new(1, -65, 0, 6),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Text = tostring(initial),
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = 11, Font = Enum.Font.GothamBold,
        ClearTextOnFocus = false, ZIndex = 16
    }, container)
    create("UICorner", { CornerRadius = UDim.new(0, 4) }, valBox)

    local track = create("Frame", {
        Size = UDim2.new(1, -24, 0, 6),
        Position = UDim2.fromOffset(12, 34),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0, ZIndex = 15
    }, container)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, track)

    local fill = create("Frame", {
        Size = UDim2.new((initial - minValue) / (maxValue - minValue), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(240, 240, 240),
        BorderSizePixel = 0, ZIndex = 16
    }, track)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, fill)

    local knob = create("Frame", {
        Size = UDim2.fromOffset(12, 12),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((initial - minValue) / (maxValue - minValue), 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0, ZIndex = 17
    }, track)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)

    local function updateValue(val)
        val = math.clamp(val, minValue, maxValue)
        val = isDecimal and (math.floor(val * 10 + 0.5) / 10) or math.floor(val + 0.5)
        local pct = (val - minValue) / (maxValue - minValue)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, 0, 0.5, 0)
        valBox.Text = tostring(val)
        callback(val)
        saveConfig()
    end

    valBox.FocusLost:Connect(function()
        local num = tonumber(valBox.Text)
        if num then updateValue(num) else valBox.Text = tostring(initial) end
    end)

    local sliderDragging = false
    local function applyInput(input)
        local posRatio = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        updateValue(minValue + posRatio * (maxValue - minValue))
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true; applyInput(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            applyInput(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = false
        end
    end)
end

-- COLOR PICKER RGB COMPACTO
local function createColorPicker(parent, title, colorKey)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 140),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0, ZIndex = 14
    }, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, container)
    create("UIStroke", { Color = Color3.fromRGB(30, 30, 30), Thickness = 1 }, container)

    create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 24),
        Position = UDim2.fromOffset(12, 6),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = settings.fontSize,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 15
    }, container)

    local previewBox = create("Frame", {
        Size = UDim2.fromOffset(30, 18),
        Position = UDim2.new(1, -42, 0, 8),
        BackgroundColor3 = getRGB(settings.colors[colorKey]),
        BorderSizePixel = 0, ZIndex = 15
    }, container)
    create("UICorner", { CornerRadius = UDim.new(0, 4) }, previewBox)
    create("UIStroke", { Color = Color3.fromRGB(60, 60, 60), Thickness = 1 }, previewBox)

    local sliderHolder = create("Frame", {
        Size = UDim2.new(1, -24, 0, 95),
        Position = UDim2.fromOffset(12, 34),
        BackgroundTransparency = 1, ZIndex = 15
    }, container)

    local function makeChanSlider(yOffset, chanName, chanIdx)
        createSlider(sliderHolder, chanName, "Ajuste do canal " .. chanName, 0, 255, settings.colors[colorKey][chanIdx], false, function(val)
            settings.colors[colorKey][chanIdx] = val
            previewBox.BackgroundColor3 = getRGB(settings.colors[colorKey])
            saveConfig()
        end)
    end

    makeChanSlider(0, "Red (R)", 1)
    makeChanSlider(32, "Green (G)", 2)
    makeChanSlider(64, "Blue (B)", 3)
end

-- ABA 1: COMBATE
local drawerAimbot = createDrawer(pageCombat, "AIMBOT PADRÃO", "Mira automática convencional.")
createToggle(drawerAimbot, "Ativar Aimbot Padrão", "Ativa o Aimbot convencional.", settings.aimbotEnabled, function(v) settings.aimbotEnabled = v end)
createToggle(drawerAimbot, "Smart Aim Assist", "Assistente para evitar puxadas bruscas.", settings.smartAssistEnabled, function(v) settings.smartAssistEnabled = v end)
createToggle(drawerAimbot, "Aim Team Check", "Evita travar em aliados.", settings.aimbotTeamCheck, function(v) settings.aimbotTeamCheck = v end)
createToggle(drawerAimbot, "Wall Check", "Não trava através de paredes.", settings.wallCheck, function(v) settings.wallCheck = v end)
createToggle(drawerAimbot, "Show FOV Circle", "Exibe o círculo do FOV padrão.", settings.showFovCircle, function(v) settings.showFovCircle = v end)
createToggle(drawerAimbot, "Movement Prediction", "Prevê movimento do alvo.", settings.prediction, function(v) settings.prediction = v end)
createSlider(drawerAimbot, "FOV Padrão", "Raio estático do círculo de alcance da mira padrão.", 10, 400, settings.fov, false, function(v) settings.fov = v end)
createSlider(drawerAimbot, "Smoothness (Suavidade)", "Suavidade do Aimbot Padrão.", 1, 20, settings.smoothness, true, function(v) settings.smoothness = v end)

-- FOV DINÂMICO
local drawerDynFov = createDrawer(pageCombat, "DYNAMIC FOV (PASTA AIM)", "FOV que ajusta de tamanho conforme a distância.")
createToggle(drawerDynFov, "Ativar Dynamic FOV", "Altera o tamanho do FOV por distância.", settings.dynamicFov, function(v) settings.dynamicFov = v end)
createSlider(drawerDynFov, "Tamanho Quando Perto", "Tamanho do FOV quando o alvo estiver próximo.", 10, 400, settings.dynSizeClose, false, function(v) settings.dynSizeClose = v end)
createSlider(drawerDynFov, "Tamanho Quando Longe", "Tamanho do FOV quando o alvo estiver distante.", 5, 200, settings.dynSizeFar, false, function(v) settings.dynSizeFar = v end)
createSlider(drawerDynFov, "Distância Máxima (Studs)", "Distância limite de cálculo.", 30, 300, settings.dynMaxDist, false, function(v) settings.dynMaxDist = v end)
createSlider(drawerDynFov, "Offset X (Lado)", "Offset horizontal da mira.", -200, 200, settings.dynOffsetX, false, function(v) settings.dynOffsetX = v end)
createSlider(drawerDynFov, "Offset Y (Altura)", "Offset vertical da mira.", -200, 200, settings.dynOffsetY, false, function(v) settings.dynOffsetY = v end)

-- AIMBOT DINÂMICO
local drawerDynAim = createDrawer(pageCombat, "AIMBOT DINÂMICO", "Mira dinâmica com força adaptativa por distância.")
createToggle(drawerDynAim, "Ativar Aimbot Dinâmico", "Liga o Aimbot adaptativo.", settings.dynamicAimEnabled, function(v) settings.dynamicAimEnabled = v end)
createToggle(drawerDynAim, "Mostrar FOV Dinâmico Aim", "Exibe o círculo visual do Aim Dinâmico.", settings.showDynamicAimFov, function(v) settings.showDynamicAimFov = v end)
createSlider(drawerDynAim, "FOV do Aim Dinâmico", "Tamanho do círculo exclusivo.", 10, 400, settings.dynamicAimFov, false, function(v) settings.dynamicAimFov = v end)
createSlider(drawerDynAim, "Suavidade MUITO PERTO", "Suavidade de perto.", 0.5, 5, settings.dynAimCloseSmooth, true, function(v) settings.dynAimCloseSmooth = v end)
createSlider(drawerDynAim, "Suavidade MÉDIA", "Suavidade em distâncias médias.", 2, 10, settings.dynAimMediumSmooth, true, function(v) settings.dynAimMediumSmooth = v end)
createSlider(drawerDynAim, "Suavidade LONGE", "Suavidade quando distante.", 5, 25, settings.dynAimFarSmooth, true, function(v) settings.dynAimFarSmooth = v end)

local drawerAssist = createDrawer(pageCombat, "ASSISTENTES EXTRAS", "Triggerbot e Hitbox.")
createToggle(drawerAssist, "Triggerbot", "Disparos automáticos.", settings.triggerbotEnabled, function(v) settings.triggerbotEnabled = v end)
createToggle(drawerAssist, "Hitbox Expander", "Expande o corpo dos oponentes.", settings.hitboxExpander, function(v) settings.hitboxExpander = v end)
createSlider(drawerAssist, "Hitbox Size", "Multiplicador de tamanho.", 2, 15, settings.hitboxSize, false, function(v) settings.hitboxSize = v end)

-- ABA 2: VISUALS ESP
local drawerEspMaster = createDrawer(pageVisuals, "ESP PRINCIPAL E CAIXAS", "Contornos visuais dos jogadores.")
createToggle(drawerEspMaster, "ESP Master (Geral)", "Liga o ESP global.", settings.espEnabled, function(v) settings.espEnabled = v end)
createToggle(drawerEspMaster, "ESP Team Check", "Separa aliados de inimigos.", settings.espTeamCheck, function(v) settings.espTeamCheck = v end)
createToggle(drawerEspMaster, "ESP Inimigos", "Mostra caixas nos oponentes.", settings.espEnemies, function(v) settings.espEnemies = v end)
createToggle(drawerEspMaster, "ESP Aliados", "Mostra caixas na equipe.", settings.espAllies, function(v) settings.espAllies = v end)
createToggle(drawerEspMaster, "ESP Health Bar", "Exibe barra de vida.", settings.espHealthBar, function(v) settings.espHealthBar = v end)
createToggle(drawerEspMaster, "Name Tag ESP", "Exibe nome.", settings.espNameTag, function(v) settings.espNameTag = v end)
createToggle(drawerEspMaster, "ESP Distância (m)", "Exibe distância.", settings.espDistance, function(v) settings.espDistance = v end)
createToggle(drawerEspMaster, "Alerta Pulsante Visível", "Pisca apenas se visível.", settings.pulseAlertEnabled, function(v) settings.pulseAlertEnabled = v end)

local drawerEspAim = createDrawer(pageVisuals, "ESP AIM (INDICADOR VISUAL)", "Linha mostrando em quem sua mira está focada.")
createToggle(drawerEspAim, "Ativar ESP Aim (Linha de Alvo)", "Linha do centro até o alvo.", settings.independentEspAim, function(v) settings.independentEspAim = v end)
createToggle(drawerEspAim, "Mostrar FOV do ESP Aim", "Exibe o círculo visual do ESP Aim.", settings.showEspAimFovCircle, function(v) settings.showEspAimFovCircle = v end)
createSlider(drawerEspAim, "Alcance do FOV (ESP Aim)", "Raio de detecção do ESP Aim.", 10, 400, settings.espAimFov, false, function(v) settings.espAimFov = v end)

local drawerEspParts = createDrawer(pageVisuals, "ESP PARTES ESPECÍFICAS", "Contornos por membros.")
createToggle(drawerEspParts, "ESP Cabeça", "Caixa na cabeça.", settings.partHeadEnabled, function(v) settings.partHeadEnabled = v end)
createToggle(drawerEspParts, "ESP Tronco", "Caixa no tronco.", settings.partTorsoEnabled, function(v) settings.partTorsoEnabled = v end)
createToggle(drawerEspParts, "ESP Braços", "Contorno nos braços.", settings.partArmsEnabled, function(v) settings.partArmsEnabled = v end)
createToggle(drawerEspParts, "ESP Pernas", "Contorno nas pernas.", settings.partLegsEnabled, function(v) settings.partLegsEnabled = v end)

local drawerEspHand = createDrawer(pageVisuals, "ESP MÃO E ITENS", "Rastreio do item em mãos.")
createToggle(drawerEspHand, "ESP Mão", "Item na mão.", settings.espHandItemEnabled, function(v) settings.espHandItemEnabled = v end)

-- ABA 3: RADAR & MUNDO
local drawerRadarPro = createDrawer(pageRadarWorld, "RADAR TÁTICO PRO", "Mini-radar e ESP de tela por proximidade.")
createToggle(drawerRadarPro, "Ativar Radar Tático Pro", "Ativa o elemento visual do mini-radar na tela.", settings.radarAdvancedEnabled, function(v) settings.radarAdvancedEnabled = v end)
createToggle(drawerRadarPro, "ESP 3D Por Aproximação", "Desenha caixas no jogo APENAS para inimigos próximos do raio.", settings.radarEspProximityEnabled, function(v) settings.radarEspProximityEnabled = v end)
createToggle(drawerRadarPro, "Alerta de Visão Direta (LoS)", "Avisa se o inimigo te olha.", settings.radarLoSAlert, function(v) settings.radarLoSAlert = v end)
createSlider(drawerRadarPro, "Raio de Proximidade (Studs)", "Alcance máximo configurável da detecção.", 20, 500, settings.radarProximityRange, false, function(v) settings.radarProximityRange = v end)

local drawerLoot = createDrawer(pageRadarWorld, "LOOT ESP", "Localizador de itens.")
createToggle(drawerLoot, "Ativar Loot ESP", "Rastreio de itens pelo mapa.", settings.lootEspEnabled, function(v) settings.lootEspEnabled = v end)
createToggle(drawerLoot, "Mostrar Caixa", "Desenha caixas.", settings.lootBoxEnabled, function(v) settings.lootBoxEnabled = v end)
createToggle(drawerLoot, "Mostrar Linha", "Desenha linhas.", settings.lootLineEnabled, function(v) settings.lootLineEnabled = v end)
createToggle(drawerLoot, "Mostrar Nome", "Exibe nome.", settings.lootNameEnabled, function(v) settings.lootNameEnabled = v end)
createSlider(drawerLoot, "Distância Máxima (Studs)", "Alcance limite.", 5, 500, settings.lootMaxDistance, false, function(v) settings.lootMaxDistance = v end)

-- ABA 4: CORES GLOBAIS
local drawerColorsEsp = createDrawer(pageColors, "CORES DOS ESPs & JOGADORES", "Ajuste RGB das caixas e partes.")
createColorPicker(drawerColorsEsp, "Cor Inimigos", "enemy")
createColorPicker(drawerColorsEsp, "Cor Aliados", "ally")
createColorPicker(drawerColorsEsp, "Cor ESP Partes do Corpo", "bodyParts")
createColorPicker(drawerColorsEsp, "Cor ESP Mão / Item", "espHand")
createColorPicker(drawerColorsEsp, "Cor ESP Aim (Linha de Alvo)", "espAim")

local drawerColorsFov = createDrawer(pageColors, "CORES DOS CÍRCULOS DE FOV", "Ajuste RGB dos círculos de mira.")
createColorPicker(drawerColorsFov, "Cor FOV Padrão", "fovCircle")
createColorPicker(drawerColorsFov, "Cor FOV Dinâmico Aim", "dynAimFovCircle")
createColorPicker(drawerColorsFov, "Cor FOV ESP Aim", "espAimFovCircle")

local drawerColorsWorld = createDrawer(pageColors, "CORES DE MUNDO & RADAR", "Ajuste RGB do radar e itens.")
createColorPicker(drawerColorsWorld, "Cor Radar Blips", "radarBlip")
createColorPicker(drawerColorsWorld, "Cor ESP por Aproximação", "radarBoxOverride")
createColorPicker(drawerColorsWorld, "Cor Loot ESP", "loot")
createColorPicker(drawerColorsWorld, "Cor Crosshair Central", "crosshair")

-- ABA 5: FERRAMENTAS & MISC
local drawerTools = createDrawer(pageTools, "UTILITÁRIOS E MISC", "Ferramentas gerais.")
createToggle(drawerTools, "Target HUD", "Painel com dados do alvo.", settings.targetHudEnabled, function(v) settings.targetHudEnabled = v end)
createToggle(drawerTools, "No-Clip", "Atravessar paredes.", settings.noclipEnabled, function(v) settings.noclipEnabled = v end)
createToggle(drawerTools, "Wall Hack", "Paredes transparentes.", settings.wallHackEnabled, function(v)
    settings.wallHackEnabled = v
    for _, part in ipairs(Workspace:GetDescendants()) do
        pcall(function() if part:IsA("BasePart") and not part:IsDescendantOf(player.Character) then part.Transparency = v and 0.6 or 0 end end)
    end
end)
createToggle(drawerTools, "Crosshair Central", "Mira de tela.", settings.universalCrosshairDot, function(v) settings.universalCrosshairDot = v end)
createToggle(drawerTools, "Fullbright", "Iluminação total.", settings.fullbright, function(v) settings.fullbright = v; Lighting.Brightness = v and 3 or 1 end)
createToggle(drawerTools, "Anti-Recoil", "Reduz coice da arma.", settings.antiRecoilEnabled, function(v) settings.antiRecoilEnabled = v end)
createToggle(drawerTools, "Bunny Hop", "Pulos automáticos.", settings.bhop, function(v) settings.bhop = v end)
createSlider(drawerTools, "Custom Camera FOV", "Campo de visão da câmera.", 70, 120, settings.customFovValue, false, function(v) settings.customFovValue = v end)

-- ESTRUTURAS VISUAIS DE FOV E LINHAS
local fovCircleFrame = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Visible = false }, gui)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, fovCircleFrame)
local fovStroke = create("UIStroke", { Thickness = 1.5, Transparency = 0.2 }, fovCircleFrame)

local dynAimFovCircleFrame = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Visible = false }, gui)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, dynAimFovCircleFrame)
local dynAimFovStroke = create("UIStroke", { Thickness = 1.5, Transparency = 0.2 }, dynAimFovCircleFrame)

local espAimFovCircleFrame = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Visible = false }, gui)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, espAimFovCircleFrame)
local espAimFovStroke = create("UIStroke", { Thickness = 1.5, Transparency = 0.2 }, espAimFovCircleFrame)

local crosshairDot = create("Frame", { Size = UDim2.fromOffset(4, 4), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BorderSizePixel = 0, Visible = false }, gui)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, crosshairDot)

local espAimLineObj = Drawing.new("Line")
espAimLineObj.Visible = false
espAimLineObj.Thickness = 2.5

local radarHolder = create("Frame", { Size = UDim2.fromOffset(130, 130), Position = UDim2.new(1, -145, 0, 50), BackgroundColor3 = Color3.fromRGB(10, 10, 10), BackgroundTransparency = 0.4, Visible = false }, gui)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, radarHolder)
create("UIStroke", { Color = Color3.fromRGB(40, 40, 40), Thickness = 1.2 }, radarHolder)

local radarCenterDot = create("Frame", { Size = UDim2.fromOffset(6, 6), Position = UDim2.new(0.5, -3, 0.5, -3), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0 }, radarHolder)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, radarCenterDot)

local targetHudBox = create("Frame", { Size = UDim2.fromOffset(230, 104), Position = UDim2.new(0.5, -115, 0, 12), BackgroundColor3 = Color3.fromRGB(10, 10, 10), BackgroundTransparency = 0.3, Visible = false, ZIndex = 5000 }, gui)
create("UICorner", { CornerRadius = UDim.new(0, 8) }, targetHudBox)
create("UIStroke", { Color = Color3.fromRGB(180, 50, 255), Thickness = 1.5 }, targetHudBox)

local hudNameLabel = create("TextLabel", { Size = UDim2.new(1, -16, 0, 22), Position = UDim2.fromOffset(8, 4), BackgroundTransparency = 1, Text = "ALVO: NENHUM", TextColor3 = Color3.fromRGB(240, 240, 240), TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5001 }, targetHudBox)
local hudStatusTag = create("TextLabel", { Size = UDim2.fromOffset(80, 18), Position = UDim2.new(1, -88, 0, 6), BackgroundColor3 = Color3.fromRGB(30, 30, 30), Text = "OCULTO", TextColor3 = Color3.fromRGB(255, 80, 80), TextSize = 9, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5001 }, targetHudBox)
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = hudStatusTag })
local hudWeaponLabel = create("TextLabel", { Size = UDim2.new(1, -16, 0, 18), Position = UDim2.fromOffset(8, 26), BackgroundTransparency = 1, Text = "Equipado: Mãos Vazias", TextColor3 = Color3.fromRGB(200, 150, 255), TextSize = 10, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5001 }, targetHudBox)
local hudLoSLabel = create("TextLabel", { Size = UDim2.new(1, -16, 0, 18), Position = UDim2.fromOffset(8, 44), BackgroundTransparency = 1, Text = "Visão Direta: Seguro", TextColor3 = Color3.fromRGB(50, 255, 100), TextSize = 10, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5001 }, targetHudBox)
local hudInfoLabel = create("TextLabel", { Size = UDim2.new(1, -16, 0, 18), Position = UDim2.fromOffset(8, 62), BackgroundTransparency = 1, Text = "Distância: 0m | HP: 0/100", TextColor3 = Color3.fromRGB(170, 170, 170), TextSize = 10, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5001 }, targetHudBox)
local hudBarBg = create("Frame", { Size = UDim2.new(1, -16, 0, 10), Position = UDim2.fromOffset(8, 84), BackgroundColor3 = Color3.fromRGB(20, 20, 20), BorderSizePixel = 0, ZIndex = 5001 }, targetHudBox)
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = hudBarBg })
local hudBarFill = create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(50, 255, 100), BorderSizePixel = 0, ZIndex = 5002 }, hudBarBg)
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = hudBarFill })

local espDrawings = {}
local function createDrawingObjects()
    local cache = {}
    cache.box = Drawing.new("Square"); cache.box.Visible = false; cache.box.Thickness = 1.5; cache.box.Filled = false
    cache.barBg = Drawing.new("Square"); cache.barBg.Visible = false; cache.barBg.Thickness = 1; cache.barBg.Filled = true; cache.barBg.Color = Color3.fromRGB(0, 0, 0)
    cache.barFill = Drawing.new("Square"); cache.barFill.Visible = false; cache.barFill.Thickness = 1; cache.barFill.Filled = true
    cache.nameTag = Drawing.new("Text"); cache.nameTag.Visible = false; cache.nameTag.Size = 11; cache.nameTag.Center = true; cache.nameTag.Outline = true
    cache.handBox = Drawing.new("Square"); cache.handBox.Visible = false; cache.handBox.Thickness = 1; cache.handBox.Filled = false
    cache.handText = Drawing.new("Text"); cache.handText.Visible = false; cache.handText.Size = 6; cache.handText.Center = true; cache.handText.Outline = true
    cache.partHead = Drawing.new("Square"); cache.partHead.Visible = false; cache.partHead.Thickness = 1; cache.partHead.Filled = false
    cache.partTorso = Drawing.new("Square"); cache.partTorso.Visible = false; cache.partTorso.Thickness = 1; cache.partTorso.Filled = false
    cache.partLeftArm = Drawing.new("Square"); cache.partLeftArm.Visible = false; cache.partLeftArm.Thickness = 1; cache.partLeftArm.Filled = false
    cache.partRightArm = Drawing.new("Square"); cache.partRightArm.Visible = false; cache.partRightArm.Thickness = 1; cache.partRightArm.Filled = false
    cache.partLeftLeg = Drawing.new("Square"); cache.partLeftLeg.Visible = false; cache.partLeftLeg.Thickness = 1; cache.partLeftLeg.Filled = false
    cache.partRightLeg = Drawing.new("Square"); cache.partRightLeg.Visible = false; cache.partRightLeg.Thickness = 1; cache.partRightLeg.Filled = false
    cache.radarBlip = create("Frame", { Size = UDim2.fromOffset(6, 6), AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Visible = false }, radarHolder)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, cache.radarBlip)
    return cache
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= player then espDrawings[p] = createDrawingObjects() end end
Players.PlayerAdded:Connect(function(p) if p ~= player then espDrawings[p] = createDrawingObjects() end end)
Players.PlayerRemoving:Connect(function(p)
    if espDrawings[p] == nil then return end
    pcall(function()
        espDrawings[p].box:Remove(); espDrawings[p].barBg:Remove(); espDrawings[p].barFill:Remove(); espDrawings[p].nameTag:Remove()
        espDrawings[p].handBox:Remove(); espDrawings[p].handText:Remove(); espDrawings[p].partHead:Remove(); espDrawings[p].partTorso:Remove()
        espDrawings[p].partLeftArm:Remove(); espDrawings[p].partRightArm:Remove(); espDrawings[p].partLeftLeg:Remove(); espDrawings[p].partRightLeg:Remove()
        espDrawings[p].radarBlip:Destroy()
    end)
    espDrawings[p] = nil
end)

local lootDrawings = {}
local function getOrCreateLootDrawings(model)
    if not lootDrawings[model] then
        local cache = {}
        cache.box = Drawing.new("Square"); cache.box.Visible = false; cache.box.Thickness = 1.5; cache.box.Filled = false
        cache.line = Drawing.new("Line"); cache.line.Visible = false; cache.line.Thickness = 1.2
        cache.text = Drawing.new("Text"); cache.text.Visible = false; cache.text.Size = 12; cache.text.Center = true; cache.text.Outline = true
        lootDrawings[model] = cache
    end
    return lootDrawings[model]
end

local function isAlly(targetPlayer, useTeamCheck)
    if not useTeamCheck then return false end
    if player.Team and targetPlayer.Team then return player.Team == targetPlayer.Team end
    return false
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
    return Workspace:Raycast(origin, direction, raycastParams) == nil
end

local cachedLootModels = {}
local function scanLoot()
    local newModels = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nameLower = string.lower(obj.Name)
            local parentNameLower = string.lower(obj.Parent.Name)
            if string.find(nameLower, "marker") or string.find(parentNameLower, "marker") or string.find(nameLower, "collect") or string.find(nameLower, "item") or string.find(nameLower, "coin") then
                local topModel = obj
                while topModel.Parent and topModel.Parent ~= Workspace and topModel.Parent ~= game do topModel = topModel.Parent end
                if topModel and topModel:IsA("Model") and not newModels[topModel] then
                    local primary = topModel.PrimaryPart or topModel:FindFirstChildWhichIsA("BasePart")
                    if primary then newModels[topModel] = primary end
                end
            end
        end
    end
    cachedLootModels = newModels
end

task.spawn(function()
    scanLoot()
    while scriptActive do
        task.wait(30)
        if settings.lootEspEnabled then scanLoot() end
    end
end)

-- LOOP PRINCIPAL
RunService.RenderStepped:Connect(function(dt)
    if not scriptActive then return end
    pcall(function()
        camera = workspace.CurrentCamera
        if not camera then return end

        crosshairDot.Visible = settings.universalCrosshairDot or settings.crosshairEnabled
        crosshairDot.BackgroundColor3 = getRGB(settings.colors.crosshair)
        camera.FieldOfView = settings.customFovValue

        if settings.noclipEnabled and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CanCollide = false end
        end

        radarHolder.Visible = settings.radarAdvancedEnabled
        local viewport = camera.ViewportSize
        local screenCenter = Vector2.new((viewport.X / 2) + settings.dynOffsetX, (viewport.Y / 2) + settings.dynOffsetY)

        local currentAimbotFov = settings.fov
        local closestEnemyStuds = 9999

        if settings.dynamicFov and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and not isAlly(p, settings.aimbotTeamCheck) and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if dist < closestEnemyStuds then closestEnemyStuds = dist end
                    end
                end
            end
            if closestEnemyStuds < 9999 then
                local progress = math.clamp(closestEnemyStuds / settings.dynMaxDist, 0, 1)
                currentAimbotFov = settings.dynSizeClose + (settings.dynSizeFar - settings.dynSizeClose) * progress
            else
                currentAimbotFov = settings.dynSizeClose
            end
        end

        local bestStdTarget, bestStdDist = nil, currentAimbotFov
        local bestDynTarget, bestDynDist, dynTargetStuds = nil, settings.dynamicAimFov, 0
        local bestEspAimDist, espAimTargetPart, activeTargetPlayer = settings.espAimFov, nil, nil

        local pulseColorPattern = (tick() % 1 < 0.5) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 220, 50)

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                local isTeammate = isAlly(p, settings.aimbotTeamCheck)
                if not isTeammate then
                    local char = p.Character
                    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                    local headPart = char and char:FindFirstChild("Head")
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    local targetPartObj = headPart or (char and char:FindFirstChild(settings.targetPart))

                    if char and rootPart and targetPartObj and humanoid and humanoid.Health > 0 then
                        local passesWallCheck = isVisible(targetPartObj)
                        local calcPos = targetPartObj.Position
                        if settings.prediction then calcPos = calcPos + (rootPart.AssemblyLinearVelocity * 0.08) end

                        local screenPos, onScreen = camera:WorldToViewportPoint(calcPos)
                        if onScreen and screenPos.Z > 0 then
                            local screenPosVector = Vector2.new(screenPos.X, screenPos.Y)
                            local distToCenter = (screenPosVector - screenCenter).Magnitude

                            if settings.aimbotEnabled and distToCenter <= currentAimbotFov and distToCenter < bestStdDist and (not settings.wallCheck or passesWallCheck) then
                                bestStdDist = distToCenter; bestStdTarget = {Position = calcPos, Part = targetPartObj, Character = char}; activeTargetPlayer = p
                            end

                            if settings.dynamicAimEnabled and distToCenter <= settings.dynamicAimFov and distToCenter < bestDynDist and (not settings.wallCheck or passesWallCheck) then
                                bestDynDist = distToCenter; bestDynTarget = {Position = calcPos, Part = targetPartObj, Character = char}; activeTargetPlayer = p
                                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                    dynTargetStuds = (rootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                end
                            end

                            if settings.independentEspAim and distToCenter <= settings.espAimFov and distToCenter < bestEspAimDist and (not settings.wallCheck or passesWallCheck) then
                                bestEspAimDist = distToCenter; espAimTargetPart = targetPartObj
                            end
                        end
                    end
                end
            end
        end

        -- TARGET HUD
        if settings.targetHudEnabled and activeTargetPlayer and activeTargetPlayer.Character and activeTargetPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local targetChar = activeTargetPlayer.Character
            local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local targetHead = targetChar:FindFirstChild("Head")
            
            local distMeters = 0
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and targetRoot then
                distMeters = math.floor((targetRoot.Position - player.Character.HumanoidRootPart.Position).Magnitude / 3)
            end

            local equippedTool = "Mãos Vazias"
            for _, item in ipairs(targetChar:GetChildren()) do
                if item:IsA("Tool") then equippedTool = item.Name break end
            end

            local visibleNow = targetHead and isVisible(targetHead) or false
            hudNameLabel.Text = "ALVO: " .. activeTargetPlayer.Name
            hudWeaponLabel.Text = "Equipado: " .. equippedTool
            hudInfoLabel.Text = "Distância: " .. distMeters .. "m | HP: " .. math.floor(targetHum.Health) .. "/" .. math.floor(targetHum.MaxHealth)
            
            hudStatusTag.Text = visibleNow and "VISÍVEL" or "OCULTO"
            hudStatusTag.TextColor3 = visibleNow and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 80, 80)

            local hpPercent = math.clamp(targetHum.Health / targetHum.MaxHealth, 0, 1)
            hudBarFill.Size = UDim2.new(hpPercent, 0, 1, 0)
            targetHudBox.Visible = true
        else
            targetHudBox.Visible = false
        end

        if settings.lootEspEnabled then
            local activeItems = {}
            for model, primaryPart in pairs(cachedLootModels) do
                if model and model.Parent and primaryPart and primaryPart.Parent then
                    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        local dist = (primaryPart.Position - myRoot.Position).Magnitude
                        if dist <= settings.lootMaxDistance then
                            local vector, onScreen = camera:WorldToViewportPoint(primaryPart.Position)
                            if onScreen then
                                local cache = getOrCreateLootDrawings(model)
                                local activeColor = getRGB(settings.colors.loot)
                                local itemName = model.Name

                                if settings.lootBoxEnabled then
                                    local size = Vector2.new(1500 / vector.Z, 2200 / vector.Z)
                                    cache.box.Size = size
                                    cache.box.Position = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)
                                    cache.box.Color = activeColor; cache.box.Visible = true
                                else cache.box.Visible = false end

                                if settings.lootLineEnabled then
                                    cache.line.From = screenCenter; cache.line.To = Vector2.new(vector.X, vector.Y)
                                    cache.line.Color = activeColor; cache.line.Visible = true
                                else cache.line.Visible = false end

                                if settings.lootNameEnabled then
                                    cache.text.Text = "[" .. itemName .. " | " .. math.floor(dist / 3) .. "m]"
                                    cache.text.Position = Vector2.new(vector.X, vector.Y - 18)
                                    cache.text.Color = activeColor; cache.text.Visible = true
                                else cache.text.Visible = false end

                                activeItems[model] = true
                            end
                        end
                    end
                end
            end
            for model, cache in pairs(lootDrawings) do
                if not activeItems[model] then cache.box.Visible = false; cache.line.Visible = false; cache.text.Visible = false end
            end
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                if not espDrawings[p] then espDrawings[p] = createDrawingObjects() end
                local cache = espDrawings[p]
                local char = p.Character
                local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                local headPart = char and char:FindFirstChild("Head")
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")

                if char and rootPart and humanoid and humanoid.Health > 0 then
                    local isTeammate = isAlly(p, settings.aimbotTeamCheck)
                    local showBox = false
                    local activeColor = getRGB(settings.colors.enemy)

                    local distToMeStuds = 9999
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        distToMeStuds = (rootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    end

                    local targetIsVisible = headPart and isVisible(headPart) or false
                    
                    -- DETECÇÃO DO ESP POR APROXIMAÇÃO DO RADAR
                    local isProximityTarget = false
                    if settings.radarEspProximityEnabled and not isTeammate and distToMeStuds <= settings.radarProximityRange then
                        showBox = true
                        isProximityTarget = true
                        activeColor = getRGB(settings.colors.radarBoxOverride)
                    end

                    -- SE O ESP GERAL ESTIVER LIGADO, E NÃO FOR ALVO DE APROXIMAÇÃO
                    if settings.espEnabled and not isProximityTarget then
                        if isTeammate then
                            if settings.espAllies then showBox = true; activeColor = getRGB(settings.colors.ally) end
                        else
                            if settings.espEnemies then showBox = true end
                        end
                    end

                    if settings.pulseAlertEnabled and targetIsVisible and not isTeammate then
                        activeColor = pulseColorPattern
                    end

                    if settings.independentEspAim and headPart and (headPart == espAimTargetPart) then
                        activeColor = getRGB(settings.colors.espAim)
                        showBox = true
                    end

                    if showBox then
                        local vector, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                        if onScreen and vector.Z > 0 and vector.Z < 450 then
                            local w = math.clamp(1200 / vector.Z, 12, 50)
                            local h = math.clamp(2000 / vector.Z, 25, 90)
                            local pos = Vector2.new(vector.X - w / 2, vector.Y - h / 2)

                            cache.box.Size = Vector2.new(w, h); cache.box.Position = pos; cache.box.Color = activeColor; cache.box.Visible = true

                            if settings.espHealthBar then
                                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                                cache.barBg.Size = Vector2.new(3, h); cache.barBg.Position = Vector2.new(pos.X - 5, pos.Y); cache.barBg.Visible = true
                                cache.barFill.Size = Vector2.new(1, h * healthPercent); cache.barFill.Position = Vector2.new(pos.X - 4, pos.Y + (h * (1 - healthPercent))); cache.barFill.Color = activeColor; cache.barFill.Visible = true
                            else cache.barBg.Visible = false; cache.barFill.Visible = false end

                            if settings.espNameTag then
                                cache.nameTag.Text = p.Name .. " [" .. math.floor(distToMeStuds / 3) .. "m]"
                                cache.nameTag.Position = Vector2.new(vector.X, pos.Y - 16); cache.nameTag.Color = activeColor; cache.nameTag.Visible = true
                            else cache.nameTag.Visible = false end
                        else cache.box.Visible = false; cache.barBg.Visible = false; cache.barFill.Visible = false; cache.nameTag.Visible = false end
                    else cache.box.Visible = false; cache.barBg.Visible = false; cache.barFill.Visible = false; cache.nameTag.Visible = false end

                    if not isTeammate or settings.espAllies then
                        local bpColor = getRGB(settings.colors.bodyParts)

                        if settings.partHeadEnabled and headPart then
                            local vPos, vOn = camera:WorldToViewportPoint(headPart.Position)
                            if vOn and vPos.Z > 0 then
                                local s = math.clamp(180 / vPos.Z, 3, 12)
                                cache.partHead.Size = Vector2.new(s, s); cache.partHead.Position = Vector2.new(vPos.X - s/2, vPos.Y - s/2); cache.partHead.Color = bpColor; cache.partHead.Visible = true
                            else cache.partHead.Visible = false end
                        else cache.partHead.Visible = false end
                    end

                    if settings.espHandItemEnabled and (not isTeammate or settings.espAllies) then
                        local activeTool = nil
                        for _, item in ipairs(char:GetChildren()) do if item:IsA("Tool") then activeTool = item break end end
                        if activeTool then
                            local handlePart = activeTool:FindFirstChild("Handle") or activeTool:FindFirstChildWhichIsA("BasePart")
                            if handlePart then
                                local vector, onScreen = camera:WorldToViewportPoint(handlePart.Position)
                                if onScreen and vector.Z > 0 then
                                    local dynamicScale = math.clamp(700 / vector.Z, 5, 11)
                                    cache.handBox.Size = Vector2.new(dynamicScale, dynamicScale); cache.handBox.Position = Vector2.new(vector.X - dynamicScale/2, vector.Y - dynamicScale/2); cache.handBox.Color = getRGB(settings.colors.espHand); cache.handBox.Visible = true
                                    cache.handText.Text = "[" .. activeTool.Name .. "]"; cache.handText.Position = Vector2.new(vector.X, vector.Y - 9); cache.handText.Color = getRGB(settings.colors.espHand); cache.handText.Visible = true
                                else cache.handBox.Visible = false; cache.handText.Visible = false end
                            else cache.handBox.Visible = false; cache.handText.Visible = false end
                        else cache.handBox.Visible = false; cache.handText.Visible = false end

                    -- MINI-RADAR BLIP
                    if settings.radarAdvancedEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local myRoot = player.Character.HumanoidRootPart
                        local relPos = myRoot.CFrame:PointToObjectSpace(rootPart.Position)
                        local radarX = math.clamp(relPos.X / 2.5, -55, 55)
                        local radarY = math.clamp(relPos.Z / 2.5, -55, 55)
                        cache.radarBlip.Position = UDim2.new(0.5, radarX, 0.5, radarY); cache.radarBlip.BackgroundColor3 = getRGB(settings.colors.radarBlip); cache.radarBlip.Visible = true
                    else cache.radarBlip.Visible = false end
                end
            end
        end

        if settings.independentEspAim and espAimTargetPart then
            local screenPos, onScreen = camera:WorldToViewportPoint(espAimTargetPart.Position)
            if onScreen then
                espAimLineObj.From = screenCenter; espAimLineObj.To = Vector2.new(screenPos.X, screenPos.Y); espAimLineObj.Color = getRGB(settings.colors.espAim); espAimLineObj.Visible = true
            else espAimLineObj.Visible = false end
        else espAimLineObj.Visible = false end

        -- CÍRCULOS DE FOV CUSTOMIZÁVEIS
        fovCircleFrame.Position = UDim2.new(0.5, settings.dynOffsetX, 0.5, settings.dynOffsetY)
        fovCircleFrame.Size = UDim2.fromOffset(currentAimbotFov * 2, currentAimbotFov * 2)
        fovCircleFrame.Visible = settings.showFovCircle and settings.aimbotEnabled
        fovStroke.Color = (settings.pulseAlertEnabled and bestStdTarget and isVisible(bestStdTarget.Part)) and pulseColorPattern or getRGB(settings.colors.fovCircle)

        dynAimFovCircleFrame.Position = UDim2.new(0.5, settings.dynOffsetX, 0.5, settings.dynOffsetY)
        dynAimFovCircleFrame.Size = UDim2.fromOffset(settings.dynamicAimFov * 2, settings.dynamicAimFov * 2)
        dynAimFovCircleFrame.Visible = settings.showDynamicAimFov and settings.dynamicAimEnabled
        dynAimFovStroke.Color = (settings.pulseAlertEnabled and bestDynTarget and isVisible(bestDynTarget.Part)) and pulseColorPattern or getRGB(settings.colors.dynAimFovCircle)

        espAimFovCircleFrame.Position = UDim2.new(0.5, settings.dynOffsetX, 0.5, settings.dynOffsetY)
        espAimFovCircleFrame.Size = UDim2.fromOffset(settings.espAimFov * 2, settings.espAimFov * 2)
        espAimFovCircleFrame.Visible = settings.independentEspAim and settings.showEspAimFovCircle
        espAimFovStroke.Color = getRGB(settings.colors.espAimFovCircle)

        -- EXECUÇÃO DE MIRA
        if settings.aimbotEnabled and bestStdTarget then
            local direction = CFrame.lookAt(camera.CFrame.Position, bestStdTarget.Position)
            camera.CFrame = camera.CFrame:Lerp(direction, math.clamp(1 / settings.smoothness, 0.01, 1))
        elseif settings.dynamicAimEnabled and bestDynTarget then
            local direction = CFrame.lookAt(camera.CFrame.Position, bestDynTarget.Position)
            local computedSmooth = settings.dynAimMediumSmooth
            if dynTargetStuds <= 25 then
                computedSmooth = settings.dynAimCloseSmooth + (settings.dynAimMediumSmooth - settings.dynAimCloseSmooth) * math.clamp(dynTargetStuds / 25, 0, 1)
            else
                computedSmooth = settings.dynAimMediumSmooth + (settings.dynAimFarSmooth - settings.dynAimMediumSmooth) * math.clamp((dynTargetStuds - 25) / 100, 0, 1)
            end
            camera.CFrame = camera.CFrame:Lerp(direction, math.clamp(1 / computedSmooth, 0.01, 1))
        end
    end)
end)

notify("Gravel.cc V58.01 Ativo!", "verde")
print("[Gravel LORDths Edition] V58.01 carregado com sucesso!")
