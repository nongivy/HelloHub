-- ══════════════════════════════════════════════════════════════
-- Anime Astral Simulator — Auto Farm All-in-One
-- Author: BluezyGPT for BZMEMBER
-- Features: Auto Farm Mob, Game Mode, Loadout, Shop,
--           Map Upgrade, Pet Upgrade, Webhook, Anti AFK, Log
-- ══════════════════════════════════════════════════════════════

-- ── Services ──
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ── Configuration ──
local Config = {
    AutoFarm = true,
    AutoGameMode = true,
    AutoLoadout = true,
    AutoShop = true,
    AutoMapUpgrade = true,
    AutoPetUpgrade = true,
    AntiAFK = true,
    FarmRange = 50,
    WebhookURL = "",  -- ใส่ Discord Webhook URL ของมึงตรงนี้
    LogKills = true,
    LogCoins = true,
    LogUpgrades = true,
    -- Shop settings
    BuySword = true,
    BuyPet = true,
    BuyEgg = true,
    -- Map Upgrade settings
    UpgradeDamage = true,
    UpgradeSpeed = true,
    UpgradeLuck = true,
    -- Pet Upgrade settings
    UpgradePetLevel = true,
    UpgradePetSkill = true,
}

-- ── Variables ──
local Stats = {
    Kills = 0,
    CoinsEarned = 0,
    UpgradesBought = 0,
    SessionStart = tick(),
}

local IsScriptRunning = true
local CurrentTarget = nil
local LastAFKMove = 0

-- ── Utility Functions ──
local function Log(Message)
    local Time = os.date("[%H:%M:%S]")
    print(Time .. " " .. Message)
    if Config.LogKills or Config.LogCoins or Config.LogUpgrades then
        -- Store for webhook
        if _LogHistory == nil then _LogHistory = {} end
        table.insert(_LogHistory, Time .. " " .. Message)
        if #_LogHistory > 50 then table.remove(_LogHistory, 1) end
    end
end

local function SendWebhook(Message)
    if Config.WebhookURL == "" then return end
    local Success, Err = pcall(function()
        local Body = HttpService:JSONEncode({
            username = "BluezyGPT — Anime Astral Bot",
            avatar_url = "https://bluezygpt.space/icon.png",
            embeds = {{
                title = "🌟 Anime Astral Simulator — Auto Farm Log",
                color = 5814783,
                fields = {{
                    name = "📝 Log",
                    value = Message,
                    inline = false,
                }, {
                    name = "📊 Stats",
                    value = "Kills: " .. Stats.Kills .. "\nCoins: " .. Stats.CoinsEarned .. "\nUpgrades: " .. Stats.UpgradesBought .. "\nSession: " .. math.floor(tick() - Stats.SessionStart) .. "s",
                    inline = false,
                }},
                footer = { text = "BluezyGPT for BZMEMBER | absolute bluezygpt" },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            }}
        })
        request({
            Url = Config.WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = Body,
        })
    end)
    if not Success then
        Log("⚠ Webhook failed: " .. tostring(Err))
    end
end

local function GetNearestMob()
    local Nearest = nil
    local NearestDist = Config.FarmRange
    for _, Obj in ipairs(workspace:GetDescendants()) do
        if Obj:IsA("Model") then
            local humanoid = Obj:FindFirstChildOfClass("Humanoid")
            local root = Obj:FindFirstChild("HumanoidRootPart")
            if humanoid and root and humanoid.Health > 0 then
                -- Check if it's an enemy (not player)
                local IsEnemy = true
                for _, Tag in ipairs(humanoid:GetTags()) do
                    if string.find(Tag, "Player") then
                        IsEnemy = false
                        break
                    end
                end
                if IsEnemy then
                    local Dist = (HumanoidRootPart.Position - root.Position).Magnitude
                    if Dist < NearestDist then
                        Nearest = Obj
                        NearestDist = Dist
                    end
                end
            end
        end
    end
    return Nearest, NearestDist
