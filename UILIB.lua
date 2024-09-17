-- สร้างการเชื่อมต่อกับ PlayerGui
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- สร้าง ScreenGui ใหม่
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = playerGui

-- ฟังก์ชันสำหรับสร้าง UI
local UILib = {}

-- สร้างหน้าต่าง UI
function UILib:CreateWindow(title)
    local window = Instance.new("Frame")
    window.Size = UDim2.new(0.5, 0, 0.6, 0)
    window.Position = UDim2.new(0.25, 0, 0.2, 0)
    window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    window.Parent = ScreenGui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Text = title
    titleLabel.Parent = window

    return window
end

-- สร้างปุ่ม
function UILib:CreateButton(window, category, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.Position = UDim2.new(0, 5, 0, 5)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Parent = window

    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- สร้าง Toggle
function UILib:CreateToggle(window, category, text, initialState, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -10, 0, 50)
    Toggle.Position = UDim2.new(0, 5, 0, 5)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Text = text .. " (Off)"
    Toggle.Parent = window

    local ToggleState = initialState
    local StateIndicator = Instance.new("Frame")
    StateIndicator.Size = UDim2.new(0, 10, 1, 0)
    StateIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    StateIndicator.Parent = Toggle
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle

    Toggle.MouseButton1Click:Connect(function()
        ToggleState = not ToggleState
        if ToggleState then
            Toggle.Text = text .. " (On)"
            StateIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            Toggle.Text = text .. " (Off)"
            StateIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
        if callback then callback(ToggleState) end
    end)
    return Toggle
end

-- สร้าง Slider
function UILib:CreateSlider(window, category, min, max, default, text, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    SliderFrame.Position = UDim2.new(0, 5, 0, 5)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderFrame.Parent = window

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
function UILib:CreateLabel(window, category, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 40)
    Label.Position = UDim2.new(0, 5, 0, 5)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = text
    Label.Parent = window
    return Label
end

-- สร้างปุ่มเปิด/ปิด UI
function UILib:CreateUIToggleButton()
    local toggleState = true
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 150, 0, 50)
    ToggleButton.Position = UDim2.new(0, 20, 0, 20)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Text = "Toggle UI"
    ToggleButton.Parent = playerGui

    ToggleButton.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui ~= ToggleButton.Parent then
                gui.Enabled = toggleState
            end
        end
    end)
end

return UILib
