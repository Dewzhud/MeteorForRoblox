local UILib = {}

-- ฟังก์ชันสำหรับสร้างหน้าต่าง UI
function UILib:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") -- ใส่ใน PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.5, 0, 0.7, 0)  -- ขนาดใหญ่ขึ้น
    MainFrame.Position = UDim2.new(0.25, 0, 0.15, 0)  -- ตำแหน่งกลางหน้าจอ
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui

    -- UI อื่นๆ เช่นปุ่มหรือหมวดหมู่จะถูกเพิ่มลงใน MainFrame นี้
    self.MainFrame = MainFrame
    return MainFrame
end

-- ฟังก์ชันสำหรับสร้างหมวดหมู่
function UILib:AddCategory(categoryName)
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 0, 50) -- หมวดหมู่ใหญ่
    CategoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CategoryFrame.BorderSizePixel = 0
    CategoryFrame.Parent = self.MainFrame

    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Text = categoryName
    CategoryLabel.Size = UDim2.new(1, 0, 0, 30)
    CategoryLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CategoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryLabel.Parent = CategoryFrame

    -- สร้างพื้นที่ให้ฟังก์ชันต่างๆ
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = CategoryFrame

    self.CurrentCategory = ContentFrame
    return ContentFrame
end

-- ฟังก์ชันสำหรับสร้างปุ่ม
function UILib:AddButton(buttonText, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = buttonText
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = self.CurrentCategory

    Button.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- ฟังก์ชันสำหรับสร้าง Toggle
function UILib:AddToggle(toggleText, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, 0, 0, 30)
    Toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    Toggle.Text = toggleText .. " (OFF)"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Parent = self.CurrentCategory

    local isToggled = false

    Toggle.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            Toggle.Text = toggleText .. " (ON)"
            Toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            Toggle.Text = toggleText .. " (OFF)"
            Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
        callback(isToggled)
    end)
end

-- ฟังก์ชันสำหรับสร้าง Slider
function UILib:AddSlider(sliderText, minValue, maxValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = self.CurrentCategory

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, 0, 0, 30)
    SliderLabel.Text = sliderText .. ": " .. tostring(minValue)
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
    SliderButton.Size = UDim2.new(0, 10, 1, 0)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar

    local isDragging = false
    local function updateSlider(input)
        local posX = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
        local value = math.floor(((posX / SliderBar.AbsoluteSize.X) * (maxValue - minValue)) + minValue)
        SliderButton.Position = UDim2.new(posX / SliderBar.AbsoluteSize.X, -5, 0, 0)
        SliderLabel.Text = sliderText .. ": " .. tostring(value)
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

return UILib
