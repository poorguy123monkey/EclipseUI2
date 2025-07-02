--[[
    RADIANT Hub UI
    - Modern, glassmorphic, animated, sidebar navigation
    - Hot pink neon, true black backgrounds, draggable (top bar only)
    - By GPT-4
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Colors & Fonts
local FONT = Enum.Font.GothamBold
local HOT_PINK = Color3.fromRGB(255, 0, 128)
local HOT_PINK2 = Color3.fromRGB(255, 128, 192)
local BG_BLACK = Color3.new(0, 0, 0)
local WHITE = Color3.new(1,1,1)
local SIDEBAR_ICON_BG = Color3.fromRGB(30,30,30)

-- Utility
local function new(class, props)
	local obj = Instance.new(class)
	for k,v in pairs(props or {}) do
		obj[k] = v
	end
	return obj
end

-- Main ScreenGui
local gui = new("ScreenGui", {
	Name = "RADIANTHub",
	Parent = PlayerGui,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
})
gui.Enabled = true -- Show main UI immediately

-- Main window
local window = new("Frame", {
	Parent = gui,
	Name = "Window",
	BackgroundColor3 = BG_BLACK,
	BackgroundTransparency = 0.15,
	Size = UDim2.new(0, 700, 0, 420),
	Position = UDim2.new(0.5, -350, 0.5, -210),
	AnchorPoint = Vector2.new(0.5, 0.5),
	ClipsDescendants = true,
})
new("UICorner", {Parent = window, CornerRadius = UDim.new(0, 22)})
new("UIStroke", {Parent = window, Color = HOT_PINK2, Thickness = 2, Transparency = 0.5})

-- Responsive scaling
local scale = Instance.new("UIScale")
scale.Scale = 1
scale.Parent = window

-- Sidebar
local sidebar = new("Frame", {
	Parent = window,
	BackgroundColor3 = BG_BLACK,
	Size = UDim2.new(0, 80, 1, 0),
	Position = UDim2.new(0, 0, 0, 0),
})
new("UICorner", {Parent = sidebar, CornerRadius = UDim.new(0, 18)})

-- Sidebar: Logo at the top
local logo = new("ImageLabel", {
	Parent = sidebar,
	Image = "rbxassetid://114951910778676", -- Your logo asset id
	BackgroundTransparency = 1,
	Size = UDim2.new(0, 56, 0, 56),
	Position = UDim2.new(0.5, -28, 0, 12),
})

-- Sidebar: Navigation
local nav = new("Frame", {
	Parent = sidebar,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 1, -80),
	Position = UDim2.new(0, 0, 0, 80),
})
local navList = new("UIListLayout", {
	Parent = nav,
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Top,
	Padding = UDim.new(0, 18),
})

local sidebarIcons = {
	{ Name = "Aimbot", Icon = "rbxassetid://6031280882" }, -- gear
}
local sidebarButtons = {}
local selectedSidebar = "Aimbot"

for i, tab in ipairs(sidebarIcons) do
	local btnBg = new("Frame", {
		Parent = nav,
		BackgroundColor3 = selectedSidebar == tab.Name and HOT_PINK or SIDEBAR_ICON_BG,
		Size = UDim2.new(0, 44, 0, 44),
	})
	new("UICorner", {Parent = btnBg, CornerRadius = UDim.new(1, 0)})
	local btn = new("ImageButton", {
		Parent = btnBg,
		Image = tab.Icon,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -12, 1, -12),
		Position = UDim2.new(0, 6, 0, 6),
		ImageColor3 = WHITE,
	})
	sidebarButtons[tab.Name] = btnBg
	btn.MouseButton1Click:Connect(function()
		if selectedSidebar == tab.Name then return end -- Prevent reselecting
		for name, b in pairs(sidebarButtons) do
			TweenService:Create(b, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = SIDEBAR_ICON_BG}):Play()
		end
		TweenService:Create(btnBg, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = HOT_PINK}):Play()
		selectedSidebar = tab.Name
		switchTab(tab.Name)
	end)
end

-- Tab bar at the top of content area (used for dragging)
local tabBar = new("Frame", {
	Parent = window,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -80, 0, 48),
	Position = UDim2.new(0, 80, 0, 0),
})
local tabList = new("UIListLayout", {
	Parent = tabBar,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	Padding = UDim.new(0, 32),
})

