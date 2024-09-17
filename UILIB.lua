-- UILib.lua

-- ฟังก์ชันสำหรับสร้าง UI
local UILib = {}

-- สร้าง ScreenGui และ Main Frame
local function CreateScreenGui()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.5, 0, 0.6, 0)
    MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui

    local MainFrameCorner = Instance.new("UICorner")
    MainFrameCorner.CornerRadius = UDim.new(0, 10)
    MainFrameCorner.Parent = MainFrame

    return ScreenGui, MainFrame
end

local ScreenGui, MainFrame = CreateScreenGui()

-- สร้าง ScrollFrame สำหรับหมวดหมู่
local CategoryScroll = Instance.new("ScrollingFrame")
CategoryScroll.Size = UDim2.new(1, -20, 1, -20)
CategoryScroll.Position = UDim2.new(0, 10, 0, 10)
CategoryScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CategoryScroll.ScrollBarThickness = 8
CategoryScroll.Parent = MainFrame

local CategoryLayout = Instance.new("UIListLayout")
CategoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
CategoryLayout.Padding = UDim.new(0, 10)
CategoryLayout.Parent = CategoryScroll

-- ฟังก์ชันสำหรับสร้างปุ่ม
function UILib.CreateButton(text)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Parent = CategoryScroll
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    return Button
end

-- ฟังก์ชันสำหรับสร้าง Toggle
function UILib.CreateToggle(text, initialState, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -10, 0, 50)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Text = text
    Toggle.Parent = CategoryScroll
    
    local ToggleState = Instance.new("BoolValue")
    ToggleState.Value = initialState

    local StatusBar = Instance.new("Frame")
    StatusBar.Size = UDim2.new(0.1, 0, 1, 0)
    StatusBar.Position = UDim2.new(0.9, 0, 0, 0)
    StatusBar.BackgroundColor3 = ToggleState.Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    StatusBar.Parent = Toggle
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle

    Toggle.MouseButton1Click:Connect(function()
        ToggleState.Value = not ToggleState.Value
        StatusBar.BackgroundColor3 = ToggleState.Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        Toggle.Text = text .. (ToggleState.Value and " (On)" or " (Off)")
        if callback then callback(ToggleState.Value) end
    end)
    
    return Toggle
end

-- ฟังก์ชันสำหรับสร้าง Slider
function UILib.CreateSlider(min, max, default, text, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderFrame.Parent = CategoryScroll
    
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

-- ฟังก์ชันสำหรับสร้าง Label
function UILib.CreateLabel(text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 40)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = text
    Label.Parent = CategoryScroll
    return Label
end

return UILib
