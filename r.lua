local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))()

task.wait(1)

local Window = WindUI:CreateWindow({
    Title = "Vex-Blox Script",
    Icon = "door-open",
    Author = "discord.gg/trixxy",
    Folder = "VexBloxHub",
    Size = UDim2.fromOffset(580, 400),
    Transparent = false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    Background = "", -- rbxassetid only
    BackgroundImageTransparency = 1,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
    KeySystem = { -- <- ↓ remove this all, if you dont neet the key system
        Key = { "1234", "5678" },
        Note = "Vexblox Hub's key system.",
        Thumbnail = {
            Image = "rbxassetid://",
            Title = "Thumbnail",
        },
        URL = "https://github.com/Footagesus/WindUI",
        SaveKey = true,
    },
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PosLabel
local connection
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local Players = game:GetService("Players")
local plr = game:GetService("Players").LocalPlayer

-- Values
_G.TeleportPlayer = "player"
_G.SeePosition = true
_G.WallHack = true
_G.Speed = "16"
_G.ToggleFly = true
_G.ToggleNoclip = true
_G.TrollPlayer = "player"
_G.TrollTeleport = true
_G.GodMode = false
_G.FlingPlayer = "player"
_G.PvpKill = true
_G.PvpAura = true
_G.KillAura = true 
_G.TugOfWar = true 
_G.EspKillers = true 
_G.InkFly = true 


-- Position display

local function ShowPosition()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Nettoyage si SeePosition désactivé
    if not _G.SeePosition then
        if connection then
            connection:Disconnect()
            connection = nil
        end
        if PosLabel then
            PosLabel:Destroy()
            PosLabel = nil
        end
        return
    end

    -- Ne rien faire si déjà actif
    if connection or PosLabel then return end

    -- Créer un ScreenGui si nécessaire
    local gui = player:FindFirstChild("PlayerGui"):FindFirstChild("VexScreenGui")
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "VexScreenGui"
        gui.ResetOnSpawn = false
        gui.Parent = player:WaitForChild("PlayerGui")
    end

    -- Créer le TextLabel
    PosLabel = Instance.new("TextLabel")
    PosLabel.Name = "PositionLabel"
    PosLabel.Size = UDim2.new(0, 300, 0, 30)
    PosLabel.Position = UDim2.new(0.5, -150, 0, 10)
    PosLabel.BackgroundTransparency = 1
    PosLabel.TextColor3 = Color3.new(30, 30, 30)
    PosLabel.TextSize = 14
    PosLabel.Font = Enum.Font.Gotham
    PosLabel.Text = ""
    PosLabel.Parent = gui

    -- Mise à jour constante
    connection = RunService.RenderStepped:Connect(function()
        if _G.SeePosition and rootPart then
            local pos = rootPart.Position
            PosLabel.Text = string.format("Position : (%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z)
        end
    end)
end


-- Get all player names
local function GetAllPlayerNames()
    local Names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(Names, player.Name)
    end
    return Names
end

-- TeleportTab UI 

local TeleportTab = Window:Tab({
    Title = "Teleports",
    Icon = "rbxassetid://4483345998",
    Locked = false,
})

local Dropdown1 = TeleportTab:Dropdown({
    Title = "Select a player to teleport to",
    Values = GetAllPlayerNames(),
    Value = "Player",
    Callback = function(option) 
        _G.TeleportPlayer = option
    end
})

local Button1 = TeleportTab:Button({
    Title = "Teleport to a player",
    Desc = "By clicking this, you will be teleported to the player you choose up.",
    Locked = false,
    Callback = function()
        local targetName = _G.TeleportPlayer
        local targetPlayer = Players:FindFirstChild(targetName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            end
        else
            warn("Target player not found or has no character.")
        end
    end
})

TeleportTab:Toggle({
    Title = "See your position",
    Default = false,
    Callback = function(state)
        _G.SeePosition = state
        ShowPosition()
    end
})



-- WallHack Function

function WallHackManager()
    local function ClearESP(player)
        if player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local label = head:FindFirstChild("ESPLabel")
                if label then label:Destroy() end
            end
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if highlight then highlight:Destroy() end
        end
    end

    local function AddESP(player)
        if not player.Character then return end
        local head = player.Character:FindFirstChild("Head")
        if not head then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPLabel"
        billboard.Size = UDim2.new(0, 100, 0, 20)
        billboard.Adornee = head
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = Color3.fromRGB(255, 0, 0)
        label.TextStrokeTransparency = 0.5
        label.TextTransparency = 0.3
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true
        label.Parent = billboard

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.7
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineTransparency = 0.2
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
    end

    local function ApplyToAll()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer then
                ClearESP(plr)
                if _G.WallHack then AddESP(plr) end
            end
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            plr.CharacterAdded:Connect(function()
                task.wait(1)
                ApplyToAll()
            end)
        end
    end

    Players.PlayerAdded:Connect(function(plr)
        if plr ~= Players.LocalPlayer then
            plr.CharacterAdded:Connect(function()
                task.wait(1)
                ApplyToAll()
            end)
        end
    end)

    ApplyToAll()
end



function ChangeSpeed()
 -- Vérifie que _G.Speed existe et est une chaîne convertible en nombre
    if type(_G.Speed) ~= "string" then
        warn("_G.Speed needs to be an int")
    return
end

    local numberSpeed = tonumber(_G.Speed)
    
 -- Vérifie que la conversion a réussi
    if not numberSpeed then
        warn("_G.Speed n'est pas un nombre valide")
    return
end

 -- Vérifie si le nombre est supérieur à 300
    if numberSpeed > 300 then
        warn("La vitesse est trop élevée (max 300)")
    return
end

 -- Appliquer la vitesse au joueur
    local player = game.Players.LocalPlayer
        if not player or not player.Character or not player.Character:FindFirstChild("Humanoid") then
            warn("Humanoid introuvable")
        return
    end

    player.Character.Humanoid.WalkSpeed = numberSpeed
end


-- Flying 


local BodyGyro, BodyVelocity, Character, HumanoidRootPart, CameraConnection

local flySpeed = 50

local function StartFlying()
   Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    -- Ajout du contrôle de rotation pour suivre la caméra
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.cframe = workspace.CurrentCamera.CFrame
    BodyGyro.Parent = HumanoidRootPart

    -- Ajout de la vélocité pour voler
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.velocity = Vector3.new(0, 0, 0)
    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Parent = HumanoidRootPart

    -- Boucle pour mise à jour directionnelle
    CameraConnection = RunService.RenderStepped:Connect(function()
        if not _G.ToggleFly then return end

        local cam = workspace.CurrentCamera
        local direction = cam.CFrame.LookVector
        BodyGyro.CFrame = cam.CFrame
        BodyVelocity.velocity = direction * flySpeed
    end)
end

-- Fonction d'arrêt du vol
local function StopFlying()
    _G.ToggleFly = false
    if CameraConnection then CameraConnection:Disconnect() end
    if BodyGyro then BodyGyro:Destroy() end
    if BodyVelocity then BodyVelocity:Destroy() end
end

ToggleFly = function()
    if _G.ToggleFly == true then
        StartFlying()
    else
        StopFlying()
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if _G.ToggleFly then
        StartFlying()
    end
end)

-- Noclip

local noclipConnection = nil

function ToggleNoclip()

    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    if _G.ToggleNoclip == true then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Wall Tab
local WallTab = Window:Tab({
    Title = "WallTab",
    Icon = "rbxassetid://4483345998",
    Locked = false,
})

WallTab:Toggle({
    Title = "Wall Hack",
    Default = false,
    Callback = function(state)
        _G.WallHack = state
        WallHackManager()
    end
})

WallTab:Slider({
    Title = "Change your speed",
    
    -- To make float number supported, 
    -- make the Step a float number.
    -- example: Step = 0.1
    Step = 10,
    
    Value = {
        Min = 16,
        Max = 300,
        Default = 16,
    },

    Callback = function(value)
        _G.Speed = value
        ChangeSpeed()
    end
})


WallTab:Toggle({
    Title = "Enable / Disable Noclip",
    Default = false,
    Callback = function(state)
        _G.ToggleNoclip = state
        ToggleNoclip()
   end    
})

WallTab:Toggle({
    Title = "Enable / Disable Fly (BETA)",
    Default = false,
    Callback = function(state)
        _G.ToggleFly = state
        ToggleFly()
   end    
})


-- All TP to a player 

function AllTpToThePlayer()
    task.spawn(function()
        while true do
            if _G.TrollTeleport == true and _G.TrollPlayer and _G.TrollPlayer ~= false then
                local target = Players:FindFirstChild(_G.TrollPlayer)
                local character = Players.LocalPlayer.Character
                if target and target.Character and character and character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = target.Character.HumanoidRootPart.Position
                    character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
                end
            elseif _G.TrollPlayer == false then
                break
            end
            task.wait(0.0001)
        end
    end)
end

-- GodMode 

local humanoidConn

function GodModeHandler()
    if not plr then return end

    -- Nettoyage si déjà actif
    if humanoidConn then
        humanoidConn:Disconnect()
        humanoidConn = nil
    end

    local function protectHumanoid(h)
        humanoidConn = h:GetPropertyChangedSignal("Health"):Connect(function()
            if _G.GodMode and h.Health < h.MaxHealth then
                h.Health = h.MaxHealth
            end
        end)
    end

    if _G.GodMode == true then
        local char = plr.Character or plr.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            protectHumanoid(humanoid)
        end
    end
end

-- Fling 

function LaunchFling()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local target = _G.TrollPlayer
    if typeof(target) ~= "string" then warn("Définis _G.FlingPlayer = \"PseudoExact\"") return end
    target = Players:FindFirstChild(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        warn("Cible non trouvée ou invalide")
        return
    end
    local targetHRP = target.Character.HumanoidRootPart

    local lp = Players.LocalPlayer
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local originalPosition = hrp.Position
    local originalRotation = hrp.Orientation

    local startTime = tick()
    local duration = 4
    local angle = 0
    local radius = 2
    local spinSpeed = 40
    local velForce = 10000

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        local t = tick() - startTime
        if t >= duration then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(originalPosition) * CFrame.Angles(
                math.rad(originalRotation.X),
                math.rad(originalRotation.Y),
                math.rad(originalRotation.Z)
            )
            conn:Disconnect()
            return
        end

        if not targetHRP or not targetHRP.Parent then return end
        angle = angle + spinSpeed * dt
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius
        local baseCFrame = CFrame.new(targetHRP.Position + Vector3.new(x, 1, z))
        local look = CFrame.lookAt(baseCFrame.p, targetHRP.Position)
        local tilt = CFrame.Angles(math.rad(90), 0, 0)
        hrp.CFrame = look * tilt

        hrp.AssemblyLinearVelocity = (targetHRP.Position - hrp.Position).Unit * velForce
        hrp.AssemblyAngularVelocity = Vector3.new(0, velForce/5, 0)
    end)
end

-- Troisième Tab

local TrollTab = Window:Tab({
    Title = "TrollTab",
    Icon = "rbxassetid://4483345998",
    Locked = false,

})

local TrollDropdown = TrollTab:Dropdown({
    Title = "Select a player to troll",
    Values = GetAllPlayerNames(),
    Value = "Player",
    Callback = function(option)
        _G.TrollPlayer = option
    end
})

TrollTab:Toggle({
    Title = "All TP to a player",
    Default = false,
    Callback = function(state)
        _G.TrollTeleport = state        
        AllTpToThePlayer()
    end
})

task.spawn(function()
    while true do
        task.wait(60)
        TrollDropdown:Refresh(GetAllPlayerNames())
        Dropdown1:Refresh(GetAllPlayerNames())
    end
end)


TrollTab:Toggle({
    Title = "Enable / Disable GodMode",
    Default = false,
    Callback = function(state)
        _G.GodMode = state        
        GodModeHandler()
    end
})

TrollTab:Button({
    Title = "Enable Fling",
    Desc = "Could ban you",
    Callback = function()
        LaunchFling()
    end
})

-- 3rd tab functions : 

-- Auto KILL PVP

local AutoKillConnection

function AutoKillMelee()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local function getCharacter(player)
        return player and player.Character or nil
    end

    local function hasShield(player)
        local char = getCharacter(player)
        return char and char:FindFirstChild("ForceField") ~= nil
    end

    local function getHealth(player)
        local char = getCharacter(player)
        if not char then return math.huge end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        return hum and hum.Health or math.huge
    end

    local function getTool()
        local char = getCharacter(LocalPlayer)
        if not char then return nil end
        return char:FindFirstChildOfClass("Tool")
    end

    if AutoKillConnection then
        AutoKillConnection:Disconnect()
        AutoKillConnection = nil
    end

    AutoKillConnection = RunService.Heartbeat:Connect(function()
        if not _G.PvpKill then
            if AutoKillConnection then
                AutoKillConnection:Disconnect()
                AutoKillConnection = nil
            end
            return
        end

        local tool = getTool()
        if not tool then return end

        local target = nil
        local minHP = math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and not hasShield(plr) then
                local hp = getHealth(plr)
                if hp > 0 and hp < minHP then
                    minHP = hp
                    target = plr
                end
            end
        end

        if not target then return end

        local targetChar = getCharacter(target)
        local myChar = getCharacter(LocalPlayer)
        if not targetChar or not myChar then return end

        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not myHRP then return end

        myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, -3, 0)

        if tool:FindFirstChild("Activate") then
            tool:Activate()
        else
            pcall(function() tool:FireServer() end)
        end
    end)
end




-- 3rd tab  

local AutoTab = Window:Tab({
    Title = "Auto Exploits",
    Icon = "rbxassetid://4483345998",
    Locked = false,
})

AutoTab:Toggle({
    Title = "Auto PVP",
    Default = false,
    Callback = function(state)
        _G.PvpKill = state
        AutoKillMelee()
    end    
})

-- Ink Games 

-- Functions 

local function Teleport(x, y, z)
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end

    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if root and x and y and z then
        root.CFrame = CFrame.new(x, y, z)
    end
end

-- Dalgona 

local function triggerDalgona()
  local DalgonaClientModule = game.ReplicatedStorage.Modules.Games.DalgonaClient

    for _, v in ipairs(getreg()) do
    if typeof(v) == "function" and islclosure(v) then
        local env = getfenv(v)
        if env and env.script == DalgonaClientModule then
            local info = debug.getinfo(v)
            if info and info.nups == 73 then
                setupvalue(v, 31, 9e9)
                break
            end
        end
    end
end 
end

-- Déplace vers le haut
function goUp(blocks)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0, blocks, 0)
    end
end

-- Déplace vers le bas
function goDown(blocks)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0, -blocks, 0)
    end
