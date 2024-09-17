-- เรียกใช้งาน Players
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- สร้าง TextLabel ที่แสดงข้อมูลทางด้านขวาบน
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(0, 300, 0, 50)
InfoText.Position = UDim2.new(1, -310, 0, 10)
InfoText.BackgroundTransparency = 1
InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoText.TextScaled = true
InfoText.Text = "Active Toggles: None"
InfoText.Parent = ScreenGui

-- ตัวเก็บสถานะของปุ่มที่เปิดอยู่ (เฉพาะ Toggle)
local activeToggles = {}

-- ฟังก์ชันอัปเดต InfoText
local function UpdateInfoText()
    local toggledOptions = {}
    for option, state in pairs(activeToggles) do
        if state then
            table.insert(toggledOptions, option)
        end
    end
    InfoText.Text = #toggledOptions > 0 and "Active Toggles: " .. table.concat(toggledOptions, ", ") or "Active Toggles: None"
end

-- ฟังก์ชันสร้าง Gradient Color สีม่วง
local function CreatePurpleGradient()
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)), -- สีม่วงเข้ม
        ColorSequenceKeypoint.new(1, Color3.fromRGB(186, 85, 211))  -- สีม่วงอ่อน
    })
    return gradient
end

-- สร้าง UI หลัก (Scrolling Frame แทน Frame ปกติ)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 400)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = false  -- ซ่อนเฟรมหลักเริ่มต้น
MainFrame.Parent = ScreenGui

-- เพิ่ม Corner และ Stroke ให้กับ MainFrame
local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 10)
MainFrameCorner.Parent = MainFrame

local MainFrameStroke = Instance.new("UIStroke")
MainFrameStroke.Color = Color3.fromRGB(255, 255, 255)
MainFrameStroke.Thickness = 2
MainFrameStroke.Parent = MainFrame

local mainGradient = CreatePurpleGradient()
mainGradient.Parent = MainFrame

-- สร้างปุ่ม Toggle ที่เปิด/ปิด
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 40)  -- ขนาดเล็กลง
ToggleButton.Position = UDim2.new(0.5, -50, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- สีพื้นหลังของปุ่ม
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "Open"  -- เริ่มต้นเป็น "Open"
ToggleButton.Parent = ScreenGui

-- เพิ่ม Gradient สีม่วงให้กับปุ่ม Toggle
local buttonGradient = CreatePurpleGradient()
buttonGradient.Parent = ToggleButton

-- ฟังก์ชันเปิด/ปิดเฟรม
ToggleButton.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
        ToggleButton.Text = "Open"
    else
        MainFrame.Visible = true
        ToggleButton.Text = "Close"
    end
end)

-- สร้าง Scroll Frame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 10
ScrollFrame.Parent = MainFrame

-- เพิ่ม UIListLayout และ UIPadding ให้กับ ScrollFrame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.Parent = ScrollFrame

-- สร้าง InfoFrame
local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(0, 200, 0, 100)
InfoFrame.Position = UDim2.new(1, -210, 0, 10)
InfoFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InfoFrame.Visible = false  -- เริ่มต้นซ่อน InfoFrame
InfoFrame.Parent = ScreenGui

-- เพิ่ม Corner และ Stroke ให้กับ InfoFrame
local InfoFrameCorner = Instance.new("UICorner")
InfoFrameCorner.CornerRadius = UDim.new(0, 10)
InfoFrameCorner.Parent = InfoFrame

local InfoFrameStroke = Instance.new("UIStroke")
InfoFrameStroke.Color = Color3.fromRGB(255, 255, 255)
InfoFrameStroke.Thickness = 2
InfoFrameStroke.Parent = InfoFrame

local infoGradient = CreatePurpleGradient()
infoGradient.Parent = InfoFrame

-- เพิ่ม UIPadding ให้กับ InfoFrame
local InfoFramePadding = Instance.new("UIPadding")
InfoFramePadding.PaddingTop = UDim.new(0, 10)
InfoFramePadding.PaddingBottom = UDim.new(0, 10)
InfoFramePadding.PaddingLeft = UDim.new(0, 10)
InfoFramePadding.PaddingRight = UDim.new(0, 10)
InfoFramePadding.Parent = InfoFrame