end

local function MoveTo(Position)
    pcall(function()
        Humanoid:MoveTo(Position)
    end)
end

local function ClickButton(ButtonName, ButtonParent)
    pcall(function()
        local Button
        if ButtonParent then
            Button = ButtonParent:FindFirstChild(ButtonName) or ButtonParent:FindFirstChildWhichIsA("TextButton")
        else
            -- Try common UI locations
            for _, ScreenGui in ipairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
                Button = ScreenGui:FindFirstChild(ButtonName, true)
                if Button and Button:IsA("TextButton") or Button:IsA("ImageButton") then
                    break
                end
            end
        end
        if Button then
            fireclickdetector(Button)
            return true
        end
        return false
    end)
    return false
end

-- ── Auto Farm Mob ──
local function AutoFarmMob()
    if not Config.AutoFarm then return end
    local Target, Dist = GetNearestMob()
    if Target then
        CurrentTarget = Target
        local Root = Target:FindFirstChild("HumanoidRootPart")
        if Root then
            -- Move towards mob
            local TargetPos = Root.Position
            if Dist > 5 then
                MoveTo(TargetPos)
            else
                -- Attack
                HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, TargetPos)
                -- Simulate click/attack
                local Args = { Target, Root.Position }
                pcall(function()
                    ReplicatedStorage:FindFirstChild("Attack") or ReplicatedStorage:FindFirstChild("Hit")
                    -- Common attack patterns
                    local AttackEvent = ReplicatedStorage:FindFirstChild("Attack")
                    if AttackEvent then
                        AttackEvent:FireServer(unpack(Args))
                    end
                end)
                -- Alternative: click-based attack
                UserInputService:MouseClick()
            end
        end
    else
        CurrentTarget = nil
        -- Wander to find mobs
        if tick() - LastAFKMove > 2 then
            MoveTo(HumanoidRootPart.Position + Vector3.new(
                math.random(-30, 30),
                0,
                math.random(-30, 30)
            ))
            LastAFKMove = tick()
        end
    end
end

-- ── Anti AFK ──
local function AntiAFK()
    if not Config.AntiAFK then return end
    pcall(function()
        -- Move camera slightly
        local Camera = workspace.CurrentCamera
        local CurrentCFrame = Camera.CFrame
        Camera.CFrame = CFrame.new(
            Camera.CFrame.Position,
            Camera.CFrame.Position + Camera.CFrame.LookVector * 0.1
        )
        task.wait(0.1)
        Camera.CFrame = CurrentCFrame

        -- Small character movement
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0.01, 0)
        task.wait(0.1)
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -0.01, 0)
    end)
end

-- ── Auto Game Mode ──
local function AutoGameMode()
    if not Config.AutoGameMode then return end
    pcall(function()
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        -- Try to find game mode buttons
        for _, ScreenGui in ipairs(PlayerGui:GetChildren()) do
            local GameModeFrame = ScreenGui:FindFirstChild("GameMode", true) or
                                  ScreenGui:FindFirstChild("ModeSelect", true) or
                                  ScreenGui:FindFirstChild("MapSelect", true)
            if GameModeFrame then
                for _, Btn in ipairs(GameModeFrame:GetDescendants()) do
                    if Btn:IsA("TextButton") or Btn:IsA("ImageButton") then
                        if Btn.Visible and Btn.Active then
                            fireclickdetector(Btn)
                            Log("🎮 Auto Game Mode: Clicked " .. Btn.Name)
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end)
end

-- ── Auto Loadout ──
local function AutoLoadout()
    if not Config.AutoLoadout then return end
    pcall(function()
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        for _, ScreenGui in ipairs(PlayerGui:GetChildren()) do
            local LoadoutFrame = ScreenGui:FindFirstChild("Loadout", true) or
                                 ScreenGui:FindFirstChild("Equipment", true) or
                                 ScreenGui:FindFirstChild("Inventory", true)
            if LoadoutFrame then
                for _, Item in ipairs(LoadoutFrame:GetDescendants()) do
                    if Item:IsA("TextButton") or Item:IsA("ImageButton") then
                        if Item.Visible and Item.Active then
                            fireclickdetector(Item)
                            Log("⚔️ Auto Loadout: Equipped " .. Item.Name)
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
    end)