end

-- Kill aura 

function AutoKillAura()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local function getCharacter(player)
        return player and player.Character or nil
    end

    local function hasShield(player)
        local char = getCharacter(player)
        return char and char:FindFirstChild("ForceField") ~= nil
    end

    local function getHealth(player)
        local char = getCharacter(player)
        if not char then return math.huge end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
          return hum and hum.Health or math.huge
    end

    local function getTool()
        local char = getCharacter(LocalPlayer)
        if not char then return nil end
        return char:FindFirstChildOfClass("Tool")
    end

    local function hasKnifeInBackpack(player)
        local backpack = player:FindFirstChild("Backpack")
        if not backpack then return false end
        return backpack:FindFirstChild("Knife") ~= nil
    end

    local connection

    connection = RunService.Heartbeat:Connect(function()
        if not _G.PvpAura then
            if connection then
                connection:Disconnect()
                connection = nil
            end
            return
        end

        local tool = getTool()
        if not tool then return end

        local target = nil
        local minHP = math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and not hasShield(plr) and not hasKnifeInBackpack(plr) then
                local hp = getHealth(plr)
                if hp > 0 and hp < minHP then
                    minHP = hp
                    target = plr
                end
            end
        end

        if not target then return end

        local targetChar = getCharacter(target)
        local myChar = getCharacter(LocalPlayer)
        if not targetChar or not myChar then return end

        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not myHRP then return end

        -- TP plus proche derrière la cible (distance 2 unités)
        local backOffset = targetHRP.CFrame.LookVector * -0.5
        myHRP.CFrame = targetHRP.CFrame + backOffset + Vector3.new(0, 0, 0)

        -- Fallback si clic ne fonctionne pas
        pcall(function()
            if tool:FindFirstChild("Activate") then
                tool:Activate()
            else
                tool:FireServer()
            end
        end)
    end)
