-- ฟังก์ชันสำหรับสร้างหน้าต่างหลักของ UI
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibScreenGui"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- สร้าง MainFrame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.5, 0, 0.6, 0)
    MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Visible = false -- ซ่อน MainFrame
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
    ContentFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
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

-- ฟังก์ชันสำหรับการแสดงผล overlay ด้านขวาบน
-- ตารางเก็บ overlay
local overlays = {}

-- ฟังก์ชันสำหรับอัพเดตตำแหน่ง
-- ฟังก์ชันสำหรับอัพเดตตำแหน่งของ overlay
local function UpdateOverlayPositions()
    local overlayHeight = 30 -- ความสูงของ overlay แต่ละอัน
    local padding = 5 -- ระยะห่างระหว่าง overlay แต่ละอัน
    for i, overlay in ipairs(overlays) do
        overlay.Position = UDim2.new(1, -160, 0, (i - 1) * (overlayHeight + padding)) -- ไล่ตำแหน่งจากบนลงล่าง
    end
end

-- ฟังก์ชันสำหรับสร้าง overlay ด้านขวาบน
local function CreateOverlay(text)
    local Overlay = Instance.new("TextLabel")
    Overlay.Size = UDim2.new(0, 150, 0, 30)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Overlay.TextColor3 = Color3.fromRGB(255, 255, 255)
    Overlay.Text = text
    Overlay.Parent = uiElements.ScreenGui
    Overlay.Position = UDim2.new(1, -160, 0, #overlays * 35) -- กำหนดตำแหน่งเริ่มต้น
    Overlay.AnchorPoint = Vector2.new(1, 0)

    table.insert(overlays, Overlay)
    UpdateOverlayPositions()
end

-- ฟังก์ชันสำหรับลบ overlay
local function RemoveOverlay(text)
    for i, overlay in ipairs(overlays) do
        if overlay.Text == text then
            overlay:Destroy()
            table.remove(overlays, i)
            UpdateOverlayPositions()
            break
        end
    end
end

-- ตัวอย่างการใช้ CreateToggle เพื่อสร้าง toggle ที่มี overlay
CreateToggle(uiElements.ContentFrame, "Show Overlay", false, function(state)
    if state then
        CreateOverlay("Overlay Active")
    else
        RemoveOverlay("Overlay Active")
    end
end)

-- Auto Aim Variables
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local autoAimEnabled = false
local maxDistance = 100
local autoAimConnection = nil

-- Function to find the closest alive player
local function getClosestAlivePlayer()
    local closestPlayer = nil
    local shortestDistance = maxDistance

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local character = otherPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local distance = (character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
                    if distance < shortestDistance then
                        closestPlayer = otherPlayer
                        shortestDistance = distance
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Function for auto aim
local function autoAimAtTarget(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- Calculate the direction to aim
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        local direction = (targetPosition - player.Character.HumanoidRootPart.Position).unit

        -- Aim the camera at the target
        camera.CFrame = CFrame.new(player.Character.Head.Position, player.Character.Head.Position + direction)
    end
end

-- CreateToggle Function with Auto Aim Integration
CreateToggle(uiElements.ContentFrame, "Auto Aim", false, function(state)
    if state then
        CreateOverlay("Auto Aim Active")

        -- Auto Aim Code
        autoAimEnabled = true
        autoAimConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if autoAimEnabled then
                local targetPlayer = getClosestAlivePlayer()
                if targetPlayer then
                    autoAimAtTarget(targetPlayer)
                end
            end
        end)
    else
        RemoveOverlay("Auto Aim Active")

        -- Disable Auto Aim
        autoAimEnabled = false
        if autoAimConnection then
            autoAimConnection:Disconnect()
            autoAimConnection = nil
        end
    end
end)
