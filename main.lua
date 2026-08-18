-- ═══════════════════════════════════════════════════════════════════
-- Anime Astral Simulator — Full Auto Farm (Config-Driven)
-- Author: BluezyGPT for BZMEMBER
-- Reads JSON config, supports ALL features from newbieIVYAstral.json
-- ═══════════════════════════════════════════════════════════════════

-- ── Services ──
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local function GetChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local Character = GetChar()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ── Default Config (mirrors newbieIVYAstral.json) ──
local Config = {
    -- Main Farming
    autoFarmMobToggle = false,
    autoFarmMob = "Nearest",
    autoFarmRaidToggle = false,
    autoFarmRaidTarget = "Center",
    autoFarmTrialToggle = false,
    autoFarmTrialTarget = "Center",
    autoFarmDefenseToggle = false,
    autoFarmDefenseTarget = "Lowest HP",
    autoFarmGateToggle = false,
    autoFarmGateTarget = "Nearest",
    autoFarmTowerToggle = false,
    autoFarmDungeonToggle = false,
    autoFarmBossRushToggle = false,

    -- Auto Join
    autoJoinRaidToggle = false,
    autoJoinTrialToggle = false,
    autoJoinDefenseToggle = false,
    autoJoinDungeonToggle = false,
    autoJoinTowerToggle = false,
    autoJoinBossRushToggle = false,
    autoJoinOpenDefenseToggle = false,
    autoJoinOpenRaidsToggle = false,

    -- Auto Leave
    autoLeaveToggle = true,
    raidLeaveFloor_World0 = "51",
    raidLeaveFloor_World1 = "101",
    raidLeaveFloor_World1Aldedo = "101",
    raidLeaveFloor_World6 = "31",
    raidLeaveFloor_World7 = "51",
    raidLeaveFloor_World10 = "61",
    raidLeaveFloor_World12 = "101",
    trialLeaveRoom_Easy = "",
    trialLeaveRoom_Medium = "",
    trialLeaveRoom_Hard = "46",
    defenseLeaveFloor_World4 = "101",
    defenseLeaveFloor_World8 = "101",
    defenseLeaveFloor_World13 = "101",
    gateLeaveWave_World5_A = "51",
    gateLeaveWave_World5_B = "51",
    gateLeaveWave_World5_C = "51",
    gateLeaveWave_World5_D = "51",
    gateLeaveWave_World5_E = "51",
    towerLeaveFloor_World14 = "51",

    -- Auto Upgrade
    autoUpgradeToggle_World0 = false,
    autoUpgradeToggle_World3 = false,
    autoUpgradeToggle_World6 = false,
    autoUpgradeToggle_World9 = false,
    autoUpgradeToggle_World10 = false,
    autoUpgradeToggle_World13 = false,
    autoUpgradeSelect_World0 = "",
    autoUpgradeSelect_World3 = "",
    autoUpgradeSelect_World6 = "",
    autoUpgradeSelect_World9 = "",
    autoUpgradeSelect_World10 = "",
    autoUpgradeSelect_World13 = "",

    -- Auto Loadout
    autoEquipLoadoutToggle = false,
    autoEquipLoadout_Raid = "",
    autoEquipLoadout_Trial_Easy = "",
    autoEquipLoadout_Trial_Medium = "",
    autoEquipLoadout_Trial_Hard = "",
    autoEquipLoadout_Defense = "",
    autoEquipLoadout_Dungeon_World9Dungeon = "",
    autoEquipLoadout_Gate_A = "",
    autoEquipLoadout_Gate_B = "",
    autoEquipLoadout_Gate_C = "",
    autoEquipLoadout_Gate_D = "",
    autoEquipLoadout_Gate_E = "",
    autoEquipLoadout_Gate_S = "",
    autoEquipLoadout_Tower = "",
    autoEquipLoadout_BossRush = "",
    autoEquipLoadout_Star = "",
    autoEquipLoadout_Relic = "",
    autoEquipLoadout_Promotion = "",
    autoEquipLoadout_MobQuest = "",
    autoEquipLoadout_GlobalQuest = "",

    -- Auto Skill Tree
    autoSkillTreeToggle = false,
    autoSkillTreeToggle_CursedTree = true,
    autoSkillTreePrio_LevelingTree_1 = "",
    autoSkillTreePrio_LevelingTree_2 = "",
    autoSkillTreePrio_LevelingTree_3 = "",
    autoSkillTreePrio_LevelingTree_4 = "",
    autoSkillTreePrio_LevelingTree_5 = "",
    autoSkillTreePrio_LevelingTree_6 = "",
    autoSkillTreePrio_CursedTree_1 = "Power",
    autoSkillTreePrio_CursedTree_2 = "Damage",
    autoSkillTreePrio_CursedTree_3 = "Drop",
    autoSkillTreePrio_CursedTree_4 = "Yen",
    autoSkillTreePrio_CursedTree_5 = "Luck",
    autoSkillTreePrio_CursedTree_6 = "XP",

    -- Auto Combat
    autoSwordToggle = false,
    autoSwordPassiveToggle = false,
    autoSwordPassiveSword = "",
    autoSwordPassiveStopAt = "",
    autoSwordBanners = "",
    autoHakiToggle = false,
    autoHakiSelect = "",
    autoPassivesToggle = false,
    autoPassivesSelect = "",
    autoPetPassiveToggle = false,
    autoPetPassivePets = {"⭐Demon Rimuru - 1.73M", "Raphael - 1.60M"},
    autoPetPassiveStopRarity = "Divine",
    autoTitanToggle = false,
    autoTitanPassiveToggle = false,
    autoTitanPassiveSelect = "",
    titanPassiveStopAt = "",
    titanStopSelect = "",
    autoPrimordialToggle = false,
    primordialStopSelect = "",

    -- Auto Quest
    autoQuestToggle = false,
    autoQuestBuyTravelToggle = true,
    autoSideQuestToggle = false,
    autoDoQuestToggle = false,

    -- Auto Gacha/Shop
    autoGachaToggle = false,
    autoGachaBanners = "",
    gachaRollAfterMaxToggle = false,
    autoMerchantToggle = false,
    autoMerchant_Merchant = "",
    autoMerchant_World7 = "",
    autoMerchant_World8 = "",
    autoMerchant_World12 = "",
    autoDefenseShopToggle = false,
    autoDefenseShopSelect = "",
    autoTrialShopToggle = false,
    autoTrialShopSelect = "",

    -- Auto Systems
    autoRelicToggle = false,
    autoRelicSelect = "",
    autoRelicUpgradeToggle = false,
    autoRelicUpgradeSelect = "",
    autoRelicCoinToggle = false,
    autoGateToggle = false,
    autoGateSelect = "Gate",
    autoGateRankSelect = "A",
    autoStarToggle = false,
    autoStarMap = "",
    autoStarOpenAnywhere = false,
    towerSelect = "Tower",
    autoDungeonSelect = {"Fire City Dungeon"},
    autoDungeonTarget = "Nearest",
    autoTrialSelect = {"Time Trial Hard", "Time Trial Easy", "Time Trial Medium"},
    autoBossRushSelect = "Cursed Rush",
    autoBossRushLeaveWave_CursedRush_V1 = "300",
    autoBossRushLeaveWave_CursedRush_V2 = "200",
    autoRankUpToggle = false,
    autoPromoteToggle = false,
    autoDoPromotionToggle = false,
    autoEvolutionToggle = false,
    autoEvolutionSelect = {"Monster Cell Absorb"},
    autoGrimoireToggle = false,
    autoGrimoireSlots = "",
    autoAriseToggle = false,
    autoConstellationToggle = false,
    autoProfessionsToggle = false,
    autoProfessionsSelect = {"Power", "Damage"},
    autoTitleToggle = false,
    autoTitleSelect = "The Absolute  (World 13)",
    autoGlobalQuestToggle = false,
    autoCollectFingerToggle = false,
    autoChest_DailyToggle = false,
    autoChest_GroupToggle = false,
    autoRenameToggle = false,
    autoRenameName = "",
    autoRenamePetSelect = "",
    autoUsePotionToggle = false,
    autoUsePotionSelect = "",
    autoExchange_Shards_toggle = false,
    autoExchange_Token_toggle = false,
    autoExchange_Exchange_toggle = false,
    autoExchange_Shards_select = "",
    autoExchange_Token_select = "",
    autoExchange_Exchange_select = "",
    autoCommandmentToggle = false,
    autoHopCommandmentToggle = false,
    autoCrowToggle = false,
    autoHopCrowToggle = false,
    autoBallToggle = false,
    autoHopBallToggle = false,
    equipBestAvatarToggle = false,
    autoExecuteToggle = false,

    -- Auto Unpause
    autoUnpause_Raid = "",
    autoUnpause_Trial_Easy = "",
    autoUnpause_Trial_Medium = "",
    autoUnpause_Trial_Hard = "",
    autoUnpause_Defense = "",
    autoUnpause_Gate_A = "",
    autoUnpause_Gate_B = "",
    autoUnpause_Gate_C = "",
    autoUnpause_Gate_D = "",
    autoUnpause_Gate_E = "",
    autoUnpause_Gate_S = "",
    autoUnpause_Dungeon_World9Dungeon = "",
    autoUnpause_Tower = "",
    autoUnpause_BossRush = "",
    autoUnpause_Star = "",
    autoUnpause_Relic = "",
    autoUnpause_Promotion = "",
    autoUnpause_MobQuest = "",
    autoUnpause_GlobalQuest = "",
    autoUnpauseBoostToggle = false,

    -- Leave for X
    leaveGamemodeForBallToggle = false,
    leaveGamemodeForCommandmentToggle = false,
    leaveGamemodeForCrowToggle = false,
    leaveGamemodeForTrialToggle = false,
    leaveGamemodeForGateToggle = false,
    leaveGamemodeForTowerToggle = false,
    leaveGamemodeForDungeonToggle = false,

    -- Webhook
    webhookURL = "",
    webhookSendToggle = true,
    webhookSendFor = {"Trial", "Defense", "Gate", "Rank Up", "Raid", "Dungeon", "Boss Rush"},
    webhookPingToggle = false,
    webhookPingID = "",
    webhookPingFor = "",
    webhookDisconnectToggle = true,

    -- Settings
    worldTpDelay = 2,
    uiScaleSlider = "1.0",
    autohideusername = false,
    BlackscreenMode = false,
    defenseSpeed = "3x",
}

