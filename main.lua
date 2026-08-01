-- ======================================================
--  HelloHUB - Anime Astral Simulator
-- ======================================================

-- โหลด UI Library (Rayfield)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้างหน้าต่างหลัก (Window)
local Window = Rayfield:CreateWindow({
   Name = "HelloHUB | Anime Astral Simulator",
   LoadingTitle = "HelloHUB Loading...",
   LoadingSubtitle = "by YourName",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HelloHUB_Config",
      FileName = "AnimeAstral"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false -- ตั้งเป็น true หากต้องการทำระบบ Key
})

-- ======================================================
--  VARIABLES & TOGGLES (ตัวแปรสำหรับเปิด/ปิดฟังก์ชัน)
-- ======================================================
local AutoFarm = false
local AutoClick = false

-- ======================================================
--  TABS (แท็บเมนูต่างๆ)
-- ======================================================

-- 1. แท็บ Main (ฟังก์ชันหลัก)
local MainTab = Window:CreateTab("Main", 4483362458) -- สามารถเปลี่ยน ID ไอคอนได้

local MainSection = MainTab:CreateSection("Auto Farm Options")

-- ปุ่ม Toggle สำหรับ Auto Click / Attack
local AutoClickToggle = MainTab:CreateToggle({
   Name = "Auto Click / Auto Attack",
   CurrentValue = false,
   Flag = "AutoClickFlag",
   Callback = function(Value)
       AutoClick = Value
       
       -- โค้ดทำงานเมื่อเปิด/ปิด Toggle
       task.spawn(function()
           while AutoClick do
               -- ใส่ RemoteEvent หรือคำสั่งโจมตีของเกม Anime Astral Simulator ที่นี่
               -- ตัวอย่าง: game:GetService("ReplicatedStorage").Remotes.Click:FireServer()
               print("[HelloHUB] Auto Clicking...")
               task.wait(0.1)
           end
       end)
   end,
})

-- ปุ่ม Toggle สำหรับ Auto Farm
local AutoFarmToggle = MainTab:CreateToggle({
   Name = "Auto Farm Mobs",
   CurrentValue = false,
   Flag = "AutoFarmFlag",
   Callback = function(Value)
       AutoFarm = Value
       
       task.spawn(function()
           while AutoFarm do
               -- ใส่ระบบวาป/โจมตีมอนสเตอร์
               print("[HelloHUB] Auto Farming...")
               task.wait(0.5)
           end
       end)
   end,
})

-- 2. แท็บ Player (ปรับแต่งตัวละคร)
local PlayerTab = Window:CreateTab("Player", 4483362458)

local WalkSpeedSlider = PlayerTab:CreateSlider({
   Name = "Walk Speed (ความเร็วการเดิน)",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeedFlag",
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- 3. แท็บ Anti-AFK (ป้องกันการหลุด)
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateButton({
   Name = "Enable Anti-AFK",
   Callback = function()
       local VirtualUser = game:GetService("VirtualUser")
       game.Players.LocalPlayer.Idled:Connect(function()
           VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
           task.wait(1)
           VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
       end)
       
       Rayfield:Notify({
          Title = "HelloHUB",
          Content = "Anti-AFK เปิดใช้งานเรียบร้อยแล้ว!",
          Duration = 3,
          Image = 4483362458,
       })
   end,
})

-- แจ้งเตือนเมื่อโหลดสคริปต์เสร็จสมบูรณ์
Rayfield:Notify({
   Title = "HelloHUB Loaded!",
   Content = "ยินดีต้อนรับสู่ HelloHUB - Anime Astral Simulator",
   Duration = 5,
   Image = 4483362458,
})
