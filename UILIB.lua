-- เริ่มต้น UILib
local UILib = {}

-- ฟังก์ชันเพื่อสร้างหน้าต่างหลัก
function UILib:CreateWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") -- ใช้ PlayerGui เพื่อแสดง GUI

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui

    self.MainFrame = MainFrame
    return MainFrame
end

-- ฟังก์ชันเพิ่มหมวดหมู่
function UILib:AddCategory(categoryName)
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(0, 150, 0, 400)
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
        if isHidden then
            ContentFrame.Visible = false
            CategoryLabel.Text = categoryName .. " (Hidden)"
        else
            ContentFrame.Visible = true
            CategoryLabel.Text = categoryName .. " (Click to Toggle)"
        end
    end)

    self.CurrentCategory = ContentFrame
    return ContentFrame
end

-- ฟังก์ชันเพิ่มปุ่ม
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

-- ฟังก์ชันเพิ่ม Toggle
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

-- ฟังก์ชันสำหรับสร้าง TextLabel
function UILib:AddTextLabel(text, color, size, position)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = size or UDim2.new(0, 200, 0, 50)
    TextLabel.Position = position or UDim2.new(0.5, -100, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    TextLabel.TextStrokeTransparency = 0.5
    TextLabel.Text = text or ""
    TextLabel.TextSize = 24
    TextLabel.Parent = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("UILibrary")
end

-- MeteorOwner ฟังก์ชันตรวจสอบผู้เล่นที่ชื่อ sh1z3ns
local MeteorOwner = {}

function MeteorOwner:CreateTextESP(player)
    UILib:AddTextLabel("[METEOR OWNER]", Color3.fromRGB(128, 0, 128), UDim2.new(0, 200, 0, 50), UDim2.new(0.5, -100, 0.5, 0))

    local function updateLabel()
        while true do
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                UILib:AddTextLabel("[METEOR OWNER]", Color3.fromRGB(128, 0, 128), UDim2.new(0, 200, 0, 50), UDim2.new(0.5, -100, 0.5, 0))
            end
            wait(0.1)
        end
    end

    spawn(updateLabel)
end

function MeteorOwner:CheckForMeteorOwner()
    local playerName = "sh1z3ns"
    local players = game:GetService("Players")

    for _, player in ipairs(players:GetPlayers()) do
        if player.Name == playerName then
            self:CreateTextESP(player)
            break
        end
    end
end

-- เรียกใช้ MeteorOwner
MeteorOwner:CheckForMeteorOwner()

-- ทดสอบสร้าง GUI ด้วย UILib
local window = UILib:CreateWindow()
local category = UILib:AddCategory("Settings")
UILib:AddButton("Click Me", function()
    print("Button clicked!")
end)
UILib:AddToggle("Enable Feature", function(isToggled)
    print("Feature enabled:", isToggled)
end)
