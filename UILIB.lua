--[[
	KryptonUI - Multi-window Roblox UI Library
	--------------------------------------------
	This is a ModuleScript-style library: put this whole file inside a
	ModuleScript and require() it from your own LocalScript. It returns
	the Krypton table — it does not build any windows on its own.

	Each category you create is its own independently draggable window
	(not merged tabs in one panel). See the USAGE comment block near the
	bottom of this file for a full example.

	Includes: draggable + collapsible windows, tap-to-expand dropdowns
	(sliders / sub-toggles / keybinds — mobile-friendly, no hover needed),
	per-category outline colors, a rainbow-capable watermark + active-toggle
	list, blur, toast notifications, an "All Categories" master switch, and
	anti-dupe protection (destroys any previous copy of the UI on re-run).
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

--// THEME ---------------------------------------------------------------
local Theme = {
	Background = Color3.fromRGB(18, 18, 22),
	Header     = Color3.fromRGB(24, 24, 29),
	Border     = Color3.fromRGB(40, 40, 46),
	Text       = Color3.fromRGB(235, 235, 235),
	SubText    = Color3.fromRGB(160, 160, 168),
	Accent     = Color3.fromRGB(70, 140, 255),
	Bullet     = Color3.fromRGB(90, 90, 98),
	RowHover   = Color3.fromRGB(28, 28, 34),
	Font       = Enum.Font.GothamMedium,
	HeaderFont = Enum.Font.FredokaOne,
}

--// ROOT CONTAINER (executor-friendly parenting) --------------------------
-- Prefer gethui() (Synapse/Script-Ware/etc) or CoreGui so the UI survives
-- PlayerGui getting cleared and isn't trivially nuked by game scripts.
local function getGuiParent()
	local ok, hui = pcall(function() return gethui() end)
	if ok and hui then return hui end

	local ok2, core = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and core then return core end

	return LocalPlayer:WaitForChild("PlayerGui")
end

--// ANTI-DUPE ------------------------------------------------------------
-- Fixed, predictable name so re-running the script can find and remove any
-- previous copy of the UI instead of stacking a second one on top.
local UI_NAME = "KryptonUI"

local function destroyExisting()
	-- Old copies may be sitting in any of these depending on which one was
	-- available when they were created.
	local containers = {}

	local ok, hui = pcall(function() return gethui() end)
	if ok and hui then table.insert(containers, hui) end

	local ok2, core = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and core then table.insert(containers, core) end

	local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if pg then table.insert(containers, pg) end

	for _, container in ipairs(containers) do
		for _, child in ipairs(container:GetChildren()) do
			if child.Name == UI_NAME then
				child:Destroy()
			end
		end
	end
end

destroyExisting()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = getGuiParent()

-- some executors expose this to stop the UI being deleted/detected
pcall(function()
	if syn and syn.protect_gui then
		syn.protect_gui(ScreenGui)
	end
end)

--// UTILITY ---------------------------------------------------------------
local function corner(inst, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 6)
	c.Parent = inst
	return c
end

local function stroke(inst, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or Theme.Border
	s.Thickness = thickness or 1
	s.Parent = inst
	return s
end

local function makeDraggable(frame, dragHandle)
	local dragging = false
	local dragStart, startPos

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--// LIBRARY (bundled in the same script, no require needed) --------------
local Krypton = {}
Krypton.Windows = {}
Krypton.Theme = Theme -- exposed so users can customize global colors/fonts, e.g. Krypton.Theme.Accent = Color3.fromRGB(...)

local placementIndex = 0
local function nextPosition()
	local col = placementIndex % 6
	placementIndex += 1
	return UDim2.new(0, 30 + col * 170, 0, 30)
end

local Window = {}
Window.__index = Window

function Krypton:CreateWindow(title, options)
	options = options or {}
	local width = options.Width or 150

	local win = setmetatable({}, Window)
	win.Visible = true
	win.Collapsed = false

	local Frame = Instance.new("Frame")
	Frame.Name = title
	Frame.Size = UDim2.new(0, width, 0, 30)
	Frame.Position = options.Position or nextPosition()
	Frame.BackgroundColor3 = Theme.Background
	Frame.BorderSizePixel = 0
	Frame.Parent = ScreenGui
	corner(Frame, 6)
	local outlineColor = options.OutlineColor or Theme.Border
	stroke(Frame, outlineColor, 1.5)

	local Header = Instance.new("TextLabel")
	Header.Name = "Header"
	Header.Size = UDim2.new(1, 0, 0, 26)
	Header.BackgroundColor3 = Theme.Header
	Header.BorderSizePixel = 0
	Header.Text = "  " .. string.upper(title)
	Header.TextXAlignment = Enum.TextXAlignment.Left
	Header.TextColor3 = Theme.Text
	Header.Font = Theme.HeaderFont
	Header.TextSize = 13
	Header.TextStrokeTransparency = 0.7
	Header.LayoutOrder = 0
	Header.Parent = Frame
	corner(Header, 6)

	local HeaderMask = Instance.new("Frame")
	HeaderMask.BackgroundColor3 = Theme.Header
	HeaderMask.BorderSizePixel = 0
	HeaderMask.Size = UDim2.new(1, 0, 0, 8)
	HeaderMask.Position = UDim2.new(0, 0, 1, -8)
	HeaderMask.Parent = Header

	-- Divider line separating the header from the toggle rows, tinted to
	-- match this category's outline color for a clearly bounded look.
	local Divider = Instance.new("Frame")
	Divider.Name = "Divider"
	Divider.Size = UDim2.new(1, 0, 0, 1)
	Divider.BackgroundColor3 = outlineColor
	Divider.BackgroundTransparency = 0.3
	Divider.BorderSizePixel = 0
	Divider.LayoutOrder = 1
	Divider.Parent = Frame

	-- Collapse ("-") button, sits at the right edge of the header
	local CollapseBtn = Instance.new("TextButton")
	CollapseBtn.Name = "Collapse"
	CollapseBtn.Size = UDim2.new(0, 20, 0, 20)
	CollapseBtn.Position = UDim2.new(1, -23, 0, 3)
	CollapseBtn.BackgroundTransparency = 1
	CollapseBtn.Text = "-"
	CollapseBtn.TextColor3 = Theme.SubText
	CollapseBtn.Font = Theme.HeaderFont
	CollapseBtn.TextSize = 16
	CollapseBtn.AutoButtonColor = false
	CollapseBtn.ZIndex = 2
	CollapseBtn.Parent = Header

	local List = Instance.new("UIListLayout")
	List.Parent = Frame
	List.SortOrder = Enum.SortOrder.LayoutOrder
	List.Padding = UDim.new(0, 0)

	local RowContainer = Instance.new("Frame")
	RowContainer.Name = "Rows"
	RowContainer.BackgroundTransparency = 1
	RowContainer.Size = UDim2.new(1, 0, 0, 0)
	RowContainer.AutomaticSize = Enum.AutomaticSize.Y
	RowContainer.LayoutOrder = 2
	RowContainer.Parent = Frame

	local RowLayout = Instance.new("UIListLayout")
	RowLayout.Parent = RowContainer
	RowLayout.SortOrder = Enum.SortOrder.LayoutOrder
	RowLayout.Padding = UDim.new(0, 0)

	local function refreshSize()
		if win.Collapsed then
			Frame.Size = UDim2.new(0, width, 0, 26)
		else
			Frame.Size = UDim2.new(0, width, 0, 27 + RowContainer.AbsoluteSize.Y + 6)
		end
	end
	RowContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshSize)
	refreshSize()

	CollapseBtn.MouseButton1Click:Connect(function()
		win.Collapsed = not win.Collapsed
		RowContainer.Visible = not win.Collapsed
		CollapseBtn.Text = win.Collapsed and "+" or "-"
		refreshSize()
	end)

	makeDraggable(Frame, Header)

	win.Frame = Frame
	win.RowContainer = RowContainer
	win.Title = title
	table.insert(Krypton.Windows, win)
	return win
end

--// ACTIVE-TOGGLES LIST (top-right HUD) -----------------------------------
-- Shows a live text list of every toggle currently switched ON, e.g. like
-- an "Arraylist"/watermark HUD. Hidden by default; call
-- Krypton:SetToggleListVisible(true) or wire it to a toggle to show it.
local ToggleListFrame = Instance.new("Frame")
ToggleListFrame.Name = "ActiveToggleList"
ToggleListFrame.AnchorPoint = Vector2.new(1, 0)
ToggleListFrame.Position = UDim2.new(1, -10, 0, 10)
ToggleListFrame.Size = UDim2.new(0, 200, 0, 0)
ToggleListFrame.AutomaticSize = Enum.AutomaticSize.Y
ToggleListFrame.BackgroundTransparency = 1
ToggleListFrame.Visible = true
ToggleListFrame.Parent = ScreenGui

local ToggleListLayout = Instance.new("UIListLayout")
ToggleListLayout.Parent = ToggleListFrame
ToggleListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ToggleListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
ToggleListLayout.Padding = UDim.new(0, 2)

-- Watermark header ("KRYPTON") always shown above the active list
local Watermark = Instance.new("TextLabel")
Watermark.Name = "Watermark"
Watermark.BackgroundTransparency = 1
Watermark.Size = UDim2.new(0, 200, 0, 30)
Watermark.Text = "KRYPTON"
Watermark.TextXAlignment = Enum.TextXAlignment.Right
Watermark.TextColor3 = Theme.Accent
Watermark.Font = Enum.Font.Bangers
Watermark.TextSize = 30
Watermark.TextStrokeTransparency = 0.4
Watermark.LayoutOrder = -1
Watermark.Parent = ToggleListFrame

local registeredToggles = {} -- { {name=..., getState=fn, label=TextLabel}, ... }
local toggleListEnabled = false
local watermarkEnabled = true
Watermark.Visible = watermarkEnabled

local function refreshToggleList()
	for _, entry in ipairs(registeredToggles) do
		entry.label.Visible = toggleListEnabled and entry.getState()
	end
end

local function registerInToggleList(name, getState)
	local Label = Instance.new("TextLabel")
	Label.Name = name
	Label.BackgroundTransparency = 1
	Label.Size = UDim2.new(0, 160, 0, 16)
	Label.Text = name
	Label.TextXAlignment = Enum.TextXAlignment.Right
	Label.TextColor3 = Theme.Text
	Label.Font = Theme.HeaderFont
	Label.TextSize = 13
	Label.TextStrokeTransparency = 0.5
	Label.Visible = false
	Label.Parent = ToggleListFrame

	table.insert(registeredToggles, {name = name, getState = getState, label = Label})
end

-- Controls ONLY the live list of active toggle names beneath the watermark.
function Krypton:SetToggleListVisible(visible)
	toggleListEnabled = visible
	refreshToggleList()
end

function Krypton:ToggleListVisible()
	Krypton:SetToggleListVisible(not toggleListEnabled)
end

-- Controls ONLY the "KRYPTON" watermark text, independent of the list above.
function Krypton:SetWatermarkVisible(visible)
	watermarkEnabled = visible
	Watermark.Visible = visible
end

function Krypton:WatermarkVisible()
	Krypton:SetWatermarkVisible(not watermarkEnabled)
end

--// RAINBOW MODE for the toggle list / watermark --------------------------
-- Cycles the hue of the watermark + every visible toggle-list label.
-- Speed is in "hue cycles per second" (roughly) — higher = faster cycling.
local rainbowEnabled = false
local rainbowSpeed = 1

task.spawn(function()
	local hue = 0
	while true do
		if rainbowEnabled then
			hue = (hue + 0.01 * rainbowSpeed) % 1
			local color = Color3.fromHSV(hue, 0.85, 1)
			Watermark.TextColor3 = color
			for _, entry in ipairs(registeredToggles) do
				if entry.label.Visible then
					entry.label.TextColor3 = color
				end
			end
		end
		task.wait(0.03)
	end
end)

function Krypton:SetRainbowEnabled(enabled)
	rainbowEnabled = enabled
	if not enabled then
		Watermark.TextColor3 = Theme.Accent
		for _, entry in ipairs(registeredToggles) do
			entry.label.TextColor3 = Theme.Text
		end
	end
end

function Krypton:SetRainbowSpeed(speed)
	rainbowSpeed = speed
end

function Window:AddToggle(name, callback, default, options)
	callback = callback or function() end
	options = options or {}
	local state = default or false
	local expanded = false
	local hoverColor = options.HoverColor or Theme.RowHover

	-- Outer row wrapper: grows automatically to fit the expand panel
	local Row = Instance.new("Frame")
	Row.Name = name
	Row.Size = UDim2.new(1, 0, 0, 22)
	Row.AutomaticSize = Enum.AutomaticSize.Y
	Row.BackgroundTransparency = 1
	Row.Parent = self.RowContainer

	local RowList = Instance.new("UIListLayout")
	RowList.Parent = Row
	RowList.SortOrder = Enum.SortOrder.LayoutOrder
	RowList.Padding = UDim.new(0, 0)

	-- Top bar: bullet / caret / label (tap = expand) / switch (tap = on-off)
	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1, 0, 0, 22)
	TopBar.BackgroundColor3 = Theme.RowHover
	TopBar.BackgroundTransparency = 1
	TopBar.LayoutOrder = 0
	TopBar.Parent = Row
	corner(TopBar, 4)

	local Bullet = Instance.new("Frame")
	Bullet.Size = UDim2.new(0, 4, 0, 4)
	Bullet.Position = UDim2.new(0, 10, 0.5, -2)
	Bullet.BackgroundColor3 = Theme.Bullet
	Bullet.BorderSizePixel = 0
	Bullet.Parent = TopBar
	corner(Bullet, 2)

	-- Caret shown once at least one sub-option is added; tapping the label
	-- expands/collapses it — this is the mobile-friendly replacement for
	-- "hover to reveal", since touchscreens have no hover state.
	local Caret = Instance.new("TextLabel")
	Caret.BackgroundTransparency = 1
	Caret.Position = UDim2.new(0, 18, 0, 0)
	Caret.Size = UDim2.new(0, 12, 1, 0)
	Caret.Text = ""
	Caret.TextColor3 = Theme.SubText
	Caret.Font = Theme.Font
	Caret.TextSize = 10
	Caret.Parent = TopBar

	local Label = Instance.new("TextButton")
	Label.Name = "Label"
	Label.BackgroundTransparency = 1
	Label.AutoButtonColor = false
	Label.Position = UDim2.new(0, 30, 0, 0)
	Label.Size = UDim2.new(1, -66, 1, 0)
	Label.Text = name
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextColor3 = Theme.SubText
	Label.Font = Theme.Font
	Label.TextSize = 12
	Label.TextStrokeTransparency = 0.75
	Label.Parent = TopBar

	local SwitchBtn = Instance.new("TextButton")
	SwitchBtn.Name = "SwitchButton"
	SwitchBtn.Size = UDim2.new(0, 34, 1, 0)
	SwitchBtn.Position = UDim2.new(1, -34, 0, 0)
	SwitchBtn.BackgroundTransparency = 1
	SwitchBtn.AutoButtonColor = false
	SwitchBtn.Text = ""
	SwitchBtn.Parent = TopBar

	local Track = Instance.new("Frame")
	Track.Size = UDim2.new(0, 26, 0, 14)
	Track.Position = UDim2.new(0, 4, 0.5, -7)
	Track.BackgroundColor3 = Color3.fromRGB(50, 50, 56)
	Track.BorderSizePixel = 0
	Track.Parent = SwitchBtn
	corner(Track, 7)
	stroke(Track, Theme.Border, 1)

	local Knob = Instance.new("Frame")
	Knob.Size = UDim2.new(0, 10, 0, 10)
	Knob.Position = UDim2.new(0, 2, 0.5, -5)
	Knob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	Knob.BorderSizePixel = 0
	Knob.Parent = Track
	corner(Knob, 5)
	stroke(Knob, Color3.fromRGB(180, 180, 186), 1)

	-- Expand panel: holds nested sliders / sub-toggles / keybinds.
	-- Hidden and empty until AddSlider/AddSubToggle/AddKeybind is called.
	local ExpandPanel = Instance.new("Frame")
	ExpandPanel.Name = "ExpandPanel"
	ExpandPanel.BackgroundTransparency = 1
	ExpandPanel.Size = UDim2.new(1, 0, 0, 0)
	ExpandPanel.AutomaticSize = Enum.AutomaticSize.Y
	ExpandPanel.Visible = false
	ExpandPanel.LayoutOrder = 1
	ExpandPanel.Parent = Row

	local ExpandList = Instance.new("UIListLayout")
	ExpandList.Parent = ExpandPanel
	ExpandList.SortOrder = Enum.SortOrder.LayoutOrder
	ExpandList.Padding = UDim.new(0, 0)

	local function applyVisual(animated)
		local trackColor = state and Theme.Accent or Color3.fromRGB(50, 50, 56)
		local knobPos = state and UDim2.new(0, 14, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
		local labelColor = state and Theme.Text or Theme.SubText

		if animated then
			TweenService:Create(Track, TweenInfo.new(0.12), {BackgroundColor3 = trackColor}):Play()
			TweenService:Create(Knob, TweenInfo.new(0.12), {Position = knobPos}):Play()
		else
			Track.BackgroundColor3 = trackColor
			Knob.Position = knobPos
		end
		Label.TextColor3 = labelColor
	end
	applyVisual(false)

	TopBar.MouseEnter:Connect(function()
		TopBar.BackgroundColor3 = hoverColor
		TopBar.BackgroundTransparency = 0.4
	end)
	TopBar.MouseLeave:Connect(function() TopBar.BackgroundTransparency = 1 end)

	-- Tap the SWITCH = flip on/off (this is the only thing that changes state)
	SwitchBtn.MouseButton1Click:Connect(function()
		state = not state
		applyVisual(true)
		callback(state)
		refreshToggleList()
		if options.Notify ~= false then
			Krypton:Notify(name, state and "Enabled" or "Disabled", options.NotifyDuration, options.NotifyColor)
		end
	end)

	-- Tap the LABEL = expand/collapse the dropdown of nested options.
	-- Works identically on mobile (tap) and desktop (click) — no hover needed.
	Label.MouseButton1Click:Connect(function()
		if Caret.Text == "" then return end -- nothing to expand yet
		expanded = not expanded
		ExpandPanel.Visible = expanded
		Caret.Text = expanded and "\226\150\190" or "\226\150\184" -- ▾ / ▸
	end)

	registerInToggleList(name, function() return state end)
	refreshToggleList()

	local handle = {}

	function handle:Set(value)
		state = value
		applyVisual(true)
		callback(state)
		refreshToggleList()
	end

	function handle:Get()
		return state
	end

	-- Adds a nested slider inside this toggle's tap-to-expand dropdown.
	function handle:AddSlider(subName, min, max, subDefault, subCallback)
		subCallback = subCallback or function() end
		Caret.Text = "\226\150\184" -- ▸, marks that this row now has content

		local value = subDefault or min

		local SubRow = Instance.new("Frame")
		SubRow.Size = UDim2.new(1, 0, 0, 22)
		SubRow.BackgroundTransparency = 1
		SubRow.Parent = ExpandPanel

		local SubLabel = Instance.new("TextLabel")
		SubLabel.BackgroundTransparency = 1
		SubLabel.Position = UDim2.new(0, 32, 0, 0)
		SubLabel.Size = UDim2.new(0.55, -32, 1, 0)
		SubLabel.Text = subName
		SubLabel.TextXAlignment = Enum.TextXAlignment.Left
		SubLabel.TextColor3 = Theme.SubText
		SubLabel.Font = Theme.Font
		SubLabel.TextSize = 11
		SubLabel.Parent = SubRow

		local Bar = Instance.new("Frame")
		Bar.Size = UDim2.new(0.45, -10, 0, 4)
		Bar.Position = UDim2.new(0.55, 0, 0.5, -2)
		Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 56)
		Bar.BorderSizePixel = 0
		Bar.Parent = SubRow
		corner(Bar, 2)
		stroke(Bar, Theme.Border, 1)

		local Fill = Instance.new("Frame")
		Fill.BackgroundColor3 = Theme.Accent
		Fill.BorderSizePixel = 0
		Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
		Fill.Parent = Bar
		corner(Fill, 2)

		local ValueLabel = Instance.new("TextLabel")
		ValueLabel.BackgroundTransparency = 1
		ValueLabel.Position = UDim2.new(1, -30, 0, 0)
		ValueLabel.Size = UDim2.new(0, 28, 1, 0)
		ValueLabel.Text = tostring(math.floor(value))
		ValueLabel.TextColor3 = Theme.Text
		ValueLabel.Font = Theme.Font
		ValueLabel.TextSize = 11
		ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
		ValueLabel.Parent = SubRow

		local dragging = false
		local function setFromX(xPos)
			local rel = math.clamp((xPos - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
			value = min + (max - min) * rel
			Fill.Size = UDim2.new(rel, 0, 1, 0)
			ValueLabel.Text = tostring(math.floor(value))
			subCallback(value)
		end

		Bar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				setFromX(input.Position.X)
			end
		end)
		Bar.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
				setFromX(input.Position.X)
			end
		end)

		return {
			Set = function(_, v) value = v; local rel = (v - min) / (max - min)
				Fill.Size = UDim2.new(rel, 0, 1, 0); ValueLabel.Text = tostring(math.floor(v)) end,
			Get = function() return value end,
		}
	end

	-- Adds a nested on/off sub-toggle inside this toggle's dropdown.
	function handle:AddSubToggle(subName, subCallback, subDefault)
		subCallback = subCallback or function() end
		Caret.Text = "\226\150\184"
		local subState = subDefault or false

		local SubRow = Instance.new("TextButton")
		SubRow.Size = UDim2.new(1, 0, 0, 20)
		SubRow.BackgroundTransparency = 1
		SubRow.AutoButtonColor = false
		SubRow.Text = ""
		SubRow.Parent = ExpandPanel

		local SubLabel = Instance.new("TextLabel")
		SubLabel.BackgroundTransparency = 1
		SubLabel.Position = UDim2.new(0, 32, 0, 0)
		SubLabel.Size = UDim2.new(1, -66, 1, 0)
		SubLabel.Text = subName
		SubLabel.TextXAlignment = Enum.TextXAlignment.Left
		SubLabel.TextColor3 = Theme.SubText
		SubLabel.Font = Theme.Font
		SubLabel.TextSize = 11
		SubLabel.Parent = SubRow

		local SubTrack = Instance.new("Frame")
		SubTrack.Size = UDim2.new(0, 22, 0, 12)
		SubTrack.Position = UDim2.new(1, -30, 0.5, -6)
		SubTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 56)
		SubTrack.BorderSizePixel = 0
		SubTrack.Parent = SubRow
		corner(SubTrack, 6)
		stroke(SubTrack, Theme.Border, 1)

		local SubKnob = Instance.new("Frame")
		SubKnob.Size = UDim2.new(0, 8, 0, 8)
		SubKnob.Position = UDim2.new(0, 2, 0.5, -4)
		SubKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
		SubKnob.BorderSizePixel = 0
		SubKnob.Parent = SubTrack
		corner(SubKnob, 4)

		local function applySub()
			SubTrack.BackgroundColor3 = subState and Theme.Accent or Color3.fromRGB(50, 50, 56)
			SubKnob.Position = subState and UDim2.new(0, 12, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)
		end
		applySub()

		SubRow.MouseButton1Click:Connect(function()
			subState = not subState
			applySub()
			subCallback(subState)
		end)

		return {
			Set = function(_, v) subState = v; applySub(); subCallback(subState) end,
			Get = function() return subState end,
		}
	end

	-- Adds a nested keybind row (tap, then press a key to bind it).
	function handle:AddKeybind(subName, subDefault, subCallback)
		subCallback = subCallback or function() end
		Caret.Text = "\226\150\184"
		local bound = subDefault
		local listening = false

		local SubRow = Instance.new("TextButton")
		SubRow.Size = UDim2.new(1, 0, 0, 20)
		SubRow.BackgroundTransparency = 1
		SubRow.AutoButtonColor = false
		SubRow.Text = ""
		SubRow.Parent = ExpandPanel

		local SubLabel = Instance.new("TextLabel")
		SubLabel.BackgroundTransparency = 1
		SubLabel.Position = UDim2.new(0, 32, 0, 0)
		SubLabel.Size = UDim2.new(0.5, -32, 1, 0)
		SubLabel.Text = subName
		SubLabel.TextXAlignment = Enum.TextXAlignment.Left
		SubLabel.TextColor3 = Theme.SubText
		SubLabel.Font = Theme.Font
		SubLabel.TextSize = 11
		SubLabel.Parent = SubRow

		local KeyLabel = Instance.new("TextLabel")
		KeyLabel.BackgroundTransparency = 1
		KeyLabel.Position = UDim2.new(0.5, 0, 0, 0)
		KeyLabel.Size = UDim2.new(0.5, -10, 1, 0)
		KeyLabel.Text = bound and bound.Name or "UNKNOWN"
		KeyLabel.TextXAlignment = Enum.TextXAlignment.Right
		KeyLabel.TextColor3 = Theme.Text
		KeyLabel.Font = Theme.Font
		KeyLabel.TextSize = 11
		KeyLabel.Parent = SubRow

		SubRow.MouseButton1Click:Connect(function()
			listening = true
			KeyLabel.Text = "..."
		end)

		UserInputService.InputBegan:Connect(function(input, gpe)
			if listening and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
				bound = input.KeyCode
				KeyLabel.Text = bound.Name
				listening = false
				subCallback(bound)
			end
		end)

		return {
			Set = function(_, keyCode) bound = keyCode; KeyLabel.Text = keyCode.Name; subCallback(bound) end,
			Get = function() return bound end,
		}
	end

	return handle