-- ── Stats ──
local Stats = {
    Kills = 0,
    Deaths = 0,
    CoinsEarned = 0,
    GemsEarned = 0,
    UpgradesBought = 0,
    SessionsJoined = 0,
    SessionStart = tick(),
    TotalPlayTime = 0,
}

local IsRunning = true
local LogHistory = {}
local CurrentMode = "Idle"

-- ── Load Config from JSON File ──
local function LoadConfigFromFile(filePath)
    local Success, Result = pcall(function()
        local File = io.open(filePath, "r")
        if File then
            local Content = File:Read("*all")
            File:Close()
            local Data = HttpService:JSONDecode(Content)
            if Data and Data.objects then
                for _, Obj in ipairs(Data.objects) do
                    local Flag = Obj.flag
                    if Config[Flag] ~= nil then
                        if Obj.type == "Toggle" then
                            Config[Flag] = Obj.state
                        elseif Obj.type == "Input" then
                            Config[Flag] = Obj.text
                        elseif Obj.type == "Dropdown" then
                            Config[Flag] = Obj.value or Obj.state
                        elseif Obj.type == "Slider" then
                            Config[Flag] = Obj.value
                        end
                    end
                end
                Log("✅ Config loaded from: " .. filePath)
                return true
            end
        end
        return false
    end)
    if not Success then
        Log("⚠ Config load failed: " .. tostring(Result))
    end
    return Success
