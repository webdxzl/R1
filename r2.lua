local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Window = WindUI:CreateWindow({
    Folder = "Ringta Scripts",
    Title = "RINGTA SCRIPTS",
    Icon = "star",
    Author = "RINGTA and BUBLIK6241",
    Theme = "Dark",
    Size = UDim2.fromOffset(500, 350),
    HasOutline = true,
})

Window:EditOpenButton({
    Title = "Open RINGTA SCRIPTS",
    Icon = "pointer",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(200, 0, 255), Color3.fromRGB(0, 200, 255)),
    Draggable = true,
})

local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "star" }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "rocket" }),
    Bring = Window:Tab({ Title = "Bring Items", Icon = "package" }),
    Hitbox = Window:Tab({ Title = "Hitbox", Icon = "target" }),
    AutoDays = Window:Tab({ Title = "Auto Farm", Icon = "sun" }),
    KillAll = Window:Tab({ Title = "Kill All Mobs", Icon = "skull" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "gift" }),
    Esp = Window:Tab({ Title = "Esp", Icon = "eye" }),
    Credits = Window:Tab({ Title = "Credits", Icon = "award" })
}

local spawnItemsActive = false
local spawnItemsThread
local traderPos = Vector3.new(-37.08, 6.98, -16.33)

Tabs.Main:Section({ Title = "Tree Farm (Hold Out Axe)" })

Tabs.Main:Button({
    Title = "AutoFarm Trees/Logs",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ewiuy438/treefarm.github.io/refs/heads/main/ere.lua"))()
    end,
})

getgenv().AutoPlantSaplings = false

Tabs.Main:Toggle({
    Title = "Auto Plant Saplings",
    Default = false,
    Callback = function(state)
        getgenv().AutoPlantSaplings = state
    end
})

coroutine.wrap(function()
    local itemsFolder = Workspace:WaitForChild("Items")
    local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
    local requestPlant = remoteEvents:WaitForChild("RequestPlantItem")
    while true do
        if getgenv().AutoPlantSaplings then
            for _, item in ipairs(itemsFolder:GetChildren()) do
                if item.Name == "Sapling" then
                    local part = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
                    if part then
                        if not item.PrimaryPart then
                            pcall(function() item.PrimaryPart = part end)
                        end
                        remoteEvents.RequestStartDraggingItem:FireServer(item)
                        task.wait(0.1)
                        requestPlant:InvokeServer(item, part.Position)
                    end
                end
            end
        end
        task.wait(1)
    end
end)()

Tabs.Main:Divider()
Tabs.Main:Section({ Title = "Auto Fuel CampFire" })

local CAMPFIRE_FUEL_ITEMS = {"Log", "Coal", "Fuel Canister", "Oil Barrel", "Biofuel"}
getgenv().AutoFuelCampfireList = {}
getgenv().AutoFuelCampfireOn = false

Tabs.Main:Dropdown({
    Title = "Choose Which Items To Use To Fuel CampFire",
    Values = CAMPFIRE_FUEL_ITEMS,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        getgenv().AutoFuelCampfireList = {}
        for _, item in ipairs(selected) do
            getgenv().AutoFuelCampfireList[item] = true
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Fuel CampFire",
    Default = false,
    Callback = function(state)
        getgenv().AutoFuelCampfireOn = state
    end
})

local itemsFolder = Workspace:WaitForChild("Items")
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local campfireDropPos = Vector3.new(0, 19, 0)

local function moveItemToPos(item, position)
    local part = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")
    if not part then return end
    if not item.PrimaryPart then pcall(function() item.PrimaryPart = part end) end
    pcall(function()
        remoteEvents.RequestStartDraggingItem:FireServer(item)
        task.wait(0.05)
        item:SetPrimaryPartCFrame(CFrame.new(position))
        task.wait(0.05)
        remoteEvents.StopDraggingItem:FireServer(item)
    end)
end

coroutine.wrap(function()
    while true do
        if getgenv().AutoFuelCampfireOn then
            for itemName, enabled in pairs(getgenv().AutoFuelCampfireList) do
                if enabled then
                    for _, item in ipairs(itemsFolder:GetChildren()) do
                        if item.Name == itemName then
                            moveItemToPos(item, campfireDropPos)
                        end
                    end
                end
            end
        end
        task.wait(2)
    end
end)()

Tabs.Main:Divider()
Tabs.Main:Section({ Title = "Auto Compress Machine" })

local itemsToCompress = {
    "Bolt",
    "Sheet Metal",
    "UFO Junk",
    "UFO Component",
    "Broken Fan",
    "Log",
    "Broken Radio",
    "Broken Microwave",
    "Tyre",
    "Metal Chair",
    "Old Car Engine",
    "Washing Machine",
    "Cultist Experiment",
    "Cultist Prototype",
    "UFO Scrap"
}