end

function Window:SetVisible(visible)
	self.Visible = visible
	self.Frame.Visible = visible
end

function Window:Toggle()
	self:SetVisible(not self.Visible)
end

function Krypton:CreateMasterToggle(title)
	local win = self:CreateWindow(title or "CLIENT", {Width = 140})

	win:AddToggle("All Categories", function(state)
		Krypton:SetAllCategoriesVisible(state, win)
	end, true)

	for _, w in ipairs(Krypton.Windows) do
		if w ~= win then
			win:AddToggle(w.Title, function(state) w:SetVisible(state) end, true)
		end
	end
	return win
end

-- Shows/hides every category window at once. `exceptWin` (optional) is left
-- untouched — used so the panel holding this switch never hides itself.
function Krypton:SetAllCategoriesVisible(visible, exceptWin)
	for _, w in ipairs(Krypton.Windows) do
		if w ~= exceptWin then
			w:SetVisible(visible)
		end
	end
end

function Krypton:BindVisibilityToggleKey(keyCode)
	keyCode = keyCode or Enum.KeyCode.RightShift
	local hidden = false
	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.KeyCode == keyCode then
			hidden = not hidden
			for _, w in ipairs(Krypton.Windows) do w:SetVisible(not hidden) end
		end
	end)
end

--// NOTIFICATIONS -----------------------------------------------------------
-- Small toast popups, e.g. Krypton:Notify("Auto Sell", "Enabled").
-- Stack in a chosen corner and fade out automatically after a duration.
local NotificationSettings = {
	Duration = 3, -- seconds
	Corner = "BottomRight", -- "TopRight", "TopLeft", "BottomRight", "BottomLeft"
	Color = Theme.Accent, -- default border/title color for notifications
}

