-- ฟังก์ชันสร้างหน้าต่างหลักของ UI
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibScreenGui"
    ScreenGui.Parent = game.CoreGui  -- เปลี่ยนให้ UI อยู่ใน CoreGui

    -- สร้าง MainFrame
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
    Title.Text = "Config🛸"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Parent = MainFrame

    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -60)
    ContentFrame.Position = UDim2.new(0, 10, 0, 55)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ContentFrame.ScrollBarThickness = 8
    ContentFrame.CanvasSize = UDim2.new(0, 0, 5, 0)  -- ทำให้เลื่อนได้
    ContentFrame.Parent = MainFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentFrame

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentFrame = ContentFrame,
        ContentLayout = ContentLayout
    }
end

-- ฟังก์ชันทำให้ปุ่มลากได้
local function MakeDraggable(button)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = button.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- ฟังก์ชันสร้างปุ่ม
local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Parent = parent

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- ฟังก์ชันสร้าง Toggle พร้อม Label
local function CreateToggleWithLabel(parent, labelText, initialState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 50)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0.5, -10, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.Text = labelText
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.5, -10, 1, 0)
    ToggleButton.Position = UDim2.new(0.5, 10, 0, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Text = initialState and "On" or "Off"
    ToggleButton.Parent = ToggleFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleButton

    local ToggleState = initialState

    ToggleButton.MouseButton1Click:Connect(function()
        ToggleState = not ToggleState
        ToggleButton.Text = ToggleState and "On" or "Off"
        callback(ToggleState)
    end)
end

-- ฟังก์ชันสร้าง Slider พร้อม Label
local function CreateSlider(parent, min, max, default, text, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderFrame.Parent = parent
    
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

-- ฟังก์ชันสร้าง Label
local function CreateLabel(parent, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 40)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = text
    Label.Parent = parent
end

-- ฟังก์ชันสำหรับ Overlay (ด้านขวาบน)
local overlays = {}
local function CreateOverlay(text)
    local overlay = Instance.new("TextLabel")
    overlay.Size = UDim2.new(0, 200, 0, 50)
    overlay.Position = UDim2.new(1, -220, 0, #overlays * 55 + 10)
    overlay.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    overlay.TextColor3 = Color3.fromRGB(255, 255, 255)
    overlay.Text = text
    overlay.Parent = game.CoreGui

    local overlayCorner = Instance.new("UICorner")
    overlayCorner.CornerRadius = UDim.new(0, 10)
    overlayCorner.Parent = overlay

    table.insert(overlays, overlay)
end

-- ฟังก์ชันลบ Overlay เมื่อ Toggle ถูกปิด
local function RemoveOverlay(text)
    for i, overlay in ipairs(overlays) do
        if overlay.Text == text then
            overlay:Destroy()
            table.remove(overlays, i)
            break
        end
    end

    -- อัปเดตตำแหน่ง Overlay ที่เหลือ
    for i, overlay in ipairs(overlays) do
        overlay.Position = UDim2.new(1, -220, 0, i * 55 + 10)
    end
end

-- ฟังก์ชันแสดง/ซ่อน MainFrame เมื่อกด Toggle UI
local function CreateToggleUI(parent)
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 100, 0, 50)
    toggleButton.Position = UDim2.new(0.9, -110, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = "Toggle UI"
    toggleButton.Parent = game.CoreGui

    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(0, 10)
    toggleButtonCorner.Parent = toggleButton

    MakeDraggable(toggleButton)

    toggleButton.MouseButton1Click:Connect(function()
        parent.Visible = not parent.Visible
    end)
end

-- เริ่มสร้าง UI และเพิ่มฟีเจอร์ต่างๆ
local ui = CreateUI()

CreateButton(ui.ContentFrame, "Click Me!", function()
    print("Button clicked!")
end)

CreateToggleWithLabel(ui.ContentFrame, "Toggle Me", false, function(state)
    if state then
        CreateOverlay("Toggle Me is On")
    else
        RemoveOverlay("Toggle Me is On")
    end
end)

CreateSlider(ui.ContentFrame, 1, 100, 50, "Adjust Slider", function(value)
    print("Slider Value:", value)
end)

CreateLabel(ui.ContentFrame, "Example Label")

-- เรียกฟังก์ชันสร้างปุ่ม Toggle UI ลอยที่ลากได้
CreateToggleUI(ui.MainFrame)
