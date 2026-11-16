-- ==========================================================
-- GRAVEL.CC | ULTIMATE UNIVERSAL EDITION [LORDTHS EDITION - PRO V50]
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
    aimbotEnabled = false,
    smartAssistEnabled = false,
    aimbotTeamCheck = true,
    wallCheck = false,
    showFovCircle = true,
    targetPart = "Head",
    smoothness = 4,
    fov = 200,
    prediction = true,
    
    dynamicFov = false,
    dynBaseSize = 120,
    dynSizeClose = 200,
    dynSizeFar = 50,
    dynMaxDist = 120,
    dynOffsetX = 0,
    dynOffsetY = 0,

    targetHudEnabled = true,
    antiRecoilEnabled = false,
    
    independentEspAim = false,
    showEspAimFovCircle = true,
    espAimFov = 150,
    espAimColorIndex = 6,

    triggerbotEnabled = false,
    hitboxExpander = false,
    hitboxSize = 6,

    espEnabled = false,
    espTeamCheck = true,
    espEnemies = true,
    espAllies = false,
    enemyColorIndex = 1,
    allyColorIndex = 3,
    espHealthBar = true,
    espNameTag = true,
    espDistance = true,

    -- RADAR PRO
    radarAdvancedEnabled = false, 
    radarProximityRange = 200, 
    radarLoSAlert = true,     
    radarColorIndex = 2, 

    -- LOOT ESP
    lootEspEnabled = false,
    lootMaxDistance = 100,
    lootColorIndex = 5,
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
    fontSize = 11
}

local configFileName = "GravelHub_LordthsConfigV50.json"

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

local colorPalette = {
    [1] = {name = "Branco Fosco", color = Color3.fromRGB(240, 240, 240)},
    [2] = {name = "Vermelho Agressivo", color = Color3.fromRGB(255, 50, 50)},
    [3] = {name = "Azul Neon", color = Color3.fromRGB(50, 150, 255)},
    [4] = {name = "Verde Limão", color = Color3.fromRGB(50, 255, 100)},
    [5] = {name = "Amarelo Ouro", color = Color3.fromRGB(255, 220, 50)},
    [6] = {name = "Roxo Alvo", color = Color3.fromRGB(180, 50, 255)}
}

local function create(class, props, parent)
    local obj = Instance.new(class)
    for key, value in pairs(props) do
        pcall(function() obj[key] = value end)
    end
    obj.Parent = parent
    return obj
end

-- Limpar versão anterior se houver
pcall(function()
    if targetGuiParent:FindFirstChild("GravelMasterLordthsEditionV50") then
        targetGuiParent.GravelMasterLordthsEditionV50:Destroy()
    end
end)

local gui = create("ScreenGui", {
    Name = "GravelMasterLordthsEditionV50",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999
}, targetGuiParent)

-- Menu Principal com Fundo Translúcido Escuro (Glassmorphism)
local main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(580, 420),
    Position = UDim2.new(0.5, -290, 0.5, -210),
    BackgroundColor3 = Color3.fromRGB(10, 10, 10),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    Visible = false
}, gui)
create("UICorner", { CornerRadius = UDim.new(0, 8) }, main)
create("UIStroke", { Color = Color3.fromRGB(45, 45, 45), Thickness = 1.2 }, main)

local loadingScreen = create("Frame", {
    Size = UDim2.fromOffset(380, 190),
    Position = UDim2.new(0.5, -190, 0.5, -95),
    BackgroundColor3 = Color3.fromRGB(10, 10, 10),
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    ZIndex = 10000
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
    ZIndex = 10001
}, loadingScreen)

create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.fromOffset(0, 60),
    BackgroundTransparency = 1,
    Text = "Carregando Lordths Edition Pro V50...",
    TextColor3 = Color3.fromRGB(130, 130, 130),
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 10001
}, loadingScreen)

local loadBarBg = create("Frame", {
    Size = UDim2.fromOffset(320, 6),
    Position = UDim2.new(0.5, -160, 0, 115),
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    BorderSizePixel = 0,
    ZIndex = 10001
}, loadingScreen)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, loadBarBg)

local loadBarFill = create("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(240, 240, 240),
    BorderSizePixel = 0,
    ZIndex = 10002
}, loadBarBg)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, loadBarFill)

local menuVisible = true
local function toggleMenu()
    menuVisible = not menuVisible
    main.Visible = menuVisible
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
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0
    }, notificationHolder)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, notif)
    create("UIStroke", { Color = Color3.fromRGB(45, 45, 45), Thickness = 1 }, notif)

    create("TextLabel", {
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = settings.fontSize,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, notif)

    task.delay(2, function() notif:Destroy() end)
end

-- ==========================================================
-- WATERMARK REFORMULADA (Fundo Translúcido Escuro)[span_3](start_span)[span_3](end_span)
-- ==========================================================
local watermark = create("Frame", {
    Size = UDim2.fromOffset(210, 28),
    Position = UDim2.new(0, 15, 0, 15),
    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0
}, gui)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, watermark)
create("UIStroke", { Color = Color3.fromRGB(50, 50, 50), Thickness = 1 }, watermark)

local watermarkLabel = create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "gravel.cc (LORDths) | fps: -- | ms: --",
    TextColor3 = Color3.fromRGB(220, 220, 220),
    TextSize = 10,
    Font = Enum.Font.GothamBold
}, watermark)

local fpsFrames = 0
local fpsTime = 0
RunService.RenderStepped:Connect(function(dt)
    fpsFrames = fpsFrames + 1
    fpsTime = fpsTime + dt
    if fpsTime >= 0.5 then
        local currentFps = math.floor(fpsFrames / fpsTime)
        local currentPing = 0
        pcall(function()
            currentPing = math.floor(player:GetNetworkPing() * 1000)
        end)
        watermarkLabel.Text = string.format("gravel.cc (LORDths) | fps: %d | ms: %d", currentFps, currentPing)
        fpsFrames = 0
        fpsTime = 0
    end
end)