local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "Notifications"
NotifHolder.BackgroundTransparency = 1
NotifHolder.Size = UDim2.new(0, 220, 1, -20)
NotifHolder.Position = UDim2.new(1, -10, 0, 10)
NotifHolder.AnchorPoint = Vector2.new(1, 0)
NotifHolder.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotifHolder
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 6)

local function applyCornerAnchor()
	local corner = NotificationSettings.Corner
	if corner == "TopRight" then
		NotifHolder.AnchorPoint = Vector2.new(1, 0)
		NotifHolder.Position = UDim2.new(1, -10, 0, 10)
		NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	elseif corner == "TopLeft" then
		NotifHolder.AnchorPoint = Vector2.new(0, 0)
		NotifHolder.Position = UDim2.new(0, 10, 0, 10)
		NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	elseif corner == "BottomLeft" then
		NotifHolder.AnchorPoint = Vector2.new(0, 1)
		NotifHolder.Position = UDim2.new(0, 10, 1, -10)
		NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	else -- BottomRight (default)
		NotifHolder.AnchorPoint = Vector2.new(1, 1)
		NotifHolder.Position = UDim2.new(1, -10, 1, -10)
		NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	end
end
applyCornerAnchor()

function Krypton:SetNotificationDuration(seconds)
	NotificationSettings.Duration = seconds