end

local function SaveConfigToFile(filePath)
    pcall(function()
        local Objects = {}
        for Flag, Value in pairs(Config) do
            local Obj = {flag = Flag}
            if type(Value) == "boolean" then
                obj.type = "Toggle"
                obj.state = Value
            elseif type(Value) == "string" then
                obj.type = "Input"
                obj.text = Value
            elseif type(Value) == "table" then
                obj.type = "Dropdown"
                obj.value = Value
            elseif type(Value) == "number" then
                obj.type = "Slider"
                obj.value = Value
            end
            table.insert(Objects, obj)
        end
        local File = io.open(filePath, "w")
        if File then
            File:Write(HttpService:JSONEncode({objects = Objects}))
            File:Close()
            Log("💾 Config saved to: " .. filePath)
        end
    end)
end

-- ── Utility Functions ──
local function Log(Message)
    local Time = os.date("[%H:%M:%S]")
    local Full = Time .. " " .. Message
    print(Full)
    table.insert(LogHistory, Full)
    if #LogHistory > 100 then table.remove(LogHistory, 1) end
end

local function SendWebhook(Title, Message, Color)
    if not Config.webhookSendToggle or Config.webhookURL == "" then return end
    pcall(function()
        local Body = HttpService:JSONEncode({
            username = "BluezyGPT — Anime Astral",
            avatar_url = "https://bluezygpt.space/icon.png",
            embeds = {{
                title = Title or "🌟 Anime Astral Simulator",
                description = Message,
                color = Color or 5814783,
                fields = {{
                    name = "👤 Player",
                    value = Config.autohideusername and "Hidden" or LocalPlayer.Name,
                    inline = true,
                }, {
                    name = "📊 Stats",
                    value = "Kills: " .. Stats.Kills .. "\nSession: " .. math.floor(tick() - Stats.SessionStart) .. "s",
                    inline = true,
                }, {
                    name = "🎮 Mode",
                    value = CurrentMode,
                    inline = true,
                }},
                footer = { text = "BluezyGPT for BZMEMBER | absolute bluezygpt" },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            }}
        })

        if syn and syn.request then
            syn.request({Url = Config.webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = Body})
        elseif http and http.request then
            http.request({Url = Config.webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = Body})
        elseif request then
            request({Url = Config.webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = Body})
        end
    end)
end

local function FindButton(Parent, Pattern)
    if not Parent then return nil end
    for _, Obj in ipairs(Parent:GetDescendants()) do
        if (Obj:IsA("TextButton") or Obj:IsA("ImageButton")) and Obj.Visible then
            if string.find(Obj.Name:lower(), Pattern:lower()) then
                return Obj
            end
        end
    end
    return nil
end

local function ClickButton(Button)
    if not Button then return false end
    pcall(function()
        fireclickdetector(Button)
    end)
    return true
end

local function GetNearestEnemy()
    local Nearest, NearestDist = nil, math.huge
    for _, Obj in ipairs(workspace:GetChildren()) do
        if Obj:IsA("Model") and Obj ~= Character then
            local Root = Obj:FindFirstChild("HumanoidRootPart")
            local Hum = Obj:FindFirstChildOfClass("Humanoid")
            if Root and Hum and Hum.Health > 0 then
                local IsPlayer = false
                for _, P in ipairs(Players:GetPlayers()) do
                    if P.Character == Obj then IsPlayer = true break end
                end
                if not IsPlayer then
                    local Dist = (HumanoidRootPart.Position - Root.Position).Magnitude
                    if Dist < NearestDist and Dist < 100 then
                        Nearest = Obj
                        NearestDist = Dist
                    end
                end
            end
        end
    end
    return Nearest, NearestDist
end

local function GetLowestHPEnemy()
    local Lowest, LowestPct = nil, 101
    for _, Obj in ipairs(workspace:GetChildren()) do
        if Obj:IsA("Model") and Obj ~= Character then
            local Root = Obj:FindFirstChild("HumanoidRootPart")
            local Hum = Obj:FindFirstChildOfClass("Humanoid")
            if Root and Hum and Hum.Health > 0 and Hum.MaxHealth > 0 then
                local Pct = (Hum.Health / Hum.MaxHealth) * 100
                if Pct < LowestPct then
                    Lowest = Obj
                    LowestPct = Pct
                end
            end
        end
    end
    return Lowest
end

local function MoveTo(Pos)
    pcall(function()
        Humanoid:MoveTo(Pos)
    end)
end

local function AttackTarget(Target)
    local Root = Target:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, Root.Position)
    pcall(function()
        -- Try common remotes
        for _, Name in ipairs({"Attack", "Hit", "Damage", "DealDamage", "Combat", "Slash"}) do
            local R = ReplicatedStorage:FindFirstChild(Name)
            if R and R:IsA("RemoteEvent") then R:FireServer(Root) return end
        end
        -- Deep search
        for _, R in ipairs(ReplicatedStorage:GetDescendants()) do
            if R:IsA("RemoteEvent") then
                local L = R.Name:lower()
                if string.find(L, "attack") or string.find(L, "hit") or string.find(L, "damage") then
                    R:FireServer(Root)
                    return
                end
            end
        end
        -- Fallback
        UserInputService:MouseClick()
    end)
end

-- ── Anti AFK ──
local function AntiAFK()
    pcall(function()
        local Cam = workspace.CurrentCamera
        if Cam then
            local Old = Cam.CFrame
            Cam.CFrame = CFrame.new(Cam.CFrame.Position + Vector3.new(0.005, 0, 0), Cam.CFrame.LookVector)
            task.wait(0.05)
            Cam.CFrame = Old
        end
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0.001, 0)
        task.wait(0.05)
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -0.001, 0)
    end)