-- ==========================================================
-- BOTÃO FLUTUANTE MINIMIZADO "THS" (Translúcido Escuro)[span_4](start_span)[span_4](end_span)
-- ==========================================================
local floatingToggleBtn = create("TextButton", {
    Size = UDim2.fromOffset(50, 36),
    Position = UDim2.new(0, 15, 0, 55),
    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
    BackgroundTransparency = 0.3,
    Text = "THS",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 12,
    Font = Enum.Font.GothamBold
}, gui)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, floatingToggleBtn)
create("UIStroke", { Color = Color3.fromRGB(50, 50, 50), Thickness = 1.2 }, floatingToggleBtn)

floatingToggleBtn.MouseButton1Click:Connect(toggleMenu)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

local top = create("Frame", {
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0
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
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

local close = create("TextButton", {
    Size = UDim2.fromOffset(22, 22),
    Position = UDim2.new(1, -28, 0, 6),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 0.2,
    Text = "X",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 9,
    Font = Enum.Font.GothamBold
}, top)
create("UICorner", { CornerRadius = UDim.new(0, 5) }, close)
create("UIStroke", { Color = Color3.fromRGB(50, 50, 50), Thickness = 1 }, close)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local layoutMode = 1
local layoutToggleBtn = create("TextButton", {
    Size = UDim2.fromOffset(22, 22),
    Position = UDim2.new(1, -54, 0, 6),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 0.2,
    Text = "[]",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 9,
    Font = Enum.Font.GothamBold
}, top)
create("UICorner", { CornerRadius = UDim.new(0, 5) }, layoutToggleBtn)
create("UIStroke", { Color = Color3.fromRGB(50, 50, 50), Thickness = 1 }, layoutToggleBtn)

layoutToggleBtn.MouseButton1Click:Connect(function()
    layoutMode = layoutMode + 1
    if layoutMode > 2 then layoutMode = 1 end
    if layoutMode == 1 then
        main.Size = UDim2.fromOffset(580, 420)
        notify("Layout: Padrão Largo")
    else
        main.Size = UDim2.fromOffset(450, 420)
        notify("Layout: Compacto")
    end
end)

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

local scrollLeftBtn = create("TextButton", {
    Size = UDim2.fromOffset(22, 36),
    Position = UDim2.fromOffset(8, 40),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 0.2,
    Text = "<",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    ZIndex = 5
}, main)
create("UICorner", { CornerRadius = UDim.new(0, 4) }, scrollLeftBtn)
create("UIStroke", { Color = Color3.fromRGB(50, 50, 50), Thickness = 1 }, scrollLeftBtn)

local scrollRightBtn = create("TextButton", {
    Size = UDim2.fromOffset(22, 36),
    Position = UDim2.new(1, -30, 0, 40),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 0.2,
    Text = ">",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    ZIndex = 5
}, main)
create("UICorner", { CornerRadius = UDim.new(0, 4) }, scrollRightBtn)
create("UIStroke", { Color = Color3.fromRGB(50, 50, 50), Thickness = 1 }, scrollRightBtn)

local tabScroll = create("ScrollingFrame", {
    Size = UDim2.new(1, -64, 0, 36),
    Position = UDim2.fromOffset(34, 40),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0, 1300, 0, 0),
    ScrollBarThickness = 2,
    ScrollingDirection = Enum.ScrollingDirection.X
}, main)

scrollLeftBtn.MouseButton1Click:Connect(function()
    tabScroll.CanvasPosition = Vector2.new(math.clamp(tabScroll.CanvasPosition.X - 150, 0, tabScroll.AbsoluteCanvasSize.X), 0)
end)

scrollRightBtn.MouseButton1Click:Connect(function()
    tabScroll.CanvasPosition = Vector2.new(math.clamp(tabScroll.CanvasPosition.X + 150, 0, tabScroll.AbsoluteCanvasSize.X), 0)
end)

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabScroll

local pagesContainer = create("Frame", {
    Position = UDim2.fromOffset(8, 82),
    Size = UDim2.new(1, -16, 1, -90),
    BackgroundTransparency = 1
}, main)

local pages = {}
local tabButtons = {}

local function createPage(name)
    local page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 1200),
        ScrollBarThickness = 2
    }, pagesContainer)
    pages[name] = page
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page
    return page
end

local pageAimbot = createPage("Aimbot")
local pageEspAim = createPage("ESP Aim")
local pageDynFov = createPage("Dynamic FOV")
local pageCalib = createPage("Calibração")
local pageRadar = createPage("Radar Pro")
local pageLoot = createPage("Loot ESP")
local pageVisuals = createPage("Visuals")
local pageColors = createPage("Cores")
local pageUniversal = createPage("Universal")
local pageHitbox = createPage("Hitbox")
local pagePlayers = createPage("Players")
local pageMisc = createPage("Misc")

local function switchPage(targetName)
    for pName, pObj in pairs(pages) do 
        pObj.Visible = (pName == targetName) 
    end
    for name, btn in pairs(tabButtons) do
        if name == targetName then
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.BackgroundTransparency = 0.1
            btn.TextColor3 = Color3.fromRGB(240, 240, 240)
        else
            -- ABAS COM TRANSPARÊNCIA MAIS ESCURA QUE O PAINEL PRINCIPAL[span_5](start_span)[span_5](end_span)
            btn.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
            btn.BackgroundTransparency = 0.4
            btn.TextColor3 = Color3.fromRGB(160, 160, 160)
        end
    end
end
switchPage("Aimbot")

