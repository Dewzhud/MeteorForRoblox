-- UILib.lua
local UILib = {}

-- ฟังก์ชันสำหรับสร้างหน้าต่าง UI ปกติ
function UILib:CreateNormalWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("StarterGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.5, 0, 0.6, 0)  -- ขนาดของหน้าต่าง UI
    MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)  -- ตำแหน่งของหน้าต่าง UI
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui

    self.MainFrame = MainFrame
    return MainFrame
end

-- ฟังก์ชันสำหรับเพิ่มหมวดหมู่ Dropdown
function UILib:AddDropdownCategory(categoryName)
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 0, 50) -- ขนาดหมวดหมู่
    CategoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CategoryFrame.BorderSizePixel = 0
    CategoryFrame.Parent = self.MainFrame

    local CategoryLabel = Instance.new("TextButton")
    CategoryLabel.Text = categoryName .. " (Click to Toggle)"
    CategoryLabel.Size = UDim2.new(1, 0, 0, 30)
    CategoryLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CategoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryLabel.Parent = CategoryFrame

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = CategoryFrame

    local isHidden = false
    CategoryLabel.MouseButton1Click:Connect(function()
        isHidden = not isHidden
        ContentFrame.Visible = not isHidden
        CategoryLabel.Text = isHidden and categoryName .. " (Hidden)" or categoryName .. " (Click to Toggle)"
    end)

    self.CurrentCategory = ContentFrame
    return ContentFrame
end

-- ฟังก์ชันสำหรับสร้างปุ่มที่สวยงาม
function UILib:AddBeautifulButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 50)  -- ขนาดปุ่ม
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Parent = self.CurrentCategory

    Button.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- ฟังก์ชันสำหรับสร้าง Toggle
function UILib:AddToggle(text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, 0, 0, 50)  -- ขนาด Toggle
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.Text = text .. " (OFF)"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.TextScaled = true
    Toggle.Parent = self.CurrentCategory

    local isToggled = false
    Toggle.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        Toggle.Text = text .. " (" .. (isToggled and "ON" or "OFF") .. ")"
        Toggle.BackgroundColor3 = isToggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(isToggled)
    end)
end

-- ฟังก์ชันสำหรับสร้าง Slider
function UILib:AddSlider(text, minValue, maxValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 80) -- ขนาด Slider
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = self.CurrentCategory

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, 0, 0, 30)
    SliderLabel.Text = text .. ": " .. tostring(minValue)
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Parent = SliderFrame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0, 10)
    SliderBar.Position = UDim2.new(0, 0, 0, 40)
    SliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 20, 1, 0)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar

    local isDragging = false
    local function updateSlider(input)
        local posX = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
        local value = math.floor(((posX / SliderBar.AbsoluteSize.X) * (maxValue - minValue)) + minValue)
        SliderButton.Position = UDim2.new(posX / SliderBar.AbsoluteSize.X, -10, 0, 0)
        SliderLabel.Text = text .. ": " .. tostring(value)
        callback(value)
    end

    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
        end
    end)

    SliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
        end
    end)

    SliderBar.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
end

-- ฟังก์ชันสำหรับสร้าง Label
function UILib:AddLabel(text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 50) -- ขนาด Label
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.TextScaled = true
    Label.Parent = self.CurrentCategory
end

return UILib