end

-- ── Auto Shop ──
local function AutoShop()
    if not Config.AutoShop then return end
    pcall(function()
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local ShopOpen = false

        -- Find and open shop
        for _, ScreenGui in ipairs(PlayerGui:GetChildren()) do
            local ShopBtn = ScreenGui:FindFirstChild("Shop", true) or
                           ScreenGui:FindFirstChild("Store", true)
            if ShopBtn and (ShopBtn:IsA("TextButton") or ShopBtn:IsA("ImageButton")) then
                fireclickdetector(ShopBtn)
                ShopOpen = true
                task.wait(0.5)
                break
            end
        end

        if ShopOpen then
            -- Buy items
            local ShopFrame = PlayerGui:FindFirstChildWhichIsA("ScreenGui")
            if ShopFrame then
                if Config.BuySword then
                    local SwordBtn = ShopFrame:FindFirstChild("BuySword", true) or
                                    ShopFrame:FindFirstChild("Sword", true)
                    if SwordBtn then fireclickdetector(SwordBtn) Log("🛒 Bought Sword") end
                end
                if Config.BuyPet then
                    local PetBtn = ShopFrame:FindFirstChild("BuyPet", true) or
                                  ShopFrame:FindFirstChild("Pet", true)
                    if PetBtn then fireclickdetector(PetBtn) Log("🛒 Bought Pet") end
                end
                if Config.BuyEgg then
                    local EggBtn = ShopFrame:FindFirstChild("BuyEgg", true) or
                                  ShopFrame:FindFirstChild("Egg", true)
                    if EggBtn then fireclickdetector(EggBtn) Log("🛒 Bought Egg") end
                end
            end
        end
    end)
end

-- ── Auto Map Upgrade ──
local function AutoMapUpgrade()
    if not Config.AutoMapUpgrade then return end
    pcall(function()
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        for _, ScreenGui in ipairs(PlayerGui:GetChildren()) do
            local UpgradeFrame = ScreenGui:FindFirstChild("Upgrade", true) or
                                ScreenGui:FindFirstChild("MapUpgrade", true) or
                                ScreenGui:FindFirstChild("Upgrades", true)
            if UpgradeFrame then
                for _, Upgrade in ipairs(UpgradeFrame:GetDescendants()) do
                    if Upgrade:IsA("TextButton") or Upgrade:IsA("ImageButton") then
                        if Upgrade.Visible and Upgrade.Active then
                            local Name = Upgrade.Name:lower()
                            if Config.UpgradeDamage and string.find(Name, "damage") then
                                fireclickdetector(Upgrade)
                                Log("⬆️ Map Upgrade: Damage")
                                Stats.UpgradesBought = Stats.UpgradesBought + 1
                            elseif Config.UpgradeSpeed and string.find(Name, "speed") then
                                fireclickdetector(Upgrade)
                                Log("⬆️ Map Upgrade: Speed")
                                Stats.UpgradesBought = Stats.UpgradesBought + 1
                            elseif Config.UpgradeLuck and string.find(Name, "luck") then
                                fireclickdetector(Upgrade)
                                Log("⬆️ Map Upgrade: Luck")
                                Stats.UpgradesBought = Stats.UpgradesBought + 1
                            end
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
    end)
end