end

-- Kill aura 2
function AutoKillAura2()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local function getCharacter(player)
        return player and player.Character or nil
    end

    local function hasShield(player)
        local char = getCharacter(player)
        return char and char:FindFirstChild("ForceField") ~= nil
    end

    local function getHealth(player)
        local char = getCharacter(player)
        if not char then return math.huge end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        return hum and hum.Health or math.huge
    end

    local function getTool()
        local char = getCharacter(LocalPlayer)
        if not char then return nil end
        return char:FindFirstChildOfClass("Tool")
    end

    local connection

    connection = RunService.Heartbeat:Connect(function()
        if not _G.KillAura then
            if connection then
                connection:Disconnect()
                connection = nil
            end
            return
        end

        local tool = getTool()
        if not tool then return end

        local target = nil
        local minHP = math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and not hasShield(plr) then
                local hp = getHealth(plr)
                if hp > 0 and hp < minHP then
                    minHP = hp
                    target = plr
                end
            end
        end

        if not target then return end

        local targetChar = getCharacter(target)
        local myChar = getCharacter(LocalPlayer)
        if not targetChar or not myChar then return end

        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not myHRP then return end

        -- Position au-dessus du joueur
        local position = targetHRP.Position + Vector3.new(0, 5, 0)

        -- Calcul d'une CFrame avec inclinaison à 90° vers le bas
        local look = targetHRP.CFrame.LookVector
        local right = targetHRP.CFrame.RightVector
        local up = right:Cross(look).Unit -- donne un axe perpendiculaire

        local baseCFrame = CFrame.lookAt(position, position - Vector3.new(0, 1, 0))
        myHRP.CFrame = baseCFrame * CFrame.Angles(0, 0, math.rad(90))

        -- Activation automatique de l'outil
        pcall(function()
            if tool:FindFirstChild("Activate") then
                tool:Activate()
            else
                tool:FireServer()
            end
        end)
    end)