getgenv().AutoWoodCompressList = {}
getgenv().AutoWoodCompressOn = false

local woodCutterPos = Vector3.new(21.15, 19, -6.12)

Tabs.Main:Dropdown({
    Title = "Choose Items To Auto Compress",
    Values = itemsToCompress,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        getgenv().AutoWoodCompressList = {}
        for _, item in ipairs(selected) do
            getgenv().AutoWoodCompressList[item] = true
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Compress Items ",
    Default = false,
    Callback = function(state)
        getgenv().AutoWoodCompressOn = state
    end
})

local itemsFolder = Workspace:WaitForChild("Items")
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

local function moveItemToWoodCutter(item)
    local part = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")
    if not part then return end
    if not item.PrimaryPart then pcall(function() item.PrimaryPart = part end) end
    pcall(function()
        remoteEvents.RequestStartDraggingItem:FireServer(item)
        task.wait(0.05)
        item:SetPrimaryPartCFrame(CFrame.new(woodCutterPos))
        task.wait(0.05)
        remoteEvents.StopDraggingItem:FireServer(item)
    end)
end

coroutine.wrap(function()
    while true do
        if getgenv().AutoWoodCompressOn then
            for itemName, enabled in pairs(getgenv().AutoWoodCompressList) do
                if enabled then
                    for _, item in ipairs(itemsFolder:GetChildren()) do
                        if item.Name == itemName then
                            moveItemToWoodCutter(item)
                        end
                    end
                end
            end
        end
        task.wait(2)
    end
end)()

Tabs.Main:Divider()
Tabs.Main:Section({ Title = "Auto Consume" })

local ITEM_GROUPS = {
    Food = {"Carrot", "Apple", "Berry"}
}

getgenv().autoConsumeList = {}
for _, item in ipairs(ITEM_GROUPS.Food) do
    getgenv().autoConsumeList[item] = false
end

local collectToggles_AutoConsume = {}
for _, item in ipairs(ITEM_GROUPS.Food) do
    collectToggles_AutoConsume[item] = false
end

local Services = setmetatable({}, {
    __index = function(self, key)
        local suc, service = pcall(game.GetService, game, key)
        if suc and service then
            return service
        end
        return nil
    end
})

local lplr = Services.Players.LocalPlayer

local function consume(item)
    local args = {item}
    Services.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestConsumeItem"):InvokeServer(unpack(args))
end

local AUTO_CONSUME_ENABLED = false

local function setAutoConsume(state)
    AUTO_CONSUME_ENABLED = state
end

local function setCollectToggles_AutoConsume(selectedFoods)
    for food, _ in pairs(collectToggles_AutoConsume) do
        collectToggles_AutoConsume[food] = false
    end
    for _, food in ipairs(selectedFoods) do
        collectToggles_AutoConsume[food] = true
    end
end

local MAX_ITEM_DISTANCE = 20
local function findNearestFoodItem()
    local character = lplr.Character
    if not (character and character:FindFirstChild("HumanoidRootPart")) then
        return nil
    end
    local rootPart = character.HumanoidRootPart
    local closestItem, closestDistance = nil, math.huge
    for _, item in pairs(Services.Workspace:WaitForChild("Items"):GetChildren()) do
        if getgenv().autoConsumeList[item.Name] then
            local primaryPart = item:GetPrimaryPartCFrame().p
            local distance = (rootPart.Position - primaryPart).Magnitude
            if distance < closestDistance and distance <= MAX_ITEM_DISTANCE then
                closestItem = item
                closestDistance = distance
            end
        end
    end
    return closestItem
end

local function consumeInventoryFood()
    local inventory = lplr:FindFirstChild("Inventory")
    if not inventory then return end
    for foodName, _ in pairs(getgenv().autoConsumeList) do
        local item = inventory:FindFirstChild(foodName)
        if item and (item:GetAttribute("RestoreHunger") or item:GetAttribute("RestoreHealth")) and getgenv().autoConsumeList[foodName] then
            consume(item)
        end
    end
end

task.spawn(function()
    while true do
        if AUTO_CONSUME_ENABLED then
            consumeInventoryFood()
            local item = findNearestFoodItem()
            if item and (item:GetAttribute("RestoreHunger") or item:GetAttribute("RestoreHealth")) then
                consume(item)
            end
        end
        task.wait(0.3)
    end
end)

Tabs.Main:Dropdown({
    Title = "Auto Consume: Food",
    Values = ITEM_GROUPS.Food,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        getgenv().autoConsumeList = {}
        for _, food in ipairs(selected) do
            getgenv().autoConsumeList[food] = true
        end
        setCollectToggles_AutoConsume(selected)
    end
})

