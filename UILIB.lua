local UILib = {}

-- สร้างหน้าต่างหลักของ UI
function UILib:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MyScreenGui"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.5, 0, 0.6, 0)
    MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui

    local MainFrameCorner = Instance.new("UICorner")
    MainFrameCorner.CornerRadius = UDim.new(0, 10)
    MainFrameCorner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Parent = MainFrame

    -- ScrollFrame สำหรับเนื้อหาภายใน
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -60)
    ContentFrame.Position = UDim2.new(0, 10, 0, 55)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ContentFrame.ScrollBarThickness = 8
    ContentFrame.CanvasSize = UDim2.new(0, 0, 5, 0)  -- ทำให้สามารถเลื่อนดูได้
    ContentFrame.Parent = MainFrame

    -- เพิ่ม Layout ให้ ScrollFrame
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentFrame

    -- ปุ่มปิด/เปิด UI
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(1, -60, 0, 10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Text = "X"
    ToggleButton.Parent = MainFrame

    local isVisible = true
    ToggleButton.MouseButton1Click:Connect(function()
        isVisible = not isVisible
        MainFrame.Visible = isVisible
    end)

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentFrame = ContentFrame,
        ContentLayout = ContentLayout
    }
end

-- ฟังก์ชันสำหรับสร้างปุ่ม
function UILib:CreateButton(window, category, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Parent = window.ContentFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- ฟังก์ชันสำหรับสร้าง Toggle
function UILib:CreateToggle(window, category, text, initialState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 50)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleFrame.Parent = window.ContentFrame

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -50, 1, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Text = text .. " (Off)"
    Toggle.Parent = ToggleFrame

    local ToggleState = Instance.new("BoolValue")
    ToggleState.Value = initialState
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle

    local StatusBar = Instance.new("Frame")
    StatusBar.Size = UDim2.new(0, 10, 1, 0)
    StatusBar.Position = UDim2.new(1, -10, 0, 0)
    StatusBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- สีเริ่มต้นสำหรับสถานะปิด
    StatusBar.Parent = ToggleFrame

    -- ฟังก์ชันที่เรียกเมื่อ Toggle ถูกกด
    Toggle.MouseButton1Click:Connect(function()
        ToggleState.Value = not ToggleState.Value
        if ToggleState.Value then
            Toggle.Text = text .. " (On)"
            StatusBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- สีสำหรับสถานะเปิด
            callback(true)
        else
            Toggle.Text = text .. " (Off)"
            StatusBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- สีสำหรับสถานะปิด
            callback(false)
        end
    end)
end

-- ฟังก์ชันสำหรับสร้าง Slider
function UILib:CreateSlider(window, category, min, max, default, text, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderFrame.Parent = window.ContentFrame
    
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
                callback(value)
            end
        end
    end)
end

-- ฟังก์ชันสำหรับสร้าง Label
function UILib:CreateLabel(window, category, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 40)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = text
    Label.Parent = window.ContentFrame
end

return UILib
