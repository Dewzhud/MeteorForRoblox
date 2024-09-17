-- UILib Core
local UILib = {}

-- สร้างหน้าต่างหลักของ UI
function UILib:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
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

    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -10, 1, -60)
    ContentFrame.Position = UDim2.new(0, 5, 0, 55)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ContentFrame.ScrollBarThickness = 8
    ContentFrame.Parent = MainFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentFrame

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentFrame = ContentFrame
    }
end

-- ฟังก์ชันสำหรับสร้างหมวดหมู่
function UILib:CreateCategory(window, categoryName)
    local Category = Instance.new("TextLabel")
    Category.Size = UDim2.new(1, -10, 0, 40)
    Category.BackgroundTransparency = 1
    Category.Text = categoryName
    Category.TextColor3 = Color3.fromRGB(255, 255, 255)
    Category.TextSize = 18
    Category.Font = Enum.Font.SourceSans
    Category.Parent = window.ContentFrame
end

-- ฟังก์ชันสำหรับสร้างปุ่ม
function UILib:CreateButton(window, category, buttonText, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = buttonText
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 18
    Button.Parent = window.ContentFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- ฟังก์ชันสำหรับสร้าง Toggle
function UILib:CreateToggle(window, category, toggleText, initialState, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -10, 0, 40)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Text = toggleText .. " (Off)"
    Toggle.Font = Enum.Font.SourceSans
    Toggle.TextSize = 18
    Toggle.Parent = window.ContentFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle

    local state = initialState

    Toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Toggle.Text = toggleText .. " (On)"
        else
            Toggle.Text = toggleText .. " (Off)"
        end
        if callback then callback(state) end
    end)
end

-- ฟังก์ชันสำหรับสร้าง Slider
function UILib:CreateSlider(window, category, min, max, default, sliderText, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderFrame.Parent = window.ContentFrame

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -10, 0, 30)
    SliderLabel.Position = UDim2.new(0, 5, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.Text = sliderText .. ": " .. default
    SliderLabel.Parent = SliderFrame

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
                SliderLabel.Text = sliderText .. ": " .. tostring(value)
                if callback then callback(value) end
            end
        end
    end)
end

-- ฟังก์ชันสำหรับสร้าง Label
function UILib:CreateLabel(window, category, labelText)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 40)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = labelText
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 18
    Label.Parent = window.ContentFrame
end

-- ฟังก์ชันสำหรับสร้างปุ่มปิด/เปิด UI
function UILib:CreateToggleUIButton()
    local toggleState = true
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 150, 0, 50)
    Button.Position = UDim2.new(0, 20, 0, 20)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = "Toggle UI"
    Button.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    Button.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                gui.Enabled = toggleState
            end
        end
    end)
end

return UILib