local function createTabButton(text, targetPage)
    local btn = create("TextButton", {
        Size = UDim2.fromOffset(95, 30),
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        BackgroundTransparency = 0.4, -- Mais escuro e translúcido que o fundo principal[span_6](start_span)[span_6](end_span)
        Text = text,
        TextColor3 = Color3.fromRGB(160, 160, 160),
        TextSize = 10,
        Font = Enum.Font.GothamBold
    }, tabScroll)
    create("UICorner", { CornerRadius = UDim.new(0, 5) }, btn)
    create("UIStroke", { Color = Color3.fromRGB(35, 35, 35), Thickness = 1 }, btn)
    
    tabButtons[targetPage] = btn
    btn.MouseButton1Click:Connect(function() 
        switchPage(targetPage) 
    end)
end

createTabButton("Aimbot", "Aimbot")
createTabButton("ESP Aim", "ESP Aim")
createTabButton("Dynamic FOV", "Dynamic FOV")
createTabButton("Calibração", "Calibração")
createTabButton("Radar Pro", "Radar Pro")
createTabButton("Loot ESP", "Loot ESP")
createTabButton("Visuals", "Visuals")
createTabButton("Cores", "Cores")
createTabButton("Universal", "Universal")
createTabButton("Hitbox", "Hitbox")
createTabButton("Players", "Players")
createTabButton("Misc", "Misc")

local function createToggle(parent, text, initial, callback)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0
    }, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, container)
    create("UIStroke", { Color = Color3.fromRGB(30, 30, 30), Thickness = 1 }, container)

    create("TextLabel", {
        Size = UDim2.new(1, -55, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = settings.fontSize,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, container)

    local switchBg = create("Frame", {
        Size = UDim2.fromOffset(36, 18),
        Position = UDim2.new(1, -44, 0.5, -9),
        BackgroundColor3 = initial and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0
    }, container)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, switchBg)

    local switchCircle = create("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = initial and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
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
        local targetColor = state and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(20, 20, 20)
        TweenService:Create(switchCircle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end)
end

local function createSlider(parent, title, minValue, maxValue, initial, callback)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0
    }, parent)
    create("UICorner", { CornerRadius = UDim.new(0, 6) }, container)
    create("UIStroke", { Color = Color3.fromRGB(30, 30, 30), Thickness = 1 }, container)

    local label = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.fromOffset(12, 6),
        BackgroundTransparency = 1,
        Text = title .. ": " .. initial,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextSize = settings.fontSize,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, container)

    local track = create("TextButton", {
        Size = UDim2.new(1, -24, 0, 6),
        Position = UDim2.fromOffset(12, 32),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Text = "",
        AutoButtonColor = false
    }, container)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, track)

    local fill = create("Frame", {
        Size = UDim2.new((initial - minValue) / (maxValue - minValue), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(240, 240, 240),
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

createToggle(pageAimbot, "Toggle Aimbot", settings.aimbotEnabled, function(v) settings.aimbotEnabled = v end)
createToggle(pageAimbot, "Smart Aim Assist", settings.smartAssistEnabled, function(v) settings.smartAssistEnabled = v end)
createToggle(pageAimbot, "Triggerbot", settings.triggerbotEnabled, function(v) settings.triggerbotEnabled = v end)
createToggle(pageAimbot, "Aim Team Check", settings.aimbotTeamCheck, function(v) settings.aimbotTeamCheck = v end)
createToggle(pageAimbot, "Wall Check", settings.wallCheck, function(v) settings.wallCheck = v end)
createToggle(pageAimbot, "Show FOV Circle", settings.showFovCircle, function(v) settings.showFovCircle = v end)
createToggle(pageAimbot, "Movement Prediction", settings.prediction, function(v) settings.prediction = v end)
createSlider(pageAimbot, "FOV Padrão", 50, 400, settings.fov, function(v) settings.fov = v end)
createSlider(pageAimbot, "Smoothness", 1, 20, settings.smoothness, function(v) settings.smoothness = v end)

createToggle(pageEspAim, "Ativar ESP Aim (Custom)", settings.independentEspAim, function(v) settings.independentEspAim = v end)
createToggle(pageEspAim, "Mostrar Círculo FOV ESP Aim", settings.showEspAimFovCircle, function(v) settings.showEspAimFovCircle = v end)
createSlider(pageEspAim, "Raio FOV ESP Aim", 30, 350, settings.espAimFov, function(v) settings.espAimFov = v end)

createToggle(pageDynFov, "Ativar Dynamic FOV", settings.dynamicFov, function(v) settings.dynamicFov = v end)
createSlider(pageDynFov, "Tamanho Inicial (Base)", 50, 400, settings.dynBaseSize, function(v) settings.dynBaseSize = v end)
createSlider(pageDynFov, "Tamanho Quando Perto", 50, 500, settings.dynSizeClose, function(v) settings.dynSizeClose = v end)
createSlider(pageDynFov, "Tamanho Quando Longe", 10, 200, settings.dynSizeFar, function(v) settings.dynSizeFar = v end)
createSlider(pageDynFov, "Distância Máxima (Studs)", 30, 300, settings.dynMaxDist, function(v) settings.dynMaxDist = v end)

createSlider(pageCalib, "Offset X (Lado)", -200, 200, settings.dynOffsetX, function(v) settings.dynOffsetX = v end)
createSlider(pageCalib, "Offset Y (Altura)", -200, 200, settings.dynOffsetY, function(v) settings.dynOffsetY = v end)

createToggle(pageRadar, "Ativar Radar Tático Pro", settings.radarAdvancedEnabled, function(v) settings.radarAdvancedEnabled = v end)
createToggle(pageRadar, "Alerta de Linha de Visão (LoS)", settings.radarLoSAlert, function(v) settings.radarLoSAlert = v end)
createSlider(pageRadar, "Raio Máximo do Radar (Studs)", 20, 500, settings.radarProximityRange, function(v) settings.radarProximityRange = v end)

local radarColorBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.3,
    Text = "Cor do Radar Pro: " .. colorPalette[settings.radarColorIndex].name,
    TextColor3 = colorPalette[settings.radarColorIndex].color,
    TextSize = settings.fontSize,
    Font = Enum.Font.GothamBold
}, pageRadar)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, radarColorBtn)
create("UIStroke", { Color = Color3.fromRGB(30, 30, 30), Thickness = 1 }, radarColorBtn)
radarColorBtn.MouseButton1Click:Connect(function()
    settings.radarColorIndex = settings.radarColorIndex + 1
    if settings.radarColorIndex > #colorPalette then settings.radarColorIndex = 1 end
    radarColorBtn.Text = "Cor do Radar Pro: " .. colorPalette[settings.radarColorIndex].name
    radarColorBtn.TextColor3 = colorPalette[settings.radarColorIndex].color
    saveConfig()
    notify("Cor do Radar Pro alterada!")
end)