end

function Krypton:SetNotificationCorner(corner)
	NotificationSettings.Corner = corner
	applyCornerAnchor()
end

function Krypton:SetNotificationColor(color)
	NotificationSettings.Color = color
end

function Krypton:Notify(title, message, duration, color)
	duration = duration or NotificationSettings.Duration
	color = color or NotificationSettings.Color

	local Card = Instance.new("Frame")
	Card.BackgroundColor3 = Theme.Background
	Card.Size = UDim2.new(1, 0, 0, 0)
	Card.AutomaticSize = Enum.AutomaticSize.Y
	Card.BackgroundTransparency = 0.05
	Card.Parent = NotifHolder
	corner(Card, 6)
	stroke(Card, color, 1)

	local Pad = Instance.new("UIPadding")
	Pad.PaddingTop = UDim.new(0, 8)
	Pad.PaddingBottom = UDim.new(0, 8)
	Pad.PaddingLeft = UDim.new(0, 10)
	Pad.PaddingRight = UDim.new(0, 10)
	Pad.Parent = Card

	local CardList = Instance.new("UIListLayout")
	CardList.Parent = Card
	CardList.SortOrder = Enum.SortOrder.LayoutOrder
	CardList.Padding = UDim.new(0, 2)

	local Title = Instance.new("TextLabel")
	Title.BackgroundTransparency = 1
	Title.Size = UDim2.new(1, 0, 0, 16)
	Title.Text = title
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextColor3 = color
	Title.Font = Theme.HeaderFont
	Title.TextSize = 13
	Title.Parent = Card

	local Message = Instance.new("TextLabel")
	Message.BackgroundTransparency = 1
	Message.Size = UDim2.new(1, 0, 0, 14)
	Message.Text = message or ""
	Message.TextXAlignment = Enum.TextXAlignment.Left
	Message.TextColor3 = Theme.SubText
	Message.Font = Theme.Font
	Message.TextSize = 11
	Message.Visible = message ~= nil and message ~= ""
	Message.Parent = Card

	Card.BackgroundTransparency = 1
	Title.TextTransparency = 1
	Message.TextTransparency = 1
	local cardStroke = Card:FindFirstChildOfClass("UIStroke")
	cardStroke.Transparency = 1

	TweenService:Create(Card, TweenInfo.new(0.18), {BackgroundTransparency = 0.05}):Play()
	TweenService:Create(cardStroke, TweenInfo.new(0.18), {Transparency = 0.2}):Play()
	TweenService:Create(Title, TweenInfo.new(0.18), {TextTransparency = 0}):Play()
	TweenService:Create(Message, TweenInfo.new(0.18), {TextTransparency = 0}):Play()

	task.delay(duration, function()
		if not Card or not Card.Parent then return end
		TweenService:Create(Card, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
		TweenService:Create(cardStroke, TweenInfo.new(0.25), {Transparency = 1}):Play()
		TweenService:Create(Title, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
		TweenService:Create(Message, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
		task.wait(0.25)
		Card:Destroy()
	end)
end

--// BLUR -------------------------------------------------------------------
-- A real Lighting.BlurEffect, controllable via toggle + size slider.
local Lighting = game:GetService("Lighting")
local oldBlur = Lighting:FindFirstChild("KryptonBlur")
if oldBlur then oldBlur:Destroy() end

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Name = "KryptonBlur"
BlurEffect.Size = 0
BlurEffect.Enabled = false
BlurEffect.Parent = Lighting

function Krypton:SetBlurEnabled(enabled)
	BlurEffect.Enabled = enabled
end

function Krypton:SetBlurSize(size)
	BlurEffect.Size = size
end

--[[
	USAGE (this is a library now — require it, don't run it directly):

	local Krypton = require(path.to.KryptonUI)

	local Combat = Krypton:CreateWindow("COMBAT", {OutlineColor = Color3.fromRGB(210, 60, 60)})
	Combat:AddToggle("Toggle A", function(state) print("Toggle A:", state) end)

	-- Tap a toggle's LABEL (not its switch) to expand a dropdown with
	-- nested options underneath it — works the same on mobile and desktop.
	local AutoCrystal = Combat:AddToggle("Auto Crystal", function(state) end)
	AutoCrystal:AddSlider("Placement Range", 1, 6, 4, function(v) end)
	AutoCrystal:AddSubToggle("Break Blocks", function(state) end)
	AutoCrystal:AddKeybind("Trigger Key", Enum.KeyCode.RightControl, function(key) end)

	local Misc = Krypton:CreateWindow("MISC", {OutlineColor = Color3.fromRGB(200, 170, 60)})
	local AutoSell = Misc:AddToggle("Auto Sell", function(state) end)
	AutoSell:AddSlider("Sell Delay", 0, 10, 2, function(v) end)

	local Render = Krypton:CreateWindow("RENDER", {OutlineColor = Color3.fromRGB(70, 140, 255)})

	local Rainbow = Render:AddToggle("Rainbow", function(state) Krypton:SetRainbowEnabled(state) end)
	Rainbow:AddSlider("Speed", 1, 10, 3, function(v) Krypton:SetRainbowSpeed(v) end)

	local Blur = Render:AddToggle("Blur", function(state) Krypton:SetBlurEnabled(state) end)
	Blur:AddSlider("Blur Size", 0, 40, 24, function(v) Krypton:SetBlurSize(v) end)

	-- Small panel that shows/hides every category window at once
	local Client = Krypton:CreateMasterToggle("KRYPTON+")
	Client:AddToggle("Watermark", function(state) Krypton:SetWatermarkVisible(state) end, true)
	Client:AddToggle("Toggle List", function(state) Krypton:SetToggleListVisible(state) end, false)

	Krypton:BindVisibilityToggleKey(Enum.KeyCode.RightShift)

	-- Notifications fire automatically on every toggle flip, or call manually:
	Krypton:Notify("Auto Sell", "Enabled")
	Krypton:SetNotificationDuration(4)
	Krypton:SetNotificationCorner("BottomRight") -- TopRight / TopLeft / BottomLeft
]]

return Krypton
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