end

function esp_killers()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")

    local espConnection = nil
    local highlights = {}

    local function removeHighlights()
        for _, h in pairs(highlights) do
            if h and h.Parent then
                h:Destroy()
            end
        end
        highlights = {}
    end

    local function stopESP()
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        removeHighlights()
    end

    stopESP()

    if not _G.EspKillers then return end

    espConnection = RunService.Heartbeat:Connect(function(step)
        local currentTime = tick()
        local lastUpdate = 0

        if currentTime - lastUpdate >= 1 then
            lastUpdate = currentTime

            if not _G.EspKillers then
                stopESP()
                return
            end

            removeHighlights()

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hasKnife = false

                        local backpack = player:FindFirstChild("Backpack")
                        if backpack and backpack:FindFirstChild("Knife") then
                            hasKnife = true
                        elseif char:FindFirstChild("Knife") then
                            hasKnife = true
                        end

                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = char
                        highlight.FillColor = hasKnife and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 255)
                        highlight.OutlineColor = Color3.new(1, 1, 1)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = char
                        table.insert(highlights, highlight)
                    end
                end
            end
        end
    end)
end

local function InkFlyToggle()
    local flyEnabled = _G.InkFly
    local flySpeed = 50
    local flyConn = nil

    if not flyEnabled then return end

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Camera = workspace.CurrentCamera

    local ghostPart = Instance.new("Part")
    ghostPart.Anchored = true
    ghostPart.CanCollide = false
    ghostPart.Transparency = 1
    ghostPart.Name = "ghp"
    ghostPart.Size = Vector3.new(1, 1, 1)
    ghostPart.Position = Vector3.new(0, -500, 0)
    ghostPart.Parent = workspace

    local stealthVelocity = Instance.new("BodyVelocity")
    stealthVelocity.Name = "ghv"
    stealthVelocity.MaxForce = Vector3.new(0, 0, 0)
    stealthVelocity.Velocity = Vector3.new(0, 0, 0)
    stealthVelocity.Parent = ghostPart

    local stealthGyro = Instance.new("BodyGyro")
    stealthGyro.Name = "ghg"
    stealthGyro.MaxTorque = Vector3.new(0, 0, 0)
    stealthGyro.CFrame = Camera.CFrame
    stealthGyro.Parent = ghostPart

    local function getMoveVector()
        local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts") or LocalPlayer.PlayerScripts
        if not playerScripts then return Vector3.new() end
        local playerModule = playerScripts:FindFirstChild("PlayerModule") or playerScripts:WaitForChild("PlayerModule", 5)
        if not playerModule then return Vector3.new() end
        local controlMod
        pcall(function()
            controlMod = require(playerModule:WaitForChild("ControlModule"))
        end)
        if controlMod and typeof(controlMod.GetMoveVector) == "function" then
            return controlMod:GetMoveVector()
        end
        return Vector3.new()
    end

    if flyConn then flyConn:Disconnect() end

    flyConn = RunService.Heartbeat:Connect(function()
        if not (_G.InkFly and Character and HumanoidRootPart) then
            flyConn:Disconnect()
            ghostPart:Destroy()
            stealthVelocity:Destroy()
            stealthGyro:Destroy()
            return
        end

        local moveVec = getMoveVector()
        local moveDir = Vector3.new()

        if moveVec.Magnitude > 0 then
            moveDir = Camera.CFrame.LookVector * -moveVec.Z + Camera.CFrame.RightVector * moveVec.X
        end

        local humanoid = Character:FindFirstChildWhichIsA("Humanoid")
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or (humanoid and humanoid.Jump) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            HumanoidRootPart.Velocity = moveDir.Unit * flySpeed
        else
            HumanoidRootPart.Velocity = Vector3.zero
        end

        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + Camera.CFrame.LookVector)
    end)