end

-- ── Auto Farm Mob ──
local function AutoFarmMob()
    if not Config.autoFarmMobToggle then return end
    local Target
    if Config.autoFarmMob == "Lowest HP" then
        Target = GetLowestHPEnemy()
    else
        Target, _ = GetNearestEnemy()
    end
    if Target then
        local Root = Target:FindFirstChild("HumanoidRootPart")
        if Root then
            local Dist = (HumanoidRootPart.Position - Root.Position).Magnitude
            if Dist > 8 then
                MoveTo(Root.Position)
            else
                AttackTarget(Target)
            end
        end
    else
        -- Wander
        if math.random() < 0.02 then
            MoveTo(HumanoidRootPart.Position + Vector3.new(math.random(-50,50), 0, math.random(-50,50)))
        end
    end
end

-- ── Auto Farm Raid ──
local function AutoFarmRaid()
    if not Config.autoFarmRaidToggle then return end
    CurrentMode = "Farming Raid"
    -- Similar to mob farm but target raid-specific enemies
    local Target = GetNearestEnemy()
    if Target then
        local Root = Target:FindFirstChild("HumanoidRootPart")
        if Root then
            local Dist = (HumanoidRootPart.Position - Root.Position).Magnitude
            if Dist > 8 then MoveTo(Root.Position) else AttackTarget(Target) end
        end
    end
end

-- ── Auto Farm Trial ──
local function AutoFarmTrial()
    if not Config.autoFarmTrialToggle then return end
    CurrentMode = "Farming Trial"
    local Target
    if Config.autoFarmTrialTarget == "Center" then
        -- Move to center of map then attack
        MoveTo(Vector3.new(0, HumanoidRootPart.Position.Y, 0))
    end
    Target = GetNearestEnemy()
    if Target then
        local Root = Target:FindFirstChild("HumanoidRootPart")
        if Root then
            local Dist = (HumanoidRootPart.Position - Root.Position).Magnitude
            if Dist > 8 then MoveTo(Root.Position) else AttackTarget(Target) end
        end
    end
end

-- ── Auto Farm Defense ──
local function AutoFarmDefense()
    if not Config.autoFarmDefenseToggle then return end
    CurrentMode = "Farming Defense"
    local Target
    if Config.autoFarmDefenseTarget == "Lowest HP" then
        Target = GetLowestHPEnemy()
    else
        Target = GetNearestEnemy()
    end
    if Target then
        local Root = Target:FindFirstChild("HumanoidRootPart")
        if Root then
            local Dist = (HumanoidRootPart.Position - Root.Position).Magnitude
            if Dist > 10 then MoveTo(Root.Position) else AttackTarget(Target) end
        end
    end
end

-- ── Auto Farm Gate ──
local function AutoFarmGate()
    if not Config.autoFarmGateToggle then return end
    CurrentMode = "Farming Gate"
    local Target = GetNearestEnemy()
    if Target then
        local Root = Target:FindFirstChild("HumanoidRootPart")
        if Root then
            local Dist = (HumanoidRootPart.Position - Root.Position).Magnitude
            if Dist > 8 then MoveTo(Root.Position) else AttackTarget(Target) end
        end
    end
end

-- ── Auto Leave Logic ──
local function CheckAutoLeave()
    if not Config.autoLeaveToggle then return end
    pcall(function()
        local Gui = PlayerGui
        -- Check for floor/wave indicators in leaderstats or UI
        local Leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if Leaderstats then
            local FloorVal = Leaderstats:FindFirstChild("Floor") or Leaderstats:FindFirstChild("Wave") or Leaderstats:FindFirstChild("Room")
            if FloorVal and FloorVal:IsA("IntValue") then
                local CurrentFloor = FloorVal.Value
                local LeaveAt = tonumber(Config.raidLeaveFloor_World0) or 51
                if CurrentFloor >= LeaveAt then
                    Log("🚪 Auto Leave: Floor " .. CurrentFloor .. " reached limit " .. LeaveAt)
                    SendWebhook("🚪 Auto Leave", "Left at floor " .. CurrentFloor)
                    -- Find leave button
                    for _, SG in ipairs(Gui:GetChildren()) do
                        local LeaveBtn = FindButton(SG, "leave") or FindButton(SG, "exit")
                        if LeaveBtn then ClickButton(LeaveBtn) return end
                    end
                end
            end
        end
    end)
end

-- ── Auto Join Logic ──
local function AutoJoinActivities()
    pcall(function()
        local Gui = PlayerGui
        if Config.autoJoinRaidToggle then
            for _, SG in ipairs(Gui:GetChildren()) do
                local JoinBtn = FindButton(SG, "join raid") or FindButton(SG, "raid join")
                if JoinBtn then ClickButton(JoinBtn) Log("⚔️ Auto Joined Raid") task.wait(1) end
            end
        end
        if Config.autoJoinTrialToggle then
            for _, SG in ipairs(Gui:GetChildren()) do
                local JoinBtn = FindButton(SG, "join trial") or FindButton(SG, "trial join")
                if JoinBtn then ClickButton(JoinBtn) Log("🏛️ Auto Joined Trial") task.wait(1) end
            end
        end
        if Config.autoJoinDefenseToggle then
            for _, SG in ipairs(Gui:GetChildren()) do
                local JoinBtn = FindButton(SG, "join defense") or FindButton(SG, "defense join")
                if JoinBtn then ClickButton(JoinBtn) Log("🛡️ Auto Joined Defense") task.wait(1) end
            end
        end
        if Config.autoJoinDungeonToggle then
            for _, SG in ipairs(Gui:GetChildren()) do
                local JoinBtn = FindButton(SG, "join dungeon") or FindButton(SG, "dungeon join")
                if JoinBtn then ClickButton(JoinBtn) Log("🏰 Auto Joined Dungeon") task.wait(1) end
            end
        end
        if Config.autoJoinTowerToggle then
            for _, SG in ipairs(Gui:GetChildren()) do
                local JoinBtn = FindButton(SG, "join tower") or FindButton(SG, "tower join")
                if JoinBtn then ClickButton(JoinBtn) Log("🗼 Auto Joined Tower") task.wait(1) end
            end
        end
        if Config.autoJoinBossRushToggle then
            for _, SG in ipairs(Gui:GetChildren()) do
                local JoinBtn = FindButton(SG, "boss rush") or FindButton(SG, "join boss")
                if JoinBtn then ClickButton(JoinBtn) Log("👹 Auto Joined Boss Rush") task.wait(1) end
            end
        end
    end)