Tabs.Main:Toggle({
    Title = "Auto Consume",
    Default = false,
    Callback = function(state)
        setAutoConsume(state)
    end
})

local AUTO_COLLECT_ITEM_GROUPS = {
    Food = {"Carrot", "Apple", "Berry"},
    Fuel = {"Fuel Canister", "Coal", "Sapling", "Log"},
    Scrappable = {"Alpha Wolf Corpse", "Wolf Corpse"},
    Other = {"Bandage", "Revolver Ammo", "Lost Child", "Item Chest", "Rifle Ammo", "Rifle"}
}

local allAutoCollectItems = {}
local groupLookup = {}
for group, items in pairs(AUTO_COLLECT_ITEM_GROUPS) do
    for _, item in ipairs(items) do
        table.insert(allAutoCollectItems, item)
        groupLookup[item] = group

    end
end

local collectToggles_AutoCollect = {}
for _, item in ipairs(allAutoCollectItems) do
    collectToggles_AutoCollect[item] = false
end

local function getSack()
    local inv = lplr:FindFirstChild("Inventory")
    if not inv then return nil end
    return inv:FindFirstChild("Old Sack") or inv:FindFirstChild("Good Sack") or inv:FindFirstChild("Giant Sack")
end

local function storeItem(item)
    local sack = getSack()
    if not sack then return end
    local args = {sack, item}
    Services.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestBagStoreItem"):InvokeServer(unpack(args))
end

local function findNearestItem()
    local character = lplr.Character
    if not (character and character:FindFirstChild("HumanoidRootPart")) then
        return nil
    end
    local rootPart = character.HumanoidRootPart
    local closestItem, closestDistance = nil, math.huge
    for itemName, enabled in pairs(collectToggles_AutoCollect) do
        if enabled then
            for _, item in pairs(Services.Workspace:WaitForChild("Items"):GetChildren()) do
                if item.Name == itemName then
                    local primaryPart = item:GetPrimaryPartCFrame().p
                    local distance = (rootPart.Position - primaryPart).Magnitude
                    if distance < closestDistance and distance <= MAX_ITEM_DISTANCE then
                        closestItem = item
                        closestDistance = distance
                    end
                end
            end
        end
    end
    return closestItem
end

local AUTO_COLLECT_ENABLED = false
local autoCollectThread = nil

function startAutoCollect()
    if AUTO_COLLECT_ENABLED then return end
    AUTO_COLLECT_ENABLED = true
    autoCollectThread = task.spawn(function()
        while AUTO_COLLECT_ENABLED do
            local item = findNearestItem()
            if item then
                storeItem(item)
            end
            task.wait(0.3)
        end
    end)
end

function stopAutoCollect()
    AUTO_COLLECT_ENABLED = false
end

Tabs.Main:Divider()
Tabs.Main:Section({ Title = "Auto Collect" })

Tabs.Main:Dropdown({
    Title = "Auto Collect Items",
    Values = allAutoCollectItems,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        for _, item in ipairs(allAutoCollectItems) do
            collectToggles_AutoCollect[item] = table.find(selected, item) ~= nil
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Collect Items",
    Default = false,
    Callback = function(state)
        if state then
            startAutoCollect()
        else
            stopAutoCollect()
        end
    end
})

Tabs.Teleport:Button({
    Title="Teleport to Camp",
    Callback=function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(
                13.287363052368164, 3.999999761581421, 0.36212217807769775,
                0.6022269129753113, -2.275036159460342e-08, 0.7983249425888062,
                6.430457055728311e-09, 1, 2.364672191390582e-08,
                -0.7983249425888062, -9.1070981866892e-09, 0.6022269129753113
            )
        end
    end
})
Tabs.Teleport:Button({
    Title="Teleport to Trader",
    Callback=function()
        local pos = Vector3.new(-37.08, 3.98, -16.33)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end
})

