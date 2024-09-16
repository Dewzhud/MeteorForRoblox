-- สร้าง UI Library
local UILib = {}

-- ฟังก์ชันสร้างหน้าต่างหลัก
function UILib:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- สร้าง Frame หลัก
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.Parent = ScreenGui

    -- สร้าง Scroll Frame
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, 0, 1, -50) -- ลดขนาด Scroll Frame เพื่อให้ปุ่มปิดเปิดอยู่ข้างล่าง
    ScrollFrame.Position = UDim2.new(0, 0, 0, 0)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- ปรับขนาด Scroll Frame เพื่อรองรับเนื้อหาที่มากขึ้น
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.Parent = MainFrame

    -- สร้างปุ่มปิด UI
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 100, 0, 50)
    CloseButton.Position = UDim2.new(0.5, -50, 1, -60)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.Text = "Close UI"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Parent = MainFrame

    -- เมื่อกดปิด UI
    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            CloseButton.Text = "Close UI"
        else
            CloseButton.Text = "Open UI"
        end
    end)

    self.MainFrame = MainFrame
    self.ScrollFrame = ScrollFrame
    return MainFrame
end

-- ฟังก์ชันสร้างหมวดหมู่
function UILib:AddCategory(categoryName)
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 0, 50)
    CategoryFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CategoryFrame.Parent = self.ScrollFrame

    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Size = UDim2.new(1, 0, 0, 30)
    CategoryLabel.BackgroundTransparency = 1
    CategoryLabel.Text = categoryName
    CategoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryLabel.Parent = CategoryFrame

    self.CurrentCategory = CategoryFrame
    return CategoryFrame
end

-- ฟังก์ชันสร้างปุ่ม
function UILib:AddButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = self.CurrentCategory

    Button.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- ฟังก์ชันสร้าง Toggle
function UILib:AddToggle(text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, 0, 0, 30)
    Toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Toggle.Text = text .. " (OFF)"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Parent = self.CurrentCategory

    local toggled = false
    Toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            Toggle.Text = text .. " (ON)"
            Toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            Toggle.Text = text .. " (OFF)"
            Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
        callback(toggled)
    end)
end

-- ฟังก์ชันสร้าง Slider
function UILib:AddSlider(text, min, max, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    SliderFrame.Parent = self.CurrentCategory

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.Text = text .. ": " .. min
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Parent = SliderFrame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0, 10)
    SliderBar.Position = UDim2.new(0, 0, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBar.Parent = SliderFrame

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 10, 1, 0)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar

    local dragging = false
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    SliderButton.MouseButton1Up:Connect(function()
        dragging = false
    end)

    SliderBar.MouseMoved:Connect(function(x)
        if dragging then
            local relativeX = x - SliderBar.AbsolutePosition.X
            local sliderWidth = SliderBar.AbsoluteSize.X
            local value = math.clamp(relativeX / sliderWidth, 0, 1) * (max - min) + min
            SliderButton.Position = UDim2.new(value / max, -5, 0, 0)
            SliderLabel.Text = text .. ": " .. math.floor(value)
            callback(math.floor(value))
        end
    end)
end

return UILib
