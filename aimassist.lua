-- AIM ASSIST PRO | PLAYERS (DELTA EXECUTOR)
-- Versão otimizada e livre de duplicatas.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIGURAÇÕES
local enabled = false
local fov = 150
local smoothness = 8
local teamCheck = true

local tracked = {}

-- CORES
local BG = Color3.fromRGB(17, 19, 26)
local PANEL = Color3.fromRGB(26, 29, 39)
local ACCENT = Color3.fromRGB(116, 92, 255)
local WHITE = Color3.fromRGB(240, 240, 245)
local MUTED = Color3.fromRGB(145, 150, 165)

-- FUNÇÃO DE INTERFACE
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
    Name = "PlayerAimAssist",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, playerGui)

-- PAINEL PRINCIPAL
local main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(330, 390),
    Position = UDim2.new(0, 35, 0.5, -195),
    BackgroundColor3 = BG,
    BorderSizePixel = 0
}, gui)

create("UICorner", { CornerRadius = UDim.new(0, 12) }, main)
create("UIStroke", { Color = Color3.fromRGB(55, 58, 75), Thickness = 1.3 }, main)

-- BARRA SUPERIOR
local top = create("Frame", {
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, main)

create("UICorner", { CornerRadius = UDim.new(0, 12) }, top)

create("TextLabel", {
    Size = UDim2.new(1, -65, 1, 0),
    Position = UDim2.fromOffset(16, 0),
    BackgroundTransparency = 1,
    Text = "AIM ASSIST  /  PLAYERS",
    TextColor3 = WHITE,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

local close = create("TextButton", {
    Size = UDim2.fromOffset(34, 30),
    Position = UDim2.new(1, -43, 0, 11),
    BackgroundColor3 = Color3.fromRGB(180, 55, 65),
    Text = "X",
    TextColor3 = WHITE,
    TextSize = 13,
    Font = Enum.Font.GothamBold
}, top)

create("UICorner", { CornerRadius = UDim.new(0, 7) }, close)
close.MouseButton1Click:Connect(function()
    enabled = false
    gui:Destroy()
end)

-- ARRASTAR PAINEL (SUPORTE A TOQUE E MOUSE)
local dragging = false
local dragStart, startPosition

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- STATUS
local status = create("TextLabel", {
    Size = UDim2.new(1, -30, 0, 28),
    Position = UDim2.fromOffset(15, 65),
    BackgroundTransparency = 1,
    Text = "STATUS: DESATIVADO",
    TextColor3 = MUTED,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, main)

-- BOTÃO ATIVAR
local toggle = create("TextButton", {
    Size = UDim2.new(1, -30, 0, 40),
    Position = UDim2.fromOffset(15, 100),
    BackgroundColor3 = Color3.fromRGB(65, 68, 83),
    Text = "ATIVAR AIM ASSIST",
    TextColor3 = WHITE,
    TextSize = 13,
    Font = Enum.Font.GothamBold
}, main)

create("UICorner", { CornerRadius = UDim.new(0, 8) }, toggle)

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        status.Text = "STATUS: ATIVO"
        status.TextColor3 = Color3.fromRGB(90, 230, 145)
        toggle.Text = "DESATIVAR AIM ASSIST"
        toggle.BackgroundColor3 = ACCENT
    else
        status.Text = "STATUS: DESATIVADO"
        status.TextColor3 = MUTED
        toggle.Text = "ATIVAR AIM ASSIST"
        toggle.BackgroundColor3 = Color3.fromRGB(65, 68, 83)
    end
end)

-- BOTÃO TEAM CHECK
local teamBtn = create("TextButton", {
    Size = UDim2.new(1, -30, 0, 35),
    Position = UDim2.fromOffset(15, 150),
    BackgroundColor3 = Color3.fromRGB(48, 95, 75),
    Text = "TEAM CHECK: ON",
    TextColor3 = WHITE,
    TextSize = 12,
    Font = Enum.Font.GothamBold
}, main)

create("UICorner", { CornerRadius = UDim.new(0, 8) }, teamBtn)

teamBtn.MouseButton1Click:Connect(function()
    teamCheck = not teamCheck
    teamBtn.Text = "TEAM CHECK: " .. (teamCheck and "ON" or "OFF")
    teamBtn.BackgroundColor3 = teamCheck and Color3.fromRGB(48, 95, 75) or Color3.fromRGB(65, 68, 83)
end)

-- CRIADOR DE SLIDERS UNIFICADO
local function createSlider(title, y, minValue, maxValue, initial, callback)
    local label = create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 25),
        Position = UDim2.fromOffset(15, y),
        BackgroundTransparency = 1,
        Text = title .. ": " .. initial,
        TextColor3 = WHITE,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left
    }, main)

    local track = create("TextButton", {
        Size = UDim2.new(1, -30, 0, 8),
        Position = UDim2.fromOffset(15, y + 25),
        BackgroundColor3 = Color3.fromRGB(55, 58, 72),
        Text = "",
        AutoButtonColor = false
    }, main)

    create("UICorner", { CornerRadius = UDim.new(1, 0) }, track)

    local fill = create("Frame", {
        Size = UDim2.new((initial - minValue) / (maxValue - minValue), 0, 1, 0),
        BackgroundColor3 = ACCENT,
        BorderSizePixel = 0
    }, track)

    create("UICorner", { CornerRadius = UDim.new(1, 0) }, fill)

    local sliderDragging = false

    local function update(input)
        local percentage = math.clamp(
            (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X,
            0, 1
        )
        local value = math.floor(minValue + percentage * (maxValue - minValue) + 0.5)
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        label.Text = title .. ": " .. value
        callback(value)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = false
        end
    end)
