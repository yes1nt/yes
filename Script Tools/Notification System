--[[
    Made by FriedPotato

    This script is free to use, edit, modify, and redistribute.
    You do NOT need permission from me to change or use any part of this code.

    Credits are appreciated but not required.
]]
--[[
    GUIDE

    local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Script%20Tools/Notification%20System"))()

    format:
    Notify.Type(Title, Caption, Duration, Callback)

    samples:
    Notify.Success("Success", "Hello world", 3)
    Notify.Error("Error", "Something went wrong", 3)
    Notify.Warning("Warning", "Be careful", 3)
    Notify.Info("Info", "Notification loaded", 3)
    Notify.Success("Done", "Loaded", 3, function()
        print("clicked notification")
    end)

    -- remove all notifications
    Notify.ClearAll()
]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RenderStepped = RunService.RenderStepped
local Stepped = RunService.Stepped
local Heartbeat = RunService.Heartbeat

-- ============================================
-- CONFIGURATION
-- ============================================
local CONFIG = {
    MaxNotifications = 6,
    DefaultLifespan = 3,
    EntryDuration = 0.4,
    ExitDuration = 0.35,
    StaggerDelay = 0.08,
    Padding = 8,
    Position = UDim2.new(1, -20, 0, 20), -- Top-right corner
    AnchorPoint = Vector2.new(1, 0),
    
    -- Colors (Premium Dark Theme)
    Colors = {
        Background = Color3.fromRGB(25, 25, 35),
        Border = Color3.fromRGB(60, 60, 80),
        Title = Color3.fromRGB(255, 255, 255),
        Caption = Color3.fromRGB(180, 180, 200),
        Accent = Color3.fromRGB(100, 150, 255),
        Success = Color3.fromRGB(80, 200, 120),
        Error = Color3.fromRGB(230, 80, 80),
        Warning = Color3.fromRGB(230, 180, 60),
        Info = Color3.fromRGB(100, 150, 255)
    }
}

-- ============================================
-- NOTIFICATION CLASS
-- ============================================
local Notification = {}
Notification.__index = Notification

-- Active notifications tracking (prevents memory leaks)
local ActiveNotifications = {}
local NotificationQueue = {}
local ScreenGui = nil
local NotificationContainer = nil

-- ============================================
-- UI CREATION HELPERS
-- ============================================
local function CreateInstance(className, props)
    local instance = Instance.new(className)
    for prop, value in pairs(props) do
        instance[prop] = value
    end
    return instance
end

local function EnsureUI()
    if ScreenGui and ScreenGui.Parent then return end
    
    ScreenGui = CreateInstance("ScreenGui", {
        Name = "PremiumNotifications",
        Parent = PlayerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999
    })
    
    -- Container for all notifications
    NotificationContainer = CreateInstance("Frame", {
        Name = "Container",
        Parent = ScreenGui,
        Size = UDim2.new(0, 320, 1, -40),
        Position = CONFIG.Position,
        AnchorPoint = CONFIG.AnchorPoint,
        BackgroundTransparency = 1,
        ClipsDescendants = false
    })
    
    -- UIListLayout for automatic stacking
    local listLayout = CreateInstance("UIListLayout", {
        Parent = NotificationContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, CONFIG.Padding)
    })
    
    -- Padding at top
    CreateInstance("UIPadding", {
        Parent = NotificationContainer,
        PaddingTop = UDim.new(0, 0),
        PaddingRight = UDim.new(0, 0)
    })
end