local tabNames = { "Aimbot" }
local tabButtons = {}
local currentTab = "Aimbot"

-- REMOVE underline creation and logic
-- local tabUnderline = new("Frame", {
-- 	Parent = tabBar,
-- 	BackgroundColor3 = HOT_PINK,
-- 	Size = UDim2.new(0, 100, 0, 3),
-- 	Position = UDim2.new(0, 0, 1, -3),
-- 	ZIndex = 2,
-- })
-- new("UICorner", {Parent = tabUnderline, CornerRadius = UDim.new(1, 0)})

for i, tabName in ipairs(tabNames) do
	local btn = new("TextButton", {
		Parent = tabBar,
		Text = tabName,
		Font = FONT,
		TextSize = 20,
		TextColor3 = currentTab == tabName and HOT_PINK or WHITE,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 1, 0),
		AutoButtonColor = false,
	})
	tabButtons[tabName] = btn
	btn.MouseButton1Click:Connect(function()
		if currentTab == tabName then return end -- Prevent reselecting
		for name, b in pairs(tabButtons) do
			TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {TextColor3 = WHITE}):Play()
		end
		TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {TextColor3 = HOT_PINK}):Play()
		-- REMOVE underline animation
		-- TweenService:Create(tabUnderline, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(0, btn.Position.X.Offset, 1, -3), Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 3)}):Play()
		currentTab = tabName
		switchTab(tabName)
	end)
end

-- REMOVE updateTabUnderline function
-- local function updateTabUnderline()
-- 	local btn = tabButtons["Aimbot"]
-- 	if btn then
-- 		TweenService:Create(tabUnderline, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
-- 			Position = UDim2.new(0, btn.Position.X.Offset, 1, -3),
-- 			Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 3)
-- 		}):Play()
-- 		for name, b in pairs(tabButtons) do
-- 			TweenService:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {TextColor3 = name == "Aimbot" and HOT_PINK or WHITE}):Play()
-- 		end
-- 	end
-- end

-- Main content area
local content = new("ScrollingFrame", {
	Parent = window,
	BackgroundColor3 = BG_BLACK,
	BackgroundTransparency = 0.1,
	Size = UDim2.new(1, -80, 1, -48),
	Position = UDim2.new(0, 80, 0, 48),
		ClipsDescendants = true,
	ScrollBarThickness = 8,
	CanvasSize = UDim2.new(0, 0, 0, 600), -- Will be updated dynamically
})
new("UICorner", {Parent = content, CornerRadius = UDim.new(0, 18)})
-- Set scrollbar color to just above black
content.ScrollBarImageColor3 = Color3.fromRGB(10,10,10)

-- Utility: Modern Toggle
local function createToggle(parent, text, y)
	local frame = new("Frame", {
		Parent = parent,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -40, 0, 36),
		Position = UDim2.new(0, 20, 0, y),
	})
	local label = new("TextLabel", {
		Parent = frame,
		Text = text,
		Font = FONT,
		TextSize = 18,
		TextColor3 = WHITE,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.7, 0, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	local toggleBtn = new("TextButton", {
		Parent = frame,
		BackgroundColor3 = Color3.fromRGB(40,40,40),
		Size = UDim2.new(0, 48, 0, 24),
		Position = UDim2.new(1, -60, 0.5, -12),
		AutoButtonColor = false,
		Text = "",
	})
	new("UICorner", {Parent = toggleBtn, CornerRadius = UDim.new(1, 0)})
	local knob = new("Frame", {
		Parent = toggleBtn,
		BackgroundColor3 = WHITE,
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(0, 2, 0, 2),
	})
	new("UICorner", {Parent = knob, CornerRadius = UDim.new(1, 0)})
	local toggled = false
	local function updateToggle(animated)
		if toggled then
			if animated then
				TweenService:Create(toggleBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundColor3 = HOT_PINK}):Play()
				TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -22, 0, 2)}):Play()
			else
				toggleBtn.BackgroundColor3 = HOT_PINK
				knob.Position = UDim2.new(1, -22, 0, 2)
			end
		else
			if animated then
				TweenService:Create(toggleBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
				TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 2, 0, 2)}):Play()
			else
				toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
				knob.Position = UDim2.new(0, 2, 0, 2)
			end
		end
	end
	toggleBtn.MouseButton1Click:Connect(function()
		toggled = not toggled
		updateToggle(true)
	end)
	updateToggle(false)
	return frame, function() return toggled end