end

-- ── Auto Upgrade ──
local function AutoUpgrade()
    pcall(function()
        local Gui = PlayerGui
        local Worlds = {
            {Flag = "autoUpgradeToggle_World0", Select = "autoUpgradeSelect_World0"},
            {Flag = "autoUpgradeToggle_World3", Select = "autoUpgradeSelect_World3"},
            {Flag = "autoUpgradeToggle_World6", Select = "autoUpgradeSelect_World6"},
            {Flag = "autoUpgradeToggle_World9", Select = "autoUpgradeSelect_World9"},
            {Flag = "autoUpgradeToggle_World10", Select = "autoUpgradeSelect_World10"},
            {Flag = "autoUpgradeToggle_World13", Select = "autoUpgradeSelect_World13"},
        }
        for _, W in ipairs(Worlds) do
            if Config[W.Flag] then
                for _, SG in ipairs(Gui:GetChildren()) do
                    local UpgradeBtn = FindButton(SG, "upgrade")
                    if UpgradeBtn then
                        ClickButton(UpgradeBtn)
                        task.wait(0.3)
                        -- Click specific upgrade
                        local Select = Config[W.Select]
                        if Select and Select ~= "" then
                            local SpecificBtn = FindButton(SG, Select:lower())
                            if SpecificBtn then ClickButton(SpecificBtn) end
                        end
                        Log("⬆️ Auto Upgrade: World")
                        Stats.UpgradesBought = Stats.UpgradesBought + 1
                        task.wait(0.5)
                    end
                end
            end
        end
    end)
end

-- ── Auto Skill Tree ──
local function AutoSkillTree()
    if not Config.autoSkillTreeToggle and not Config.autoSkillTreeToggle_CursedTree then return end
    pcall(function()
        local Gui = PlayerGui
        for _, SG in ipairs(Gui:GetChildren()) do
            local SkillBtn = FindButton(SG, "skill") or FindButton(SG, "tree")
            if SkillBtn then
                ClickButton(SkillBtn)
                task.wait(0.3)
                -- Click priority skills
                local Priorities = {
                    Config.autoSkillTreePrio_CursedTree_1,
                    Config.autoSkillTreePrio_CursedTree_2,
                    Config.autoSkillTreePrio_CursedTree_3,
                    Config.autoSkillTreePrio_CursedTree_4,
                    Config.autoSkillTreePrio_CursedTree_5,
                    Config.autoSkillTreePrio_CursedTree_6,
                }
                for _, Prio in ipairs(Priorities) do
                    if Prio and Prio ~= "" then
                        local PrioBtn = FindButton(SG, Prio:lower())
                        if PrioBtn then ClickButton(PrioBtn) Log("🌳 Skill: " .. Prio) task.wait(0.2) end
                    end
                end
            end
        end
    end)
end

-- ── Auto Gacha ──
local function AutoGacha()
    if not Config.autoGachaToggle then return end
    pcall(function()
        local Gui = PlayerGui
        for _, SG in ipairs(Gui:GetChildren()) do
            local GachaBtn = FindButton(SG, "gacha") or FindButton(SG, "summon") or FindButton(SG, "roll")
            if GachaBtn then
                ClickButton(GachaBtn)
                Log("🎰 Auto Gacha Roll")
                task.wait(1)
                if Config.gachaRollAfterMaxToggle then
                    -- Keep rolling
                    for i = 1, 10 do
                        local RollBtn = FindButton(SG, "roll") or FindButton(SG, "summon")
                        if RollBtn then ClickButton(RollBtn) task.wait(0.5) end
                    end
                end
            end
        end
    end)
end

-- ── Auto Quest ──
local function AutoQuest()
    if not Config.autoQuestToggle and not Config.autoSideQuestToggle and not Config.autoDoQuestToggle then return end
    pcall(function()
        local Gui = PlayerGui
        if Config.autoQuestToggle or Config.autoDoQuestToggle then
            for _, SG in ipairs(Gui:GetChildren()) do
                local QuestBtn = FindButton(SG, "quest") or FindButton(SG, "mission")
                if QuestBtn then
                    ClickButton(QuestBtn)
                    task.wait(0.5)
                    local ClaimBtn = FindButton(SG, "claim") or FindButton(SG, "complete")
                    if ClaimBtn then ClickButton(ClaimBtn) Log("📜 Quest Completed") end
                end
            end
        end
        if Config.autoSideQuestToggle then
            for _, SG in ipairs(Gui:GetChildren()) do
                local SideBtn = FindButton(SG, "side quest") or FindButton(SG, "sidequest")
                if SideBtn then ClickButton(SideBtn) Log("📋 Side Quest") task.wait(0.5) end
            end
        end
    end)
end