-- ── Auto Pet Upgrade ──
local function AutoPetUpgrade()
    if not Config.AutoPetUpgrade then return end
    pcall(function()
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        for _, ScreenGui in ipairs(PlayerGui:GetChildren()) do
            local PetFrame = ScreenGui:FindFirstChild("Pet", true) or
                            ScreenGui:FindFirstChild("Pets", true) or
                            ScreenGui:FindFirstChild("PetUpgrade", true)
            if PetFrame then
                for _, PetBtn in ipairs(PetFrame:GetDescendants()) do
                    if PetBtn:IsA("TextButton") or PetBtn:IsA("ImageButton") then
                        if PetBtn.Visible and PetBtn.Active then
                            local Name = PetBtn.Name:lower()
                            if Config.UpgradePetLevel and string.find(Name, "level") then
                                fireclickdetector(PetBtn)
                                Log("🐾 Pet Upgrade: Level")
                            elseif Config.UpgradePetSkill and string.find(Name, "skill") then
                                fireclickdetector(PetBtn)
                                Log("🐾 Pet Upgrade: Skill")
                            end
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
    end)
end

-- ── Kill Tracker (Leaderstats) ──
local function SetupLeaderstats()
    pcall(function()
        local Leaderstats = Instance.new("Folder")
        Leaderstats.Name = "leaderstats"
        Leaderstats.Parent = LocalPlayer

        local Kills = Instance.new("IntValue")
        Kills.Name = "Kills"
        Kills.Value = 0
        Kills.Parent = Leaderstats

        local Coins = Instance.new("IntValue")
        Coins.Name = "Coins"
        Coins.Value = 0
        Coins.Parent = Leaderstats

        -- Track kills by monitoring humanoid deaths near player
        workspace.DescendantAdded:Connect(function(Obj)
            if Obj:IsA("Humanoid") then
                Obj.Died:Connect(function()
                    local Root = Obj.Parent:FindFirstChild("HumanoidRootPart")
                    if Root and (HumanoidRootPart.Position - Root.Position).Magnitude < Config.FarmRange then
                        Stats.Kills = Stats.Kills + 1
                        Kills.Value = Stats.Kills
                        Log("💀 Kill! Total: " .. Stats.Kills)
                        if Config.LogKills and Stats.Kills % 10 == 0 then
                            SendWebhook("💀 Killed 10 mobs! Total: " .. Stats.Kills)
                        end
                    end
                end)
            end
        end)
    end)
end

