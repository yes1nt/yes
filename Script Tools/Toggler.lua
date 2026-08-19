local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local Module = {}

-- ============================================================
-- MAKE TOGGLE
-- MakeToggle(Name, Function)
-- ============================================================

function Module.MakeToggle(Name, Callback)

	assert(type(Name) == "string", "MakeToggle: Name must be a string")
	assert(type(Callback) == "function", "MakeToggle: Function must be a function")

	local data = {
		Instance = nil,
		Connections = {},
		Destroyed = false
	}

	local connections = data.Connections

	-- ========================================================
	-- CONNECTION HELPER
	-- ========================================================

	local function connect(signal, fn)

		local connection = signal:Connect(fn)
		table.insert(connections, connection)

		return connection
	end

	-- ========================================================
	-- CONFIG
	-- ========================================================

	local BASE_COLOR = Color3.fromRGB(27, 28, 40)
	local GLASS_COLOR = Color3.fromRGB(78, 75, 112)
	local ACCENT_COLOR = Color3.fromRGB(174, 151, 255)
	local TEXT_COLOR = Color3.fromRGB(248, 247, 255)

	local normalSize

	local dragging = false
	local isPressed = false
	local didDrag = false

	local activeInput = nil

	local dragStart
	local startPosition

	local dragThreshold = 7

	-- ========================================================
	-- SCREEN GUI
	-- ========================================================

	local screenGui = Instance.new("ScreenGui")

	screenGui.Name = "ToggleButton"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui

	data.Instance = screenGui

	-- ========================================================
	-- SHADOW
	-- ========================================================

	local shadow = Instance.new("Frame")

	shadow.Name = "Shadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.fromScale(0.94, 0.08)

	shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.72
	shadow.BorderSizePixel = 0

	shadow.ZIndex = 1
	shadow.Parent = screenGui

	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = UDim.new(0.32, 0)
	shadowCorner.Parent = shadow

	local shadowStroke = Instance.new("UIStroke")
	shadowStroke.Color = ACCENT_COLOR
	shadowStroke.Thickness = 6
	shadowStroke.Transparency = 0.9
	shadowStroke.Parent = shadow

	-- ========================================================
	-- BUTTON
	-- ========================================================

	local button = Instance.new("TextButton")

	button.Name = "Toggle"
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.Position = UDim2.fromScale(0.94, 0.08)

	button.BackgroundColor3 = BASE_COLOR
	button.BackgroundTransparency = 0.08
	button.BorderSizePixel = 0

	button.Text = ""
	button.AutoButtonColor = false

	button.ZIndex = 5
	button.Parent = screenGui

	-- ========================================================
	-- CORNER
	-- ========================================================

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.32, 0)
	corner.Parent = button

	-- ========================================================
	-- BORDER
	-- ========================================================

	local stroke = Instance.new("UIStroke")
	stroke.Color = ACCENT_COLOR
	stroke.Thickness = 1.35
	stroke.Transparency = 0.12
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = button

	-- ========================================================
	-- GLASS GRADIENT
	-- ========================================================

	local gradient = Instance.new("UIGradient")

	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(
			0,
			Color3.fromRGB(82, 77, 120)
		),

		ColorSequenceKeypoint.new(
			0.35,
			Color3.fromRGB(37, 38, 53)
		),

		ColorSequenceKeypoint.new(
			0.65,
			Color3.fromRGB(29, 30, 43)
		),

		ColorSequenceKeypoint.new(
			1,
			Color3.fromRGB(80, 75, 116)
		)
	}

	gradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.12),
		NumberSequenceKeypoint.new(0.5, 0.02),
		NumberSequenceKeypoint.new(1, 0.12)
	}

	gradient.Rotation = 90
	gradient.Parent = button

	-- ========================================================
	-- INNER GLASS
	-- ========================================================

	local inner = Instance.new("Frame")

	inner.Name = "Glass"
	inner.AnchorPoint = Vector2.new(0.5, 0.5)
	inner.Position = UDim2.fromScale(0.5, 0.5)
	inner.Size = UDim2.fromScale(0.94, 0.82)

	inner.BackgroundColor3 = GLASS_COLOR
	inner.BackgroundTransparency = 0.82
	inner.BorderSizePixel = 0

	inner.ZIndex = 6
	inner.Parent = button

	local innerCorner = Instance.new("UICorner")
	innerCorner.CornerRadius = UDim.new(0.28, 0)
	innerCorner.Parent = inner

	-- ========================================================
	-- TOP GLASS REFLECTION
	-- ========================================================

	local reflection = Instance.new("Frame")

	reflection.Name = "Reflection"
	reflection.AnchorPoint = Vector2.new(0.5, 0.5)
	reflection.Position = UDim2.fromScale(0.5, 0.18)
	reflection.Size = UDim2.fromScale(0.72, 0.14)

	reflection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	reflection.BackgroundTransparency = 0.92
	reflection.BorderSizePixel = 0

	reflection.ZIndex = 7
	reflection.Parent = button

	local reflectionCorner = Instance.new("UICorner")
	reflectionCorner.CornerRadius = UDim.new(1, 0)
	reflectionCorner.Parent = reflection

	-- ========================================================
	-- TEXT SHADOW
	-- ========================================================

	local textShadow = Instance.new("TextLabel")

	textShadow.Name = "TextShadow"
	textShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	textShadow.Position = UDim2.fromScale(0.5, 0.525)
	textShadow.Size = UDim2.fromScale(0.84, 0.64)

	textShadow.BackgroundTransparency = 1

	textShadow.Text = Name
	textShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
	textShadow.TextTransparency = 0.72

	textShadow.Font = Enum.Font.GothamBold
	textShadow.TextScaled = true
	textShadow.TextXAlignment = Enum.TextXAlignment.Center
	textShadow.TextYAlignment = Enum.TextYAlignment.Center

	textShadow.ZIndex = 9
	textShadow.Parent = button

	local shadowConstraint = Instance.new("UITextSizeConstraint")
	shadowConstraint.MinTextSize = 10
	shadowConstraint.MaxTextSize = 16
	shadowConstraint.Parent = textShadow

	-- ========================================================
	-- TEXT
	-- ========================================================

	local text = Instance.new("TextLabel")

	text.Name = "Text"
	text.AnchorPoint = Vector2.new(0.5, 0.5)
	text.Position = UDim2.fromScale(0.5, 0.5)
	text.Size = UDim2.fromScale(0.84, 0.64)

	text.BackgroundTransparency = 1

	text.Text = Name
	text.TextColor3 = TEXT_COLOR
	text.Font = Enum.Font.GothamBold
	text.TextScaled = true
	text.TextXAlignment = Enum.TextXAlignment.Center
	text.TextYAlignment = Enum.TextYAlignment.Center

	text.ZIndex = 10
	text.Parent = button

	local textConstraint = Instance.new("UITextSizeConstraint")
	textConstraint.MinTextSize = 10
	textConstraint.MaxTextSize = 16
	textConstraint.Parent = text

	-- ========================================================
	-- TWEEN HELPER
	-- ========================================================

	local function tween(object, time, properties, style, direction)

		return TweenService:Create(
			object,
			TweenInfo.new(
				time,
				style or Enum.EasingStyle.Quint,
				direction or Enum.EasingDirection.Out
			),
			properties
		)
	end

	-- ========================================================
	-- RESPONSIVE SIZE
	-- ========================================================

	local function updateButton()

		if data.Destroyed then
			return
		end

		local viewport = camera.ViewportSize

		local width = math.clamp(
			viewport.X * 0.13,
			95,
			170
		)

		local height = math.clamp(
			viewport.Y * 0.052,
			38,
			58
		)

		normalSize = UDim2.fromOffset(
			width,
			height
		)

		if not isPressed and not dragging then

			button.Size = normalSize

			shadow.Size = UDim2.fromOffset(
				width + 10,
				height + 10
			)
		end
	end

	-- ========================================================
	-- PRESS EFFECT
	-- ========================================================

	local function pressEffect()

		if data.Destroyed or not normalSize then
			return
		end

		isPressed = true

		tween(
			button,
			0.075,
			{
				Size = UDim2.fromOffset(
					normalSize.X.Offset * 0.91,
					normalSize.Y.Offset * 0.91
				)
			},
			Enum.EasingStyle.Quart
		):Play()

		tween(
			shadow,
			0.075,
			{
				Size = UDim2.fromOffset(
					normalSize.X.Offset,
					normalSize.Y.Offset
				),

				BackgroundTransparency = 0.82
			},
			Enum.EasingStyle.Quart
		):Play()

		tween(
			stroke,
			0.075,
			{
				Thickness = 1.9
			}
		):Play()
	end

	-- ========================================================
	-- RELEASE EFFECT
	-- ========================================================

	local function releaseEffect()

		if data.Destroyed or not normalSize then
			return
		end

		isPressed = false

		tween(
			button,
			0.3,
			{
				Size = normalSize
			},
			Enum.EasingStyle.Back
		):Play()

		tween(
			shadow,
			0.3,
			{
				Size = UDim2.fromOffset(
					normalSize.X.Offset + 10,
					normalSize.Y.Offset + 10
				),

				BackgroundTransparency = 0.72
			},
			Enum.EasingStyle.Back
		):Play()

		tween(
			stroke,
			0.2,
			{
				Thickness = 1.35
			}
		):Play()
	end

	-- ========================================================
	-- INPUT BEGIN
	-- FIRST INPUT ONLY
	-- ========================================================

	connect(button.InputBegan, function(input)

		if data.Destroyed then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		-- First input owns the interaction.
		if activeInput then
			return
		end

		activeInput = input

		dragging = true
		didDrag = false

		dragStart = input.Position
		startPosition = button.Position

		pressEffect()
	end)

	-- ========================================================
	-- DRAG
	-- ========================================================

	connect(UserInputService.InputChanged, function(input)

		if data.Destroyed then
			return
		end

		if not dragging then
			return
		end

		-- Only first input can move the button.
		if input ~= activeInput then
			return
		end

		local delta = input.Position - dragStart

		if math.abs(delta.X) > dragThreshold
			or math.abs(delta.Y) > dragThreshold then

			didDrag = true
		end

		local viewport = camera.ViewportSize

		local x =
			startPosition.X.Scale
			+ delta.X / viewport.X

		local y =
			startPosition.Y.Scale
			+ delta.Y / viewport.Y

		local halfWidth =
			button.AbsoluteSize.X / viewport.X / 2

		local halfHeight =
			button.AbsoluteSize.Y / viewport.Y / 2

		x = math.clamp(
			x,
			halfWidth,
			1 - halfWidth
		)

		y = math.clamp(
			y,
			halfHeight,
			1 - halfHeight
		)

		button.Position = UDim2.fromScale(x, y)
	end)

	-- ========================================================
	-- INPUT END
	-- ========================================================

	connect(UserInputService.InputEnded, function(input)

		if data.Destroyed then
			return
		end

		-- Only original input can release.
		if input ~= activeInput then
			return
		end

		activeInput = nil
		dragging = false

		releaseEffect()
	end)

	-- ========================================================
	-- HOVER
	-- ========================================================

	connect(button.MouseEnter, function()

		if data.Destroyed or isPressed then
			return
		end

		tween(
			button,
			0.18,
			{
				BackgroundTransparency = 0.025
			}
		):Play()

		tween(
			stroke,
			0.18,
			{
				Transparency = 0,
				Thickness = 1.7
			}
		):Play()

		tween(
			shadowStroke,
			0.18,
			{
				Transparency = 0.76
			}
		):Play()

		tween(
			reflection,
			0.18,
			{
				BackgroundTransparency = 0.86
			}
		):Play()
	end)

	connect(button.MouseLeave, function()

		if data.Destroyed or isPressed then
			return
		end

		tween(
			button,
			0.2,
			{
				BackgroundTransparency = 0.08
			}
		):Play()

		tween(
			stroke,
			0.2,
			{
				Transparency = 0.12,
				Thickness = 1.35
			}
		):Play()

		tween(
			shadowStroke,
			0.2,
			{
				Transparency = 0.9
			}
		):Play()

		tween(
			reflection,
			0.2,
			{
				BackgroundTransparency = 0.92
			}
		):Play()
	end)

	-- ========================================================
	-- CLICK
	-- ========================================================

	connect(button.MouseButton1Click, function()

		if data.Destroyed then
			return
		end

		-- Drag should never count as click.
		if didDrag then
			return
		end

		Callback()

		pressEffect()

		task.delay(0.085, function()

			if data.Destroyed then
				return
			end

			if button.Parent then
				releaseEffect()
			end
		end)
	end)

	-- ========================================================
	-- GRADIENT ANIMATION
	-- ========================================================

	local gradientConnection

	gradientConnection = RunService.RenderStepped:Connect(function()

		if data.Destroyed then
			return
		end

		gradient.Rotation += 0.15

		if gradient.Rotation >= 450 then
			gradient.Rotation = 90
		end
	end)

	table.insert(connections, gradientConnection)

	-- ========================================================
	-- INITIALIZE
	-- ========================================================

	updateButton()

	connect(
		camera:GetPropertyChangedSignal("ViewportSize"),
		updateButton
	)

	connect(
		button:GetPropertyChangedSignal("Position"),
		function()

			if data.Destroyed then
				return
			end

			if shadow.Parent then
				shadow.Position = button.Position
			end
		end
	)

	-- ========================================================
	-- DESTROY
	-- ========================================================

	function data:Destroy()

		if self.Destroyed then
			return
		end

		self.Destroyed = true

		activeInput = nil
		dragging = false
		isPressed = false

		-- Disconnect EVERYTHING.
		for i = #connections, 1, -1 do

			local connection = connections[i]

			if connection and connection.Connected then
				connection:Disconnect()
			end

			connections[i] = nil
		end

		-- Destroy GUI and all descendants.
		if screenGui and screenGui.Parent then
			screenGui:Destroy()
		end

		self.Instance = nil
	end

	-- ========================================================
	-- AUTOMATIC CLEANUP
	-- ========================================================

	-- If someone manually destroys the ScreenGui,
	-- disconnect everything as well.
	connect(screenGui.Destroying, function()

		if data.Destroyed then
			return
		end

		data.Destroyed = true

		activeInput = nil
		dragging = false
		isPressed = false

		for i = #connections, 1, -1 do

			local connection = connections[i]

			if connection and connection ~= nil and connection.Connected then
				connection:Disconnect()
			end

			connections[i] = nil
		end

		data.Instance = nil
	end)

	return data
end

return Module
