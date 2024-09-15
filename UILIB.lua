local UILib = {}

-- ฟังก์ชันสำหรับสร้างหน้าต่าง UI
function UILib:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") -- ใส่ใน PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.4, 0, 0.5, 0)  -- ขนาด UI 
    MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)  -- ตำแหน่ง UI กลางหน้าจอ
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui

    -- สร้าง UI อื่นๆ เช่นปุ่มหรือหมวดหมู่ที่นี่
    self.MainFrame = MainFrame
    return MainFrame
end

-- ฟังก์ชันสำหรับสร้างหมวดหมู่
function UILib:AddCategory(categoryName)
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 0, 30)
    CategoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CategoryFrame.BorderSizePixel = 0
    CategoryFrame.Parent = self.MainFrame

    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Text = categoryName
    CategoryLabel.Size = UDim2.new(1, 0, 0, 30)
    CategoryLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    CategoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryLabel.Parent = CategoryFrame

    self.CurrentCategory = CategoryFrame
    return CategoryFrame
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

return UILib
