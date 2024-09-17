
local UILib = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ฟังก์ชันสำหรับสร้าง Main UI Frame
local function CreateMainFrame()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.5, 0, 0.6, 0)
    MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    local MainFrameCorner = Instance.new("UICorner")
    MainFrameCorner.CornerRadius = UDim.new(0, 10)
    MainFrameCorner.Parent = MainFrame

    return ScreenGui, MainFrame
end

-- ฟังก์ชันสำหรับสร้าง Toggle
function UILib.CreateToggle(text, initialState, callback)
    local ScreenGui, MainFrame = CreateMainFrame()

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 50)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleFrame.Parent = MainFrame

    local StatusBar = Instance.new("Frame")
    StatusBar.Size = UDim2.new(0, 10, 1, 0)
    StatusBar.Position = UDim2.new(0, 0, 0, 0)
    StatusBar.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    StatusBar.Parent = ToggleFrame

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -20, 1, 0)
    Toggle.Position = UDim2.new(0, 15, 0, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Text = text .. (initialState and " (On)" or " (Off)")
    Toggle.Parent = ToggleFrame

    local ToggleState = Instance.new("BoolValue")
    ToggleState.Value = initialState

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle

    -- ฟังก์ชันที่เรียกเมื่อ Toggle ถูกกด
    Toggle.MouseButton1Click:Connect(function()
        ToggleState.Value = not ToggleState.Value
        if ToggleState.Value then
            Toggle.Text = text .. " (On)"
            StatusBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            if callback then callback(true) end
        else
            Toggle.Text = text .. " (Off)"
            StatusBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            if callback then callback(false) end
        end
    end)

    return Toggle
end

-- ฟังก์ชันสำหรับสร้าง Button
function UILib.CreateButton(text)
    local ScreenGui, MainFrame = CreateMainFrame()

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Parent = MainFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    return Button
end

-- ฟังก์ชันสำหรับสร้าง Slider
function UILib.CreateSlider(min, max, default, text, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderFrame.Parent = MainFrame
    
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
    Label.Parent = MainFrame
    return Label
end