-- ============================================
-- NOTIFICATION METHODS
-- ============================================
function Notification.new(title, caption, lifespan, notifType, callback)
    EnsureUI()
    
    local self = setmetatable({}, Notification)
    
    -- Properties
    self.Title = title or "Notification"
    self.Caption = caption or ""
    self.Lifespan = lifespan or CONFIG.DefaultLifespan
    self.Type = notifType or "Info"
    self.Callback = callback
    self.IsDestroyed = false
    self.Connections = {} -- Track connections for cleanup
    
    -- Determine accent color
    local accentColor = CONFIG.Colors.Accent
    if self.Type == "Success" then accentColor = CONFIG.Colors.Success
    elseif self.Type == "Error" then accentColor = CONFIG.Colors.Error
    elseif self.Type == "Warning" then accentColor = CONFIG.Colors.Warning
    end
    
    -- ============================================
    -- BUILD UI
    -- ============================================
    
    -- Main Frame
    self.Frame = CreateInstance("Frame", {
        Name = "Notification",
        Parent = NotificationContainer,
        Size = UDim2.new(1, 0, 0, 0), -- Auto-height
        BackgroundColor3 = CONFIG.Colors.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        LayoutOrder = #ActiveNotifications
    })
    
    -- Corner radius
    CreateInstance("UICorner", {
        Parent = self.Frame,
        CornerRadius = UDim.new(0, 10)
    })
    
    -- Stroke/Border
    CreateInstance("UIStroke", {
        Parent = self.Frame,
        Color = accentColor,
        Thickness = 1.5,
        Transparency = 0.3
    })
    
    -- Shadow
    local shadow = CreateInstance("ImageLabel", {
        Name = "Shadow",
        Parent = self.Frame,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 4),
        Size = UDim2.new(1, 20, 1, 20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://1316045217", -- Shadow image
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = -1
    })
    
    -- Content Container
    local content = CreateInstance("Frame", {
        Name = "Content",
        Parent = self.Frame,
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    CreateInstance("UIPadding", {
        Parent = content,
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8)
    })
    
    -- Accent Bar (Left side)
    local accentBar = CreateInstance("Frame", {
        Name = "AccentBar",
        Parent = self.Frame,
        Size = UDim2.new(0, 3, 1, -16),
        Position = UDim2.new(0, 6, 0, 8),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0
    })
    CreateInstance("UICorner", {
        Parent = accentBar,
        CornerRadius = UDim.new(1, 0)
    })
    
    -- Title Label
    self.TitleLabel = CreateInstance("TextLabel", {
        Name = "Title",
        Parent = content,
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = self.Title,
        TextColor3 = CONFIG.Colors.Title,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        RichText = true
    })
    
    -- Caption Label
    if self.Caption ~= "" then
        self.CaptionLabel = CreateInstance("TextLabel", {
            Name = "Caption",
            Parent = content,
            Size = UDim2.new(1, -20, 0, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = self.Caption,
            TextColor3 = CONFIG.Colors.Caption,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            RichText = true
        })
    end
    
    -- Progress Bar (Bottom)
    self.ProgressBar = CreateInstance("Frame", {
        Name = "ProgressBar",
        Parent = self.Frame,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        BackgroundTransparency = 0.2
    })
    
    -- ============================================
    -- ANIMATIONS
    -- ============================================
    
    -- Initial state (off-screen right + invisible)
    self.Frame.Position = UDim2.new(1, 50, 0, 0)
    self.Frame.BackgroundTransparency = 1
    self.Frame.Size = UDim2.new(1, 0, 0, 0)
    
    -- ENTRY ANIMATION
    task.delay(#ActiveNotifications * CONFIG.StaggerDelay, function()
        if self.IsDestroyed then return end
        
        -- Slide in from right
        local entryTween = TweenService:Create(
            self.Frame,
            TweenInfo.new(CONFIG.EntryDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 0.1
            }
        )
        entryTween:Play()
        
        -- Progress bar shrink animation
        local progressTween = TweenService:Create(
            self.ProgressBar,
            TweenInfo.new(self.Lifespan, Enum.EasingStyle.Linear),
            { Size = UDim2.new(0, 0, 0, 2) }
        )
        progressTween:Play()
        
        -- Auto-dismiss after lifespan
        local dismissConnection
        dismissConnection = task.delay(self.Lifespan + CONFIG.EntryDuration, function()
            self:Dismiss()
        end)
        table.insert(self.Connections, dismissConnection)
    end)
    
    -- Hover effect - pause progress
    local hoverConnection = self.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            -- Could add hover pause logic here
        end
    end)
    table.insert(self.Connections, hoverConnection)
    
    -- Click to dismiss
    local clickConnection = self.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            if self.Callback then
                self.Callback()
                self.Callback = nil
            end
            self:Dismiss()
        end
    end)
    table.insert(self.Connections, clickConnection)
    
    table.insert(ActiveNotifications, self)
    
    -- Cleanup old notifications if exceeding max
    if #ActiveNotifications > CONFIG.MaxNotifications then
        ActiveNotifications[1]:Dismiss()
    end
    
    return self
end

-- ============================================
-- DISMISS / DESTROY
-- ============================================
function Notification:Dismiss()
    if self.IsDestroyed then return end
    self.IsDestroyed = true
    
    -- Remove from active list
    for i, notif in ipairs(ActiveNotifications) do
        if notif == self then
            table.remove(ActiveNotifications, i)
            break
        end
    end
    
    -- EXIT ANIMATION
    local exitTween = TweenService:Create(
        self.Frame,
        TweenInfo.new(CONFIG.ExitDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        }
    )
    
    exitTween:Play()
    
    exitTween.Completed:Connect(function()
        self:Destroy()
    end)
end

function Notification:Destroy()
    -- Disconnect all connections
    for _, conn in ipairs(self.Connections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    self.Connections = {}
    
    -- Destroy UI
    if self.Frame then
        self.Frame:Destroy()
        self.Frame = nil
    end
    
    -- Clear references
    self.TitleLabel = nil
    self.CaptionLabel = nil
    self.ProgressBar = nil
end

-- ============================================
-- GLOBAL CLEANUP
-- ============================================
local function CleanupAll()
    for _, notif in ipairs(ActiveNotifications) do
        notif:Destroy()
    end
    ActiveNotifications = {}
    
    if ScreenGui then
        ScreenGui:Destroy()
        ScreenGui = nil
    end
end

-- Auto-cleanup on character reset
LocalPlayer.CharacterRemoving:Connect(CleanupAll)

-- ============================================
-- PUBLIC API
-- ============================================
local PremiumNotify = {}

function PremiumNotify.Notify(title, caption, lifespan, notifType, callback)
    return Notification.new(title, "\n\n"..caption, lifespan, notifType, callback)
end

function PremiumNotify.Success(title, caption, lifespan, callback)
    return Notification.new(title, "\n\n"..caption, lifespan, "Success", callback)
end

function PremiumNotify.Error(title, caption, lifespan, callback)
    return Notification.new(title, "\n\n"..caption, lifespan, "Error", callback)
end

function PremiumNotify.Warning(title, caption, lifespan, callback)
    return Notification.new(title, "\n\n"..caption, lifespan, "Warning", callback)
end

function PremiumNotify.Info(title, caption, lifespan, callback)
    return Notification.new(title, "\n\n"..caption, lifespan, "Info", callback)
end

function PremiumNotify.ClearAll()
    CleanupAll()
end

return PremiumNotify
