-- สร้างหน้าต่างหลักของ UI
local function CreateUI()
    -- สร้าง ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibScreenGui"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

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
    ContentFrame.CanvasSize = UDim2.new(0, 0, 5, 0)  -- ทำให้สามารถเลื่อนดูได้
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

-- ฟังก์ชันสำหรับทำให้ปุ่มลากได้
local function MakeDraggable(button)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    -- ฟังก์ชันที่ใช้คำนวณการลาก
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

-- ฟังก์ชันสำหรับสร้างปุ่ม
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

-- ฟังก์ชันสำหรับสร้าง Toggle
local function CreateToggle(parent, text, initialState, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -10, 0, 50)
    Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Text = text .. (initialState and " (On)" or " (Off)")
    Toggle.Parent = parent

    local ToggleState = initialState
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle

    -- ฟังก์ชันที่เรียกเมื่อ Toggle ถูกกด
    Toggle.MouseButton1Click:Connect(function()
        ToggleState = not ToggleState
        Toggle.Text = text .. (ToggleState and " (On)" or " (Off)")
        callback(ToggleState)
    end)
end

-- ฟังก์ชันสำหรับสร้าง Slider
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

-- ฟังก์ชันสำหรับสร้าง Label
local function CreateLabel(parent, text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 40)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = text
    Label.Parent = parent
end

-- สร้าง UI
local uiElements = CreateUI()

-- ฟังก์ชันสร้าง Text Overlay
local function CreateTextOverlay(uiElements)
    local Overlay = Instance.new("TextLabel")
    Overlay.Size = UDim2.new(0, 200, 0, 50)
    Overlay.Position = UDim2.new(0.5, -100, 0.1, 0) -- Overlay อยู่ตรงกลางด้านบนของหน้าจอ
    Overlay.BackgroundTransparency = 0.5
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.TextColor3 = Color3.fromRGB(255, 255, 255)
    Overlay.TextSize = 24
    Overlay.Visible = false
    Overlay.Parent = uiElements.ScreenGui
    return Overlay
end

-- Text Overlay
local TextOverlay = CreateTextOverlay(uiElements)

-- การสร้าง UI ตัวอย่าง
CreateButton(uiElements.ContentFrame, "Sample Button", function()
    print("Button clicked!")
end)

CreateToggle(uiElements.ContentFrame, "Sample Toggle", false, function(state)
    TextOverlay.Text = "Sample Toggle is " .. (state and "On" or "Off")
    TextOverlay.Visible = true
    wait(2)
    TextOverlay.Visible = false
end)

CreateSlider(uiElements.ContentFrame, 0, 100, 50, "Sample Slider", function(value)
    print("Slider value:", value)
end)

CreateLabel(uiElements.ContentFrame, "Sample Label")

-- ปุ่มปิด/เปิด MainFrame ลอยบนหน้าจอ
local ToggleUIBtn = Instance.new("TextButton")
ToggleUIBtn.Size = UDim2.new(0, 150,0, 50)
ToggleUIBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUIBtn.Text = "Toggle UI"
ToggleUIBtn.Parent = uiElements.ScreenGui

local ToggleUICorner = Instance.new("UICorner")
ToggleUICorner.CornerRadius = UDim.new(0, 8)
ToggleUICorner.Parent = ToggleUIBtn

-- สร้างฟังก์ชันสำหรับปิด/เปิด UI
ToggleUIBtn.MouseButton1Click:Connect(function()
    uiElements.MainFrame.Visible = not uiElements.MainFrame.Visible
end)

-- ทำให้ปุ่ม Toggle UI ลากได้
MakeDraggable(ToggleUIBtn)
