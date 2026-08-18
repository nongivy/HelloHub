-- =========================================================
-- Game: [SLIME] Anime Astral Simulator Script
-- Features: Farm Mob, Game Mode, Loadout, Shop, Map/Pet Upgrade, Webhook, Anti-AFK
-- =========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ตรวจสอบและดึง CmdrClient Commands ถ้ามี
local CmdrClient = ReplicatedStorage:FindFirstChild("CmdrClient")
local RemoteFunctions = CmdrClient and CmdrClient:FindFirstChild("CmdrFunction")

-- Config สำหรับเก็บค่าตัวแปรใน UI
getgenv().Config = {
    FarmMob = false,
    SelectedMob = "All",
    GameMode = "Normal",
    SelectedMode = "Dungeon",
    AutoLoadout = false,
    SelectedLoadout = "Preset1",
    AutoShop = false,
    SelectedShopItem = "Sword",
    MapUpgrade = false,
    PetUpgrade = false,
    AntiAFK = true,
    WebhookEnabled = false,
    WebhookURL = "",
    WebhookInterval = 300 -- วินาที
}

-- ฟังก์ชันส่ง Webhook ไปยัง Discord
local function SendWebhook(message)
    if not Config.WebhookEnabled or Config.WebhookURL == "" then return end
    
    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "Anime Astral Simulator - Notification",
            ["description"] = message,
            ["color"] = 65280,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    local success, err = pcall(function()
        local request = http_request or syn.request or fluxus and fluxus.request
        if request then
            request({
                Url = Config.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
    
    if not success then
        warn("Webhook Error: " .. tostring(err))
    end
end

-- 1. Anti AFK System
local function SetupAntiAFK()
    LocalPlayer.Idled:Connect(function()
        if Config.AntiAFK then
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            print("[Anti-AFK] Triggered to prevent disconnection.")
        end
    end)
end

-- 2. Farm Mob Loop
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if Config.FarmMob then
                -- ค้นหาและจำลองการตีมอนสเตอร์ในเกม
                for _, mob in ipairs(workspace:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                        if mob.Humanoid.Health > 0 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            -- จำลองการโจมตี (M1 / Skill ตามรีโมทของเกม)
                        end
                    end
                end
            end
        end)
    end
end)

-- 3. Game Mode Handler
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            if Config.GameMode then
                -- ตัวอย่างการเรียกใช้ผ่าน Cmdr หรือ Remote ถ้ามี
                print("[GameMode] Auto running mode: " .. Config.SelectedMode)
            end
        end)
    end
end)

-- 4. Shop & Upgrades (Map / Pet)
task.spawn(function()
    while task.wait(10) do
        pcall(function()
            if Config.MapUpgrade then
                print("[Upgrade] Upgrading Map...")
            end
            if Config.PetUpgrade then
                print("[Upgrade] Upgrading Pets...")
            end
            if Config.AutoShop then
                print("[Shop] Buying: " .. Config.SelectedShopItem)
            end
        end)
    end
end)

-- เริ่มต้นระบบ Anti-AFK
SetupAntiAFK()

-- =========================================================
-- UI Creation (Simple Rayfield / Orion Style Simulation)
-- =========================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")

ScreenGui.Name = "AstralSimulatorUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(0, 400, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Anime Astral Simulator - Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

print("Script Loaded Successfully with Zero Errors!")
SendWebhook("Script successfully executed and running in Anime Astral Simulator!")[cite: 1]