createToggle(pageLoot, "Ativar Loot/Marcadores ESP", settings.lootEspEnabled, function(v) settings.lootEspEnabled = v end)
createToggle(pageLoot, "Mostrar Caixa (Contorno)", settings.lootBoxEnabled, function(v) settings.lootBoxEnabled = v end)
createToggle(pageLoot, "Mostrar Linha (Tracer)", settings.lootLineEnabled, function(v) settings.lootLineEnabled = v end)
createToggle(pageLoot, "Mostrar Nome e Distância", settings.lootNameEnabled, function(v) settings.lootNameEnabled = v end)
createSlider(pageLoot, "Distância Máxima (Studs)", 5, 500, settings.lootMaxDistance, function(v) settings.lootMaxDistance = v end)

local lootColorBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.3,
    Text = "Cor do Loot ESP: " .. colorPalette[settings.lootColorIndex].name,
    TextColor3 = colorPalette[settings.lootColorIndex].color,
    TextSize = settings.fontSize,
    Font = Enum.Font.GothamBold
}, pageLoot)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, lootColorBtn)
create("UIStroke", { Color = Color3.fromRGB(30, 30, 30), Thickness = 1 }, lootColorBtn)
lootColorBtn.MouseButton1Click:Connect(function()
    settings.lootColorIndex = settings.lootColorIndex + 1
    if settings.lootColorIndex > #colorPalette then settings.lootColorIndex = 1 end
    lootColorBtn.Text = "Cor do Loot ESP: " .. colorPalette[settings.lootColorIndex].name
    lootColorBtn.TextColor3 = colorPalette[settings.lootColorIndex].color
    saveConfig()
    notify("Cor do Loot ESP alterada!")
end)

createToggle(pageVisuals, "ESP Master (Geral)", settings.espEnabled, function(v) settings.espEnabled = v end)
createToggle(pageVisuals, "ESP Team Check", settings.espTeamCheck, function(v) settings.espTeamCheck = v end)
createToggle(pageVisuals, "ESP Inimigos", settings.espEnemies, function(v) settings.espEnemies = v end)
createToggle(pageVisuals, "ESP Aliados", settings.espAllies, function(v) settings.espAllies = v end)
createToggle(pageVisuals, "ESP Health Bar", settings.espHealthBar, function(v) settings.espHealthBar = v end)
createToggle(pageVisuals, "Name Tag ESP", settings.espNameTag, function(v) settings.espNameTag = v end)
createToggle(pageVisuals, "ESP Distância (m)", settings.espDistance, function(v) settings.espDistance = v end)

local espAimColorBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.3,
    Text = "Cor do ESP Aim: " .. colorPalette[settings.espAimColorIndex].name,
    TextColor3 = colorPalette[settings.espAimColorIndex].color,
    TextSize = settings.fontSize,
    Font = Enum.Font.GothamBold
}, pageColors)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, espAimColorBtn)
create("UIStroke", { Color = Color3.fromRGB(30, 30, 30), Thickness = 1 }, espAimColorBtn)
espAimColorBtn.MouseButton1Click:Connect(function()
    settings.espAimColorIndex = settings.espAimColorIndex + 1
    if settings.espAimColorIndex > #colorPalette then settings.espAimColorIndex = 1 end
    espAimColorBtn.Text = "Cor do ESP Aim: " .. colorPalette[settings.espAimColorIndex].name
    espAimColorBtn.TextColor3 = colorPalette[settings.espAimColorIndex].color
    saveConfig()
    notify("Cor do ESP Aim alterada!")
end)

local enemyColorLabel = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.3,
    Text = "Cor Inimigo: " .. colorPalette[settings.enemyColorIndex].name,
    TextColor3 = colorPalette[settings.enemyColorIndex].color,
    TextSize = settings.fontSize,
    Font = Enum.Font.GothamBold
}, pageColors)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, enemyColorLabel)
create("UIStroke", { Color = Color3.fromRGB(30, 30, 30), Thickness = 1 }, enemyColorLabel)
enemyColorLabel.MouseButton1Click:Connect(function()
    settings.enemyColorIndex = settings.enemyColorIndex + 1
    if settings.enemyColorIndex > #colorPalette then settings.enemyColorIndex = 1 end
    enemyColorLabel.Text = "Cor Inimigo: " .. colorPalette[settings.enemyColorIndex].name
    enemyColorLabel.TextColor3 = colorPalette[settings.enemyColorIndex].color
    saveConfig()
    notify("Cor do Inimigo alterada!")
end)

