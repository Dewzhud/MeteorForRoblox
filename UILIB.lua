-- โหลด UILib
local UILib = {}

-- ฟังก์ชันสำหรับสร้าง UI Elements
local function CreateUIElement(type, parent, properties)
    local element = Instance.new(type)
    for property, value in pairs(properties) do
        element[property] = value
    end
    element.Parent = parent
    return element
end

-- ฟังก์ชันสำหรับสร้างหมวดหมู่
function UILib.CreateCategory(name)
    local CategoryFrame = CreateUIElement("Frame", UILib.MainFrame, {
        Size = UDim2.new(1, 0, 0, 200),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        LayoutOrder = #UILib.Categories + 1
    })
    
    UILib.Categories[name] = CategoryFrame

    CreateUIElement("TextLabel", CategoryFrame, {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = name,
        TextSize = 20,
        TextStrokeTransparency = 0.5
    })
end

-- ฟังก์ชันสำหรับสร้างปุ่ม
function UILib.CreateButton(category, text)
    local CategoryFrame = UILib.Categories[category]
    if not CategoryFrame then return end

    local Button = CreateUIElement("TextButton", CategoryFrame, {
        Size = UDim2.new(1, -10, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = text,
    })
end

-- ฟังก์ชันสำหรับสร้าง Toggle
function UILib.CreateToggle(category, text, initialState, callback)
    local CategoryFrame = UILib.Categories[category]
    if not CategoryFrame then return end

    local ToggleFrame = CreateUIElement("Frame", CategoryFrame, {
        Size = UDim2.new(1, -10, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    })

    local ToggleState = Instance.new("BoolValue")
    ToggleState.Value = initialState

    local ToggleText = CreateUIElement("TextButton", ToggleFrame, {
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = text,
    })

    local StatusBar = CreateUIElement("Frame", ToggleFrame, {
        Size = UDim2.new(0.2, 0, 1, 0),
        BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0),
        Position = UDim2.new(0.8, 0, 0, 0)
    })

    ToggleText.MouseButton1Click:Connect(function()
        ToggleState.Value = not ToggleState.Value
        if ToggleState.Value then
            StatusBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            if callback then callback(true) end
        else
            StatusBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            if callback then callback(false) end
        end
    end)
end

-- ฟังก์ชันสำหรับสร้าง UI หลัก
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

UILib.MainFrame = CreateUIElement("Frame", ScreenGui, {
    Size = UDim2.new(0.5, 0, 0.6, 0),
    Position = UDim2.new(0.25, 0, 0.2, 0),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    Visible = false
})

local ToggleButton = CreateUIElement("TextButton", ScreenGui, {
    Size = UDim2.new(0.2, 0, 0.05, 0),
    Position = UDim2.new(0.4, 0, 0.05, 0),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Text = "Open UI"
})

ToggleButton.MouseButton1Click:Connect(function()
    UILib.MainFrame.Visible = not UILib.MainFrame.Visible
    ToggleButton.Text = UILib.MainFrame.Visible and "Close UI" or "Open UI"
end)

-- เก็บหมวดหมู่
UILib.Categories = {}

return UILib
