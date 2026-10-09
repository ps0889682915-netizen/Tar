-- ==========================================
-- 👾 TARHUB - RETRO ARCADE SCRIPT
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ลบ UI เก่าถ้ามีอยู่
if game.CoreGui:FindFirstChild("TARHUB_Gui") then
    game.CoreGui.TARHUB_Gui:Destroy()
end

-- 1. สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TARHUB_Gui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 2. สร้างกรอบหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25) -- สีดำอมม่วงตู้เกมส์
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 128) -- ขอบชมพูนีออน
MainFrame.BorderSizePixel = 4
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

-- หัวข้อ (Title Header)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 128)
TitleLabel.BorderColor3 = Color3.fromRGB(255, 255, 0)
TitleLabel.BorderSizePixel = 2
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.Arcade
TitleLabel.Text = "👾 TARHUB 👾"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 22
TitleLabel.TextStrokeTransparency = 0

-- 3. ปุ่มย่อ/เปิดปิด เมนู (Toggle Menu Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 128)
ToggleButton.BorderColor3 = Color3.fromRGB(0, 255, 255)
ToggleButton.BorderSizePixel = 3
ToggleButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0, 80, 0, 35)
ToggleButton.Font = Enum.Font.Arcade
ToggleButton.Text = "👾 TARHUB"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Active = true
ToggleButton.Draggable = true

local menuVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

-- ฟังก์ชันช่วยสร้างปุ่มสไตล์ Arcade
local function CreateArcadeButton(name, text, posY, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = MainFrame
    btn.BackgroundColor3 = color
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 3
    btn.Position = UDim2.new(0.08, 0, 0, posY)
    btn.Size = UDim2.new(0.84, 0, 0, 45)
    btn.Font = Enum.Font.Arcade
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    return btn
end

-- ==========================================
-- ⚙️ สถานะระบบ (STATES)
-- ==========================================
local isSpeedOn = false
local isAntiFallOn = false
local isTrainFireOn = false
local platformPart = nil

-- 1. ปุ่ม Speed Hack
local SpeedBtn = CreateArcadeButton("SpeedBtn", "⚡ SPEED : OFF", 55, Color3.fromRGB(40, 40, 60))
SpeedBtn.MouseButton1Click:Connect(function()
    isSpeedOn = not isSpeedOn
    if isSpeedOn then
        SpeedBtn.Text = "⚡ SPEED : ON"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        SpeedBtn.Text = "⚡ SPEED : OFF"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- Loop อัปเดตความเร็ว
RunService.RenderStepped:Connect(function()
    if isSpeedOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 60 -- ปรับความเร็วตามต้องการ
    end
end)

-- 2. ปุ่ม กันตก 100% (Anti-Fall)
local AntiFallBtn = CreateArcadeButton("AntiFallBtn", "🛡️ ANTI-FALL : OFF", 115, Color3.fromRGB(40, 40, 60))
AntiFallBtn.MouseButton1Click:Connect(function()
    isAntiFallOn = not isAntiFallOn
    if isAntiFallOn then
        AntiFallBtn.Text = "🛡️ ANTI-FALL : ON"
        AntiFallBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        
        -- สร้างแผ่นรองรับใต้เท้า
        platformPart = Instance.new("Part")
        platformPart.Size = Vector3.new(15, 1, 15)
        platformPart.Anchored = true
        platformPart.Transparency = 0.5
        platformPart.Color = Color3.fromRGB(255, 0, 128)
        platformPart.Material = Enum.Material.Neon
        platformPart.Parent = workspace
    else
        AntiFallBtn.Text = "🛡️ ANTI-FALL : OFF"
        AntiFallBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        if platformPart then
            platformPart:Destroy()
            platformPart = nil
        end
    end
end)

-- Loop ปรับตำแหน่งแผ่นกันตกให้อยู่ใต้ตัวผู้เล่นตลอดเวลา
RunService.Heartbeat:Connect(function()
    if isAntiFallOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if platformPart then
            platformPart.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
        end
    end
end)

-- 3. ปุ่มยิงปืนรถไฟ (Train Auto-Fire)
local TrainFireBtn = CreateArcadeButton("TrainFireBtn", "🚂 TRAIN FIRE : OFF", 175, Color3.fromRGB(40, 40, 60))
TrainFireBtn.MouseButton1Click:Connect(function()
    isTrainFireOn = not isTrainFireOn
    if isTrainFireOn then
        TrainFireBtn.Text = "🚂 TRAIN FIRE : ON"
        TrainFireBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    else
        TrainFireBtn.Text = "🚂 TRAIN FIRE : OFF"
        TrainFireBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end
end)

-- Loop ยิงปืนรถไฟอัตโนมัติ (จำลองการกดรัวๆ หรือสั่งงาน Tool ยิง)
task.spawn(function()
    while true do
        task.wait(0.1)
        if isTrainFireOn and LocalPlayer.Character then
            -- ลองสั่งคุมปืนหรือเครื่องมือที่ถืออยู่
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
            
            -- ค้นหา Event ยิงปืนในตัวรถไฟ (ถ้ามีอยู่ในเกม)
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:lower():find("fire") or v.Name:lower():find("shoot") or v.Name:lower():find("train")) then
                    v:FireServer()
                end
            end
        end
    end
end)

-- ปุ่มปิดเมนูทั้งหมด
local CloseBtn = CreateArcadeButton("CloseBtn", "❌ CLOSE", 240, Color3.fromRGB(200, 30, 30))
CloseBtn.MouseButton1Click:Connect(function()
    if platformPart then platformPart:Destroy() end
    ScreenGui:Destroy()
end)
