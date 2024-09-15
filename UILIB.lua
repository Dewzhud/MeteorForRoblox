local UILib = {}

-- สร้างหน้าต่างหลัก
function UILib:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false -- ป้องกันไม่ให้รีเซ็ตเมื่อ Player ตาย
    ScreenGui.Parent = game:GetService("StarterGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400) -- ลดขนาดความกว้างเป็น 300
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.ClipsDescendants = true -- ให้เนื้อหาไม่เกินขอบ Frame
    MainFrame.Parent = ScreenGui

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- กำหนด Canvas Size ให้ใหญ่กว่าขนาด Frame
    ScrollingFrame.ScrollBarThickness = 6
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Parent = MainFrame

    self.MainFrame = MainFrame
    self.ScrollingFrame = ScrollingFrame
    return ScrollingFrame
end

-- สร้างหมวดหมู่ที่สามารถซ่อน/แสดงได้
function UILib:AddCategory(categoryName)
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 0, 30)
    CategoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CategoryFrame.BorderSizePixel = 0
    CategoryFrame.Parent = self.ScrollingFrame

    local CategoryLabel = Instance.new("TextButton")
    CategoryLabel.Text = categoryName .. " (Click to Toggle)"
    CategoryLabel.Size = UDim2.new(1, 0, 0, 30)
    CategoryLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CategoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryLabel.Parent = CategoryFrame

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 0, 0) -- กำหนดขนาดเริ่มต้นของ Content เป็น 0 เพื่อให้สามารถซ่อน
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = CategoryFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ContentFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local isHidden = true -- ซ่อนในตอนเริ่มต้น
    CategoryLabel.MouseButton1Click:Connect(function()
        isHidden = not isHidden
        if isHidden then
            ContentFrame.Size = UDim2.new(1, 0, 0, 0)
            CategoryLabel.Text = categoryName .. " (Hidden)"
        else
            ContentFrame.Size = UDim2.new(1, 0, 0, #ContentFrame:GetChildren() * 30)
            CategoryLabel.Text = categoryName .. " (Click to Toggle)"
        end
    end)

    self.CurrentCategory = ContentFrame
    return ContentFrame
end

-- ฟังก์ชันสำหรับสร้างปุ่ม
function UILib:AddButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = self.CurrentCategory

    Button.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- ฟังก์ชันสำหรับสร้าง Toggle
function UILib:AddToggle(text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, 0, 0, 30)
    Toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    Toggle.Text = text .. " (OFF)"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Parent = self.CurrentCategory

    local isToggled = false

    Toggle.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            Toggle.Text = text .. " (ON)"
            Toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            Toggle.Text = text .. " (OFF)"
            Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
        callback(isToggled)
    end)
end

-- ฟังก์ชันสำหรับสร้าง Slider
function UILib:AddSlider(text, minValue, maxValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
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
    SliderButton.Size = UDim2.new(0, 10, 1, 0)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar

    local isDragging = false
    local function updateSlider(input)
        local posX = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
        local value = math.floor(((posX / SliderBar.AbsoluteSize.X) * (maxValue - minValue)) + minValue)
        SliderButton.Position = UDim2.new(posX / SliderBar.AbsoluteSize.X, -5, 0, 0)
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
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Parent = self.CurrentCategory
end

return UILib
