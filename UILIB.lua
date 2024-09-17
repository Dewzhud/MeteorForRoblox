-- UILib.lua
local UILib = {}
UILib.MainFrame = nil
UILib.Categories = {}

-- Helper function to create UI elements
local function createElement(type, properties)
    local element = Instance.new(type)
    for key, value in pairs(properties) do
        element[key] = value
    end
    return element
end

-- Function to create the main UI frame
function UILib.Initialize()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- Create main UI frame
    UILib.MainFrame = createElement("Frame", {
        Size = UDim2.new(0.5, 0, 0.6, 0),
        Position = UDim2.new(0.25, 0, 0.2, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Visible = false,
        Parent = playerGui
    })

    -- Add corner radius to the main frame
    createElement("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = UILib.MainFrame
    })

    -- Create a category scroll frame
    local categoryScroll = createElement("ScrollingFrame", {
        Size = UDim2.new(0.3, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        ScrollBarThickness = 8,
        Parent = UILib.MainFrame
    })

    -- Add layout to the category scroll frame
    createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = categoryScroll
    })

    -- Create a scroll frame for the main content
    local contentScroll = createElement("ScrollingFrame", {
        Size = UDim2.new(0.7, -10, 1, -10),
        Position = UDim2.new(0.3, 5, 0, 5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        ScrollBarThickness = 8,
        Parent = UILib.MainFrame
    })

    -- Add layout to the content scroll frame
    createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = contentScroll
    })

    -- Create a button to toggle UI visibility
    UILib.ToggleButton = createElement("TextButton", {
        Size = UDim2.new(0.2, 0, 0.05, 0),
        Position = UDim2.new(0.4, 0, 0.05, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = "Open UI",
        Parent = playerGui
    })

    -- Toggle UI visibility function
    UILib.ToggleButton.MouseButton1Click:Connect(function()
        UILib.MainFrame.Visible = not UILib.MainFrame.Visible
        UILib.ToggleButton.Text = UILib.MainFrame.Visible and "Close UI" or "Open UI"
    end)
end

-- Function to create a category
function UILib.CreateCategory(name)
    local categoryFrame = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Parent = UILib.MainFrame
    })

    createElement("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = name,
        Parent = categoryFrame
    })

    local contentFrame = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 150),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Parent = UILib.MainFrame
    })

    createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = contentFrame
    })

    UILib.Categories[name] = contentFrame
end

-- Function to create a button
function UILib.CreateButton(category, text)
    local button = createElement("TextButton", {
        Size = UDim2.new(1, -10, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = text,
        Parent = UILib.Categories[category]
    })

    createElement("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = button
    })
end

-- Function to create a toggle
function UILib.CreateToggle(category, text, initialState, callback)
    local toggle = createElement("Frame", {
        Size = UDim2.new(1, -10, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Parent = UILib.Categories[category]
    })

    local toggleState = Instance.new("BoolValue")
    toggleState.Value = initialState

    local label = createElement("TextLabel", {
        Size = UDim2.new(0.8, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = text .. " (Off)",
        Parent = toggle
    })

    local stateIndicator = createElement("Frame", {
        Size = UDim2.new(0.2, 0, 1, 0),
        Position = UDim2.new(0.8, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        Parent = toggle
    })

    createElement("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = toggle
    })

    toggle.MouseButton1Click:Connect(function()
        toggleState.Value = not toggleState.Value
        if toggleState.Value then
            label.Text = text .. " (On)"
            stateIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            if callback then callback(true) end
        else
            label.Text = text .. " (Off)"
            stateIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            if callback then callback(false) end
        end
    end)
end

-- Function to create a slider
function UILib.CreateSlider(category, min, max, default, text, callback)
    local sliderFrame = createElement("Frame", {
        Size = UDim2.new(1, -10, 0, 70),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Parent = UILib.Categories[category]
    })

    createElement("TextLabel", {
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = text .. ": " .. default,
        Parent = sliderFrame
    })

    local slider = createElement("TextBox", {
        Size = UDim2.new(1, -10, 0, 25),
        Position = UDim2.new(0, 5, 1, -30),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Text = tostring(default),
        Parent = sliderFrame
    })

    slider.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local value = tonumber(slider.Text)
            if value then
                value = math.clamp(value, min, max)
                slider.Text = tostring(value)
                slider.Parent:FindFirstChildOfClass("TextLabel").Text = text .. ": " .. tostring(value)
                if callback then callback(value) end
            end
        end
    end)
end

-- Function to create a label
function UILib.CreateLabel(category, text)
    createElement("TextLabel", {
        Size = UDim2.new(1, -10, 0, 40),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Text = text,
        Parent = UILib.Categories[category]
    })
end

-- Initialize UILib
UILib.Initialize()

return UILib