-- ── UI Library (Built-in) ──
local function CreateUI()
    pcall(function()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "BluezyGPT_UI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

        -- Main Frame
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 320, 0, 480)
        MainFrame.Position = UDim2.new(0, 20, 0, 20)
        MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui

        -- Corner
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = MainFrame

        -- Title
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.Position = UDim2.new(0, 0, 0, 0)
        Title.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
        Title.BorderSizePixel = 0
        Title.Text = "🌟 BluezyGPT — Anime Astral"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 16
        Title.Font = Enum.Font.GothamBold
        Title.Parent = MainFrame
        local TitleCorner = Instance.new("UICorner")
        TitleCorner.CornerRadius = UDim.new(0, 12)
        TitleCorner.Parent = Title

        -- Scroll Frame
        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, -10, 1, -50)
        Scroll.Position = UDim2.new(0, 5, 0, 45)
        Scroll.BackgroundTransparency = 1
        Scroll.ScrollBarThickness = 4
        Scroll.Parent = MainFrame

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 4)
        Layout.Parent = Scroll

        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 8)
        Padding.PaddingRight = UDim.new(0, 8)
        Padding.PaddingTop = UDim.new(0, 4)
        Padding.PaddingBottom = UDim.new(0, 4)
        Padding.Parent = Scroll

        -- Toggle Button Helper
        local function CreateToggle(Name, Default, Callback)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 30)
            Container.BackgroundTransparency = 1
            Container.Parent = Scroll

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.Position = UDim2.new(0, 0, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Name
            Label.TextColor3 = Color3.fromRGB(200, 200, 220)
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Container

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(0, 50, 0, 24)
            ToggleBtn.Position = UDim2.new(1, -55, 0.5, -12)
            ToggleBtn.BackgroundColor3 = Default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
            ToggleBtn.Text = Default and "ON" or "OFF"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleBtn.TextSize = 11
            ToggleBtn.Font = Enum.Font.GothamBold
            ToggleBtn.Parent = Container
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = ToggleBtn

            ToggleBtn.MouseButton1Click:Connect(function()
                Default = not Default
                ToggleBtn.BackgroundColor3 = Default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
                ToggleBtn.Text = Default and "ON" or "OFF"
                if Callback then Callback(Default) end
            end)
        end

        -- Create Toggles
        CreateToggle("🗡️ Auto Farm Mob", Config.AutoFarm, function(v) Config.AutoFarm = v end)
        CreateToggle("🎮 Auto Game Mode", Config.AutoGameMode, function(v) Config.AutoGameMode = v end)
        CreateToggle("⚔️ Auto Loadout", Config.AutoLoadout, function(v) Config.AutoLoadout = v end)
        CreateToggle("🛒 Auto Shop", Config.AutoShop, function(v) Config.AutoShop = v end)
        CreateToggle("⬆️ Auto Map Upgrade", Config.AutoMapUpgrade, function(v) Config.AutoMapUpgrade = v end)
        CreateToggle("🐾 Auto Pet Upgrade", Config.AutoPetUpgrade, function(v) Config.AutoPetUpgrade = v end)
        CreateToggle("🤖 Anti AFK", Config.AntiAFK, function(v) Config.AntiAFK = v end)

        -- Webhook Input
        local WebhookContainer = Instance.new("Frame")
        WebhookContainer.Size = UDim2.new(1, 0, 0, 50)
        WebhookContainer.BackgroundTransparency = 1
        WebhookContainer.Parent = Scroll

        local WebhookLabel = Instance.new("TextLabel")
        WebhookLabel.Size = UDim2.new(1, 0, 0, 15)
        WebhookLabel.BackgroundTransparency = 1
        WebhookLabel.Text = "🪝 Discord Webhook URL:"
        WebhookLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        WebhookLabel.TextSize = 11
        WebhookLabel.Font = Enum.Font.Gotham
        WebhookLabel.TextXAlignment = Enum.TextXAlignment.Left
        WebhookLabel.Parent = WebhookContainer

        local WebhookBox = Instance.new("TextBox")
        WebhookBox.Size = UDim2.new(1, 0, 0, 25)
        WebhookBox.Position = UDim2.new(0, 0, 0, 18)
        WebhookBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        WebhookBox.PlaceholderText = "Paste webhook URL here..."
        WebhookBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
        WebhookBox.Text = ""
        WebhookBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        WebhookBox.TextSize = 10
        WebhookBox.Font = Enum.Font.Gotham
        WebhookBox.ClearTextOnFocus = false
        WebhookBox.Parent = WebhookContainer
        local WebhookCorner = Instance.new("UICorner")
        WebhookCorner.CornerRadius = UDim.new(0, 6)
        WebhookCorner.Parent = WebhookBox

        WebhookBox.FocusLost:Connect(function(EnterPressed)
            if EnterPressed then
                Config.WebhookURL = WebhookBox.Text
                Log("🪝 Webhook URL set!")
                SendWebhook("✅ Script started! Webhook connected.")
            end
        end)

        -- Stats Label
        local StatsLabel = Instance.new("TextLabel")
        StatsLabel.Size = UDim2.new(1, 0, 0, 60)
        StatsLabel.BackgroundTransparency = 1
        StatsLabel.Text = "📊 Stats\nKills: 0\nCoins: 0\nUpgrades: 0"
        StatsLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
        StatsLabel.TextSize = 11
        StatsLabel.Font = Enum.Font.Gotham
        StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
        StatsLabel.TextYAlignment = Enum.TextYAlignment.Top
        StatsLabel.Parent = Scroll

        -- Update stats display
        task.spawn(function()
            while IsScriptRunning do
                StatsLabel.Text = "📊 Stats\nKills: " .. Stats.Kills ..
                                  "\nCoins: " .. Stats.CoinsEarned ..
                                  "\nUpgrades: " .. Stats.UpgradesBought ..
                                  "\nSession: " .. math.floor(tick() - Stats.SessionStart) .. "s"
                task.wait(1)
            end
        end)

        -- Drag functionality
        local Dragging = false
        local DragInput, MousePos, FramePos
        Title.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                MousePos = Input.Position
                FramePos = MainFrame.Position
                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)
        Title.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                DragInput = Input
            end
        end)
        UserInputService.InputChanged:Connect(function(Input)
            if Input == DragInput and Dragging then
                local Delta = Input.Position - MousePos
                MainFrame.Position = UDim2.new(
                    FramePos.X.Scale,
                    FramePos.X.Offset + Delta.X,
                    FramePos.Y.Scale,
                    FramePos.Y.Offset + Delta.Y
                )
            end
        end)
    end)