end

-- Ink UI

local InkTab = Window:Tab({
    Title = "Ink games",
    Icon = "rbxassetid://4483345998",
    Locked = false,
})

-- Green Light 

local Section = InkTab:Section({
	Title = "Green Light",
    TextXAlignment = "Left",
    TextSize = 17,
})

InkTab:Button({
	Title = "Finish Green Light",
    Desc = "Finish Green Light, Red Light by teleporting to the end.",
	Callback = function()
      		Teleport(-45,1024.7,136.7)
  	end    
})

local Section = InkTab:Section({
	Title = "Dalgona",
    TextXAlignment = "Left",
    TextSize = 17,
})

InkTab:Button({
	Title = "Auto Dalgona",
    Desc = "Auto Cut the candy in 0.1 secs.",
	Callback = function()
        triggerDalgona()
  	end    
})

-- Night 

local Section = InkTab:Section({
	Title = "Night",
    TextXAlignment = "Left",
    TextSize = 17,
})

InkTab:Button({
	Title = "Get Bottle and food",
    Desc = "Get automatically the food in the night.",
	Callback = function()
        game:GetService("ReplicatedStorage").Remotes.TemporaryReachedBindable:FireServer()
  	end    
})

InkTab:Toggle({
    Title = "Smart Kill Aura",
    Desc = "Kill aura for Lights Out, Last Dinner, and Final.",
    Default = false,
    Callback = function(state)
        _G.KillAura = state
        AutoKillAura2()
    end    
})
-- Hide And Seek 

