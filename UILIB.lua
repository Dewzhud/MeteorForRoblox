-- UILib Module
local UILib = {}
UILib.__index = UILib

-- สร้างและกำหนดค่าหมวดหมู่
function UILib.CreateCategory(name)
    -- สร้าง CategoryFrame
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 0, 50)
    CategoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CategoryFrame.Name = name
    CategoryFrame.Parent = UILib.MainFrame

    -- สร้าง Label สำหรับชื่อหมวดหมู่
    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Size = UDim2.new(1, 0, 1, 0)
    CategoryLabel.BackgroundTransparency = 1
    CategoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryLabel.Text = name
    CategoryLabel.Parent = CategoryFrame

    -- สร้าง ScrollingFrame สำหรับหมวดหมู่
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, 0, 1, -50)
    ScrollFrame.Position = UDim2.new(0, 0, 0, 50)
    ScrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ScrollFrame.ScrollBarThickness = 8
    ScrollFrame.Parent = CategoryFrame

    -- สร้าง Layout สำหรับ ScrollingFrame
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 10)
    Layout.Parent = ScrollFrame

    UILib[name] = ScrollFrame
end

-- สร้างปุ่ม
function UILib.CreateButton(category, text)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Parent = UILib[category]

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    return Button
end

-- สร้าง Toggle
function UILib.CreateToggle(category, text, initialState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 50)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleFrame.Parent = UILib[category]

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.8, -10, 1, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Text = text .. (initialState and " (On)" or " (Off)")
    ToggleButton.Parent = ToggleFrame

    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Size = UDim2.new(0.2, 0, 1, 0)
    ToggleIndicator.Position = UDim2.new(0.8, 0, 0, 0)
    ToggleIndicator.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ToggleIndicator.Parent = ToggleFrame

    local ToggleState = initialState

    ToggleButton.MouseButton1Click:Connect(function()
        ToggleState = not ToggleState
        ToggleButton.Text = text .. (ToggleState and " (On)" or " (Off)")
        ToggleIndicator.BackgroundColor3 = ToggleState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        if callback then callback(ToggleState) end
    end)

    return ToggleButton
end

-- สร้าง Slider
function UILib.CreateSlider(category, min, max, default, text, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderFrame.Parent = UILib[category]

    local SliderText = Instance.new("TextLabel")
    SliderText.Size = UDim2.new(1, -10, 0, 30)
    SliderText.Position = UDim2.new(0, 5, 0, 5)
    SliderText.BackgroundTransparency = 1
    SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderText.Text = text .. ": " .. default
    SliderText.Parent = SliderFrame

    local Slider = Instance.new("TextBox")
    Slider.Size = UDim2.new(1, -10, 0, 25)
    Slider.Position = UDim2.new(0, 5, 1, -30)
    Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Slider.Text = tostring(default)
    Slider.Parent = SliderFrame

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

    return Slider
end

-- สร้าง Label
function UILib.CreateLabel(category, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 40)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = text
    Label.Parent = UILib[category]
    return Label
end

-- สร้าง MainFrame
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

UILib.MainFrame = Instance.new("Frame")
UILib.MainFrame.Size = UDim2.new(0.5, 0, 0.6, 0)
UILib.MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
UILib.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UILib.MainFrame.Visible = false
UILib.MainFrame.Parent = ScreenGui

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 10)
MainFrameCorner.Parent = UILib.MainFrame

return UILib