end

-- Utility: Modern Slider
local isSliderActive = false -- Prevent drag while slider is active
local function createSlider(parent, text, y, min, max, default)
	local frame = new("Frame", {
		Parent = parent,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -40, 0, 44),
		Position = UDim2.new(0, 20, 0, y),
	})
	local label = new("TextLabel", {
		Parent = frame,
		Text = text,
		Font = FONT,
		TextSize = 18,
		TextColor3 = WHITE,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.7, 0, 0, 24),
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	local valueLabel = new("TextLabel", {
		Parent = frame,
		Text = tostring(math.floor(default)),
		Font = FONT,
		TextSize = 18,
		TextColor3 = WHITE,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.3, -12, 0, 24),
		Position = UDim2.new(0.7, 0, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Right,
	})
	local sliderBar = new("Frame", {
		Parent = frame,
		BackgroundColor3 = Color3.fromRGB(40,40,40),
		Size = UDim2.new(1, 0, 0, 8),
		Position = UDim2.new(0, 0, 0, 30),
	})
	new("UICorner", {Parent = sliderBar, CornerRadius = UDim.new(1, 0)})
	local sliderFill = new("Frame", {
		Parent = sliderBar,
		BackgroundColor3 = HOT_PINK,
		Size = UDim2.new((default-min)/(max-min), 0, 1, 0),
	})
	new("UICorner", {Parent = sliderFill, CornerRadius = UDim.new(1, 0)})
	local knob = new("Frame", {
		Parent = sliderBar,
		BackgroundColor3 = WHITE,
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8),
	})
	new("UICorner", {Parent = knob, CornerRadius = UDim.new(1, 0)})
	local draggingSlider = false
	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSlider = true
			isSliderActive = true
		end
	end)
	sliderBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSlider = false
			isSliderActive = false
		end
	end)
	sliderBar.InputChanged:Connect(function(input)
		if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mouse = UserInputService:GetMouseLocation()
			local relX = math.clamp(mouse.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
			local percent = relX / sliderBar.AbsoluteSize.X
			TweenService:Create(sliderFill, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
			TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Position = UDim2.new(percent, -8, 0.5, -8)}):Play()
			local value = min + percent * (max - min)
			value = math.floor(value + 0.5)
			value = math.clamp(value, min, max)
			valueLabel.Text = tostring(value)
		end
	end)
	return frame, function() return tonumber(valueLabel.Text) end
end