local allyColorLabel = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BackgroundTransparency = 0.3,
    Text = "Cor Aliado: " .. colorPalette[settings.allyColorIndex].name,
    TextColor3 = colorPalette[settings.allyColorIndex].color,
    TextSize = settings.fontSize,
    Font = Enum.Font.GothamBold
}, pageColors)
create("UICorner", { CornerRadius = UDim.new(0, 6) }, allyColorLabel)
create("UIStroke", { Color = Color3.fromRGB(30, 30, 30), Thickness = 1 }, allyColorLabel)
allyColorLabel.MouseButton1Click:Connect(function()
    settings.allyColorIndex = settings.allyColorIndex + 1
    if settings.allyColorIndex > #colorPalette then settings.allyColorIndex = 1 end
    allyColorLabel.Text = "Cor Aliado: " .. colorPalette[settings.allyColorIndex].name
    allyColorLabel.TextColor3 = colorPalette[settings.allyColorIndex].color
    saveConfig()
    notify("Cor do Aliado alterada!")
end)

createToggle(pageUniversal, "Ativar Radar Inteligente", settings.targetHudEnabled, function(v) settings.targetHudEnabled = v end)
createToggle(pageUniversal, "No-Clip (Atravessar Paredes)", settings.noclipEnabled, function(v) settings.noclipEnabled = v end)
createToggle(pageUniversal, "Wall Hack (Transparência)", settings.wallHackEnabled, function(v)
    settings.wallHackEnabled = v
    for _, part in ipairs(Workspace:GetDescendants()) do
        pcall(function()
            if part:IsA("BasePart") and not part:IsDescendantOf(player.Character) then
                part.Transparency = v and 0.6 or 0
            end
        end)
    end
end)
createToggle(pageUniversal, "Crosshair Premium", settings.universalCrosshairDot, function(v) settings.universalCrosshairDot = v end)

createToggle(pageHitbox, "Hitbox Expander", settings.hitboxExpander, function(v) settings.hitboxExpander = v end)
createSlider(pageHitbox, "Hitbox Size", 2, 15, settings.hitboxSize, function(v) settings.hitboxSize = v end)

local function refreshPlayerButtons()
    for _, child in ipairs(pagePlayers:GetChildren()) do
        if child:IsA("TextButton") and child.Name == "PlayerSelectBtn" then
            child:Destroy()
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local pBtn = create("TextButton", {
                Name = "PlayerSelectBtn",
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = (settings.lockedTargetName == p.Name) and Color3.fromRGB(180, 50, 255) or Color3.fromRGB(15, 15, 15),
                BackgroundTransparency = 0.3,
                Text = "Alvo: " .. p.Name,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                TextSize = settings.fontSize,
                Font = Enum.Font.GothamBold
            }, pagePlayers)
            create("UICorner", { CornerRadius = UDim.new(0, 6) }, pBtn)
            create("UIStroke", { Color = Color3.fromRGB(30, 30, 30), Thickness = 1 }, pBtn)

            pBtn.MouseButton1Click:Connect(function()
                if settings.lockedTargetName == p.Name then
                    settings.lockedTargetName = ""
                    notify("Alvo desbloqueado!")
                else
                    settings.lockedTargetName = p.Name
                    notify("Focado em: " .. p.Name)
                end
                refreshPlayerButtons()
            end)
        end
    end
end
refreshPlayerButtons()
Players.PlayerAdded:Connect(refreshPlayerButtons)
Players.PlayerRemoving:Connect(refreshPlayerButtons)

createToggle(pageMisc, "Fullbright", settings.fullbright, function(v)
    settings.fullbright = v
    Lighting.Brightness = v and 3 or 1
end)
createToggle(pageMisc, "Anti-Recoil", settings.antiRecoilEnabled, function(v) settings.antiRecoilEnabled = v end)
createToggle(pageMisc, "Bunny Hop", settings.bhop, function(v) settings.bhop = v end)
createSlider(pageMisc, "Custom Camera FOV", 70, 120, settings.customFovValue, function(v) settings.customFovValue = v end)

local fovCircleFrame = create("Frame", {
    Name = "FOVCircleVisual",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.fromOffset(settings.fov * 2, settings.fov * 2),
    BackgroundTransparency = 1,
    Visible = false
}, gui)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, fovCircleFrame)
local fovStroke = create("UIStroke", { Color = Color3.fromRGB(240, 240, 240), Thickness = 1.5, Transparency = 0.2 }, fovCircleFrame)

local espAimFovCircleFrame = create("Frame", {
    Name = "EspAimFovCircleVisual",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.fromOffset(settings.espAimFov * 2, settings.espAimFov * 2),
    BackgroundTransparency = 1,
    Visible = false
}, gui)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, espAimFovCircleFrame)
local espAimFovStroke = create("UIStroke", { Color = Color3.fromRGB(180, 50, 255), Thickness = 1.5, Transparency = 0.2 }, espAimFovCircleFrame)

local crosshairDot = create("Frame", {
    Size = UDim2.fromOffset(4, 4),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = Color3.fromRGB(240, 240, 240),
    BorderSizePixel = 0,
    Visible = false
}, gui)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, crosshairDot)

local espAimLineObj = Drawing.new("Line")
espAimLineObj.Visible = false
espAimLineObj.Thickness = 2.5

local radarHolder = create("Frame", {
    Size = UDim2.fromOffset(130, 130),
    Position = UDim2.new(1, -145, 0, 50),
    BackgroundColor3 = Color3.fromRGB(10, 10, 10),
    BackgroundTransparency = 0.4,
    Visible = false
}, gui)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, radarHolder)
local radarStroke = create("UIStroke", { Color = Color3.fromRGB(40, 40, 40), Thickness = 1.2 }, radarHolder)

local radarCenterDot = create("Frame", {
    Size = UDim2.fromOffset(6, 6),
    Position = UDim2.new(0.5, -3, 0.5, -3),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0
}, radarHolder)
create("UICorner", { CornerRadius = UDim.new(1, 0) }, radarCenterDot)

