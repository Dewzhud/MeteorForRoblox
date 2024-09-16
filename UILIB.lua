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

-- สร้างปุ่มปิด
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.Parent = MainFrame

-- ฟังก์ชันปิดเฟรม
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- สร้างปุ่มเปิด
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 100, 0, 30)
OpenButton.Position = UDim2.new(0.5, -50, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Text = "Open UI"
OpenButton.Parent = ScreenGui

-- ฟังก์ชันเปิดเฟรม
OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
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

-- ฟังก์ชันสร้างปุ่ม Toggle
local function CreateToggle(optionText, onToggleOn, onToggleOff)
    -- สร้างปุ่ม Toggle
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 120, 0, 50)
    ToggleButton.Text = optionText
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)  -- สีข้อความเป็นสีดำ
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
        else
            StatusBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- สีแดงเมื่อปิด
            if onToggleOff then
                onToggleOff()  -- เรียกฟังก์ชันเมื่อปิด Toggle
            end
        end

        -- อัปเดต InfoText
        UpdateInfoText()
    end)
end

-- ฟังก์ชันตัวอย่างที่เรียกเมื่อ Toggle ถูกเปิด
local function ToggleOnAutoClicker()
    print("Auto Clicker is ON")
    -- ใส่โค้ดที่ต้องการเมื่อ Toggle Auto Clicker เปิดที่นี่
end

-- ฟังก์ชันตัวอย่างที่เรียกเมื่อ Toggle ถูกปิด
local function ToggleOffAutoClicker()
    print("Auto Clicker is OFF")
    -- ใส่โค้ดที่ต้องการเมื่อ Toggle Auto Clicker ปิดที่นี่
end-- สร้าง Toggle แต่ละตัว โดยส่งฟังก์ชันที่ต่างกัน
CreateToggle("Auto Clicker", ToggleOnAutoClicker, ToggleOffAutoClicker)
CreateToggle("Kill Aura", function()
    print("Kill Aura is ON")
    -- ใส่โค้ดที่ต้องการเมื่อ Toggle Kill Aura เปิดที่นี่
end, function()
    print("Kill Aura is OFF")
    -- ใส่โค้ดที่ต้องการเมื่อ Toggle Kill Aura ปิดที่นี่
end)
CreateToggle("ESP", function()
    print("ESP is ON")
    -- ใส่โค้ดที่ต้องการเมื่อ Toggle ESP เปิดที่นี่
end, function()
    print("ESP is OFF")
    -- ใส่โค้ดที่ต้องการเมื่อ Toggle ESP ปิดที่นี่
end)

-- เพิ่ม Toggle อื่น ๆ ตามต้องการ