-- Utility: Modern Dropdown (for other dropdowns, single select)
local function createDropdown(parent, text, options, y)
	-- Always ensure "None" is first, but do NOT mutate the original options table
	local dropdownOptions = {}
	dropdownOptions[1] = "None"
	local seen = {["None"] = true}
	for i = 1, #options do
		local opt = options[i]
		if not seen[opt] then
			dropdownOptions[#dropdownOptions+1] = opt
			seen[opt] = true
		end
	end

	local frame = new("Frame", {
		Parent = parent,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -40, 0, 36),
		Position = UDim2.new(0, 20, 0, y),
	})
	local label = new("TextLabel", {
		Parent = frame,
		Text = text,
		Font = FONT,
		TextSize = 18,
		TextColor3 = WHITE,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.7, 0, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	local selected = new("TextButton", {
		Parent = frame,
		Text = "",
		Font = FONT,
		TextSize = 18,
		TextColor3 = WHITE,
		BackgroundColor3 = Color3.new(0,0,0),
		Size = UDim2.new(0, 120, 1, 0),
		Position = UDim2.new(1, -130, 0, 0),
		AutoButtonColor = true,
		ClipsDescendants = true,
	})
	new("UICorner", {Parent = selected, CornerRadius = UDim.new(1, 0)})
	local chevron = new("ImageLabel", {
		Parent = selected,
		Image = "rbxassetid://6031091002",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(1, -22, 0.5, -9),
		ZIndex = 2,
		Rotation = 0,
		ImageColor3 = WHITE,
	})

	local dropdownOpen = false
	local optionButtons = {}
	local optionList = new("Frame", {
		Parent = selected,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.new(0,0,0),
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Visible = false,
		ZIndex = 11,
		ClipsDescendants = true,
	})
	local listLayout = new("UIListLayout", {
		Parent = optionList,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 0),
	})

	for i, option in ipairs(dropdownOptions) do
		local optBtn = new("TextButton", {
			Parent = optionList,
			Text = option,
			Font = FONT,
			TextSize = 18,
			TextColor3 = WHITE,
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(0,0,0),
			Size = UDim2.new(1, 0, 0, 28),
			AutoButtonColor = true,
			ZIndex = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
		})
		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 8)
		padding.PaddingRight = UDim.new(0, 8)
		padding.Parent = optBtn
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8.5)
		corner.Parent = optBtn

		optionButtons[optBtn] = true
		optBtn.MouseEnter:Connect(function()
			TweenService:Create(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {BackgroundColor3 = HOT_PINK2}):Play()
		end)
		optBtn.MouseLeave:Connect(function()
			TweenService:Create(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.new(0,0,0)}):Play()
		end)
		optBtn.MouseButton1Click:Connect(function()
			if i == 1 then
				selected.Text = ""
			else
				selected.Text = option
			end
			dropdownOpen = false
			TweenService:Create(selected, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 1, 0)}):Play()
			TweenService:Create(chevron, TweenInfo.new(0.2), {Rotation = 0}):Play()
			optionList.Visible = false
			TweenService:Create(selected, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
		end)
	end

	-- Set initial text to empty (since first option is "None")
	selected.Text = ""

	selected.MouseButton1Click:Connect(function()
		dropdownOpen = not dropdownOpen
		if dropdownOpen then
			optionList.Visible = true
			local optionCount = #dropdownOptions
			local height = optionCount * 28
			TweenService:Create(selected, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 0, height)}):Play()
			TweenService:Create(chevron, TweenInfo.new(0.2), {Rotation = 180}):Play()
			TweenService:Create(selected, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
		else
			TweenService:Create(selected, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 1, 0)}):Play()
			TweenService:Create(chevron, TweenInfo.new(0.2), {Rotation = 0}):Play()
			TweenService:Create(selected, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
			task.wait(0.2)
			optionList.Visible = false
		end
	end)

	selected:GetPropertyChangedSignal("Size"):Connect(function()
		optionList.Size = selected.Size
	end)

	local function onInputBegan(input)
		if dropdownOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePos = UserInputService:GetMouseLocation()
			local absPos = selected.AbsolutePosition
			local absSize = selected.AbsoluteSize
			if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
				dropdownOpen = false
				TweenService:Create(selected, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 1, 0)}):Play()
				TweenService:Create(chevron, TweenInfo.new(0.2), {Rotation = 0}):Play()
				TweenService:Create(selected, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
				task.wait(0.2)
				optionList.Visible = false
			end
		end
	end
	UserInputService.InputBegan:Connect(onInputBegan)
	return frame, function() return selected.Text end
end

-- Tab content setup
local function clearContent()
	for _, child in ipairs(content:GetChildren()) do
		child:Destroy()
	end
end

local function setupAimbotTab()
	clearContent()
	local y = 10
	local sectionHeader = new("TextLabel", {
		Parent = content,
		Text = "Aimbot Controls",
		Font = FONT,
		TextSize = 22,
		TextColor3 = WHITE,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -40, 0, 32),
		Position = UDim2.new(0, 20, 0, y),
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	y = y + 40
	local aimbotToggle = createToggle(content, "Aimbot", y)
	y = y + 40
	-- Arc Type dropdown removed
	local camlockSlider = createSlider(content, "Camlock Holdtime", y, 0, 1, 0)
	y = y + 50
	local offsetSlider = createSlider(content, "Autoshoot Offset", y, -5, 5, 0)
	y = y + 50
	local autoPowerToggle = createToggle(content, "Auto Power", y)
	y = y + 40
	local autoShootToggle = createToggle(content, "Auto Shoot", y)
	y = y + 40
	local indicatorToggle = createToggle(content, "Indicator", y)
	y = y + 40
	local fovToggle = createToggle(content, "FOV", y)
	y = y + 40
	local fovRadiusSlider = createSlider(content, "FOV Radius", y, 0, 100, 50)
end

local tabFunctions = {
	["Aimbot"] = setupAimbotTab,
}

function switchTab(tabName)
	if tabFunctions[tabName] then
		tabFunctions[tabName]()
		currentTab = tabName
		-- REMOVE updateTabUnderline call
		-- updateTabUnderline()
	end
end

-- Settings flyout content
local settingsFlyout = new("Frame", {
	Parent = window,
	BackgroundColor3 = BG_BLACK,
	Size = UDim2.new(0, 220, 1, 0),
	Position = UDim2.new(0, -220, 0, 0),
	Visible = false,
	ZIndex = 10,
})
new("UICorner", {Parent = settingsFlyout, CornerRadius = UDim.new(0, 18)})
new("UIStroke", {Parent = settingsFlyout, Color = HOT_PINK2, Thickness = 2, Transparency = 0.5})

local flyTitle = new("TextLabel", {
	Parent = settingsFlyout,
	Text = "Settings",
	Font = FONT,
	TextSize = 24,
	TextColor3 = HOT_PINK2,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -20, 0, 40),
	Position = UDim2.new(0, 10, 0, 20),
	TextXAlignment = Enum.TextXAlignment.Left,
})
local closeFly = new("TextButton", {
	Parent = settingsFlyout,
	Text = "✕",
	Font = FONT,
	TextSize = 22,
	TextColor3 = HOT_PINK2,
	BackgroundTransparency = 1,
	Size = UDim2.new(0, 40, 0, 40),
	Position = UDim2.new(1, -50, 0, 10),
})
closeFly.MouseButton1Click:Connect(function()
	settingsFlyout.Visible = false
end)

-- Add minimize and close buttons to the top right of the window
local closeBtn = new("TextButton", {
	Parent = window,
	Text = "✕",
	Font = FONT,
	TextSize = 24,
	TextColor3 = HOT_PINK2,
	BackgroundTransparency = 1,
	Size = UDim2.new(0, 40, 0, 40),
	Position = UDim2.new(1, -50, 0, 10),
	ZIndex = 10,
})
local minimizeBtn = new("TextButton", {
	Parent = window,
	Text = "-",
	Font = FONT,
	TextSize = 32,
	TextColor3 = HOT_PINK2,
	BackgroundTransparency = 1,
	Size = UDim2.new(0, 40, 0, 40),
	Position = UDim2.new(1, -100, 0, 10),
	ZIndex = 10,
})

-- Minimized logo button (hidden by default)
local minimizedLogo = new("ImageButton", {
	Parent = gui,
	BackgroundColor3 = BG_BLACK,
	Size = UDim2.new(0, 64, 0, 64),
	Position = UDim2.new(0.5, -32, 0.5, -32),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 0,
	Visible = false,
	ZIndex = 100,
	AutoButtonColor = true,
})
new("UICorner", {Parent = minimizedLogo, CornerRadius = UDim.new(1, 0)})

local logoImg = Instance.new("ImageLabel")
logoImg.Parent = minimizedLogo
logoImg.Image = "rbxassetid://114951910778676"
logoImg.BackgroundTransparency = 1
logoImg.Size = UDim2.new(1, 0, 1, 0)
logoImg.Position = UDim2.new(0, 0, 0, 0)
logoImg.ScaleType = Enum.ScaleType.Fit
logoImg.ZIndex = 101

-- Draggable logic for minimized logo
local miniDragging, miniDragInput, miniDragStart, miniStartPos
minimizedLogo.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		miniDragging = true
		miniDragStart = input.Position
		miniStartPos = minimizedLogo.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				miniDragging = false
			end
		end)
	end
end)
minimizedLogo.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		miniDragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == miniDragInput and miniDragging then
		local delta = input.Position - miniDragStart
		minimizedLogo.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
	end
end)

-- Minimize logic (NO FADE)
minimizeBtn.MouseButton1Click:Connect(function()
	window.BackgroundTransparency = 1 -- Instantly set transparent
	window.Visible = false
	minimizedLogo.Visible = true
end)
minimizedLogo.MouseButton1Click:Connect(function()
	if not miniDragging then
		window.Visible = true
		window.BackgroundTransparency = 0.15 -- Instantly restore transparency
		minimizedLogo.Visible = false
	end
end)

-- Close logic
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Restrict dragging to the top bar only
local dragging, dragInput, dragStart, startPos
tabBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not isSliderActive then
		dragging = true
		dragStart = input.Position
		startPos = window.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
tabBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Start with Aimbot tab
setupAimbotTab()
-- updateTabUnderline() -- REMOVED

return {ScreenGui = gui}