-- สร้างคำอธิบาย
local DescriptionText = Instance.new("TextLabel")
DescriptionText.Size = UDim2.new(1, 0, 0.6, 0)
DescriptionText.Position = UDim2.new(0, 0, 0, 0)
DescriptionText.BackgroundTransparency = 1
DescriptionText.TextColor3 = Color3.fromRGB(255, 255, 255)
DescriptionText.TextScaled = true
DescriptionText.Text = "Toggle Description"
DescriptionText.Parent = InfoFrame

-- สร้างปุ่ม Toggle ใน InfoFrame
local ToggleButtonInInfo = Instance.new("TextButton")
ToggleButtonInInfo.Size = UDim2.new(1, 0, 0.4, 0)
ToggleButtonInInfo.Position = UDim2.new(0, 0, 0.6, 0)
ToggleButtonInInfo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButtonInInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButtonInInfo.Text = "Toggle OFF"
ToggleButtonInInfo.Parent = InfoFrame

-- ฟังก์ชันสร้างปุ่ม Toggle
local function CreateToggle(optionText, onToggleOn, onToggleOff)
    -- สร้างปุ่ม Toggle
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 120, 0, 50)
    ToggleButton.Text = optionText
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- สีพื้นหลังของปุ่ม
    ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)  -- ข้อความสีดำ
    ToggleButton.Parent = ScrollFrame

    -- เพิ่ม Corner และ Stroke ให้กับ ToggleButton
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = ToggleButton

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
    ButtonStroke.Thickness = 2
    ButtonStroke.Parent = ToggleButton

    -- สร้างแถบสีซ้ายเพื่อแสดงสถานะ Toggle
    local StatusBar = Instance.new("Frame")
    StatusBar.Size = UDim2.new(0, 6, 1, 0)
    StatusBar.Position = UDim2.new(0, 0, 0, 0)
    StatusBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- เริ่มต้นเป็นสีแดง (ปิด)
    StatusBar.Parent = ToggleButton
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 3)
    StatusCorner.Parent = StatusBar

    -- เพิ่ม Padding ให้กับ ToggleButton
    local ButtonPadding = Instance.new("UIPadding")
    ButtonPadding.PaddingTop = UDim.new(0, 5)
    ButtonPadding.PaddingBottom = UDim.new(0, 5)
    ButtonPadding.PaddingLeft = UDim.new(0, 5)
    ButtonPadding.PaddingRight = UDim.new(0, 5)
    ButtonPadding.Parent = ToggleButton

    -- ฟังก์ชันเมื่อกด Toggle
    ToggleButton.MouseButton1Click:Connect(function()
        -- เปลี่ยนสถานะของ Toggle
        local newState = not activeToggles[optionText]
        activeToggles[optionText] = newState

        -- อัปเดตแถบสีตามสถานะ
        if newState then
            StatusBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- สีเขียวเมื่อเปิด
            if onToggleOn then
                onToggleOn()  -- เรียกฟังก์ชันเมื่อเปิด Toggle
            end
            -- อัปเดต InfoFrame
            InfoFrame.Visible = true
            DescriptionText.Text = optionText .. " is ON"
            ToggleButtonInInfo.Text = "Toggle ON"
            ToggleButtonInInfo.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            StatusBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- สีแดงเมื่อปิด
            if onToggleOff then
                onToggleOff()  -- เรียกฟังก์ชันเมื่อปิด Toggle
            end
            -- อัปเดต InfoFrame
            InfoFrame.Visible = false
            DescriptionText.Text = optionText .. " is OFF"
            ToggleButtonInInfo.Text = "Toggle OFF"
            ToggleButtonInInfo.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end

        -- อัปเดต InfoText
        UpdateInfoText()
    end)
end

-- สร้าง Toggle ที่มีฟังก์ชันเปิด-ปิด
CreateToggle("Auto Clicker", function()
    print("Auto Clicker is ON")
end, function()
    print("Auto Clicker is OFF")
end)

CreateToggle("Kill Aura", function()
    print("Kill Aura is ON")
end, function()
    print("Kill Aura is OFF")
end)

CreateToggle("ESP", function()
    print("ESP is ON")
end, function()
    print("ESP is OFF")
end)

-- ฟังก์ชันการทำงานเพื่อป้องกันการรีเซ็ต UI เมื่อตาย
local function OnCharacterAdded(character)
    -- ป้องกันการรีเซ็ต UI
    local uiClone = ScreenGui:Clone()
    uiClone.Parent = player:WaitForChild("PlayerGui")
end

player.CharacterAdded:Connect(OnCharacterAdded)
