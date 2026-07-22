if getgenv().Password then return end
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvertisementGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui
-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.Position = UDim2.fromScale(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(19,1,50)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = screenGui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.08,0)
corner.Parent = frame
-- TITLE
local title = Instance.new("TextLabel")
title.Parent = frame
title.Name = "Title"
title.Position = UDim2.fromScale(0.1,0.04)
title.Size = UDim2.fromScale(0.8,0.1)
title.BackgroundTransparency = 1
title.Text = "✨ Advertisement"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json")
title.TextXAlignment = Enum.TextXAlignment.Center
-- DIVIDER
local divider = Instance.new("Frame")
divider.Parent = frame
divider.Position = UDim2.fromScale(0,0.16)
divider.Size = UDim2.new(1,0,0,1)
divider.BackgroundColor3 = Color3.fromRGB(100,88,131)
divider.BorderSizePixel = 0
-- ============================================
-- SCROLL FRAME
-- ============================================
local scroll = Instance.new("ScrollingFrame")
scroll.Parent = frame
scroll.Name = "Scroll"
scroll.Position = UDim2.fromScale(0.04,0.19)
scroll.Size = UDim2.fromScale(0.92,0.63)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = Color3.fromRGB(123,47,247)
scroll.ScrollingEnabled = true
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
-- manual canvas control
scroll.AutomaticCanvasSize = Enum.AutomaticSize.None
scroll.CanvasSize = UDim2.new(0,0,0,0)
local padding = Instance.new("UIPadding")
padding.Parent = scroll
padding.PaddingLeft = UDim.new(0,5)
padding.PaddingRight = UDim.new(0,5)
padding.PaddingTop = UDim.new(0,5)
padding.PaddingBottom = UDim.new(0,20)
-- ============================================
-- ADVERTISEMENT TEXT
-- ============================================
local text = Instance.new("TextLabel")
text.Parent = scroll
text.Name = "AdvertisementText"
text.BackgroundTransparency = 1
text.Size = UDim2.new(1, -10, 0, 0)
text.AutomaticSize = Enum.AutomaticSize.Y
text.Text = [[
Hello! I am friedpotatomatoe ✨
You can DM me on discord to commission me
for a custom made script to your liking.
(More awesome than this free one and
more VFX according to your likings.)
✨ Custom Moveset Pricing ✨
Want your own custom moveset or script?
Pricing depends on complexity.
💵 Base Rate:
$6 USD per hour
📋 I'll give an estimate first
depending on features and difficulty.
Most simple scripts:
« 🎨 $20 USD »
OR
« 💰 5,000 Robux »
($1 USD = 250 Robux)
Includes:
🛠️ Custom skills / mechanics
✅ Exclusive to you
✅ Obfuscated
❌ Cannot be resold
❤️ Every commission helps support
my studies and expenses.
DM your idea/details 🚀
]]
text.TextColor3 = Color3.fromRGB(255,255,255)
text.TextWrapped = true
text.TextScaled = false
text.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json")
text.TextXAlignment = Enum.TextXAlignment.Center
text.TextYAlignment = Enum.TextYAlignment.Top
-- ============================================
-- FIXED TEXT SIZE + CANVAS SYSTEM
-- ============================================
local canvasUpdating = false
local function UpdateCanvasSize()
	if canvasUpdating then
		return
	end
	canvasUpdating = true
	task.defer(function()
		task.wait()
		scroll.CanvasSize = UDim2.new(0, 0, 0, text.AbsoluteSize.Y + padding.PaddingTop.Offset + padding.PaddingBottom.Offset + 10)
		canvasUpdating = false
	end)
end
local function UpdateTextSize()
	text.TextSize = math.clamp(frame.AbsoluteSize.Y * 0.03, 12, 60)
	UpdateCanvasSize()