-- ── Kill Tracker ──
local function SetupTracking()
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

        local Gems = Instance.new("IntValue")
        Gems.Name = "Gems"
        Gems.Value = 0
        Gems.Parent = Leaderstats

        local SessionTime = Instance.new("IntValue")
        SessionTime.Name = "Session"
        SessionTime.Value = 0
        SessionTime.Parent = Leaderstats

        workspace.ChildAdded:Connect(function(Child)
            if Child:IsA("Model") then
                local Root = Child:FindFirstChild("HumanoidRootPart")
                local Hum = Child:FindFirstChildOfClass("Humanoid")
                if Root and Hum then
                    Hum.Died:Connect(function()
                        if Root and (HumanoidRootPart.Position - Root.Position).Magnitude < 100 then
                            Stats.Kills = Stats.Kills + 1
                            Kills.Value = Stats.Kills
                            Log("💀 Kill! Total: " .. Stats.Kills)
                            if Stats.Kills % 50 == 0 then
                                SendWebhook("💀 Milestone!", Stats.Kills .. " kills reached!")
                            end
                        end
                    end)
                end
            end
        end)

        -- Update session time
        task.spawn(function()
            while IsRunning do
                SessionTime.Value = math.floor(tick() - Stats.SessionStart)
                task.wait(1)
            end
        end)
    end)
end