end

-- ── Main Loop ──
local function MainLoop()
    local GameModeTimer = 0
    local LoadoutTimer = 0
    local ShopTimer = 0
    local MapUpgradeTimer = 0
    local PetUpgradeTimer = 0
    local AFKTimer = 0

    while IsScriptRunning do
        local DeltaTime = task.wait(0.1)

        -- Auto Farm (every frame)
        AutoFarmMob()

        -- Anti AFK (every 3s)
        AFKTimer = AFKTimer + DeltaTime
        if AFKTimer >= 3 then
            AntiAFK()
            AFKTimer = 0
        end

        -- Auto Game Mode (every 15s)
        GameModeTimer = GameModeTimer + DeltaTime
        if GameModeTimer >= 15 and Config.AutoGameMode then
            AutoGameMode()
            GameModeTimer = 0
        end

        -- Auto Loadout (every 20s)
        LoadoutTimer = LoadoutTimer + DeltaTime
        if LoadoutTimer >= 20 and Config.AutoLoadout then
            AutoLoadout()
            LoadoutTimer = 0
        end

        -- Auto Shop (every 30s)
        ShopTimer = ShopTimer + DeltaTime
        if ShopTimer >= 30 and Config.AutoShop then
            AutoShop()
            ShopTimer = 0
        end

        -- Auto Map Upgrade (every 25s)
        MapUpgradeTimer = MapUpgradeTimer + DeltaTime
        if MapUpgradeTimer >= 25 and Config.AutoMapUpgrade then
            AutoMapUpgrade()
            MapUpgradeTimer = 0
        end

        -- Auto Pet Upgrade (every 25s)
        PetUpgradeTimer = PetUpgradeTimer + DeltaTime
        if PetUpgradeTimer >= 25 and Config.AutoPetUpgrade then
            AutoPetUpgrade()
            PetUpgradeTimer = 0
        end
    end
end

-- ── Initialization ──
local function Init()
    pcall(function()
        Log("🌟 BluezyGPT — Anime Astral Simulator Script Loaded")
        Log("👤 Player: " .. LocalPlayer.Name)
        Log("⚙️ Features: Auto Farm, Game Mode, Loadout, Shop, Map Upgrade, Pet Upgrade, Anti AFK, Webhook")

        SetupLeaderstats()
        CreateUI()

        Log("✅ UI Created — Look for the panel on your screen")
        Log("💡 Tip: Set your Discord Webhook URL in the panel to get logs")

        -- Start main loop
        task.spawn(MainLoop)

        -- Welcome webhook
        task.wait(2)
        SendWebhook("🌟 **BluezyGPT Script Started!**\n" ..
                    "👤 Player: " .. LocalPlayer.Name .. "\n" ..
                    "🎮 Game: Anime Astral Simulator\n" ..
                    "⏰ Time: " .. os.date("%H:%M:%S"))
    end)
end

-- Run
Init()
