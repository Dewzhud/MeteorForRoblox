-- UILib Core
local UILib = {}

-- สร้างหน้าต่างหลักของ UI
function UILib:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

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
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Parent = MainFrame

    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -10, 1, -60)
    ContentFrame.Position = UDim2.new(0, 5, 0, 55)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ContentFrame.ScrollBarThickness = 8
    ContentFrame.Parent = MainFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentFrame

    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentFrame = ContentFrame
    }
end

-- ฟังก์ชันสำหรับสร้างปุ่มปิด/เปิด UI
function UILib:CreateToggleUIButton()
    local toggleState = true
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 150, 0, 50)
    ToggleButton.Position = UDim2.new(0, 20, 0, 20)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Text = "Toggle UI"
    ToggleButton.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    ToggleButton.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= ToggleButton.Parent.Name then
                gui.Enabled = toggleState
            end
        end
    end)
end

return UILib