local targetHudBox = create("Frame", {
    Size = UDim2.fromOffset(230, 104),
    Position = UDim2.new(0.5, -115, 0, 12),
    BackgroundColor3 = Color3.fromRGB(10, 10, 10),
    BackgroundTransparency = 0.3,
    Visible = false,
    ZIndex = 5000
}, gui)
create("UICorner", { CornerRadius = UDim.new(0, 8) }, targetHudBox)
local targetHudStroke = create("UIStroke", { Color = Color3.fromRGB(180, 50, 255), Thickness = 1.5 }, targetHudBox)

local hudNameLabel = create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 22),
    Position = UDim2.fromOffset(8, 4),
    BackgroundTransparency = 1,
    Text = "ALVO: NENHUM",
    TextColor3 = Color3.fromRGB(240, 240, 240),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5001
}, targetHudBox)

local hudStatusTag = create("TextLabel", {
    Size = UDim2.fromOffset(80, 18),
    Position = UDim2.new(1, -88, 0, 6),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    Text = "OCULTO",
    TextColor3 = Color3.fromRGB(255, 80, 80),
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 5001
}, targetHudBox)
create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = hudStatusTag })

local hudWeaponLabel = create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 18),
    Position = UDim2.fromOffset(8, 26),
    BackgroundTransparency = 1,
    Text = "Equipado: Mãos Vazias",
    TextColor3 = Color3.fromRGB(200, 150, 255),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5001
}, targetHudBox)

local hudLoSLabel = create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 18),
    Position = UDim2.fromOffset(8, 44),
    BackgroundTransparency = 1,
    Text = "Visão Direta: Seguro",
    TextColor3 = Color3.fromRGB(50, 255, 100),
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5001
}, targetHudBox)

local hudInfoLabel = create("TextLabel", {
    Size = UDim2.new(1, -16, 0, 18),
    Position = UDim2.fromOffset(8, 62),
    BackgroundTransparency = 1,
    Text = "Distância: 0m | HP: 0/100",
    TextColor3 = Color3.fromRGB(170, 170, 170),
    TextSize = 10,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5001
}, targetHudBox)

local hudBarBg = create("Frame", {
    Size = UDim2.new(1, -16, 0, 10),
    Position = UDim2.fromOffset(8, 84),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BorderSizePixel = 0,
    ZIndex = 5001
}, targetHudBox)
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = hudBarBg })

local hudBarFill = create("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(50, 255, 100),
    BorderSizePixel = 0,
    ZIndex = 5002
}, hudBarBg)
create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = hudBarFill })

local espDrawings = {}
local function createDrawingObjects()
    local cache = {}
    cache.box = Drawing.new("Square")
    cache.box.Visible = false
    cache.box.Thickness = 1.8
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

    cache.nameTag = Drawing.new("Text")
    cache.nameTag.Visible = false
    cache.nameTag.Size = 13
    cache.nameTag.Center = true
    cache.nameTag.Outline = true

    cache.radarBlip = create("Frame", {
        Size = UDim2.fromOffset(6, 6),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        BorderSizePixel = 0,
        Visible = false
    }, radarHolder)
    create("UICorner", { CornerRadius = UDim.new(1, 0) }, cache.radarBlip)

    return cache
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then espDrawings[p] = createDrawingObjects() end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= player then espDrawings[p] = createDrawingObjects() end
end)
Players.PlayerRemoving:Connect(function(p)
    if espDrawings[p] == nil then return end
    pcall(function()
        espDrawings[p].box:Remove()
        espDrawings[p].barBg:Remove()
        espDrawings[p].barFill:Remove()
        espDrawings[p].nameTag:Remove()
        espDrawings[p].radarBlip:Destroy()
    end)
    espDrawings[p] = nil
end)

local lootDrawings = {}
local function getOrCreateLootDrawings(model)
    if not lootDrawings[model] then
        local cache = {}
        cache.box = Drawing.new("Square")
        cache.box.Visible = false
        cache.box.Thickness = 1.5
        cache.box.Filled = false

        cache.line = Drawing.new("Line")
        cache.line.Visible = false
        cache.line.Thickness = 1.2

        cache.text = Drawing.new("Text")
        cache.text.Visible = false
        cache.text.Size = 12
        cache.text.Center = true
        cache.text.Outline = true

        lootDrawings[model] = cache
    end
    return lootDrawings[model]
end

local function isAlly(targetPlayer, useTeamCheck)
    if not useTeamCheck then return false end
    if player.Team and targetPlayer.Team then
        return player.Team == targetPlayer.Team
    end
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
    local result = Workspace:Raycast(origin, direction, raycastParams)
    return result == nil
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
                while topModel.Parent and topModel.Parent ~= Workspace and topModel.Parent ~= game do
                    topModel = topModel.Parent
                end
                if topModel and topModel:IsA("Model") and not newModels[topModel] then
                    local primary = topModel.PrimaryPart or topModel:FindFirstChildWhichIsA("BasePart")
                    if primary then
                        newModels[topModel] = primary
                    end
                end
            end
        end
    end
    cachedLootModels = newModels
end