end
UpdateTextSize()
frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateTextSize)
text:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateCanvasSize)
task.defer(UpdateCanvasSize)
-- ============================================
-- CLOSE BUTTON
-- ============================================
local buttonHolder = Instance.new("Frame")
buttonHolder.Parent = frame
buttonHolder.BackgroundTransparency = 1
buttonHolder.Position = UDim2.fromScale(0,0.85)
buttonHolder.Size = UDim2.fromScale(1,0.12)
local close = Instance.new("TextButton")
close.Parent = buttonHolder
close.AnchorPoint = Vector2.new(0.5,0.5)
close.Position = UDim2.fromScale(0.5,0.5)
close.Size = UDim2.fromScale(0.45,0.65)
close.BackgroundColor3 = Color3.fromRGB(0,198,255)
close.BorderSizePixel = 0
close.Text = "CLOSE"
close.TextColor3 = Color3.fromRGB(255,255,255)
close.TextScaled = true
close.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json")
local closeCorner = Instance.new("UICorner")
closeCorner.Parent = close
closeCorner.CornerRadius = UDim.new(0.2,0)
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Parent = close
buttonGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0,198,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(123,47,247))})
buttonGradient.Rotation = 90
-- ============================================
-- RESPONSIVE FRAME
-- ============================================
local camera = workspace.CurrentCamera
local function UpdateFrame()
	local viewport = camera.ViewportSize
	local w = viewport.X
	local h = viewport.Y
	if w > h then
		local size = math.min(h * 0.65, w / 1.5 * 0.65)
		frame.Size = UDim2.fromOffset(size * 1.5, size)
	else
		local size = math.min(w,h) * 0.75
		frame.Size = UDim2.fromOffset(size, size)
	end
end
UpdateFrame()
camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateFrame)
-- ============================================
-- BORDER GLOW
-- ============================================
local stroke = Instance.new("UIStroke")
stroke.Parent = frame
stroke.Thickness = 2
stroke.Transparency = 0.25
stroke.Color = Color3.fromRGB(0,198,255)
local strokeGradient = Instance.new("UIGradient")
strokeGradient.Parent = stroke
strokeGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0,198,255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(123,47,247)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,198,255))})
task.spawn(function()
	while frame.Parent do
		strokeGradient.Rotation += 1
		task.wait()
	end
end)
-- ============================================
-- TITLE GLOW
-- ============================================
local titleStroke = Instance.new("UIStroke")
titleStroke.Parent = title
titleStroke.Color = Color3.fromRGB(0,198,255)
titleStroke.Thickness = 2
titleStroke.Transparency = 0.4
-- ============================================
-- BUTTON HOVER
-- ============================================
close.MouseEnter:Connect(function()
	TweenService:Create(close, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.5, 0.7)}):Play()
end)
close.MouseLeave:Connect(function()
	TweenService:Create(close, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.fromScale(0.45, 0.65)}):Play()
end)
-- ============================================
-- OPEN ANIMATION
-- ============================================
local finalSize = frame.Size
frame.Size = UDim2.fromScale(0, 0)
TweenService:Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = finalSize}):Play()
-- ============================================
-- TEXT GLOW
-- ============================================
local function AddTextGlow(textObject,color)
	for _, thickness in ipairs({2, 4, 6}) do
		local s = Instance.new("UIStroke")
		s.Color = color
		s.Thickness = thickness
		s.Transparency = 0.85
		s.Parent = textObject
	end
end
AddTextGlow(title, Color3.fromRGB(0,198,255))
AddTextGlow(close, Color3.fromRGB(255,255,255))
-- ============================================
-- PARTICLES
-- ============================================
local function AddParticles(mainframe)
	local particleHolder = Instance.new("Frame")
	particleHolder.Name = "Particles"
	particleHolder.Size = UDim2.fromScale(1,1)
	particleHolder.BackgroundTransparency = 1
	particleHolder.ClipsDescendants = true
	particleHolder.Parent = mainframe
	task.spawn(function()
		while mainframe.Parent do
			task.wait(math.random(8,18)/100)
			local particle = Instance.new("Frame")
			particle.Size = UDim2.fromOffset(math.random(2,8), math.random(2,8))
			particle.Position = UDim2.fromScale(math.random(), math.random())
			particle.BackgroundColor3 = mainframe.BackgroundColor3:Lerp(Color3.new(1,1,1), 0.35)
			particle.BackgroundTransparency = 0.15
			particle.BorderSizePixel = 0
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1,0)
			corner.Parent = particle
			particle.Parent = particleHolder
			TweenService:Create(particle, TweenInfo.new(1, Enum.EasingStyle.Quad), {BackgroundTransparency = 1, Position = particle.Position + UDim2.fromOffset(math.random(-60,60), math.random(-60,60))}):Play()
			task.delay(1, function()
				if particle then
					particle:Destroy()
				end
			end)
		end
	end)
end
AddParticles(frame)
close.MouseButton1Click:Once(function()
	screenGui:Destroy()
end)
repeat task.wait() until not screenGui.Parent
