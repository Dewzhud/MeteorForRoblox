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

    -- เพิ่ม ScrollFrame และจัดการหมวดหมู่ที่พับ/ขยายได้
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

-- เก็บรายการของ Overlays ที่เปิดอยู่
local overlayList = {}

-- ฟังก์ชันสำหรับปรับตำแหน่งของ Text Overlays
local function UpdateOverlaysPosition()
    -- เรียงลำดับตำแหน่งของแต่ละ Overlay จากบนสุดไล่ลงล่าง
    for index, overlay in ipairs(overlayList) do
        overlay.Position = UDim2.new(1, -160, 0, (index - 1) * 30 + 10) -- ตำแหน่งด้านขวาบน
    end
end

-- ฟังก์ชันสำหรับสร้าง Text Overlay
local function CreateTextOverlay(text)
    local overlay = Instance.new("TextLabel")
    overlay.Size = UDim2.new(0, 150, 0, 30)
    overlay.AnchorPoint = Vector2.new(1, 0)
    overlay.Position = UDim2.new(1, -160, 0, #overlayList * 30 + 10) -- จัดตำแหน่งตามลำดับ
    overlay.BackgroundTransparency = 0.3
    overlay.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    overlay.TextColor3 = Color3.fromRGB(255, 255, 255)
    overlay.Text = text
    overlay.Parent = game.Players.LocalPlayer.PlayerGui.UILibScreenGui
    overlayList[#overlayList + 1] = overlay

    -- ปรับตำแหน่งของ Overlays ใหม่
    UpdateOverlaysPosition()
    -- ทำให้ Text Overlay หายไปหลังจาก toggle ถูกปิด
    local function RemoveTextOverlay(overlay)
        for i, o in ipairs(overlayList) do
            if o == overlay then
                o:Destroy()
                table.remove(overlayList, i)
                break
            end
        end
        -- อัปเดตตำแหน่งของ overlays ใหม่
        UpdateOverlaysPosition()
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

        -- เพิ่ม Text Overlay เมื่อ toggle เปิด
        local overlay = nil
        if ToggleState then
            overlay = CreateTextOverlay(text .. " เปิด")
        end

        -- ฟังก์ชันที่เรียกเมื่อ Toggle ถูกกด
        Toggle.MouseButton1Click:Connect(function()
            ToggleState = not ToggleState
            Toggle.Text = text .. (ToggleState and " (On)" or " (Off)")
            callback(ToggleState)

            -- จัดการกับ Overlay
            if ToggleState then
                -- สร้าง Text Overlay ถ้า toggle เปิด
                overlay = CreateTextOverlay(text .. " เปิด")
            else
                -- ลบ Text Overlay ถ้า toggle ปิด
                if overlay then
                    RemoveTextOverlay(overlay)
                    overlay = nil
                end
            end
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

    -- การสร้าง UI ตัวอย่าง
    CreateButton(uiElements.ContentFrame, "Sample Button", function()
        print("Button clicked!")
    end)

    CreateToggle(uiElements.ContentFrame, "Sample Toggle", false, function(state)
        print("Toggle state:", state)
    end)

    CreateSlider(uiElements.ContentFrame, 0, 100, 50, "Sample Slider", function(value)
        print("Slider value:", value)
    end)

    CreateLabel(uiElements.ContentFrame, "Sample Label")

    -- ปุ่มปิด/เปิด MainFrame ลอยบนหน้าจอ
    local ToggleUIBtn = Instance.new("TextButton")
    ToggleUIBtn.Size = UDim2.new(0, 150, 0, 50)
    ToggleUIBtn.Position = UDim2.new(0, 10, 0, 10)  -- ตำแหน่งลอยบนจอ
    ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleUIBtn.Text = "Meteor🌠"
    ToggleUIBtn.Parent = uiElements.ScreenGui

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = ToggleUIBtn

    local toggleState = true
    ToggleUIBtn.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        uiElements.MainFrame.Visible = toggleState
    end)

    -- ทำให้ปุ่มลากได้
    MakeDraggable(ToggleUIBtn)