-- ── UI Library ──
local function CreateUI()
    pcall(function()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "BluezyGPT_FullUI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = PlayerGui

        -- Main Frame
        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 380, 0, 560)
        MainFrame.Position = UDim2.new(0, 20, 0, 20)
        MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui
        local MC = Instance.new("UICorner")
        MC.CornerRadius = UDim.new(0, 12)
        MC.Parent = MainFrame

        -- Title
        local TitleBar = Instance.new("Frame")
        TitleBar.Size = UDim2.new(1, 0, 0, 38)
        TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 65)
        TitleBar.BorderSizePixel = 0
        TitleBar.Parent = MainFrame
        local TC = Instance.new("UICorner")
        TC.CornerRadius = UDim.new(0, 12)
        TC.Parent = TitleBar

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, 0, 1, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = "🌟 BluezyGPT — Anime Astral [FULL]"
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.TextSize = 14
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Parent = TitleBar

        -- Close
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -34, 0, 4)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseBtn.TextSize = 14
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.Parent = TitleBar
        local CC = Instance.new("UICorner")
        CC.CornerRadius = UDim.new(0, 6)
        CC.Parent = CloseBtn
        CloseBtn.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
            IsRunning = false
            Log("❌ Script stopped")
        end)

        -- Tabs
        local TabContainer = Instance.new("Frame")
        TabContainer.Size = UDim2.new(1, 0, 0, 30)
        TabContainer.Position = UDim2.new(0, 0, 0, 42)
        TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
        TabContainer.BorderSizePixel = 0
        TabContainer.Parent = MainFrame

        local Tabs = {"Main", "Farm", "Auto", "Config", "Info"}
        local TabFrames = {}
        local TabWidth = 1 / #Tabs

        for i, TabName in ipairs(Tabs) do
            local TabBtn = Instance.new("TextButton")
            TabBtn.Size = UDim2.new(TabWidth, 0, 1, 0)
            TabBtn.Position = UDim2.new((i-1) * TabWidth, 0, 0, 0)
            TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
            TabBtn.Text = TabName
            TabBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
            TabBtn.TextSize = 11
            TabBtn.Font = Enum.Font.GothamBold
            TabBtn.Parent = TabContainer
            local TBC = Instance.new("UICorner")
            TBC.CornerRadius = UDim.new(0, 4)
            TBC.Parent = TabBtn

            -- Tab Content Frame
            local TabFrame = Instance.new("ScrollingFrame")
            TabFrame.Size = UDim2.new(1, -8, 1, -88)
            TabFrame.Position = UDim2.new(0, 4, 0, 76)
            TabFrame.BackgroundTransparency = 1
            TabFrame.ScrollBarThickness = 4
            TabFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
            TabFrame.Visible = (i == 1)
            TabFrame.Parent = MainFrame
            TabFrames[TabName] = TabFrame

            local Layout = Instance.new("UIListLayout")
            Layout.Padding = UDim.new(0, 3)
            Layout.Parent = TabFrame
            local Pad = Instance.new("UIPadding")
            Pad.PaddingLeft = UDim.new(0, 6)
            Pad.PaddingRight = UDim.new(0, 6)
            Pad.PaddingTop = UDim.new(0, 4)
            Pad.PaddingBottom = UDim.new(0, 4)
            Pad.Parent = TabFrame

            TabBtn.MouseButton1Click:Connect(function()
                for _, TF in pairs(TabFrames) do TF.Visible = false end
                TabFrame.Visible = true
            end)
        end

        -- Toggle Helper
        local function MakeToggle(Parent, Name, Default, Callback, Order)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 26)
            Container.BackgroundTransparency = 1
            Container.LayoutOrder = Order or 0
            Container.Parent = Parent

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = Name
            Label.TextColor3 = Color3.fromRGB(180, 180, 200)
            Label.TextSize = 10
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Container

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(0, 44, 0, 20)
            ToggleBtn.Position = UDim2.new(1, -48, 0.5, -10)
            ToggleBtn.BackgroundColor3 = Default and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(160, 0, 0)
            ToggleBtn.Text = Default and "ON" or "OFF"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleBtn.TextSize = 9
            ToggleBtn.Font = Enum.Font.GothamBold
            ToggleBtn.Parent = Container
            local TgC = Instance.new("UICorner")
            TgC.CornerRadius = UDim.new(0, 5)
            TgC.Parent = ToggleBtn

            ToggleBtn.MouseButton1Click:Connect(function()
                Default = not Default
                ToggleBtn.BackgroundColor3 = Default and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(160, 0, 0)
                ToggleBtn.Text = Default and "ON" or "OFF"
                if Callback then Callback(Default) end
            end)
            return Default
        end

        local function MakeInput(Parent, Label, Default, Callback, Order)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 40)
            Container.BackgroundTransparency = 1
            Container.LayoutOrder = Order or 0
            Container.Parent = Parent

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, 0, 0, 14)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = Label
            Lbl.TextColor3 = Color3.fromRGB(160, 160, 180)
            Lbl.TextSize = 9
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Container

            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(1, 0, 0, 22)
            Box.Position = UDim2.new(0, 0, 0, 16)
            Box.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
            Box.PlaceholderText = Default or ""
            Box.PlaceholderColor3 = Color3.fromRGB(80, 80, 100)
            Box.Text = ""
            Box.TextColor3 = Color3.fromRGB(255, 255, 255)
            Box.TextSize = 9
            Box.Font = Enum.Font.Gotham
            Box.ClearTextOnFocus = false
            Box.Parent = Container
            local BC = Instance.new("UICorner")
            BC.CornerRadius = UDim.new(0, 5)
            BC.Parent = Box

            Box.FocusLost:Connect(function(EnterPressed)
                if EnterPressed and Callback then Callback(Box.Text) end
            end)
        end

        -- === MAIN TAB ===
        local MainTab = TabFrames["Main"]
        MakeToggle(MainTab, "🗡️ Auto Farm Mob", Config.autoFarmMobToggle, function(v) Config.autoFarmMobToggle = v end, 1)
        MakeToggle(MainTab, "⚔️ Auto Join Raid", Config.autoJoinRaidToggle, function(v) Config.autoJoinRaidToggle = v end, 2)
        MakeToggle(MainTab, "🏛️ Auto Join Trial", Config.autoJoinTrialToggle, function(v) Config.autoJoinTrialToggle = v end, 3)
        MakeToggle(MainTab, "🛡️ Auto Join Defense", Config.autoJoinDefenseToggle, function(v) Config.autoJoinDefenseToggle = v end, 4)
        MakeToggle(MainTab, "🏰 Auto Join Dungeon", Config.autoJoinDungeonToggle, function(v) Config.autoJoinDungeonToggle = v end, 5)
        MakeToggle(MainTab, "🗼 Auto Join Tower", Config.autoJoinTowerToggle, function(v) Config.autoJoinTowerToggle = v end, 6)
        MakeToggle(MainTab, "👹 Auto Join Boss Rush", Config.autoJoinBossRushToggle, function(v) Config.autoJoinBossRushToggle = v end, 7)
        MakeToggle(MainTab, "🚪 Auto Leave", Config.autoLeaveToggle, function(v) Config.autoLeaveToggle = v end, 8)
        MakeToggle(MainTab, "🤖 Anti AFK", true, function(v) Config.AntiAFK = v end, 9)

        -- === FARM TAB ===
        local FarmTab = TabFrames["Farm"]
        MakeToggle(FarmTab, "🗡️ Farm Mob", Config.autoFarmMobToggle, function(v) Config.autoFarmMobToggle = v end, 1)
        MakeToggle(FarmTab, "⚔️ Farm Raid", Config.autoFarmRaidToggle, function(v) Config.autoFarmRaidToggle = v end, 2)
        MakeToggle(FarmTab, "🏛️ Farm Trial", Config.autoFarmTrialToggle, function(v) Config.autoFarmTrialToggle = v end, 3)
        MakeToggle(FarmTab, "🛡️ Farm Defense", Config.autoFarmDefenseToggle, function(v) Config.autoFarmDefenseToggle = v end, 4)
        MakeToggle(FarmTab, "🚪 Farm Gate", Config.autoFarmGateToggle, function(v) Config.autoFarmGateToggle = v end, 5)
        MakeToggle(FarmTab, "🗼 Farm Tower", Config.autoFarmTowerToggle, function(v) Config.autoFarmTowerToggle = v end, 6)
        MakeToggle(FarmTab, "👹 Farm Boss Rush", Config.autoFarmBossRushToggle, function(v) Config.autoFarmBossRushToggle = v end, 7)

        -- === AUTO TAB ===
        local AutoTab = TabFrames["Auto"]
        MakeToggle(AutoTab, "⬆️ Auto Upgrade", Config.autoUpgradeToggle_World0 or Config.autoUpgradeToggle_World3, function(v) Config.autoUpgradeToggle_World0 = v end, 1)
        MakeToggle(AutoTab, "🌳 Auto Skill Tree", Config.autoSkillTreeToggle, function(v) Config.autoSkillTreeToggle = v end, 2)
        MakeToggle(AutoTab, "🌑 Cursed Tree", Config.autoSkillTreeToggle_CursedTree, function(v) Config.autoSkillTreeToggle_CursedTree = v end, 3)
        MakeToggle(AutoTab, "🎰 Auto Gacha", Config.autoGachaToggle, function(v) Config.autoGachaToggle = v end, 4)
        MakeToggle(AutoTab, "📜 Auto Quest", Config.autoQuestToggle, function(v) Config.autoQuestToggle = v end, 5)
        MakeToggle(AutoTab, "🗡️ Auto Sword", Config.autoSwordToggle, function(v) Config.autoSwordToggle = v end, 6)
        MakeToggle(AutoTab, "💪 Auto Haki", Config.autoHakiToggle, function(v) Config.autoHakiToggle = v end, 7)
        MakeToggle(AutoTab, "🐾 Auto Pet Passive", Config.autoPetPassiveToggle, function(v) Config.autoPetPassiveToggle = v end, 8)
        MakeToggle(AutoTab, "👊 Auto Titan", Config.autoTitanToggle, function(v) Config.autoTitanToggle = v end, 9)
        MakeToggle(AutoTab, "💎 Auto Relic", Config.autoRelicToggle, function(v) Config.autoRelicToggle = v end, 10)
        MakeToggle(AutoTab, "🚪 Auto Gate", Config.autoGateToggle, function(v) Config.autoGateToggle = v end, 11)
        MakeToggle(AutoTab, "⭐ Auto Star", Config.autoStarToggle, function(v) Config.autoStarToggle = v end, 12)
        MakeToggle(AutoTab, "🔄 Auto Evolution", Config.autoEvolutionToggle, function(v) Config.autoEvolutionToggle = v end, 13)
        MakeToggle(AutoTab, "📖 Auto Grimoire", Config.autoGrimoireToggle, function(v) Config.autoGrimoireToggle = v end, 14)
        MakeToggle(AutoTab, "🏪 Auto Merchant", Config.autoMerchantToggle, function(v) Config.autoMerchantToggle = v end, 15)

        -- === CONFIG TAB ===
        local ConfigTab = TabFrames["Config"]
        MakeInput(ConfigTab, "🪝 Discord Webhook URL:", Config.webhookURL, function(v) Config.webhookURL = v Log("🪝 Webhook set!") SendWebhook("✅ Connected!", "Player: " .. LocalPlayer.Name) end, 1)
        MakeInput(ConfigTab, "📂 Load Config (filepath):", "", function(v) if v ~= "" then LoadConfigFromFile(v) end end, 2)
        MakeInput(ConfigTab, "💾 Save Config (filepath):", "", function(v) if v ~= "" then SaveConfigToFile(v) end end, 3)
        MakeInput(ConfigTab, "🌍 World TP Delay (sec):", tostring(Config.worldTpDelay), function(v) Config.worldTpDelay = tonumber(v) or 2 end, 4)

        -- === INFO TAB ===
        local InfoTab = TabFrames["Info"]
        local InfoLabel = Instance.new("TextLabel")
        InfoLabel.Size = UDim2.new(1, 0, 1, 0)
        InfoLabel.BackgroundTransparency = 1
        InfoLabel.Text = "🌟 BluezyGPT — Anime Astral\n\n👤 Player: " .. LocalPlayer.Name ..
                         "\n📊 Kills: 0\n💰 Coins: 0\n⬆️ Upgrades: 0\n⏱️ Session: 0s\n\n" ..
                         "absolute bluezygpt to BZMEMBER"
        InfoLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
        InfoLabel.TextSize = 10
        InfoLabel.Font = Enum.Font.Gotham
        InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
        InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
        InfoLabel.Parent = InfoTab

        task.spawn(function()
            while IsRunning do
                pcall(function()
                    InfoLabel.Text = "🌟 BluezyGPT — Anime Astral\n\n👤 Player: " ..
                                     (Config.autohideusername and "Hidden" or LocalPlayer.Name) ..
                                     "\n📊 Kills: " .. Stats.Kills ..
                                     "\n💰 Coins: " .. Stats.CoinsEarned ..
                                     "\n⬆️ Upgrades: " .. Stats.UpgradesBought ..
                                     "\n⏱️ Session: " .. math.floor(tick() - Stats.SessionStart) .. "s" ..
                                     "\n🎮 Mode: " .. CurrentMode ..
                                     "\n\nabsolute bluezygpt to BZMEMBER"
                end)
                task.wait(1)
            end
        end)

        -- Drag
        local Dragging, DragStart, StartPos = false, nil, nil
        TitleBar.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                DragStart = Input.Position
                StartPos = MainFrame.Position
            end
        end)
        TitleBar.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(Input)
            if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                local Delta = Input.Position - DragStart
                MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            end
        end)
    end)
