local UILib = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- สร้าง Main Frame สำหรับ UI
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.5, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 10)
MainFrameCorner.Parent = MainFrame

-- สร้างปุ่ม Toggle เพื่อเปิด/ปิด UI
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.2, 0, 0.05, 0)
ToggleButton.Position = UDim2.new(0.4, 0, 0.05, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "Open UI"
ToggleButton.Parent = ScreenGui

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleButton.Text = "Close UI"
    else
        ToggleButton.Text = "Open UI"
    end
end)

-- สร้างหมวดหมู่
local function CreateCategory(name)
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, -20, 0, 200)
    CategoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CategoryFrame.Parent = MainFrame
    
    local CategoryTitle = Instance.new("TextLabel")
    CategoryTitle.Size = UDim2.new(1, -10, 0, 30)
    CategoryTitle.Position = UDim2.new(0, 5, 0, 5)
    CategoryTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CategoryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryTitle.Text = name
    CategoryTitle.TextScaled = true
    CategoryTitle.Parent = CategoryFrame
    
    local CategoryScroll = Instance.new("ScrollingFrame")
    CategoryScroll.Size = UDim2.new(1, -10, 1, -40)
    CategoryScroll.Position = UDim2.new(0, 5, 0, 35)
    CategoryScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CategoryScroll.ScrollBarThickness = 8
    CategoryScroll.Parent = CategoryFrame
    
    local CategoryLayout = Instance.new("UIListLayout")
    CategoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CategoryLayout.Padding = UDim.new(0, 10)
    CategoryLayout.Parent = CategoryScroll
    
    return CategoryScroll
end

-- ฟังก์ชันสร้างปุ่ม
function UILib.CreateButton(categoryScroll, text)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Parent = categoryScroll
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    return Button
end

-- ฟังก์ชันสร้าง Toggle
function UILib.CreateToggle(categoryScroll, text, initialState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 50)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleFrame.Parent = categoryScroll
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Size = UDim2.new(0, 20, 1, -10)
    ToggleIndicator.Position = UDim2.new(1, -30, 0, 5)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ToggleIndicator.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, -30, 1, 0)
    ToggleButton.Position = UDim2.new(0, 5, 0, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Text = text
    ToggleButton.Parent = ToggleFrame
    
    local ToggleState = initialState
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        ToggleState = not ToggleState
        if ToggleState then
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            ToggleButton.Text = text .. " (On)"
        else
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            ToggleButton.Text = text .. " (Off)"
        end
        if callback then callback(ToggleState) end
    end)
    
    return ToggleButton
end

-- ฟังก์ชันสร้าง Slider
function UILib.CreateSlider(categoryScroll, min, max, default, text, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderFrame.Parent = categoryScroll
    
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

-- ฟังก์ชันสร้าง Label
function UILib.CreateLabel(categoryScroll, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 40)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = text
    Label.Parent = categoryScroll
    return Label
end

-- ตัวอย่างการใช้งาน
local generalCategory = CreateCategory("General")
UILib.CreateButton(generalCategory, "General Button")
UILib.CreateToggle(generalCategory, "General Toggle", false, function(state)
    print("General Toggle state:", state)
end)
UILib.CreateSlider(generalCategory, 0, 100, 50, "General Slider", function(value)
    print("General Slider value:", value)
end)
UILib.CreateLabel(generalCategory, "General Label")

local settingsCategory = CreateCategory("Settings")
UILib.CreateButton(settingsCategory, "Settings Button")
UILib.CreateToggle(settingsCategory, "Settings Toggle", true, function(state)
    print("Settings Toggle state:", state)
end)
UILib.CreateSlider(settingsCategory, 0, 200, 100, "Settings Slider", function(value)
    print("Settings Slider value:", value)
end)
UILib.CreateLabel(settingsCategory, "Settings Label")

return UILib