end

-- CRIAR SLIDERS DE FOV E SMOOTHNESS
createSlider("FOV", 200, 50, 350, fov, function(value) fov = value end)
createSlider("SMOOTHNESS", 260, 1, 20, smoothness, function(value) smoothness = value end)

-- CÍRCULO DE FOV NA TELA
local fovCircle = create("Frame", {
    Name = "FOVCircle",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(fov * 2, fov * 2),
    BackgroundTransparency = 1,
    Visible = true
}, gui)

create("UICorner", { CornerRadius = UDim.new(1, 0) }, fovCircle)
create("UIStroke", { Color = ACCENT, Thickness = 1.5, Transparency = 0.2 }, fovCircle)

-- GERENCIAMENTO DE ESP (HIGHLIGHT)
local function createESP(p)
    if tracked[p] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESP"
    highlight.Adornee = p.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.85
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(255, 65, 65)
    highlight.OutlineColor = Color3.fromRGB(255, 65, 65)
    highlight.Parent = playerGui
    
    tracked[p] = highlight
end

local function removeESP(p)
    if tracked[p] then
        tracked[p]:Destroy()
        tracked[p] = nil
    end
end

local function isAlly(targetPlayer)
    if not teamCheck then return false end
    if player.Team and targetPlayer.Team then
        return player.Team == targetPlayer.Team
    end
    return false
end

-- LOOP PRINCIPAL DE EXECUÇÃO
RunService.RenderStepped:Connect(function()
    camera = workspace.CurrentCamera
    if not camera then return end

    fovCircle.Size = UDim2.fromOffset(fov * 2, fov * 2)
    fovCircle.Visible = enabled

    local viewport = camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

    local bestTarget = nil
    local bestDistance = fov

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local char = p.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local head = char and char:FindFirstChild("Head")

            if char and humanoid and humanoid.Health > 0 and head then
                createESP(p)
                local highlight = tracked[p]
                
                if highlight then
                    highlight.Adornee = char
                    local ally = isAlly(p)
                    highlight.Enabled = enabled and not ally
                end

                -- Lógica do Aim Assist focada em players
                if enabled and not isAlly(p) then
                    local screenPosition, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen and screenPosition.Z > 0 then
                        local screenDist = (Vector2.new(screenPosition.X, screenPosition.Y) - center).Magnitude
                        if screenDist < bestDistance then
                            bestDistance = screenDist
                            bestTarget = head
                        end
                    end
                end
            else
                removeESP(p)
            end
        end
    end

    -- Suavização da câmera em direção ao alvo
    if enabled and bestTarget then
        local direction = CFrame.lookAt(camera.CFrame.Position, bestTarget.Position)
        local alpha = math.clamp(1 / smoothness, 0.01, 1)
        camera.CFrame = camera.CFrame:Lerp(direction, alpha)
    end
end)

Players.PlayerRemoving:Connect(removeESP)

print("[Aim Assist Players] Limpo e carregado com sucesso!")