Tabs.Teleport:Button({
    Title = "TP to Random Tree",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart", 3)
        if not hrp then return end
        local map = workspace:FindFirstChild("Map")
        if not map then return end
        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end
        local trees = {}
        for _, obj in ipairs(foliage:GetChildren()) do
            if obj.Name == "Small Tree" and obj:IsA("Model") then
                local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                if trunk then
                    table.insert(trees, trunk)
                end
            end
        end
        if #trees > 0 then
            local trunk = trees[math.random(1, #trees)]
            local treeCFrame = trunk.CFrame
            local rightVector = treeCFrame.RightVector
            local targetPosition = treeCFrame.Position + rightVector * 3
            hrp.CFrame = CFrame.new(targetPosition)
        end
    end
})

Tabs.Teleport:Button({
    Title = "Tp to Anvil",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local target = workspace:WaitForChild("Map")
            :WaitForChild("Landmarks")
            :WaitForChild("ToolWorkshop")
            :WaitForChild("Building")
            :GetChildren()[13]
        if target and target:FindFirstChild("Union") and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = target.Union.CFrame
        end
    end
})

Tabs.Teleport:Button({
    Title = "Tp to Stronghold",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local target = workspace:WaitForChild("Map")
            :WaitForChild("Landmarks")
            :WaitForChild("Stronghold")
            :WaitForChild("Building")
            :WaitForChild("Sign")
            :WaitForChild("ScaledModel")
        if character:FindFirstChild("HumanoidRootPart") and target then
            character.HumanoidRootPart.CFrame = target:GetPivot()
        end
    end
})

Tabs.Bring:Button({Title="Open Chests", Callback=function()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local running = true
    task.spawn(function()
        while running do
            local chests = workspace:FindFirstChild("Items")
            if chests then
                for _, chest in ipairs(chests:GetChildren()) do
                    if chest:IsA("Model") and chest.Name:match("^Item Chest%d*$") then
                        local prompt = chest:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            fireproximityprompt(prompt, 3)
                        end
                    end
                end
            end
            task.wait(2)
        end
    end)
end})

local function bringItemsByName(name)
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find(name:lower()) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
end

local BRING_OPTIONS = {
    "Bring Everything", "Auto Cook Meat", "Bring Logs", "Bring Lost Child", "Bring Revolver",
    "Bring Riffle", "Bring Rifle ammo", "Bring Revolver ammo", "Katana", "Chainsaw", "Morningstar",
    "Tactical Shotgun", "Kunai", "Riot Shield", "Spear", "Good Axe", "Strong Axe", "Leather Armor",
    "Iron Armor", "Thorn Armor", "Coin Stack", "Bandage", "Medkit", "Good Sack", "Giant Sack",
    "Car Engine", "Broken Fan", "Broken Radio", "Sheet Metal", "Tyre", "Coal", "Fuel Canister",
    "Biofuel", "Oil Barrel", "Wolf Pelt", "Alpha Wolf Pelt", "Bear Pelt", "Cultist Gem",
    "Cultist Prototype", "Cultist Experiment", "Old Flashlight", "Strong Flashlight", "Rabbit Foot"
}

local BRING_CALLBACKS = {}

BRING_CALLBACKS["Bring Everything"] = function()
    for _, item in ipairs(workspace.Items:GetChildren()) do
        local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
        if part then
            part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end

BRING_CALLBACKS["Auto Cook Meat"] = function()
    local campfirePos = Vector3.new(1.87, 4.33, -3.67)
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") or item:IsA("BasePart") then
            local name = item.Name:lower()
            if name:find("meat") then
                local part = item:FindFirstChildWhichIsA("BasePart") or item
                if part then
                    part.CFrame = CFrame.new(campfirePos + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2)))
                end
            end
        end
    end
end

BRING_CALLBACKS["Bring Logs"] = function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("log") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end

local function bringByName(name)
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") and item.Name:lower():find(name) then
            local part = item:FindFirstChildWhichIsA("BasePart")
            if part then
                part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
            end
        end
    end
end

BRING_CALLBACKS["Bring Lost Child"] = function()
    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name:lower():find("lost") and model:FindFirstChild("HumanoidRootPart") then
            model:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
        end
    end
end

local BY_NAME_LIST = {
    ["Bring Revolver"] = "revolver",
    ["Bring Riffle"] = "rifle",
    ["Bring Rifle ammo"] = "rifle ammo",
    ["Bring Revolver ammo"] = "revolver ammo",
    ["Katana"] = "katana",
    ["Chainsaw"] = "chainsaw",
    ["Morningstar"] = "morningstar",
    ["Tactical Shotgun"] = "tactical shotgun",
    ["Kunai"] = "kunai",
    ["Riot Shield"] = "riot shield",
    ["Spear"] = "spear",
    ["Good Axe"] = "good axe",
    ["Strong Axe"] = "strong axe",
    ["Leather Armor"] = "leather armor",
    ["Iron Armor"] = "iron armor",
    ["Thorn Armor"] = "thorn armor",
    ["Coin Stack"] = "coin stack",
    ["Bandage"] = "bandage",
    ["Medkit"] = "medkit",
    ["Good Sack"] = "good sack",
    ["Giant Sack"] = "giant sack",
    ["Car Engine"] = "car engine",
    ["Broken Fan"] = "broken fan",
    ["Broken Radio"] = "broken radio",
    ["Sheet Metal"] = "sheet metal",
    ["Tyre"] = "tyre",
    ["Coal"] = "coal",
    ["Fuel Canister"] = "fuel canister",
    ["Biofuel"] = "biofuel",
    ["Oil Barrel"] = "oil barrel",
    ["Wolf Pelt"] = "wolf pelt",
    ["Alpha Wolf Pelt"] = "alpha wolf pelt",
    ["Bear Pelt"] = "bear pelt",
    ["Cultist Gem"] = "cultist gem",
    ["Cultist Prototype"] = "cultist prototype",
    ["Cultist Experiment"] = "cultist experiment",
    ["Old Flashlight"] = "old flashlight",
    ["Strong Flashlight"] = "strong flashlight",
    ["Rabbit Foot"] = "rabbit foot",
}

