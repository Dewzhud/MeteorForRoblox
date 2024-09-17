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

    -- เพิ่ม ScrollFrame สำหรับหมวดหมู่
    local CategoryScroll = CreateUIElement("ScrollingFrame", CategoryFrame, {
        Size = UDim2.new(1, 0, 1, -50),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        ScrollBarThickness = 8,
        CanvasSize = UDim2.new(0, 0, 1, 0),
        ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
    })

    local Layout = CreateUIElement("UIListLayout", CategoryScroll, {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })

    UILib.Categories[name].ScrollFrame = CategoryScroll
end

-- ฟังก์ชันสำหรับสร้างปุ่ม
function UILib.CreateButton(category, text)
    local CategoryFrame = UILib.Categories[category]
    if not CategoryFrame then return end

    local Button = CreateUIElement("TextButton", CategoryFrame.ScrollFrame, {
        Size = UDim2.new(1, -10, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = text,
        LayoutOrder = #CategoryFrame.ScrollFrame:GetChildren() + 1
    })

    local ButtonCorner = CreateUIElement("UICorner", Button, {
        CornerRadius = UDim.new(0, 8)
    })

    return Button
end

-- ฟังก์ชันสำหรับสร้าง Toggle
function UILib.CreateToggle(category, text, initialState, callback)
    local CategoryFrame = UILib.Categories[category]
    if not CategoryFrame then return end

    local ToggleFrame = CreateUIElement("Frame", CategoryFrame.ScrollFrame, {
        Size = UDim2.new(1, -10, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        LayoutOrder = #CategoryFrame.ScrollFrame:GetChildren() + 1
    })

    local ToggleState = Instance.new("BoolValue")
    ToggleState.Value = initialState

    local ToggleText = CreateUIElement("TextButton", ToggleFrame, {
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = text,
        LayoutOrder = 1
    })

    local StatusBar = CreateUIElement("Frame", ToggleFrame, {
        Size = UDim2.new(0.2, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 255, 0),
        Position = UDim2.new(0.8, 0, 0, 0)
    })

    local ToggleCorner = CreateUIElement("UICorner", ToggleText, {
        CornerRadius = UDim.new(0, 8)
    })

    ToggleText.MouseButton1Click:Connect(function()
        ToggleState.Value = not ToggleState.Value
        if ToggleState.Value then
            ToggleText.Text = text .. " (On)"
            StatusBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            if callback then callback(true) end
        else
            ToggleText.Text = text .. " (Off)"
            StatusBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            if callback then callback(false) end
        end
    end)

    return ToggleFrame
end

-- ฟังก์ชันสำหรับสร้าง Slider
function UILib.CreateSlider(category, min, max, default, text, callback)
    local CategoryFrame = UILib.Categories[category]
    if not CategoryFrame then return end

    local SliderFrame = CreateUIElement("Frame", CategoryFrame.ScrollFrame, {
        Size = UDim2.new(1, -10, 0, 70),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        LayoutOrder = #CategoryFrame.ScrollFrame:GetChildren() + 1
    })

    local SliderText = CreateUIElement("TextLabel", SliderFrame, {
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = text .. ": " .. default
    })

    local Slider = CreateUIElement("TextBox", SliderFrame, {
        Size = UDim2.new(1, -10, 0, 25),
        Position = UDim2.new(0, 5, 1, -30),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Text = tostring(default)
    })

    Slider.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local value = tonumber(Slider.Text)
            if value then
                value = math.clamp(value, min, max)
                SliderText.Text = text .. ": " .. tostring(value)
                if callback then callback(value) end
            end
        end
    end)

    return SliderFrame
end

-- ฟังก์ชันสำหรับสร้าง Label
function UILib.CreateLabel(category, text)
    local CategoryFrame = UILib.Categories[category]
    if not CategoryFrame then return end

    local Label = CreateUIElement("TextLabel", CategoryFrame.ScrollFrame, {
        Size = UDim2.new(1, -10, 0, 40),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = text,
        LayoutOrder = #CategoryFrame.ScrollFrame:GetChildren() + 1
    })

    return Label
end

-- สร้าง UI หลัก
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

CreateUIElement("UICorner", UILib.MainFrame, {
    CornerRadius = UDim.new(0, 10)
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
    if UILib.MainFrame.Visible then
        ToggleButton.Text = "Close UI"
    else
        ToggleButton.Text = "Open UI"
    end
end)

return UILib
