
-- TARHUB SPEED CONTROL
-- เพิ่มต่อท้ายโค้ดเมนูเดิม

local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.fromOffset(460, 75)
speedFrame.Position = UDim2.fromOffset(20, 175)
speedFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 45)
speedFrame.Parent = panel

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 28)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "CART SPEED: 35"
speedLabel.TextColor3 = Color3.fromRGB(0, 255, 220)
speedLabel.Font = Enum.Font.Arcade
speedLabel.TextScaled = true
speedLabel.Parent = speedFrame

local minus = Instance.new("TextButton")
minus.Size = UDim2.fromOffset(55, 35)
minus.Position = UDim2.fromOffset(5, 33)
minus.Text = "-"
minus.TextScaled = true
minus.Parent = speedFrame

local plus = Instance.new("TextButton")
plus.Size = UDim2.fromOffset(55, 35)
plus.Position = UDim2.new(1, -60, 0, 33)
plus.Text = "+"
plus.TextScaled = true
plus.Parent = speedFrame

local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, -135, 0, 10)
bar.Position = UDim2.fromOffset(68, 46)
bar.BackgroundColor3 = Color3.fromRGB(80, 50, 120)
bar.Parent = speedFrame

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0.3, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(255, 30, 180)
fill.Parent = bar

local speed = 35
local MIN_SPEED = 10
local MAX_SPEED = 100

local function updateSpeed()
    speedLabel.Text = "CART SPEED: " .. speed
    fill.Size = UDim2.new(
        (speed - MIN_SPEED) / (MAX_SPEED - MIN_SPEED),
        0, 1, 0
    )

    -- นำค่า speed ไปเชื่อมกับระบบรถเข็นของเกมที่คุณสร้างเอง
end

minus.Activated:Connect(function()
    speed = math.max(MIN_SPEED, speed - 5)
    updateSpeed()
end)

plus.Activated:Connect(function()
    speed = math.min(MAX_SPEED, speed + 5)
    updateSpeed()
end)

updateSpeed()
