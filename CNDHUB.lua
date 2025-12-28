--// CDN HUB SCRIPT

-- Anti-duplicado
if game.CoreGui:FindFirstChild("CDN_HUB") then
    game.CoreGui.CDN_HUB:Destroy()
end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "CDN_HUB"

-- Botón circular
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 20, 0.5, -30)
openBtn.Text = "CDN"
openBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.TextScaled = true
openBtn.Active = true
openBtn.Draggable = true
openBtn.BorderSizePixel = 0
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

-- Menú
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 420, 0, 300)
menu.Position = UDim2.new(0.5, -210, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(120,120,120)
menu.Visible = false
menu.Active = true
menu.Draggable = true
Instance.new("UICorner", menu)

-- Título
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1,0,0,40)
title.Text = "CDN HUB"
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextColor3 = Color3.new(0,0,0)

-- Tabs
local tabNames = {"Visual","Herramientas","Mundo","Movimiento","Combate"}
local tabs = {}
local pages = {}

for i,name in ipairs(tabNames) do
    local b = Instance.new("TextButton", menu)
    b.Size = UDim2.new(0,80,0,30)
    b.Position = UDim2.new(0,(i-1)*84,0,45)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(80,80,80)
    b.TextColor3 = Color3.new(1,1,1)
    tabs[name] = b

    local p = Instance.new("Frame", menu)
    p.Size = UDim2.new(1,-20,1,-90)
    p.Position = UDim2.new(0,10,0,80)
    p.Visible = false
    p.BackgroundTransparency = 1
    pages[name] = p

    b.MouseButton1Click:Connect(function()
        for _,pg in pairs(pages) do pg.Visible = false end
        p.Visible = true
    end)
end
pages.Visual.Visible = true

-- Función crear botón
local function makeBtn(parent,text,y,callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0,180,0,35)
    btn.Position = UDim2.new(0,10,0,y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(callback)
end

-- VISUAL
makeBtn(pages.Visual,"Full Bright",10,function()
    Lighting.Brightness = 3
    Lighting.ClockTime = 14
end)

-- HERRAMIENTAS
local savedPos
makeBtn(pages.Herramientas,"Guardar Posición",10,function()
    savedPos = hrp.CFrame
end)
makeBtn(pages.Herramientas,"Volver a Posición",55,function()
    if savedPos then hrp.CFrame = savedPos end
end)

-- MUNDO
makeBtn(pages.Mundo,"Quitar Niebla",10,function()
    Lighting.FogEnd = 1e9
end)

-- MOVIMIENTO
local speedOn = false
makeBtn(pages.Movimiento,"Speed ON/OFF",10,function()
    speedOn = not speedOn
    hum.WalkSpeed = speedOn and 50 or 16
end)

local noclip = false
makeBtn(pages.Movimiento,"Noclip",55,function()
    noclip = not noclip
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- COMBATE (ejemplo simple)
makeBtn(pages.Combate,"Fling (cerca)",10,function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < 10 then
                hrp.Velocity = Vector3.new(0,500,0)
            end
        end
    end
end)

-- Abrir / cerrar
openBtn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)