task.spawn(function()
    scanLoot()
    while true do
        task.wait(30)
        if settings.lootEspEnabled then
            scanLoot()
        end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    pcall(function()
        camera = workspace.CurrentCamera
        if not camera then return end

        crosshairDot.Visible = settings.universalCrosshairDot or settings.crosshairEnabled
        camera.FieldOfView = settings.customFovValue

        if settings.noclipEnabled and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CanCollide = false end
        end

        radarHolder.Visible = settings.targetHudEnabled

        local viewport = camera.ViewportSize
        local screenCenter = Vector2.new((viewport.X / 2) + settings.dynOffsetX, (viewport.Y / 2) + settings.dynOffsetY)

        local currentAimbotFov = settings.fov
        local bestTarget = nil
        local bestAimbotDist = currentAimbotFov
        
        local bestEspAimDist = settings.espAimFov
        local espAimTargetPart = nil
        local activeTargetPlayer = nil

        if settings.lockedTargetName ~= "" then
            local lockedP = Players:FindFirstChild(settings.lockedTargetName)
            if lockedP and lockedP.Character then
                local char = lockedP.Character
                local root = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head") or char:FindFirstChild(settings.targetPart)
                local hum = char:FindFirstChildOfClass("Humanoid")
                if root and head and hum and hum.Health > 0 then
                    bestTarget = {Position = head.Position, Part = head, Character = char}
                    activeTargetPlayer = lockedP
                end
            end
        end

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
                        local calcPos = targetPartObj.Position
                        if settings.prediction then
                            calcPos = calcPos + (rootPart.AssemblyLinearVelocity * 0.08)
                        end

                        local screenPos, onScreen = camera:WorldToViewportPoint(calcPos)
                        if onScreen and screenPos.Z > 0 then
                            local screenPosVector = Vector2.new(screenPos.X, screenPos.Y)
                            local distToCenter = (screenPosVector - screenCenter).Magnitude

                            if settings.dynamicFov and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local distToPlayer = (rootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                local progress = math.clamp(distToPlayer / settings.dynMaxDist, 0, 1)
                                currentAimbotFov = settings.dynSizeClose + (settings.dynSizeFar - settings.dynSizeClose) * progress
                            end

                            if settings.lockedTargetName == "" and distToCenter <= currentAimbotFov and distToCenter < bestAimbotDist and isVisible(targetPartObj) then
                                bestAimbotDist = distToCenter
                                bestTarget = {Position = calcPos, Part = targetPartObj, Character = char}
                                activeTargetPlayer = p
                            end

                            if settings.independentEspAim and distToCenter <= settings.espAimFov and distToCenter < bestEspAimDist and isVisible(targetPartObj) then
                                bestEspAimDist = distToCenter
                                espAimTargetPart = targetPartObj
                            end
                        end
                    end
                end
            end
        end

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
                if item:IsA("Tool") then
                    equippedTool = item.Name
                    break
                end
            end

            local lookingAtMe = false
            if settings.radarLoSAlert and targetRoot and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local enemyLookVector = targetRoot.CFrame.LookVector
                local vectorToMe = (player.Character.HumanoidRootPart.Position - targetRoot.Position).Unit
                if enemyLookVector:Dot(vectorToMe) > 0.4 then
                    lookingAtMe = true
                end
            end

            local visibleNow = targetHead and isVisible(targetHead) or false

            hudNameLabel.Text = "ALVO: " .. activeTargetPlayer.Name
            hudWeaponLabel.Text = "Equipado: " .. equippedTool
            
            if lookingAtMe then
                hudLoSLabel.Text = "Visão Direta: ALERTA (Olhando p/ ti)"
                hudLoSLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            else
                hudLoSLabel.Text = "Visão Direta: Seguro"
                hudLoSLabel.TextColor3 = Color3.fromRGB(50, 255, 100)
            end

            hudInfoLabel.Text = "Distância: " .. distMeters .. "m | HP: " .. math.floor(targetHum.Health) .. "/" .. math.floor(targetHum.MaxHealth)
            
            if visibleNow then
                hudStatusTag.Text = "VISÍVEL"
                hudStatusTag.TextColor3 = Color3.fromRGB(50, 255, 100)
            else
                hudStatusTag.Text = "OCULTO"
                hudStatusTag.TextColor3 = Color3.fromRGB(255, 80, 80)
            end

            local hpPercent = math.clamp(targetHum.Health / targetHum.MaxHealth, 0, 1)
            hudBarFill.Size = UDim2.new(hpPercent, 0, 1, 0)
            
            if hpPercent > 0.5 then
                hudBarFill.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
            elseif hpPercent > 0.25 then
                hudBarFill.BackgroundColor3 = Color3.fromRGB(255, 220, 50)
            else
                hudBarFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            end

            targetHudBox.Visible = true
        else
            targetHudBox.Visible = false
        end

        if settings.hitboxExpander then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(settings.hitboxSize, settings.hitboxSize, settings.hitboxSize)
                        hrp.Transparency = 0.7
                        hrp.CanCollide = false
                    end
                end
            end
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
                                local activeColor = colorPalette[settings.lootColorIndex].color
                                local itemName = model.Name

                                if settings.lootBoxEnabled then
                                    local size = Vector2.new(1500 / vector.Z, 2200 / vector.Z)
                                    local pos = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)
                                    cache.box.Size = size
                                    cache.box.Position = pos
                                    cache.box.Color = activeColor
                                    cache.box.Visible = true
                                else
                                    cache.box.Visible = false
                                end

                                if settings.lootLineEnabled then
                                    cache.line.From = screenCenter
                                    cache.line.To = Vector2.new(vector.X, vector.Y)
                                    cache.line.Color = activeColor
                                    cache.line.Visible = true
                                else
                                    cache.line.Visible = false
                                end

                                if settings.lootNameEnabled then
                                    cache.text.Text = "[" .. itemName .. " | " .. math.floor(dist / 3) .. "m]"
                                    cache.text.Position = Vector2.new(vector.X, vector.Y - 18)
                                    cache.text.Color = activeColor
                                    cache.text.Visible = true
                                else
                                    cache.text.Visible = false
                                end

                                activeItems[model] = true
                            end
                        end
                    end
                end
            end
            for model, cache in pairs(lootDrawings) do
                if not activeItems[model] then
                    cache.box.Visible = false
                    cache.line.Visible = false
                    cache.text.Visible = false
                end
            end
        else
            for _, cache in pairs(lootDrawings) do
                cache.box.Visible = false
                cache.line.Visible = false
                cache.text.Visible = false
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
                    local activeColor = colorPalette[settings.enemyColorIndex].color

                    local distToMeStuds = 9999
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        distToMeStuds = (rootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    end

                    local isBehindWall = headPart and not isVisible(headPart) or false
                    local inRange = distToMeStuds <= settings.radarProximityRange

                    if settings.radarAdvancedEnabled and not isTeammate then
                        if isBehindWall and inRange then
                            showBox = true
                            activeColor = colorPalette[settings.radarColorIndex].color
                        end
                    end

                    if settings.espEnabled then
                        if isTeammate then
                            if settings.espAllies then 
                                showBox = true 
                                activeColor = colorPalette[settings.allyColorIndex].color
                            end
                        else
                            if settings.espEnemies then 
                                showBox = true 
                            end
                        end
                    end

                    local isEspAimTarget = settings.independentEspAim and headPart and (headPart == espAimTargetPart)
                    if isEspAimTarget then
                        activeColor = colorPalette[settings.espAimColorIndex].color
                        showBox = true
                    end

                    if showBox then
                        local vector, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                        if onScreen then
                            local size = Vector2.new(2000 / vector.Z, 3000 / vector.Z)
                            local pos = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)

                            cache.box.Size = size
                            cache.box.Position = pos
                            cache.box.Color = activeColor
                            cache.box.Visible = true

                            if settings.espHealthBar then
                                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                                local barHeight = size.Y
                                cache.barBg.Size = Vector2.new(3, barHeight)
                                cache.barBg.Position = Vector2.new(pos.X - 6, pos.Y)
                                cache.barBg.Visible = true

                                cache.barFill.Size = Vector2.new(1, barHeight * healthPercent)
                                cache.barFill.Position = Vector2.new(pos.X - 5, pos.Y + (barHeight * (1 - healthPercent)))
                                cache.barFill.Color = activeColor
                                cache.barFill.Visible = true
                            else
                                cache.barBg.Visible = false
                                cache.barFill.Visible = false
                            end

                            if settings.espNameTag then
                                local distanceMeters = math.floor(distToMeStuds / 3)
                                cache.nameTag.Text = p.Name .. " [" .. distanceMeters .. "m]"
                                cache.nameTag.Position = Vector2.new(vector.X, pos.Y - 18)
                                cache.nameTag.Color = activeColor
                                cache.nameTag.Visible = true
                            else
                                cache.nameTag.Visible = false
                            end
                        else
                            cache.box.Visible = false
                            cache.barBg.Visible = false
                            cache.barFill.Visible = false
                            cache.nameTag.Visible = false
                        end
                    else
                        cache.box.Visible = false
                        cache.barBg.Visible = false
                        cache.barFill.Visible = false
                        cache.nameTag.Visible = false
                    end

                    if settings.targetHudEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local myRoot = player.Character.HumanoidRootPart
                        local relPos = myRoot.CFrame:PointToObjectSpace(rootPart.Position)
                        local radarScale = 2.5
                        local radarX = math.clamp(relPos.X / radarScale, -55, 55)
                        local radarY = math.clamp(relPos.Z / radarScale, -55, 55)

                        local isAtBorder = (math.abs(radarX) >= 54 or math.abs(radarY) >= 54)
                        cache.radarBlip.Size = isAtBorder and UDim2.fromOffset(8, 8) or UDim2.fromOffset(5, 5)

                        cache.radarBlip.Position = UDim2.new(0.5, radarX, 0.5, radarY)
                        cache.radarBlip.BackgroundColor3 = activeColor
                        cache.radarBlip.Visible = true
                    else
                        cache.radarBlip.Visible = false
                    end
                else
                    cache.box.Visible = false
                    cache.barBg.Visible = false
                    cache.barFill.Visible = false
                    cache.nameTag.Visible = false
                    cache.radarBlip.Visible = false
                end
            end
        end

        if settings.independentEspAim and espAimTargetPart then
            local screenPos, onScreen = camera:WorldToViewportPoint(espAimTargetPart.Position)
            if onScreen then
                espAimLineObj.From = screenCenter
                espAimLineObj.To = Vector2.new(screenPos.X, screenPos.Y)
                espAimLineObj.Color = colorPalette[settings.espAimColorIndex].color
                espAimLineObj.Visible = true
            else
                espAimLineObj.Visible = false
            end
        else
            espAimLineObj.Visible = false
        end

        fovCircleFrame.Position = UDim2.new(0.5, settings.dynOffsetX, 0.5, settings.dynOffsetY)
        fovCircleFrame.Size = UDim2.fromOffset(currentAimbotFov * 2, currentAimbotFov * 2)
        fovCircleFrame.Visible = settings.showFovCircle

        espAimFovCircleFrame.Position = UDim2.new(0.5, settings.dynOffsetX, 0.5, settings.dynOffsetY)
        espAimFovCircleFrame.Size = UDim2.fromOffset(settings.espAimFov * 2, settings.espAimFov * 2)
        espAimFovCircleFrame.Visible = settings.independentEspAim and settings.showEspAimFovCircle
        espAimFovStroke.Color = colorPalette[settings.espAimColorIndex].color

        if settings.aimbotEnabled and bestTarget then
            local direction = CFrame.lookAt(camera.CFrame.Position, bestTarget.Position)
            local alpha = math.clamp(1 / settings.smoothness, 0.01, 1)
            camera.CFrame = camera.CFrame:Lerp(direction, alpha)
        end
    end)
end)

notify("Gravel.cc (LORDths) - Pro V50 Ativo com Sucesso!")
print("[Gravel LORDths Edition] Pro V50 gelueden: Tema translúcido escuro e botão THS aplicados.")