local Section = InkTab:Section({
	Title = "Hide And Seek",
    TextXAlignment = "Left",
    TextSize = 17,
})

InkTab:Button({
	Title = "100 Blocks Up",
	Callback = function()
      goUp(100)
  	end    
})

InkTab:Button({
	Title = "40 Blocks Down",
	Callback = function()
      goDown(40)
  	end    
})

InkTab:Toggle({
    Title = "Kill Aura",
    desc = "Kill aura for Hide And Seek.",
    Default = false,
    Callback = function(state)
        _G.PvpAura = state 
        AutoKillAura()
    end    
})

InkTab:Toggle({
    Title = "Killers and Hider ESP",
    Default = false,
    Callback = function(state)
        _G.EspKillers = state
        esp_killers()
    end    
})

-- Tug Of War 
local Section = InkTab:Section({
	Title = "Tug Of War",
    TextXAlignment = "Left",
    TextSize = 17,
})

InkTab:Toggle({
    Title = "Auto Tug of War",
    Default = false,
    Callback = function(state)
        _G.TugOfWar = state 
        while _G.TugOfWar == true do 
          local args = {
            {
              IHateYou = true
            }
          }
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TemporaryReachedBindable"):FireServer(unpack(args))
          task.wait(0.01)
        end
    end    
})
-- Jump Rope 

local Section = InkTab:Section({
	Title = "Jump Rope",
    TextXAlignment = "Left",
    TextSize = 17,
})

InkTab:Button({
	Title = "Finish Jump Rope",
    Desc = "Teleport to the end of Jump rope",
	Callback = function()
      		Teleport(720.7,197.1,920.1)
  	end    
})

InkTab:Toggle({
    Title = "Toggle Fly (BETA)",
    Default = false,
    Callback = function(state)
        _G.InkFly = state 
        InkFlyToggle()
    end    
})

-- Glasses

local Section = InkTab:Section({
	Title = "Glass Bridge",
    TextXAlignment = "Left",
    TextSize = 17,
})

InkTab:Button({
	Title = "Finish Glass Bridge",
    Desc = "Teleport to the end of Glass Bridge",
	Callback = function()
      		Teleport(-203.7,520.7,-1534.9)
  	end    
})
