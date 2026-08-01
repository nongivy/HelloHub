-- ======================================================
--  HelloHUB - Anime Astral Simulator
-- ======================================================

-- โหลด Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้างหน้าต่างหลัก
local Window = Rayfield:CreateWindow({
   Name = "HelloHUB | Anime Astral Simulator",
   LoadingTitle = "HelloHUB is Loading...",
   LoadingSubtitle = "by HelloHUB Team",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HelloHUB_Configs",
      FileName = "AnimeAstral"
   },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Services & Remote Events
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Remotes (อ้างอิงตามโครงสร้างเกม)
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5) or ReplicatedStorage:WaitForChild("Packages", 5)

-- ======================================================
--  VARIABLES (ตัวแปรสำหรับเปิด/ปิดระบบ)
-- ======================================================
local AutoClick = false
local AutoFarm = false
local AutoCollect = false
local SelectedEgg = "Basic"
local AutoHatch = false

-- ======================================================
--  TABS & SECTIONS
-- ======================================================

-- [ Tab 1: Main Farming ]
local MainTab = Window:CreateTab("Main Farm", 4483362458)
MainTab:CreateSection("Auto Farming Options")

-- Auto Click / Swing
MainTab:CreateToggle({
   Name = "Auto Click / Attack (โจมตีอัตโนมัติ)",
   CurrentValue = false,
   Flag = "AutoClick",
   Callback = function(Value)
       AutoClick = Value
       task.spawn(function()
           while AutoClick do
               -- ส่งคำสั่งกดคลิก/โจมตีไปยังเซิร์ฟเวอร์
               pcall(function()
                   if Remotes and Remotes:FindFirstChild("Click") then
                       Remotes.Click:FireServer()
                   elseif Remotes and Remotes:FindFirstChild("Swing") then
                       Remotes.Swing:FireServer()
                   end
               end)
               task.wait(0.1)
           end
       end)
   end,
})

-- Auto Collect Drops/Coins
MainTab:CreateToggle({
   Name = "Auto Collect Gems/Coins (เก็บของอัตโนมัติ)",
   CurrentValue = false,
   Flag = "AutoCollect",
   Callback = function(Value)
       AutoCollect = Value
       task.spawn(function()
           while AutoCollect do
               pcall(function()
                   for _, v in pairs(workspace:GetChildren()) do
                       if v:IsA("BasePart") and (v.Name == "Coin" or v.Name == "Gem" or v.Name == "Orb") then
                           v.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                       end
                   end
               end)
               task.wait(0.5)
           end
       end)
   end,
})

-- [ Tab 2: Eggs & Hatching ]
local EggTab = Window:CreateTab("Eggs", 4483362458)
EggTab:CreateSection("Auto Hatch")

EggTab:CreateDropdown({
   Name = "Select Egg (เลือกไข่)",
   Options = {"Basic Egg", "Rare Egg", "Epic Egg", "Astral Egg"},
   CurrentOption = {"Basic Egg"},
   MultipleOptions = false,
   Flag = "EggDropdown",
   Callback = function(Option)
       SelectedEgg = Option[1]
   end,
})

EggTab:CreateToggle({
   Name = "Auto Hatch (สุ่มตัวละครอัตโนมัติ)",
   CurrentValue = false,
   Flag = "AutoHatch",
   Callback = function(Value)
       AutoHatch = Value
       task.spawn(function()
           while AutoHatch do
               pcall(function()
                   if Remotes and Remotes:FindFirstChild("HatchEgg") then
                       Remotes.HatchEgg:FireServer(SelectedEgg, 1)
                   end
               end)
               task.wait(0.5)
           end
       end)
   end,
})

-- [ Tab 3: Player Settings ]
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSection("Player Stat Modifiers")

PlayerTab:CreateSlider({
   Name = "WalkSpeed (ความเร็วการเดิน)",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = Value
       end
   end,
})

PlayerTab:CreateSlider({
   Name = "JumpPower (ความสูงการกระโดด)",
   Range = {50, 300},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.JumpPower = Value
       end
   end,
})

-- [ Tab 4: Misc & Utility ]
local MiscTab = Window:CreateTab("Misc", 4483362458)
MiscTab:CreateSection("Utilities")

MiscTab:CreateButton({
   Name = "Enable Anti-AFK (กันหลุด 20 นาที)",
   Callback = function()
       local VirtualUser = game:GetService("VirtualUser")
       LocalPlayer.Idled:Connect(function()
           VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
           task.wait(1)
           VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
       end)
       
       Rayfield:Notify({
          Title = "HelloHUB System",
          Content = "ระบบ Anti-AFK เริ่มทำงานแล้ว!",
          Duration = 3,
          Image = 4483362458,
       })
   end,
})

-- แจ้งเตือนเมื่อโหลดสคริปต์สำเร็จ
Rayfield:Notify({
   Title = "HelloHUB Loaded!",
   Content = "พร้อมใช้งานสำหรับ Anime Astral Simulator แล้ว",
   Duration = 4,
   Image = 4483362458,
})