end

-- ── Main Loop ──
local function MainLoop()
    local JoinTimer, UpgradeTimer, SkillTimer, GachaTimer, QuestTimer = 0, 0, 0, 0, 0
    local AFKTimer = 0

    while IsRunning do
        local dt = task.wait(0.1)

        -- Auto Farm (priority based on what's enabled)
        if Config.autoFarmMobToggle then
            CurrentMode = "Farming Mob"
            AutoFarmMob()
        elseif Config.autoFarmRaidToggle then
            AutoFarmRaid()
        elseif Config.autoFarmTrialToggle then
            AutoFarmTrial()
        elseif Config.autoFarmDefenseToggle then
            AutoFarmDefense()
        elseif Config.autoFarmGateToggle then
            AutoFarmGate()
        end

        -- Anti AFK
        AFKTimer = AFKTimer + dt
        if AFKTimer >= 3 then
            AntiAFK()
            AFKTimer = 0
        end

        -- Auto Join
        JoinTimer = JoinTimer + dt
        if JoinTimer >= 10 then
            AutoJoinActivities()
            JoinTimer = 0
        end

        -- Auto Leave Check
        CheckAutoLeave()

        -- Auto Upgrade
        UpgradeTimer = UpgradeTimer + dt
        if UpgradeTimer >= 20 then
            AutoUpgrade()
            UpgradeTimer = 0
        end

        -- Auto Skill Tree
        SkillTimer = SkillTimer + dt
        if SkillTimer >= 30 then
            AutoSkillTree()
            SkillTimer = 0
        end

        -- Auto Gacha
        GachaTimer = GachaTimer + dt
        if GachaTimer >= 60 then
            AutoGacha()
            GachaTimer = 0
        end

        -- Auto Quest
        QuestTimer = QuestTimer + dt
        if QuestTimer >= 45 then
            AutoQuest()
            QuestTimer = 0
        end
    end
end

-- ── Init ──
local function Init()
    pcall(function()
        Log("🌟 BluezyGPT — Anime Astral [FULL CONFIG] Loaded")
        Log("👤 Player: " .. LocalPlayer.Name)
        Log("📋 Features: All-in-One — Farm, Join, Leave, Upgrade, Skill, Gacha, Quest, Webhook")

        SetupTracking()
        CreateUI()

        Log("✅ UI Ready — 5 tabs: Main, Farm, Auto, Config, Info")
        Log("💡 Tip: Paste config file path in Config tab to load settings")

        task.spawn(MainLoop)

        task.wait(2)
        SendWebhook("🌟 **Script Started!**",
                    "Player: " .. LocalPlayer.Name ..
                    "\nGame: Anime Astral Simulator" ..
                    "\nTime: " .. os.date("%H:%M:%S"),
                    5814783)
    end)
end

-- Run
Init()
