local UILib = {}

-- สร้าง Main Frame สำหรับ UI
local function CreateMainFrame()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.5, 0, 0.6, 0)
    MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Visible = false
    return MainFrame
end

-- สร้าง Toggle Button
local function CreateToggleButton()
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.2, 0, 0.05, 0)
    ToggleButton.Position = UDim2.new(0.4, 0, 0.05, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Text = "Open UI"
    return ToggleButton
end

-- สร้าง ScrollFrame สำหรับหมวดหมู่
function UILib.CreateCategoryScrollFrame(parentFrame)
    local CategoryScroll = Instance.new("ScrollingFrame")
    CategoryScroll.Size = UDim2.new(1, -20, 1, -20)
    CategoryScroll.Position = UDim2.new(0, 10, 0, 10)
    CategoryScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CategoryScroll.ScrollBarThickness = 8  -- ขนาด ScrollBar
    CategoryScroll.Parent = parentFrame

    -- เพิ่ม Layout ให้กับ ScrollFrame
    local CategoryLayout = Instance.new("UIListLayout")
    CategoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CategoryLayout.Padding = UDim.new(0, 10)
    CategoryLayout.Parent = CategoryScroll

    return CategoryScroll
end

-- ฟังก์ชันสำหรับสร้างปุ่ม
function UILib.CreateButton(category, text)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Parent = UILib.GetCategoryScroll(category)

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    return Button
end

-- ฟังก์ชันสำหรับสร้าง Toggle
function UILib.CreateToggle(category, text, initialState, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -10, 0, 50)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Text = text
    Toggle.Parent = UILib.GetCategoryScroll(category)

    local ToggleState = Instance.new("BoolValue")
    ToggleState.Value = initialState

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle

    -- สร้างแท็บสีสำหรับ Toggle
    local StatusTab = Instance.new("Frame")
    StatusTab.Size = UDim2.new(0, 10, 1, 0)
    StatusTab.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    StatusTab.Position = UDim2.new(0, 0, 0, 0)
    StatusTab.Parent = Toggle

    -- ฟังก์ชันที่เรียกเมื่อ Toggle ถูกกด
    Toggle.MouseButton1Click:Connect(function()
        ToggleState.Value = not ToggleState.Value
        if ToggleState.Value then
            Toggle.Text = text .. " (On)"
            StatusTab.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            if callback then callback(true) end
        else
            Toggle.Text = text .. " (Off)"
            StatusTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            if callback then callback(false) end
        end
    end)

    return Toggle
end

-- ฟังก์ชันสำหรับสร้าง Slider
function UILib.CreateSlider(category, min, max, default, text, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderFrame.Parent = UILib.GetCategoryScroll(category)

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
function UILib.CreateLabel(category, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 40)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = text
    Label.Parent = UILib.GetCategoryScroll(category)
    return Label
end

-- ฟังก์ชันสำหรับสร้างหมวดหมู่
function UILib.CreateCategory(name)
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 1, 0)
    CategoryFrame.BackgroundTransparency = 1
    CategoryFrame.Name = name
    CategoryFrame.Parent = UILib.GetMainFrame()

    -- สร้าง ScrollFrame สำหรับหมวดหมู่
    local CategoryScroll = UILib.CreateCategoryScrollFrame(CategoryFrame)
    
    -- เพิ่ม Layout ให้กับ ScrollFrame
    local CategoryLayout = Instance.new("UIListLayout")
    CategoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CategoryLayout.Padding = UDim.new(0, 10)
    CategoryLayout.Parent = CategoryScroll

    return CategoryFrame
end

-- ฟังก์ชันสำหรับดึง ScrollFrame ตามหมวดหมู่
function UILib.GetCategoryScroll(category)
    return UILib.GetMainFrame():FindFirstChild(category):FindFirstChildOfClass("ScrollingFrame")
end

-- ฟังก์ชันสำหรับดึง Main Frame
function UILib.GetMainFrame()
    return game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MainFrame")
end

-- สร้าง Main Frame
local MainFrame = CreateMainFrame()
MainFrame.Name = "MainFrame"
MainFrame.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- สร้าง Toggle Button
local ToggleButton = CreateToggleButton()
ToggleButton.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- ฟังก์ชันเปิด/ปิด UI
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleButton.Text = "Close UI"
    else
        ToggleButton.Text = "Open UI"
    end
end)

return UILib