for option, name in pairs(BY_NAME_LIST) do
    BRING_CALLBACKS[option] = function()
        bringByName(name)
    end
end

local selectedBring = BRING_OPTIONS[1]

Tabs.Bring:Dropdown({
    Title = "Select Item to Bring",
    Values = BRING_OPTIONS,
    Value = BRING_OPTIONS[1],
    Multi = false,
    AllowNone = false,
    Callback = function(choice)
        selectedBring = choice
    end
})

Tabs.Bring:Button({
    Title = "Bring Selected Item(s)",
    Callback = function()
        local cb = BRING_CALLBACKS[selectedBring]
        if cb then
            cb()
        end
    end
})

local hitboxSettings = {Wolf=false, Bunny=false, Cultist=false, Show=false, Size=10}

local function updateHitboxForModel(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local name = model.Name:lower()
    local shouldResize =
        (hitboxSettings.Wolf and (name:find("wolf") or name:find("alpha"))) or
        (hitboxSettings.Bunny and name:find("bunny")) or
        (hitboxSettings.Cultist and (name:find("cultist") or name:find("cross")))
    if shouldResize then
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
    end
end

task.spawn(function()
    while true do
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                updateHitboxForModel(model)
            end
        end
        task.wait(2)
    end
end)

Tabs.Hitbox:Toggle({Title="Expand Wolf Hitbox", Default=false, Callback=function(val) hitboxSettings.Wolf=val end})
Tabs.Hitbox:Toggle({Title="Expand Bunny Hitbox", Default=false, Callback=function(val) hitboxSettings.Bunny=val end})
Tabs.Hitbox:Toggle({Title="Expand Cultist Hitbox", Default=false, Callback=function(val) hitboxSettings.Cultist=val end})
Tabs.Hitbox:Slider({Title="Hitbox Size", Value={Min=2, Max=30, Default=10}, Step=1, Callback=function(val) hitboxSettings.Size=val end})
Tabs.Hitbox:Toggle({Title="Show Hitbox (Transparency)", Default=false, Callback=function(val) hitboxSettings.Show=val end})

local autoDaysActive = false
local autoDaysThread

Tabs.AutoDays:Toggle({
    Title = "Activate Auto Days",
    Default = false,
    Callback = function(state)
        autoDaysActive = state
        if state then
            autoDaysThread = task.spawn(function()
                local Players = game:GetService("Players")
                local Workspace = game:GetService("Workspace")
                local VirtualInputManager = game:GetService("VirtualInputManager")
                local camera = Workspace.CurrentCamera
                local player = Players.LocalPlayer
                local center = Vector3.new(0.25, 7.82, -0.65)
                local platformPosition = Vector3.new(-1.88, -40.59, 3.62)
                local maxRadius = 1500
                local radiusStep = 50
                local angleStep = 10
                local delay = 0.05
                local carrotIterations = 15
                local function ensurePlatform()
                    if not Workspace:FindFirstChild("SafePlatform") then
                        local platform = Instance.new("Part")
                        platform.Size = Vector3.new(10, 1, 10)
                        platform.Position = platformPosition - Vector3.new(0, 0.5, 0)
                        platform.Anchored = true
                        platform.Name = "SafePlatform"
                        platform.Parent = Workspace
                    end
                end
                local function lookAt(target)
                    camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
                end
                local function circleMovement(duration)
                    local char = player.Character or player.CharacterAdded:Wait()
                    local root = char:WaitForChild("HumanoidRootPart")
                    local startTime = tick()
                    while tick() - startTime < duration and autoDaysActive do
                        for radius = 0, maxRadius, radiusStep do
                            for angleDeg = 0, 360, angleStep do
                                if not autoDaysActive then return end
                                local angleRad = math.rad(angleDeg)
                                local x = center.X + radius * math.cos(angleRad)
                                local z = center.Z + radius * math.sin(angleRad)
                                root.CFrame = CFrame.new(x, center.Y, z)
                                task.wait(delay)
                                if tick() - startTime >= duration then return end
                            end
                        end
                    end
                end
                local function collectCarrots(times)
                    local char = player.Character or player.CharacterAdded:Wait()
                    local root = char:WaitForChild("HumanoidRootPart")
                    for i = 1, times do
                        if not autoDaysActive then return end
                        local items = {}
                        local carrot = Workspace:FindFirstChild("Items") and Workspace.Items:FindFirstChild("Carrot")
                        local patch = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Foliage") and Workspace.Map.Foliage:FindFirstChild("Carrot Patch")
                        local berry = Workspace:FindFirstChild("Items") and Workspace.Items:FindFirstChild("Berry")
                        if carrot then table.insert(items, carrot) end
                        if patch then table.insert(items, patch) end
                        if berry then table.insert(items, berry) end
                        for _, target in ipairs(items) do
                            if not autoDaysActive then return end
                            local part = target:IsA("Model") and target.PrimaryPart or target
                            if part then
                                local direction = (part.Position - root.Position).Unit
                                local offsetPos = part.Position - direction * 2
                                root.CFrame = CFrame.new(offsetPos + Vector3.new(0, 2, 0))
                                lookAt(part)
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                task.wait(0.1)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                break
                            end
                        end
                        task.wait(0.2)
                    end
                end
                ensurePlatform()
                circleMovement(80)
                if not autoDaysActive then return end
                local char = player.Character or player.CharacterAdded:Wait()
                local root = char:WaitForChild("HumanoidRootPart")
                root.CFrame = CFrame.new(platformPosition)
                task.wait(60)
                while autoDaysActive do
                    collectCarrots(carrotIterations)
                    if not autoDaysActive then break end
                    root.CFrame = CFrame.new(platformPosition)
                    task.wait(60)
                end
            end)
        else
            autoDaysActive = false
            local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(traderPos)
            end
        end
    end
})

Tabs.AutoDays:Divider()
Tabs.AutoDays:Section({ Title = "Auto Cook Food" })

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local itemsFolder = Workspace:WaitForChild("Items")
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

local campfireDropPos = Vector3.new(0, 19, 0)
local autoCookItems = { "Morsel", "Steak" }

getgenv().AutoDaysAutoCookEnabled = false

Tabs.AutoDays:Toggle({
    Title = "Auto Cook Food",
    Default = false,
    Callback = function(state)
        getgenv().AutoDaysAutoCookEnabled = state
    end
})

task.spawn(function()
    while true do
        if getgenv().AutoDaysAutoCookEnabled then
            for _, itemName in ipairs(autoCookItems) do
                for _, item in ipairs(itemsFolder:GetChildren()) do
                    if item.Name == itemName then
                        local part = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")
                        if not part then break end
                        if not item.PrimaryPart then
                            pcall(function() item.PrimaryPart = part end)
                        end
                        pcall(function()
                            remoteEvents.RequestStartDraggingItem:FireServer(item)
                            task.wait(0.05)
                            item:SetPrimaryPartCFrame(CFrame.new(campfireDropPos))
                            task.wait(0.05)
                            remoteEvents.StopDraggingItem:FireServer(item)
                        end)
                    end
                end
            end
        end
        task.wait(2.5)
    end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

getgenv().KillAuraActive = false
getgenv().KillAuraRadius = 100

local toolsDamageIDs = {
    ["Old Axe"] = "1_8982038982",
    ["Good Axe"] = "112_8982038982",
    ["Strong Axe"] = "116_8982038982",
    ["Chainsaw"] = "647_8992824875",
    ["Spear"] = "196_8999010016"
}

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local ToolDamageObject = RemoteEvents:WaitForChild("ToolDamageObject")
local EquipItemHandle = RemoteEvents:WaitForChild("EquipItemHandle")
local UnequipItemHandle = RemoteEvents:WaitForChild("UnequipItemHandle")

local function getAnyToolWithDamageID()
    local inventory = LocalPlayer:FindFirstChild("Inventory")
    if not inventory then return nil, nil end
    for toolName, damageID in pairs(toolsDamageIDs) do
        local tool = inventory:FindFirstChild(toolName)
        if tool then
            return tool, damageID
        end
    end
    return nil, nil
end

local function equipTool(tool)
    if tool then
        EquipItemHandle:FireServer("FireAllClients", tool)
    end
end

Tabs.KillAll:Toggle({
    Title = "Kill Aura",
    Default = false,
    Callback = function(state)
        getgenv().KillAuraActive = state
    end
})

Tabs.KillAll:Slider({
    Title = "Kill Aura Radius",
    Step = 1,
    Value = {Min = 10, Max = 150, Default = 100},
    Callback = function(val)
        getgenv().KillAuraRadius = tonumber(val)
    end
})

task.spawn(function()
    while true do
        if getgenv().KillAuraActive then
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local tool, damageID = getAnyToolWithDamageID()
                if tool and damageID then
                    equipTool(tool)
                    for _, mob in ipairs(Workspace:WaitForChild("Characters"):GetChildren()) do
                        if mob:IsA("Model") then
                            local part = mob:FindFirstChildWhichIsA("BasePart")
                            if part and (part.Position - hrp.Position).Magnitude <= tonumber(getgenv().KillAuraRadius) then
                                pcall(function()
                                    ToolDamageObject:InvokeServer(
                                        mob,
                                        tool,
                                        damageID,
                                        CFrame.new(part.Position)
                                    )
                                end)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

getgenv().speedEnabled = false
getgenv().speedValue = 28
Tabs.Misc:Toggle({
    Title = "Speed Hack",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})
Tabs.Misc:Slider({
    Title = "Speed Value",
    Value = {Min = 16, Max = 600, Default = 28},
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

local fullbrightActive = false
local fullbrightThread

Tabs.Misc:Toggle({
    Title = "Fullbright",
    Default = false,
    Callback = function(state)
        fullbrightActive = state
        if state then
            fullbrightThread = task.spawn(function()
                local Lighting = game:GetService("Lighting")
                while fullbrightActive do
                    Lighting.Ambient = Color3.new(1, 1, 1)
                    Lighting.Brightness = 5
                    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                    Lighting.ClockTime = 12
                    task.wait(10)
                end
            end)
        else
            fullbrightActive = false
        end
    end
})

local Noclip_Mingle = false

Tabs.Misc:Toggle({
    Title = "Noclip",
    Default = false,
    Callback = function(state)
        Noclip_Mingle = state
        local LocalPlayer = game:GetService("Players").LocalPlayer
        if not state and LocalPlayer and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if Noclip_Mingle then
        local LocalPlayer = game:GetService("Players").LocalPlayer
        if LocalPlayer and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 10), Color3.fromRGB(0,255,0), false, true, showFPS
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 30), Color3.fromRGB(0,255,0), false, true, showPing
local fpsCounter, fpsLastUpdate = 0, tick()

RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end
        if showPing then
            local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            msText.Text = "Ping: " .. ping .. " ms"
            if ping <= 60 then
                msText.Color = Color3.fromRGB(0, 255, 0)
            elseif ping <= 120 then
                msText.Color = Color3.fromRGB(255, 165, 0)
            else
                msText.Color = Color3.fromRGB(255, 0, 0)
            end
            msText.Visible = true
        else
            msText.Visible = false
        end
        fpsCounter = 0
        fpsLastUpdate = tick()
    end
end)
Tabs.Misc:Toggle({Title="Show FPS", Default=true, Callback=function(val) showFPS=val; fpsText.Visible=val end})
Tabs.Misc:Toggle({Title="Show Ping (ms)", Default=true, Callback=function(val) showPing=val; msText.Visible=val end})

Tabs.Misc:Button({
    Title = "FPS Boost",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 0
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        print("РІСљвЂ¦ FPS Boost Applied")
    end
})

local function createESPLabel(parent)
    if parent:FindFirstChild("ESP_Label") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Label"
    billboard.Adornee = parent
    billboard.Size = UDim2.new(0, 50, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = parent

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = parent.Name
    textLabel.TextColor3 = Color3.fromRGB(25, 25, 112)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboard
end

local function createESPHighlight(item)
    if item:FindFirstChild("Highlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight"
    highlight.Parent = item
    highlight.Adornee = item
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    if item.Name == "Bandage" then
        highlight.FillColor = Color3.fromRGB(0, 0, 0)
    elseif item.Name == "Log" then
        highlight.FillColor = Color3.fromRGB(139, 69, 19)
    elseif item.Name == "Coal" then
        highlight.FillColor = Color3.fromRGB(50, 50, 50)
    elseif item.Name == "Fuel Canister" then
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
    elseif item.Name == "Revolver Ammo" then
        highlight.FillColor = Color3.fromRGB(255, 215, 0)
    end
end

local function removeESP(item)
    if item:FindFirstChild("Highlight") then
        item.Highlight:Destroy()
    end
    if item:FindFirstChild("ESP_Label") then
        item.ESP_Label:Destroy()
    end
end

local function ESPisFood(item)
    return item:GetAttribute("RestoreHunger")
end
local function ESPisScrappable(item)
    return item:GetAttribute("Scrappable")
end
local function ESPisFuel(item)
    return item:GetAttribute("BurnFuel")
end

local ESP_ITEMS = {
    Health = {"Bandage"},
    Fuel = {"Fuel Canister", "Coal", "Sapling", "Log"},
    Food = {"Carrot", "Apple", "Berry"},
    Scrappable = {"Alpha Wolf Corpse", "Wolf Corpse"},
    Other = {
        "Revolver Ammo", "Lost Child", "Lost Child2", "Lost Child3", "Item Chest", "Rifle Ammo",
        "Rifle", "Ammo", "Revolver", "Leather Body", "Iron Body"
    }
}

local function toggleCategoryESP(category, enabled, customCheck)
    local items = ESP_ITEMS[category]
    local Workspace = game:GetService("Workspace")
    if enabled then
        for _, item in pairs(Workspace.Items:GetChildren()) do
            if (table.find(items, item.Name) or (customCheck and customCheck(item))) then
                createESPHighlight(item)
                createESPLabel(item)
            end
        end
        for _, item in pairs(Workspace.Characters:GetChildren()) do
            if (table.find(items, item.Name) or (customCheck and customCheck(item))) then
                createESPHighlight(item)
                createESPLabel(item)
            end
        end
        if not _G["esp_"..category.."Added"] then
            _G["esp_"..category.."Added"] = Workspace.Items.ChildAdded:Connect(function(item)
                if (table.find(items, item.Name) or (customCheck and customCheck(item))) then
                    createESPHighlight(item)
                    createESPLabel(item)
                end
            end)
        end
        if not _G["esp_"..category.."CharAdded"] then
            _G["esp_"..category.."CharAdded"] = Workspace.Characters.ChildAdded:Connect(function(item)
                if (table.find(items, item.Name) or (customCheck and customCheck(item))) then
                    createESPHighlight(item)
                    createESPLabel(item)
                end
            end)
        end
    else
        for _, item in pairs(Workspace.Items:GetChildren()) do
            if (table.find(items, item.Name) or (customCheck and customCheck(item))) then
                removeESP(item)
            end
        end
        for _, item in pairs(Workspace.Characters:GetChildren()) do
            if (table.find(items, item.Name) or (customCheck and customCheck(item))) then
                removeESP(item)
            end
        end
        if _G["esp_"..category.."Added"] then
            _G["esp_"..category.."Added"]:Disconnect()
            _G["esp_"..category.."Added"] = nil
        end
        if _G["esp_"..category.."CharAdded"] then
            _G["esp_"..category.."CharAdded"]:Disconnect()
            _G["esp_"..category.."CharAdded"] = nil
        end
    end
end

Tabs.Esp:Toggle({
    Title = "Health ESP",
    Default = false,
    Callback = function(state)
        toggleCategoryESP("Health", state)
    end
})
Tabs.Esp:Toggle({
    Title = "Fuel ESP",
    Default = false,
    Callback = function(state)
        toggleCategoryESP("Fuel", state, ESPisFuel)
    end
})
Tabs.Esp:Toggle({
    Title = "Food ESP",
    Default = false,
    Callback = function(state)
        toggleCategoryESP("Food", state, ESPisFood)
    end
})
Tabs.Esp:Toggle({
    Title = "Scrappable ESP",
    Default = false,
    Callback = function(state)
        toggleCategoryESP("Scrappable", state, ESPisScrappable)
    end
})
Tabs.Esp:Toggle({
    Title = "Other ESP",
    Default = false,
    Callback = function(state)
        toggleCategoryESP("Other", state)
    end
})

Tabs.Credits:Divider()

Tabs.Credits:Button({
    Title = "JOIN DISCORD SERVER RINGTA",
    Description = "Click To Copy The Discord Server Link For RINGTA",
    Callback = function()
        setclipboard("discord.gg/ringta")
        WindUI:Notify({
            Title = "Copied!",
            Content = "Discord invite copied to clipboard.",
            Duration = 3,
        })
    end,
})

Tabs.Credits:Button({
    Title = "JOIN DISCORD SERVER BUBLIK6241",
    Description = "Click To Copy The Discord Server Link For BUBLIK6241",
    Callback = function()
        setclipboard("https://discord.gg/GMaZPHpn6g")
        WindUI:Notify({
            Title = "Copied!",
            Content = "Discord invite copied to clipboard.",
            Duration = 3,
        })
    end,
})

Tabs.Credits:Divider()

Tabs.Credits:Paragraph({
    Title = "PLEASE JOIN BOTH DISCORD SERVER",
    Desc = "JOIN BOTH RINGTA AND BUBLIK6241 DISCORD SERVERS. THEY DO HUGE EVENTS AND YOU GET EARLY ACCESS TO SCRIPTS & COMMUNITY. IT WILL HELP US BOTH AS THE KEY IS KEYLESS AND WE GET TO HEAR SUGGESTIONS AND REPORTS ABOUT SCRIPTS AND THEY ALSO MADE THIS SCRIPT",
    Color = "Green",
    Locked = false,
})
