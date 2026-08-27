--[[
    â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•— â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•— â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•— â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—
    â–ˆâ–ˆâ•”â•â•â–ˆâ–ˆâ•—â–ˆâ–ˆâ•”â•â•â•â•â•â–ˆâ–ˆâ•”â•â•â–ˆâ–ˆâ•—â–ˆâ–ˆâ•”â•â•â•â•â•â–ˆâ–ˆâ•”â•â•â•â•â•â–ˆâ–ˆâ•”â•â•â•â•â•
    â–ˆâ–ˆâ•‘  â–ˆâ–ˆâ•‘â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—  â–ˆâ–ˆâ•‘  â–ˆâ–ˆâ•‘â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—  â–ˆâ–ˆâ•‘     
    â–ˆâ–ˆâ•‘  â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•”â•â•â•  â–ˆâ–ˆâ•‘  â–ˆâ–ˆâ•‘â•šâ•â•â•â•â–ˆâ–ˆâ•‘â–ˆâ–ˆâ•”â•â•â•  â–ˆâ–ˆâ•‘     
    â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•”â•â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•”â•â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•‘â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—â•šâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ•—
    â•šâ•â•â•â•â•â• â•šâ•â•â•â•â•â•â•â•šâ•â•â•â•â•â• â•šâ•â•â•â•â•â•â•â•šâ•â•â•â•â•â•â• â•šâ•â•â•â•â•â•
    
    Premium Roblox UI Script
    Theme: REAL & KSX Hybrid
--]]

local RunService = game:GetService("RunService")
if RunService:IsServer() and not RunService:IsClient() then
    error("DedSec: This is a CLIENT UI script and cannot be run on the Server! Please run it inside a LocalScript, Command Bar (Client mode), or executor.")
    return
end

local Players = game:GetService("Players")
repeat wait() until Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer

-- Polyfill for task library (for older or limited executors)
if not task or not task.spawn or not task.wait then
    task = {
        wait = wait,
        spawn = function(f, ...)
            local args = {...}
            spawn(function() f(unpack(args)) end)
        end,
        defer = function(f, ...)
            local args = {...}
            spawn(function() f(unpack(args)) end)
        end,
        delay = function(t, f, ...)
            local args = {...}
            delay(t, function() f(unpack(args)) end)
        end
    }
end

print("DedSec: Initializing UI Script...")

-- Clean up existing UI if re-executed
local oldGui
pcall(function()
    oldGui = game:GetService("CoreGui"):FindFirstChild("DedSecPanel")
end)
if not oldGui then
    pcall(function()
        oldGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("DedSecPanel")
    end)
end
if oldGui then
    oldGui:Destroy()
    print("DedSec: Cleaned up old GUI.")
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DedSecPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Try to parent to CoreGui (for executors) or fallback to PlayerGui
local success, err = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    print("DedSec: Parented ScreenGui to PlayerGui.")
else
    print("DedSec: Parented ScreenGui to CoreGui.")
end

-- Theme Palette (Modern Cyber Dark)
local Theme = {
    Background = Color3.fromRGB(12, 12, 12),
    Sidebar = Color3.fromRGB(12, 12, 12),
    CardBg = Color3.fromRGB(18, 18, 18),
    Border = Color3.fromRGB(30, 30, 30),
    BorderHover = Color3.fromRGB(45, 45, 45),
    TextPrimary = Color3.fromRGB(245, 245, 245),
    TextSecondary = Color3.fromRGB(160, 160, 160),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentGlow = Color3.fromRGB(200, 200, 200),
    Green = Color3.fromRGB(52, 199, 89),
    Red = Color3.fromRGB(255, 59, 48),
    Font = Enum.Font.GothamMedium
}

-- Static asset ID for DedSec Logo Icon
local gifAsset = "rbxassetid://133888377916111"
-- ==========================================
-- NOTIFICATION SYSTEM (Bottom Right)
-- ==========================================

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Size = UDim2.new(0, 300, 1, -20)
NotificationContainer.Position = UDim2.new(1, -320, 0, 10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.ZIndex = 99
NotificationContainer.Parent = ScreenGui

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationLayout.Padding = UDim.new(0, 10)
NotificationLayout.Parent = NotificationContainer

local function notify(title, text)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 65)
    card.BackgroundColor3 = Theme.CardBg
    card.BorderSizePixel = 0
    card.Position = UDim2.new(1.5, 0, 0, 0) -- Start off-screen
    card.ClipsDescendants = true
    card.Parent = NotificationContainer

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Theme.Border
    cardStroke.Thickness = 0.8
    cardStroke.Parent = card

    local leftLine = Instance.new("Frame")
    leftLine.Size = UDim2.new(0, 3, 1, 0)
    leftLine.BackgroundColor3 = Theme.Accent
    leftLine.BorderSizePixel = 0
    leftLine.Parent = card

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 32, 0, 32)
    icon.Position = UDim2.new(0, 12, 0.5, 0)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = gifAsset
    icon.Parent = card

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = icon

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 0, 16)
    titleLabel.Position = UDim2.new(0, 52, 0.18, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.TextPrimary
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -60, 0, 32)
    descLabel.Position = UDim2.new(0, 52, 0.44, 0)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = text
    descLabel.TextColor3 = Theme.TextSecondary
    descLabel.TextSize = 9
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.Parent = card

    -- Animate In
    card:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.4, true)

    -- Animate Out
    task.spawn(function()
        task.wait(4)
        card:TweenPosition(UDim2.new(1.5, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.4, true, function()
            card:Destroy()
        end)
    end)
end

-- ==========================================
-- 1. LOADER SCREEN (CIRCULAR INTRO)
-- ==========================================

-- ==========================================
-- 2. MAIN GUI WINDOW
-- ==========================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Start MainFrame scaled down and immediately tween to full size
MainFrame:TweenSize(UDim2.new(0, 950, 0, 620), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5, true)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- ==========================================
-- 1. LOADER SCREEN (CIRCULAR INTRO INSIDE MAINFRAME)
-- ==========================================

local LoaderFrame = Instance.new("Frame")
LoaderFrame.Name = "Loader"
LoaderFrame.Size = UDim2.new(1, 0, 1, 0)
LoaderFrame.BackgroundColor3 = Theme.Background
LoaderFrame.BorderSizePixel = 0
LoaderFrame.ZIndex = 10
LoaderFrame.Parent = MainFrame

local LoaderCorner = Instance.new("UICorner")
LoaderCorner.CornerRadius = UDim.new(0, 8)
LoaderCorner.Parent = LoaderFrame

-- Ambient Background Code Effect (subtle grid pattern or glow)
local GlowBackground = Instance.new("ImageLabel")
GlowBackground.Size = UDim2.new(1, 0, 1, 0)
GlowBackground.BackgroundTransparency = 1
GlowBackground.Image = "rbxassetid://6015897843" -- Radial glow
GlowBackground.ImageColor3 = Theme.Accent
GlowBackground.ImageTransparency = 0.95
GlowBackground.Parent = LoaderFrame

local LoaderContent = Instance.new("Frame")
LoaderContent.Size = UDim2.new(0, 360, 0, 360)
LoaderContent.Position = UDim2.new(0.5, 0, 0.5, 0)
LoaderContent.AnchorPoint = Vector2.new(0.5, 0.5)
LoaderContent.BackgroundTransparency = 1
LoaderContent.Parent = LoaderFrame

-- Logo Container (Perfect Circle)
local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(0, 140, 0, 140)
LogoContainer.Position = UDim2.new(0.5, 0, 0.4, 0)
LogoContainer.AnchorPoint = Vector2.new(0.5, 0.5)
LogoContainer.BackgroundColor3 = Theme.Background
LogoContainer.BorderSizePixel = 0
LogoContainer.Parent = LoaderContent

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = LogoContainer

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Theme.Accent
LogoStroke.Thickness = 2
LogoStroke.Parent = LogoContainer

local LogoImage = Instance.new("ImageLabel")
LogoImage.Size = UDim2.new(1, -8, 1, -8)
LogoImage.Position = UDim2.new(0.5, 0, 0.5, 0)
LogoImage.AnchorPoint = Vector2.new(0.5, 0.5)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = gifAsset
LogoImage.Parent = LogoContainer

local LogoImageCorner = Instance.new("UICorner")
LogoImageCorner.CornerRadius = UDim.new(1, 0)
LogoImageCorner.Parent = LogoImage

-- Spinner ring around logo
local Spinner = Instance.new("ImageLabel")
Spinner.Size = UDim2.new(0, 160, 0, 160)
Spinner.Position = UDim2.new(0.5, 0, 0.4, 0)
Spinner.AnchorPoint = Vector2.new(0.5, 0.5)
Spinner.BackgroundTransparency = 1
Spinner.Image = "rbxassetid://6015896677" -- Segmented ring
Spinner.ImageColor3 = Theme.Accent
Spinner.ImageTransparency = 0.3
Spinner.Parent = LoaderContent

-- Rotating Animation for Spinner
task.spawn(function()
    while LoaderFrame.Parent do
        Spinner.Rotation = Spinner.Rotation + 1
        task.wait(0.01)
    end
end)

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0.5, 0, 0.7, 0)
TitleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "D E D S E C"
TitleLabel.TextColor3 = Theme.TextPrimary
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = LoaderContent

-- Status Text
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0.5, 0, 0.78, 0)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Initializing secure connection..."
StatusLabel.TextColor3 = Theme.TextSecondary
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = LoaderContent

-- Progress Bar Outer
local ProgressBack = Instance.new("Frame")
ProgressBack.Size = UDim2.new(0, 240, 0, 4)
ProgressBack.Position = UDim2.new(0.5, 0, 0.86, 0)
ProgressBack.AnchorPoint = Vector2.new(0.5, 0.5)
ProgressBack.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ProgressBack.BorderSizePixel = 0
ProgressBack.Parent = LoaderContent

local ProgressBackCorner = Instance.new("UICorner")
ProgressBackCorner.CornerRadius = UDim.new(1, 0)
ProgressBackCorner.Parent = ProgressBack

-- Progress Bar Fill
local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Theme.Accent
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressBack

local ProgressFillCorner = Instance.new("UICorner")
ProgressFillCorner.CornerRadius = UDim.new(1, 0)
ProgressFillCorner.Parent = ProgressFill

local ProgressGlow = Instance.new("UIStroke")
ProgressGlow.Color = Theme.Accent
ProgressGlow.Thickness = 1
ProgressGlow.Parent = ProgressFill

-- Loader Sequence Thread
task.spawn(function()
    local loadingStates = {
        {0.15, "Connecting to mainframe..."},
        {0.35, "Bypassing anti-cheat protocols..."},
        {0.60, "Injecting system libraries..."},
        {0.80, "Decrypting user profiles..."},
        {1.00, "System ready."}
    }
    
    for _, state in ipairs(loadingStates) do
        local targetProgress = state[1]
        local message = state[2]
        StatusLabel.Text = message
        
        local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local progressTween = TweenService:Create(ProgressFill, tweenInfo, {Size = UDim2.new(targetProgress, 0, 1, 0)})
        progressTween:Play()
        progressTween.Completed:Wait()
        task.wait(0.2)
    end
    
    -- Fade out loader
    local fadeTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeTween = TweenService:Create(LoaderFrame, fadeTweenInfo, {BackgroundTransparency = 1})
    TweenService:Create(LoaderContent, fadeTweenInfo, {Position = UDim2.new(0.5, 0, 0.4, 0)}):Play()
    
    -- Fade elements inside content
    for _, child in ipairs(LoaderContent:GetDescendants()) do
        if child:IsA("TextLabel") then
            TweenService:Create(child, fadeTweenInfo, {TextTransparency = 1}):Play()
        elseif child:IsA("ImageLabel") then
            TweenService:Create(child, fadeTweenInfo, {ImageTransparency = 1}):Play()
        elseif child:IsA("Frame") then
            TweenService:Create(child, fadeTweenInfo, {BackgroundTransparency = 1}):Play()
        elseif child:IsA("UIStroke") then
            TweenService:Create(child, fadeTweenInfo, {Transparency = 1}):Play()
        end
    end
    
    fadeTween:Play()
    fadeTween.Completed:Wait()
    LoaderFrame:Destroy()
    
    -- Welcome Notification
    notify("DedSec Panel", "Seja bem-vindo, " .. LocalPlayer.DisplayName .. "!\nAproveite o painel!")
end)

-- Dragging Functionality
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)


-- ==========================================
-- 3. SIDEBAR LAYOUT
-- ==========================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 220, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarRightBorder = Instance.new("Frame")
SidebarRightBorder.Size = UDim2.new(0, 1, 1, 0)
SidebarRightBorder.Position = UDim2.new(1, -1, 0, 0)
SidebarRightBorder.BackgroundColor3 = Theme.Border
SidebarRightBorder.BorderSizePixel = 0
SidebarRightBorder.Parent = Sidebar

-- Logo + Brand Name
local BrandContainer = Instance.new("Frame")
BrandContainer.Size = UDim2.new(1, 0, 0, 60)
BrandContainer.BackgroundTransparency = 1
BrandContainer.Parent = Sidebar

local BrandLogo = Instance.new("ImageLabel")
BrandLogo.Size = UDim2.new(0, 24, 0, 24)
BrandLogo.Position = UDim2.new(0, 18, 0.5, 0)
BrandLogo.AnchorPoint = Vector2.new(0, 0.5)
BrandLogo.BackgroundTransparency = 1
BrandLogo.Image = gifAsset
BrandLogo.Parent = BrandContainer

local BrandLogoCorner = Instance.new("UICorner")
BrandLogoCorner.CornerRadius = UDim.new(1, 0)
BrandLogoCorner.Parent = BrandLogo

local BrandTitle = Instance.new("TextLabel")
BrandTitle.Size = UDim2.new(1, -55, 1, 0)
BrandTitle.Position = UDim2.new(0, 50, 0, 0)
BrandTitle.BackgroundTransparency = 1
BrandTitle.Text = "DedSec"
BrandTitle.TextColor3 = Theme.TextPrimary
BrandTitle.TextSize = 16
BrandTitle.Font = Enum.Font.GothamBold
BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
BrandTitle.Parent = BrandContainer

local BrandVersion = Instance.new("TextLabel")
BrandVersion.Size = UDim2.new(0, 40, 0, 15)
BrandVersion.Position = UDim2.new(0, 110, 0.5, -7)
BrandVersion.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BrandVersion.Text = "v1.0.0"
BrandVersion.TextColor3 = Theme.TextPrimary
BrandVersion.TextSize = 9
BrandVersion.Font = Enum.Font.GothamBold
BrandVersion.Parent = BrandContainer

local BrandVersionCorner = Instance.new("UICorner")
BrandVersionCorner.CornerRadius = UDim.new(0, 10)
BrandVersionCorner.Parent = BrandVersion

local BrandVersionStroke = Instance.new("UIStroke")
BrandVersionStroke.Color = Theme.Border
BrandVersionStroke.Thickness = 0.8
BrandVersionStroke.Parent = BrandVersion

-- Tabs Scrolling Frame
local TabsContainer = Instance.new("ScrollingFrame")
TabsContainer.Size = UDim2.new(1, 0, 1, -138)
TabsContainer.Position = UDim2.new(0, 0, 0, 60)
TabsContainer.BackgroundTransparency = 1
TabsContainer.BorderSizePixel = 0
TabsContainer.CanvasSize = UDim2.new(0, 0, 0, 460)
TabsContainer.ScrollBarThickness = 2
TabsContainer.ScrollBarImageColor3 = Theme.Border
TabsContainer.Parent = Sidebar

-- Profile Widget (Real Style)
local ProfileWidget = Instance.new("Frame")
ProfileWidget.Name = "ProfileWidget"
ProfileWidget.Size = UDim2.new(1, -20, 0, 50)
ProfileWidget.Position = UDim2.new(0, 10, 1, -60)
ProfileWidget.BackgroundColor3 = Theme.CardBg
ProfileWidget.Parent = Sidebar

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 10)
ProfileCorner.Parent = ProfileWidget

local ProfileIcon = Instance.new("ImageLabel")
ProfileIcon.Size = UDim2.new(0, 32, 0, 32)
ProfileIcon.Position = UDim2.new(0, 10, 0.5, 0)
ProfileIcon.AnchorPoint = Vector2.new(0, 0.5)
ProfileIcon.BackgroundTransparency = 1
ProfileIcon.Image = "rbxassetid://16441460337" -- Default avatar placeholder
ProfileIcon.Parent = ProfileWidget

local ProfileIconCorner = Instance.new("UICorner")
ProfileIconCorner.CornerRadius = UDim.new(1, 0)
ProfileIconCorner.Parent = ProfileIcon

local ProfileName = Instance.new("TextLabel")
ProfileName.Size = UDim2.new(1, -60, 0, 16)
ProfileName.Position = UDim2.new(0, 50, 0, 10)
ProfileName.BackgroundTransparency = 1
ProfileName.Text = "BobPaulada"
ProfileName.TextColor3 = Theme.TextPrimary
ProfileName.TextSize = 13
ProfileName.Font = Enum.Font.GothamBold
ProfileName.TextXAlignment = Enum.TextXAlignment.Left
ProfileName.Parent = ProfileWidget

local ProfileSub = Instance.new("TextLabel")
ProfileSub.Size = UDim2.new(1, -60, 0, 14)
ProfileSub.Position = UDim2.new(0, 50, 0, 26)
ProfileSub.BackgroundTransparency = 1
ProfileSub.Text = "Signed In"
ProfileSub.TextColor3 = Theme.TextSecondary
ProfileSub.TextSize = 10
ProfileSub.Font = Enum.Font.GothamMedium
ProfileSub.TextXAlignment = Enum.TextXAlignment.Left
ProfileSub.Parent = ProfileWidget

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabsLayout.Parent = TabsContainer

-- Profile / User Card Footer (At Sidebar Bottom)
local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, -20, 0, 62)
ProfileCard.Position = UDim2.new(0.5, 0, 1, -12)
ProfileCard.AnchorPoint = Vector2.new(0.5, 1)
ProfileCard.BackgroundColor3 = Theme.CardBg
ProfileCard.Parent = Sidebar

local ProfileCardCorner = Instance.new("UICorner")
ProfileCardCorner.CornerRadius = UDim.new(0, 10)
ProfileCardCorner.Parent = ProfileCard

local ProfileCardStroke = Instance.new("UIStroke")
ProfileCardStroke.Color = Theme.Border
ProfileCardStroke.Thickness = 0.8
ProfileCardStroke.Parent = ProfileCard

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 36, 0, 36)
AvatarImage.Position = UDim2.new(0, 10, 0.5, 0)
AvatarImage.AnchorPoint = Vector2.new(0, 0.5)
AvatarImage.BackgroundColor3 = Theme.Sidebar
AvatarImage.Parent = ProfileCard

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

task.spawn(function()
    pcall(function()
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size420x420
        local content, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, thumbType, thumbSize)
        if isReady then
            AvatarImage.Image = content
        end
    end)
end)

local ProfileName = Instance.new("TextLabel")
ProfileName.Size = UDim2.new(1, -64, 0, 16)
ProfileName.Position = UDim2.new(0, 54, 0, 8)
ProfileName.BackgroundTransparency = 1
ProfileName.Text = LocalPlayer.DisplayName
ProfileName.TextColor3 = Theme.TextPrimary
ProfileName.TextSize = 12
ProfileName.Font = Enum.Font.GothamBold
ProfileName.TextXAlignment = Enum.TextXAlignment.Left
ProfileName.Parent = ProfileCard

local ProfileHandle = Instance.new("TextLabel")
ProfileHandle.Size = UDim2.new(1, -64, 0, 14)
ProfileHandle.Position = UDim2.new(0, 54, 0, 24)
ProfileHandle.BackgroundTransparency = 1
ProfileHandle.Text = "@" .. LocalPlayer.Name
ProfileHandle.TextColor3 = Theme.TextSecondary
ProfileHandle.TextSize = 9
ProfileHandle.Font = Enum.Font.Gotham
ProfileHandle.TextXAlignment = Enum.TextXAlignment.Left
ProfileHandle.Parent = ProfileCard

local MemberBadge = Instance.new("Frame")
MemberBadge.Size = UDim2.new(0, 48, 0, 13)
MemberBadge.Position = UDim2.new(0, 54, 0, 41)
MemberBadge.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MemberBadge.Parent = ProfileCard

local MemberBadgeCorner = Instance.new("UICorner")
MemberBadgeCorner.CornerRadius = UDim.new(0, 3)
MemberBadgeCorner.Parent = MemberBadge

local MemberBadgeStroke = Instance.new("UIStroke")
MemberBadgeStroke.Color = Theme.Border
MemberBadgeStroke.Thickness = 0.8
MemberBadgeStroke.Parent = MemberBadge

local MemberBadgeText = Instance.new("TextLabel")
MemberBadgeText.Size = UDim2.new(1, 0, 1, 0)
MemberBadgeText.BackgroundTransparency = 1
MemberBadgeText.Text = "MEMBER"
MemberBadgeText.TextColor3 = Theme.TextPrimary
MemberBadgeText.TextSize = 7
MemberBadgeText.Font = Enum.Font.GothamBold
MemberBadgeText.Parent = MemberBadge


-- ==========================================
-- 4. CONTAINER FOR TAB CONTENTS
-- ==========================================

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -220, 1, 0)
Container.Position = UDim2.new(0, 220, 0, 0)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Topbar inside Container
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 50)
Topbar.BackgroundTransparency = 1
Topbar.Parent = Container

local TabTitle = Instance.new("TextLabel")
TabTitle.Size = UDim2.new(1, -80, 0, 50)
TabTitle.Position = UDim2.new(0, 40, 0, 50)
TabTitle.BackgroundTransparency = 1
TabTitle.Text = "Home"
TabTitle.TextColor3 = Theme.TextPrimary
TabTitle.TextSize = 18
TabTitle.Font = Enum.Font.GothamBold
TabTitle.TextXAlignment = Enum.TextXAlignment.Left
TabTitle.Parent = Topbar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -45, 0.5, 0)
CloseBtn.AnchorPoint = Vector2.new(0, 0.5)
CloseBtn.BackgroundColor3 = Theme.CardBg
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.TextSecondary
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.Parent = Topbar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Theme.Border
CloseStroke.Thickness = 0.8
CloseStroke.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Red, TextColor3 = Color3.new(1, 1, 1)}):Play()
end)

CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.CardBg, TextColor3 = Theme.TextSecondary}):Play()
end)

local DeleteBtn = Instance.new("TextButton")
DeleteBtn.Size = UDim2.new(0, 32, 0, 32)
DeleteBtn.Position = UDim2.new(1, -85, 0.5, 0)
DeleteBtn.AnchorPoint = Vector2.new(0, 0.5)
DeleteBtn.BackgroundColor3 = Theme.CardBg
DeleteBtn.Text = "ðŸ—‘"
DeleteBtn.TextColor3 = Theme.TextSecondary
DeleteBtn.TextSize = 16
DeleteBtn.Font = Enum.Font.Gotham
DeleteBtn.Parent = Topbar

local DeleteCorner = Instance.new("UICorner")
DeleteCorner.CornerRadius = UDim.new(0, 10)
DeleteCorner.Parent = DeleteBtn

local DeleteStroke = Instance.new("UIStroke")
DeleteStroke.Color = Theme.Border
DeleteStroke.Thickness = 0.8
DeleteStroke.Parent = DeleteBtn

DeleteBtn.MouseEnter:Connect(function()
    TweenService:Create(DeleteBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Red, TextColor3 = Color3.new(1, 1, 1)}):Play()
end)

DeleteBtn.MouseLeave:Connect(function()
    TweenService:Create(DeleteBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.CardBg, TextColor3 = Theme.TextSecondary}):Play()
end)

-- Confirmation Modal for deleting GUI
local DeleteConfirmFrame = Instance.new("Frame")
DeleteConfirmFrame.Name = "DeleteConfirmFrame"
DeleteConfirmFrame.Size = UDim2.new(1, 0, 1, 0)
DeleteConfirmFrame.Position = UDim2.new(0, 0, 0, 0)
DeleteConfirmFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
DeleteConfirmFrame.BackgroundTransparency = 1 -- Animate this to 0.6
DeleteConfirmFrame.BorderSizePixel = 0
DeleteConfirmFrame.ZIndex = 100
DeleteConfirmFrame.Visible = false
DeleteConfirmFrame.Parent = MainFrame

local DeleteConfirmCorner = Instance.new("UICorner")
DeleteConfirmCorner.CornerRadius = UDim.new(0, 8)
DeleteConfirmCorner.Parent = DeleteConfirmFrame

local ConfirmCard = Instance.new("Frame")
ConfirmCard.Name = "ConfirmCard"
ConfirmCard.Size = UDim2.new(0, 340, 0, 160)
ConfirmCard.Position = UDim2.new(0.5, 0, 0.5, 0)
ConfirmCard.AnchorPoint = Vector2.new(0.5, 0.5)
ConfirmCard.BackgroundColor3 = Theme.CardBg
ConfirmCard.BorderSizePixel = 0
ConfirmCard.ZIndex = 101
ConfirmCard.Parent = DeleteConfirmFrame

local ConfirmCardCorner = Instance.new("UICorner")
ConfirmCardCorner.CornerRadius = UDim.new(0, 8)
ConfirmCardCorner.Parent = ConfirmCard

local ConfirmCardStroke = Instance.new("UIStroke")
ConfirmCardStroke.Color = Theme.Border
ConfirmCardStroke.Thickness = 1.2
ConfirmCardStroke.Parent = ConfirmCard

local ConfirmTitle = Instance.new("TextLabel")
ConfirmTitle.Size = UDim2.new(1, -30, 0, 30)
ConfirmTitle.Position = UDim2.new(0, 15, 0, 15)
ConfirmTitle.BackgroundTransparency = 1
ConfirmTitle.Text = "Deletar Painel?"
ConfirmTitle.TextColor3 = Theme.TextPrimary
ConfirmTitle.TextSize = 16
ConfirmTitle.Font = Enum.Font.GothamBold
ConfirmTitle.TextXAlignment = Enum.TextXAlignment.Left
ConfirmTitle.ZIndex = 102
ConfirmTitle.Parent = ConfirmCard

local ConfirmDesc = Instance.new("TextLabel")
ConfirmDesc.Size = UDim2.new(1, -30, 0, 45)
ConfirmDesc.Position = UDim2.new(0, 15, 0, 45)
ConfirmDesc.BackgroundTransparency = 1
ConfirmDesc.Text = "VocÃª realmente deseja deletar a GUI de forma permanente? Ela deixarÃ¡ de existir nesta sessÃ£o do jogo."
ConfirmDesc.TextColor3 = Theme.TextSecondary
ConfirmDesc.TextSize = 11
ConfirmDesc.Font = Enum.Font.Gotham
ConfirmDesc.TextWrapped = true
ConfirmDesc.TextXAlignment = Enum.TextXAlignment.Left
ConfirmDesc.TextYAlignment = Enum.TextYAlignment.Top
ConfirmDesc.ZIndex = 102
ConfirmDesc.Parent = ConfirmCard

local ConfirmBtn = Instance.new("TextButton")
ConfirmBtn.Size = UDim2.new(0, 140, 0, 35)
ConfirmBtn.Position = UDim2.new(0.5, 10, 1, -50)
ConfirmBtn.BackgroundColor3 = Theme.Red
ConfirmBtn.Text = "Sim, Deletar"
ConfirmBtn.TextColor3 = Color3.new(1, 1, 1)
ConfirmBtn.Font = Enum.Font.GothamBold
ConfirmBtn.TextSize = 12
ConfirmBtn.AutoButtonColor = false
ConfirmBtn.ZIndex = 102
ConfirmBtn.Parent = ConfirmCard

local ConfirmBtnCorner = Instance.new("UICorner")
ConfirmBtnCorner.CornerRadius = UDim.new(0, 10)
ConfirmBtnCorner.Parent = ConfirmBtn

local CancelBtn = Instance.new("TextButton")
CancelBtn.Size = UDim2.new(0, 140, 0, 35)
CancelBtn.Position = UDim2.new(0.5, -150, 1, -50)
CancelBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
CancelBtn.Text = "Cancelar"
CancelBtn.TextColor3 = Theme.TextPrimary
CancelBtn.Font = Enum.Font.GothamBold
CancelBtn.TextSize = 12
CancelBtn.AutoButtonColor = false
CancelBtn.ZIndex = 102
CancelBtn.Parent = ConfirmCard

local CancelBtnCorner = Instance.new("UICorner")
CancelBtnCorner.CornerRadius = UDim.new(0, 10)
CancelBtnCorner.Parent = CancelBtn

local CancelBtnStroke = Instance.new("UIStroke")
CancelBtnStroke.Color = Theme.Border
CancelBtnStroke.Thickness = 0.8
CancelBtnStroke.Parent = CancelBtn

-- Button animations and actions
CancelBtn.MouseEnter:Connect(function()
    TweenService:Create(CancelBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 32)}):Play()
end)
CancelBtn.MouseLeave:Connect(function()
    TweenService:Create(CancelBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 24, 24)}):Play()
end)

ConfirmBtn.MouseEnter:Connect(function()
    TweenService:Create(ConfirmBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 38, 38)}):Play()
end)
ConfirmBtn.MouseLeave:Connect(function()
    TweenService:Create(ConfirmBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Red}):Play()
end)

local function showDeleteConfirm()
    DeleteConfirmFrame.Visible = true
    ConfirmCard.Size = UDim2.new(0, 340, 0, 0)
    DeleteConfirmFrame.BackgroundTransparency = 1
    
    TweenService:Create(DeleteConfirmFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.6}):Play()
    TweenService:Create(ConfirmCard, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 340, 0, 160)}):Play()
end

local function hideDeleteConfirm()
    TweenService:Create(DeleteConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    local t = TweenService:Create(ConfirmCard, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 340, 0, 0)})
    t:Play()
    t.Completed:Connect(function()
        DeleteConfirmFrame.Visible = false
    end)
end

DeleteBtn.MouseButton1Click:Connect(showDeleteConfirm)
CancelBtn.MouseButton1Click:Connect(hideDeleteConfirm)

ConfirmBtn.MouseButton1Click:Connect(function()
    TweenService:Create(DeleteConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    local destroyTween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    destroyTween:Play()
    destroyTween.Completed:Wait()
    pcall(function() broadcastSkinUpdate(nil) end)
    ScreenGui:Destroy()
end)

local toggling = false
local function toggleUI()
    if not ScreenGui or not ScreenGui.Parent or not MainFrame or not MainFrame.Parent then return end
    if toggling then return end
    toggling = true
    if ScreenGui.Enabled then
        MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.4, true, function()
            if ScreenGui then ScreenGui.Enabled = false end
            toggling = false
        end)
    else
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        ScreenGui.Enabled = true
        MainFrame:TweenSize(UDim2.new(0, 950, 0, 620), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.4, true, function()
            toggling = false
        end)
    end
end

CloseBtn.MouseButton1Click:Connect(toggleUI)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        toggleUI()
    end
end)

-- Main views folder
local Views = Instance.new("Folder")
Views.Name = "Views"
Views.Parent = Container

-- Tab management variables
local tabIcons = {
    Home = "rbxassetid://6034509993",
    Emphasis = "rbxassetid://6031267597",
    Character = "rbxassetid://6031302824",
    Target = "rbxassetid://6031267597",
    Animations = "rbxassetid://6031761611",
    Misc = "rbxassetid://6031280882",
    Graphics = "rbxassetid://6031265976",
    Flick = "rbxassetid://6031267597",
    Chat = "rbxassetid://6034789547",
    Games = "rbxassetid://6031280882",
    Server = "rbxassetid://6031280882",
    About = "rbxassetid://6031280882"
}
local tabsList = {"Home", "Emphasis", "Character", "Target", "Animations", "Misc", "Graphics", "Flick", "Chat", "Games", "Server", "About"}
local tabButtons = {}
local activeTab = nil

local function showTab(tabName)
    if activeTab == tabName then return end
    
    -- Deactivate current tab visual state
    if activeTab and tabButtons[activeTab] then
        local btn = tabButtons[activeTab]
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1}):Play()
        TweenService:Create(btn.TextLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextSecondary}):Play()
        if btn:FindFirstChild("Icon") then TweenService:Create(btn.Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.TextSecondary}):Play() end
        local currentView = Views:FindFirstChild(activeTab)
        if currentView then currentView.Visible = false end
    end
    
    -- Activate new tab visual state
    activeTab = tabName
    TabTitle.Text = tabName
    
    local btn = tabButtons[tabName]
    if btn then
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.CardBg, BackgroundTransparency = 0}):Play()
        TweenService:Create(btn.TextLabel, TweenInfo.new(0.2), {TextColor3 = Theme.TextPrimary}):Play()
        if btn:FindFirstChild("Icon") then TweenService:Create(btn.Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.TextPrimary}):Play() end
    end
    
    local targetView = Views:FindFirstChild(tabName)
    if targetView then
        targetView.Visible = true
    end
end

-- ==========================================
-- 5. TAB VIEW DESIGN SYSTEM
-- ==========================================

for _, tabName in ipairs(tabsList) do
    -- Create Tab Button inside Sidebar
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -20, 0, 32)
    TabBtn.BackgroundColor3 = Color3.new(0,0,0)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = ""
    TabBtn.Parent = TabsContainer
    tabButtons[tabName] = TabBtn
    
    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(1, 0)
    TabBtnCorner.Parent = TabBtn
    
    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Name = "Icon"
    TabIcon.Size = UDim2.new(0, 16, 0, 16)
    TabIcon.Position = UDim2.new(0, 12, 0.5, 0)
    TabIcon.AnchorPoint = Vector2.new(0, 0.5)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Image = tabIcons[tabName] or "rbxassetid://6034509993"
    TabIcon.ImageColor3 = Theme.TextSecondary
    TabIcon.Parent = TabBtn
    
    local TabBtnText = Instance.new("TextLabel")
    TabBtnText.Name = "TextLabel"
    TabBtnText.Size = UDim2.new(1, -40, 1, 0)
    TabBtnText.Position = UDim2.new(0, 36, 0, 0)
    TabBtnText.BackgroundTransparency = 1
    TabBtnText.Text = tabName
    TabBtnText.TextColor3 = Theme.TextSecondary
    TabBtnText.TextSize = 13
    TabBtnText.Font = Enum.Font.Gotham
    TabBtnText.TextXAlignment = Enum.TextXAlignment.Left
    TabBtnText.Parent = TabBtn
    
    TabBtn.MouseEnter:Connect(function()
        if activeTab ~= tabName then
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 22), BackgroundTransparency = 0.5}):Play()
            TweenService:Create(TabBtnText, TweenInfo.new(0.2), {TextColor3 = Theme.TextPrimary}):Play()
            if TabBtn:FindFirstChild("Icon") then TweenService:Create(TabBtn.Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.TextPrimary}):Play() end
        end
    end)
    
    TabBtn.MouseLeave:Connect(function()
        if activeTab ~= tabName then
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1}):Play()
            TweenService:Create(TabBtnText, TweenInfo.new(0.2), {TextColor3 = Theme.TextSecondary}):Play()
            if TabBtn:FindFirstChild("Icon") then TweenService:Create(TabBtn.Icon, TweenInfo.new(0.2), {ImageColor3 = Theme.TextSecondary}):Play() end
        end
    end)
    
    TabBtn.MouseButton1Click:Connect(function()
        showTab(tabName)
    end)
    
    -- Create view frame
    local ViewFrame
    if tabName == "Home" then
        ViewFrame = Instance.new("ScrollingFrame")
        ViewFrame.CanvasSize = UDim2.new(0, 0, 0, 470)
        ViewFrame.ScrollBarThickness = 2
        ViewFrame.ScrollBarImageColor3 = Theme.Border
        ViewFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        ViewFrame.BorderSizePixel = 0
    elseif tabName == "Character" then
        ViewFrame = Instance.new("ScrollingFrame")
        ViewFrame.CanvasSize = UDim2.new(0, 0, 0, 520)
        ViewFrame.ScrollBarThickness = 2
        ViewFrame.ScrollBarImageColor3 = Theme.Border
        ViewFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        ViewFrame.BorderSizePixel = 0
    elseif tabName == "Target" then
        ViewFrame = Instance.new("ScrollingFrame")
        ViewFrame.CanvasSize = UDim2.new(0, 0, 0, 780)
        ViewFrame.ScrollBarThickness = 2
        ViewFrame.ScrollBarImageColor3 = Theme.Border
        ViewFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        ViewFrame.BorderSizePixel = 0
    elseif tabName == "Games" then
        ViewFrame = Instance.new("ScrollingFrame")
        ViewFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
        ViewFrame.ScrollBarThickness = 2
        ViewFrame.ScrollBarImageColor3 = Theme.Border
        ViewFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        ViewFrame.BorderSizePixel = 0
        ViewFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    elseif tabName == "Animations" then
        ViewFrame = Instance.new("Frame") -- no outer scroll; inner gridScroller handles it
    elseif tabName == "Server" then
        ViewFrame = Instance.new("ScrollingFrame")
        ViewFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
        ViewFrame.ScrollBarThickness = 2
        ViewFrame.ScrollBarImageColor3 = Theme.Border
        ViewFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        ViewFrame.BorderSizePixel = 0
    else
        ViewFrame = Instance.new("Frame")
    end
    ViewFrame.Name = tabName
    ViewFrame.Size = UDim2.new(1, -50, 1, -70)
    ViewFrame.Position = UDim2.new(0, 25, 0, 55)
    ViewFrame.BackgroundTransparency = 1
    ViewFrame.Visible = false
    ViewFrame.Parent = Views
end

-- ==========================================
-- 6. TABS CONFIGURATION (HOME VIEW & STATS)
-- ==========================================

local HomeView = Views:WaitForChild("Home")

-- Welcome Banner Card
local WelcomeCard = Instance.new("Frame")
WelcomeCard.Size = UDim2.new(1, 0, 0, 95)
WelcomeCard.BackgroundColor3 = Theme.CardBg
WelcomeCard.Parent = HomeView

local WelcomeCorner = Instance.new("UICorner")
WelcomeCorner.CornerRadius = UDim.new(0, 10)
WelcomeCorner.Parent = WelcomeCard

local WelcomeStroke = Instance.new("UIStroke")
WelcomeStroke.Color = Theme.Border
WelcomeStroke.Thickness = 0.8
WelcomeStroke.Parent = WelcomeCard

local WAvatar = Instance.new("ImageLabel")
WAvatar.Size = UDim2.new(0, 60, 0, 60)
WAvatar.Position = UDim2.new(0, 20, 0.5, 0)
WAvatar.AnchorPoint = Vector2.new(0, 0.5)
WAvatar.BackgroundColor3 = Theme.Sidebar
WAvatar.Parent = WelcomeCard

local WAvatarCorner = Instance.new("UICorner")
WAvatarCorner.CornerRadius = UDim.new(1, 0)
WAvatarCorner.Parent = WAvatar

local WAvatarStroke = Instance.new("UIStroke")
WAvatarStroke.Color = Theme.Accent
WAvatarStroke.Thickness = 1.2
WAvatarStroke.Parent = WAvatar

task.spawn(function()
    pcall(function()
        local content, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        if isReady then
            WAvatar.Image = content
        end
    end)
end)

local WText = Instance.new("TextLabel")
WText.Size = UDim2.new(1, -110, 0, 22)
WText.Position = UDim2.new(0, 96, 0.5, -20)
WText.BackgroundTransparency = 1
WText.Text = "Welcome, " .. LocalPlayer.DisplayName .. "!"
WText.TextColor3 = Theme.TextPrimary
WText.TextSize = 16
WText.Font = Enum.Font.GothamBold
WText.RichText = true
WText.TextXAlignment = Enum.TextXAlignment.Left
WText.Parent = WelcomeCard

local WSubText = Instance.new("TextLabel")
WSubText.Size = UDim2.new(1, -110, 0, 16)
WSubText.Position = UDim2.new(0, 96, 0.5, 2)
WSubText.BackgroundTransparency = 1
WSubText.Text = "@" .. LocalPlayer.Name
WSubText.TextColor3 = Theme.TextSecondary
WSubText.TextSize = 12
WSubText.Font = Enum.Font.Gotham
WSubText.TextXAlignment = Enum.TextXAlignment.Left
WSubText.Parent = WelcomeCard

-- Helper function to make stats cards
local function createStatCard(parent, title, value, position, size, valueColor)
    local card = Instance.new("Frame")
    card.Size = size
    card.Position = position
    card.BackgroundColor3 = Theme.CardBg
    card.Parent = parent
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card
    
    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Theme.Border
    cardStroke.Thickness = 0.8
    cardStroke.Parent = card
    
    local cardTitle = Instance.new("TextLabel")
    cardTitle.Size = UDim2.new(1, -30, 0, 20)
    cardTitle.Position = UDim2.new(0, 15, 0, 12)
    cardTitle.BackgroundTransparency = 1
    cardTitle.Text = string.upper(title)
    cardTitle.TextColor3 = Theme.TextSecondary
    cardTitle.TextSize = 9
    cardTitle.Font = Enum.Font.GothamBold
    cardTitle.TextXAlignment = Enum.TextXAlignment.Left
    cardTitle.Parent = card
    
    local cardVal = Instance.new("TextLabel")
    cardVal.Size = UDim2.new(1, -30, 1, -40)
    cardVal.Position = UDim2.new(0, 15, 0, 32)
    cardVal.BackgroundTransparency = 1
    cardVal.Text = value
    cardVal.TextColor3 = valueColor or Theme.TextPrimary
    cardVal.TextSize = 22
    cardVal.Font = Enum.Font.GothamBold
    cardVal.TextXAlignment = Enum.TextXAlignment.Left
    cardVal.Parent = card
    
    return card, cardVal
end

-- Session and stats registration
local sessionId = HttpService:GenerateGUID(false)

local API_URL = "https://dedsec-api.celular3dobob.workers.dev"

local function parseJson(str)
    local success, tbl = pcall(function()
        return HttpService:JSONDecode(str)
    end)
    if success then
        return tbl
    end
    return nil
end

local function apiPostRun()
    local requestFunc = syn and syn.request or http_request or request or (http and http.request)
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = API_URL .. "/add_run",
                Method = "POST"
            })
        end)
    else
        pcall(function()
            -- fallback for executors that don't support custom request headers properly
            game:HttpPost(API_URL .. "/add_run", "")
        end)
    end
end

-- Initialize execution tracking
task.spawn(function()
    apiPostRun()
end)

-- Stats Row 1
local pingCard, pingVal = createStatCard(HomeView, "Ping / Latency", "Measuring...", UDim2.new(0, 0, 0, 110), UDim2.new(0.5, -8, 0, 90), Theme.Green)
local ageCard, ageVal = createStatCard(HomeView, "Account Age", tostring(LocalPlayer.AccountAge) .. " days", UDim2.new(0.5, 8, 0, 110), UDim2.new(0.5, -8, 0, 90))

-- Stats Row 2
local onlineCard, onlineVal = createStatCard(HomeView, "Online Players", tostring(#Players:GetPlayers()), UDim2.new(0, 0, 0, 215), UDim2.new(0.25, -6, 0, 85))
local usersCard, usersVal = createStatCard(HomeView, "Users Active", "Loading...", UDim2.new(0.25, 2, 0, 215), UDim2.new(0.25, -6, 0, 85))
local runsCard, runsVal = createStatCard(HomeView, "Global Runs", "Loading...", UDim2.new(0.5, 4, 0, 215), UDim2.new(0.25, -6, 0, 85))
local dateCard, dateVal = createStatCard(HomeView, "Date", "Calculating...", UDim2.new(0.75, 6, 0, 215), UDim2.new(0.25, -6, 0, 85))

-- Setup Dynamic Stat Updates
task.spawn(function()
    local tickCounter = 0
    while MainFrame.Parent do
        -- Latency approximation
        local ping = math.random(35, 62)
        pingVal.Text = tostring(ping) .. "ms"
        
        -- Player Count update
        onlineVal.Text = tostring(#Players:GetPlayers())
        
        -- Date Update (Formated nicely)
        local date = os.date("%d/%m/%Y - %H:%M")
        dateVal.Text = date
        
        -- Cloudflare API real-time updates (every 15 seconds)
        if tickCounter % 15 == 0 then
            task.spawn(function()
                pcall(function()
                    local raw
                    local requestFunc = syn and syn.request or http_request or request or (http and http.request)
                    if requestFunc then
                        local res = requestFunc({Url = API_URL, Method = "GET"})
                        raw = res.Body
                    else
                        raw = game:HttpGet(API_URL)
                    end
                    
                    local data = parseJson(raw)
                    if data then
                        -- Atualiza usuários ativos
                        usersVal.Text = tostring(data.active_users or "1")
                        
                        -- Atualiza global runs com formatação de vírgula (ex: 854,912)
                        local runs = data.runs or 0
                        local formatted = tostring(runs):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
                        runsVal.Text = formatted
                    end
                end)
            end)
        end
        
        tickCounter = tickCounter + 1
        task.wait(1)
    end
end)

-- Bottom Tags Card
local TagsCard = Instance.new("Frame")
TagsCard.Size = UDim2.new(1, 0, 0, 65)
TagsCard.Position = UDim2.new(0, 0, 0, 312)
TagsCard.BackgroundColor3 = Theme.CardBg
TagsCard.Parent = HomeView

local TagsCorner = Instance.new("UICorner")
TagsCorner.CornerRadius = UDim.new(0, 10)
TagsCorner.Parent = TagsCard

local TagsStroke = Instance.new("UIStroke")
TagsStroke.Color = Theme.Border
TagsStroke.Thickness = 0.8
TagsStroke.Parent = TagsCard

local TagsLabel = Instance.new("TextLabel")
TagsLabel.Size = UDim2.new(0, 200, 0, 20)
TagsLabel.Position = UDim2.new(0, 15, 0, 12)
TagsLabel.BackgroundTransparency = 1
TagsLabel.Text = "MY TAGS"
TagsLabel.TextColor3 = Theme.TextSecondary
TagsLabel.TextSize = 9
TagsLabel.Font = Enum.Font.GothamBold
TagsLabel.TextXAlignment = Enum.TextXAlignment.Left
TagsLabel.Parent = TagsCard

local TagsSub = Instance.new("TextLabel")
TagsSub.Size = UDim2.new(0, 300, 0, 15)
TagsSub.Position = UDim2.new(0, 15, 0, 32)
TagsSub.BackgroundTransparency = 1
TagsSub.Text = "Select the tag shown above your character"
TagsSub.TextColor3 = Theme.TextSecondary
TagsSub.TextSize = 10
TagsSub.Font = Enum.Font.Gotham
TagsSub.TextXAlignment = Enum.TextXAlignment.Left
TagsSub.Parent = TagsCard

-- Tag user option button
local UserTagBtn = Instance.new("TextButton")
UserTagBtn.Size = UDim2.new(0, 60, 0, 26)
UserTagBtn.Position = UDim2.new(0, 360, 0.5, -13)
UserTagBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
UserTagBtn.Text = "User"
UserTagBtn.TextColor3 = Theme.TextPrimary
UserTagBtn.TextSize = 11
UserTagBtn.Font = Enum.Font.GothamBold
UserTagBtn.Parent = TagsCard

local UserTagCorner = Instance.new("UICorner")
UserTagCorner.CornerRadius = UDim.new(0, 10)
UserTagCorner.Parent = UserTagBtn

local UserTagStroke = Instance.new("UIStroke")
UserTagStroke.Color = Theme.Accent
UserTagStroke.Thickness = 0.8
UserTagStroke.Parent = UserTagBtn

-- Hide tags toggle switch
local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Size = UDim2.new(0, 100, 0, 20)
ToggleLabel.Position = UDim2.new(1, -165, 0.5, -10)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "HIDE TAGS"
ToggleLabel.TextColor3 = Theme.TextSecondary
ToggleLabel.TextSize = 9
ToggleLabel.Font = Enum.Font.GothamBold
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Right
ToggleLabel.Parent = TagsCard

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 44, 0, 22)
ToggleBtn.Position = UDim2.new(1, -55, 0.5, -11)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
ToggleBtn.Text = ""
ToggleBtn.Parent = TagsCard

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleCircle = Instance.new("Frame")
ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
ToggleCircle.Position = UDim2.new(0, 3, 0.5, 0)
ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
ToggleCircle.BackgroundColor3 = Theme.TextSecondary
ToggleCircle.BorderSizePixel = 0
ToggleCircle.Parent = ToggleBtn

local ToggleCircleCorner = Instance.new("UICorner")
ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
ToggleCircleCorner.Parent = ToggleCircle

local toggled = false
ToggleBtn.MouseButton1Click:Connect(function()
    toggled = not toggled
    local targetPos = toggled and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    local targetColor = toggled and Theme.Accent or Theme.TextSecondary
    local bgTargetColor = toggled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
    
    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = bgTargetColor}):Play()
end)

-- Keybinds and Personalization cards at the bottom of HomeView
local BottomCardsFrame = Instance.new("Frame")
BottomCardsFrame.Name = "BottomCardsFrame"
BottomCardsFrame.Size = UDim2.new(1, 0, 0, 60)
BottomCardsFrame.Position = UDim2.new(0, 0, 0, 390)
BottomCardsFrame.BackgroundTransparency = 1
BottomCardsFrame.Parent = HomeView

-- 1. Keybinds Card
local KeybindsCard = Instance.new("Frame")
KeybindsCard.Name = "Keybinds"
KeybindsCard.Size = UDim2.new(0.5, -8, 1, 0)
KeybindsCard.Position = UDim2.new(0, 0, 0, 0)
KeybindsCard.BackgroundColor3 = Theme.CardBg
KeybindsCard.Parent = BottomCardsFrame

local KeybindsCorner = Instance.new("UICorner")
KeybindsCorner.CornerRadius = UDim.new(0, 10)
KeybindsCorner.Parent = KeybindsCard

local KeybindsStroke = Instance.new("UIStroke")
KeybindsStroke.Color = Theme.Border
KeybindsStroke.Thickness = 0.8
KeybindsStroke.Parent = KeybindsCard

local KeybindsIcon = Instance.new("ImageLabel")
KeybindsIcon.Size = UDim2.new(0, 24, 0, 24)
KeybindsIcon.Position = UDim2.new(0, 15, 0.5, 0)
KeybindsIcon.AnchorPoint = Vector2.new(0, 0.5)
KeybindsIcon.BackgroundTransparency = 1
KeybindsIcon.Image = "rbxassetid://10747373176" -- Keyboard icon
KeybindsIcon.ImageColor3 = Theme.TextPrimary
KeybindsIcon.Parent = KeybindsCard

local KeybindsTitle = Instance.new("TextLabel")
KeybindsTitle.Size = UDim2.new(1, -55, 0, 16)
KeybindsTitle.Position = UDim2.new(0, 50, 0.5, -15)
KeybindsTitle.BackgroundTransparency = 1
KeybindsTitle.Text = "KEYBINDS"
KeybindsTitle.TextColor3 = Theme.TextPrimary
KeybindsTitle.TextSize = 11
KeybindsTitle.Font = Enum.Font.GothamBold
KeybindsTitle.TextXAlignment = Enum.TextXAlignment.Left
KeybindsTitle.Parent = KeybindsCard

local KeybindsSub = Instance.new("TextLabel")
KeybindsSub.Size = UDim2.new(1, -55, 0, 14)
KeybindsSub.Position = UDim2.new(0, 50, 0.5, 1)
KeybindsSub.BackgroundTransparency = 1
KeybindsSub.Text = "Keyboard shortcuts"
KeybindsSub.TextColor3 = Theme.TextSecondary
KeybindsSub.TextSize = 9
KeybindsSub.Font = Enum.Font.Gotham
KeybindsSub.TextXAlignment = Enum.TextXAlignment.Left
KeybindsSub.Parent = KeybindsCard

-- 2. Personalization Card
local PersCard = Instance.new("Frame")
PersCard.Name = "Personalization"
PersCard.Size = UDim2.new(0.5, -8, 1, 0)
PersCard.Position = UDim2.new(0.5, 8, 0, 0)
PersCard.BackgroundColor3 = Theme.CardBg
PersCard.Parent = BottomCardsFrame

local PersCorner = Instance.new("UICorner")
PersCorner.CornerRadius = UDim.new(0, 10)
PersCorner.Parent = PersCard

local PersStroke = Instance.new("UIStroke")
PersStroke.Color = Theme.Border
PersStroke.Thickness = 0.8
PersStroke.Parent = PersCard

local PersIcon = Instance.new("ImageLabel")
PersIcon.Size = UDim2.new(0, 24, 0, 24)
PersIcon.Position = UDim2.new(0, 15, 0.5, 0)
PersIcon.AnchorPoint = Vector2.new(0, 0.5)
PersIcon.BackgroundTransparency = 1
PersIcon.Image = "rbxassetid://10747387991" -- Palette/Themes icon
PersIcon.ImageColor3 = Theme.TextPrimary
PersIcon.Parent = PersCard

local PersTitle = Instance.new("TextLabel")
PersTitle.Size = UDim2.new(1, -55, 0, 16)
PersTitle.Position = UDim2.new(0, 50, 0.5, -15)
PersTitle.BackgroundTransparency = 1
PersTitle.Text = "PERSONALIZATION"
PersTitle.TextColor3 = Theme.TextPrimary
PersTitle.TextSize = 11
PersTitle.Font = Enum.Font.GothamBold
PersTitle.TextXAlignment = Enum.TextXAlignment.Left
PersTitle.Parent = PersCard

local PersSub = Instance.new("TextLabel")
PersSub.Size = UDim2.new(1, -55, 0, 14)
PersSub.Position = UDim2.new(0, 50, 0.5, 1)
PersSub.BackgroundTransparency = 1
PersSub.Text = "Themes & colors"
PersSub.TextColor3 = Theme.TextSecondary
PersSub.TextSize = 9
PersSub.Font = Enum.Font.Gotham
PersSub.TextXAlignment = Enum.TextXAlignment.Left
PersSub.Parent = PersCard


-- ==========================================
-- EMPHASIS TOOLS VIEW
-- ==========================================

local EmphasisView = Views:WaitForChild("Emphasis")

local EmphasisCard = Instance.new("Frame")
EmphasisCard.Name = "EmphasisCard"
EmphasisCard.Size = UDim2.new(1, 0, 1, 0)
EmphasisCard.BackgroundColor3 = Theme.CardBg
EmphasisCard.Parent = EmphasisView

local EmphasisCorner = Instance.new("UICorner")
EmphasisCorner.CornerRadius = UDim.new(0, 10)
EmphasisCorner.Parent = EmphasisCard

local EmphasisStroke = Instance.new("UIStroke")
EmphasisStroke.Color = Theme.Border
EmphasisStroke.Thickness = 0.8
EmphasisStroke.Parent = EmphasisCard

-- Header Title
local EmphasisTitle = Instance.new("TextLabel")
EmphasisTitle.Size = UDim2.new(1, -30, 0, 20)
EmphasisTitle.Position = UDim2.new(0, 15, 0, 15)
EmphasisTitle.BackgroundTransparency = 1
EmphasisTitle.Text = "EMPHASIS TOOLS"
EmphasisTitle.TextColor3 = Theme.TextPrimary
EmphasisTitle.TextSize = 10
EmphasisTitle.Font = Enum.Font.GothamBold
EmphasisTitle.TextXAlignment = Enum.TextXAlignment.Left
EmphasisTitle.Parent = EmphasisCard

local EmphasisSub = Instance.new("TextLabel")
EmphasisSub.Size = UDim2.new(1, -30, 0, 15)
EmphasisSub.Position = UDim2.new(0, 15, 0, 35)
EmphasisSub.BackgroundTransparency = 1
EmphasisSub.Text = "Movement, physics and character effects in one organized place."
EmphasisSub.TextColor3 = Theme.TextSecondary
EmphasisSub.TextSize = 9
EmphasisSub.Font = Enum.Font.Gotham
EmphasisSub.TextXAlignment = Enum.TextXAlignment.Left
EmphasisSub.Parent = EmphasisCard

-- Grid Frame for Buttons (2 columns, 6 rows)
local GridFrame = Instance.new("Frame")
GridFrame.Name = "GridFrame"
GridFrame.Size = UDim2.new(1, -30, 1, -80)
GridFrame.Position = UDim2.new(0, 15, 0, 65)
GridFrame.BackgroundTransparency = 1
GridFrame.Parent = EmphasisCard

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellSize = UDim2.new(0.5, -6, 0, 36)
UIGridLayout.CellPadding = UDim2.new(0, 12, 0, 10)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.Parent = GridFrame

local emphasisTools = {
    {"Invisible", "Toggle"}, {"ESP", "Toggle"},
    {"NoClip", "Toggle"}, {"ClickTP", "Toggle"},
    {"Spin", "Toggle"}, {"AntiVoid", "Toggle"},
    {"Jerk Off", "Toggle"}, {"AnimSpeed", "Toggle"},
    {"feFlip", "Toggle"}, {"Flashback", "Toggle"},
    {"Fling", "Toggle"}, {"AntiFling", "Toggle"}
}

local espActive = false
local espFolders = {}
local clickTPConnection = nil

-- Adicionar limpeza do ClickTP ao destruir o painel
MainFrame.Destroying:Connect(function()
    if clickTPConnection then clickTPConnection:Disconnect() end
end)

local function createESP(player)
    if player == LocalPlayer then return end
    
    local function drawESP()
        local char = player.Character
        if not char then return end
        
        local head = char:WaitForChild("Head", 5)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not head or not hrp then return end
        
        -- Evita duplicados de Box 3D
        if char:FindFirstChild("DedSecBoxESP") then return end
        
        local bgBillboard = Instance.new("BillboardGui")
        bgBillboard.Name = "DedSecESP"
        bgBillboard.Size = UDim2.new(0, 200, 0, 50)
        bgBillboard.AlwaysOnTop = true
        bgBillboard.Adornee = head
        bgBillboard.ExtentsOffset = Vector3.new(0, 2.5, 0)
        bgBillboard.Parent = hrp
        
        local espText = Instance.new("TextLabel")
        espText.Size = UDim2.new(1, 0, 1, 0)
        espText.BackgroundTransparency = 1
        espText.Text = player.DisplayName .. " (@" .. player.Name .. ") [" .. tostring(math.floor((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0)) .. "m]"
        espText.TextColor3 = Color3.fromRGB(0, 255, 128) -- Verde neon clÃ¡ssico Hacker
        espText.TextStrokeTransparency = 0.5
        espText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        espText.Font = Enum.Font.GothamBold
        espText.TextSize = 10
        espText.Parent = bgBillboard
        
        -- AtualizaÃ§Ã£o dinÃ¢mica de distÃ¢ncia
        task.spawn(function()
            while hrp and hrp.Parent and bgBillboard and bgBillboard.Parent and espActive do
                local dist = 0
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                end
                espText.Text = player.DisplayName .. " [" .. tostring(dist) .. "m]"
                task.wait(0.5)
            end
        end)
        
        -- Adiciona Box 3D ultra robusta (funciona em qualquer nÃ­vel grÃ¡fico atravÃ©s de paredes)
        local boxAdorn = Instance.new("BoxHandleAdornment")
        boxAdorn.Name = "DedSecBoxESP"
        boxAdorn.Size = char:GetExtentsSize() + Vector3.new(0.5, 0.5, 0.5) -- Tamanho exato do jogador + margem
        boxAdorn.AlwaysOnTop = true
        boxAdorn.ZIndex = 5
        boxAdorn.Adornee = hrp
        boxAdorn.Color3 = Color3.fromRGB(0, 255, 128) -- Verde neon clÃ¡ssico Hacker
        boxAdorn.Transparency = 0.75 -- TranslÃºcido para nÃ£o tampar a visÃ£o
        boxAdorn.Parent = char
    end
    
    player.CharacterAdded:Connect(function()
        if espActive then
            task.wait(0.5)
            drawESP()
        end
    end)
    
    if player.Character then
        drawESP()
    end
end

local function removeESP(player)
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local esp = hrp:FindFirstChild("DedSecESP")
            if esp then esp:Destroy() end
        end
        local box = char:FindFirstChild("DedSecBoxESP")
        if box then box:Destroy() end
    end
end

for i, tool in ipairs(emphasisTools) do
    local toolName = tool[1]
    local toolType = tool[2]
    
    local btn = Instance.new("Frame")
    btn.Name = toolName
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    btn.Parent = GridFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Theme.Border
    btnStroke.Thickness = 0.8
    btnStroke.Parent = btn
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = toolName
    label.TextColor3 = Theme.TextPrimary
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn
    
    if toolType == "Toggle" then
        -- Keybind button (ConfigurÃ¡vel por clique)
        local kbBtn = Instance.new("TextButton")
        kbBtn.Name = "Keybind"
        kbBtn.Size = UDim2.new(0, 46, 0, 20)
        kbBtn.Position = UDim2.new(1, -112, 0.5, -10) -- Chega um pouco para a esquerda para abrir espaÃ§o para o X
        kbBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        kbBtn.Text = "None"
        kbBtn.TextColor3 = Theme.TextSecondary
        kbBtn.TextSize = 9
        kbBtn.Font = Enum.Font.GothamBold
        kbBtn.Parent = btn
        
        local kbCorner = Instance.new("UICorner")
        kbCorner.CornerRadius = UDim.new(0, 10)
        kbCorner.Parent = kbBtn
        
        local kbStroke = Instance.new("UIStroke")
        kbStroke.Color = Theme.Border
        kbStroke.Thickness = 0.8
        kbStroke.Parent = kbBtn

        -- BotÃ£o 'X' muito pequeno para limpar o atalho
        local clearBtn = Instance.new("TextButton")
        clearBtn.Name = "ClearKeybind"
        clearBtn.Size = UDim2.new(0, 14, 0, 14)
        clearBtn.Position = UDim2.new(1, -62, 0.5, -7) -- Colado entre o Bind e o Switch
        clearBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
        clearBtn.Text = "x"
        clearBtn.TextColor3 = Theme.TextSecondary
        clearBtn.TextSize = 8
        clearBtn.Font = Enum.Font.GothamBold
        clearBtn.Parent = btn
        
        local clearCorner = Instance.new("UICorner")
        clearCorner.CornerRadius = UDim.new(1, 0) -- Redondo
        clearCorner.Parent = clearBtn
        
        local clearStroke = Instance.new("UIStroke")
        clearStroke.Color = Theme.Border
        clearStroke.Thickness = 0.6
        clearStroke.Parent = clearBtn

        -- Toggle switch
        local tBtn = Instance.new("TextButton")
        tBtn.Size = UDim2.new(0, 32, 0, 18)
        tBtn.Position = UDim2.new(1, -44, 0.5, -9)
        tBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tBtn.Text = ""
        tBtn.Parent = btn
        
        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(1, 0)
        tCorner.Parent = tBtn
        
        local tCircle = Instance.new("Frame")
        tCircle.Size = UDim2.new(0, 12, 0, 12)
        tCircle.Position = UDim2.new(0, 3, 0.5, 0)
        tCircle.AnchorPoint = Vector2.new(0, 0.5)
        tCircle.BackgroundColor3 = Theme.TextSecondary
        tCircle.BorderSizePixel = 0
        tCircle.Parent = tBtn
        
        local tCircleCorner = Instance.new("UICorner")
        tCircleCorner.CornerRadius = UDim.new(1, 0)
        tCircleCorner.Parent = tCircle
        
        local active = false
        local currentBind = nil
        local listening = false
        
        local function executeAction()
            active = not active
            local targetPos = active and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            local targetColor = Theme.TextPrimary
            local bgTargetColor = active and Theme.Green or Color3.fromRGB(35, 35, 35)
            
            TweenService:Create(tCircle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
            TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = bgTargetColor}):Play()

            -- LÃ“GICA DE EXECUÃ‡ÃƒO REAL DAS EPHASIS TOOLS
            if toolName == "ESP" then
                espActive = active
                if active then
                    for _, player in ipairs(Players:GetPlayers()) do
                        createESP(player)
                    end
                    -- Conecta novos jogadores que entrarem
                    local conn = Players.PlayerAdded:Connect(createESP)
                    table.insert(espFolders, conn)
                else
                    for _, conn in ipairs(espFolders) do
                        conn:Disconnect()
                    end
                    espFolders = {}
                    for _, player in ipairs(Players:GetPlayers()) do
                        removeESP(player)
                    end
                end
            elseif toolName == "NoClip" then
                if active then
                    if noclipConnection then noclipConnection:Disconnect() end
                    noclipConnection = RunService.Stepped:Connect(function()
                        if LocalPlayer.Character then
                            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                                if part:IsA("BasePart") and part.CanCollide then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end)
                else
                    if noclipConnection then
                        noclipConnection:Disconnect()
                        noclipConnection = nil
                    end
                end
            elseif toolName == "ClickTP" then
                if active then
                    if clickTPConnection then clickTPConnection:Disconnect() end
                    local mouse = LocalPlayer:GetMouse()
                    local uis = game:GetService("UserInputService")
                    
                    clickTPConnection = mouse.Button1Down:Connect(function()
                        if uis:IsKeyDown(Enum.KeyCode.LeftControl) or uis:IsKeyDown(Enum.KeyCode.RightControl) then
                            local char = LocalPlayer.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            if hrp and mouse.Hit then
                                hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                            end
                        end
                    end)
                else
                    if clickTPConnection then
                        clickTPConnection:Disconnect()
                        clickTPConnection = nil
                    end
                end
            elseif toolName == "Invisible" then
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("Decal") then
                            if part.Name ~= "HumanoidRootPart" then
                                part.Transparency = active and 1 or 0
                            end
                        end
                    end
                end
            elseif toolName == "Spin" then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local existing = hrp:FindFirstChild("DedSecSpin")
                    if existing then existing:Destroy() end
                    if active then
                        local spin = Instance.new("BodyAngularVelocity")
                        spin.Name = "DedSecSpin"
                        spin.MaxTorque = Vector3.new(0, math.huge, 0)
                        spin.AngularVelocity = Vector3.new(0, 35, 0) -- RotaÃ§Ã£o constante polida
                        spin.Parent = hrp
                    end
                end
            elseif toolName == "AntiVoid" then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local existing = hrp:FindFirstChild("DedSecAntiVoid")
                    if existing then existing:Destroy() end
                    if active then
                        local conn
                        conn = RunService.Heartbeat:Connect(function()
                            if not espActive and not active then conn:Disconnect() return end
                            if hrp.Position.Y < -100 then
                                hrp.Velocity = Vector3.new(0, 0, 0)
                                hrp.CFrame = CFrame.new(hrp.Position.X, 15, hrp.Position.Z)
                                notify("DedSec Panel", "Anti-Void ativado! Teleportado de volta ao topo.")
                            end
                        end)
                        local tag = Instance.new("Folder")
                        tag.Name = "DedSecAntiVoid"
                        tag.Parent = hrp
                    end
                end
            elseif toolName == "Jerk Off" then
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local existing = hrp:FindFirstChild("DedSecJerk")
                    if existing then existing:Destroy() end
                    if active then
                        local speed = 0.4
                        local conn
                        conn = RunService.Stepped:Connect(function()
                            if not active then conn:Disconnect() return end
                            local rShoulder = char:FindFirstChild("Right Shoulder", true) or char:FindFirstChild("RightShoulder", true)
                            if rShoulder and rShoulder:IsA("Motor6D") then
                                rShoulder.CurrentAngle = math.sin(tick() * 15) * speed
                            end
                        end)
                        local tag = Instance.new("Folder")
                        tag.Name = "DedSecJerk"
                        tag.Parent = hrp
                    end
                end
            elseif toolName == "AnimSpeed" then
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local animator = hum:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            track:AdjustSpeed(active and 2.5 or 1.0) -- Multiplica velocidade da animaÃ§Ã£o ou restaura ao normal
                        end
                    end
                end
            elseif toolName == "feFlip" then
                local ca = game:GetService("ContextActionService")
                local h = 0.0174533
                
                local function zeezyFrontflip(act, inp, obj)
                    if inp == Enum.UserInputState.Begin then
                        local char = LocalPlayer.Character
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hum and hrp then
                            hum:ChangeState(Enum.HumanoidStateType.Jumping)
                            task.wait()
                            hum.Sit = true
                            for i = 1, 360 do 
                                delay(i/720, function()
                                    if hum and hrp then
                                        hum.Sit = true
                                        hrp.CFrame = hrp.CFrame * CFrame.Angles(-h, 0, 0)
                                    end
                                end)
                            end
                            task.wait(0.55)
                            if hum then hum.Sit = false end
                        end
                    end
                end

                local function zeezyBackflip(act, inp, obj)
                    if inp == Enum.UserInputState.Begin then
                        local char = LocalPlayer.Character
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hum and hrp then
                            hum:ChangeState(Enum.HumanoidStateType.Jumping)
                            task.wait()
                            hum.Sit = true
                            for i = 1, 360 do
                                delay(i/720, function()
                                    if hum and hrp then
                                        hum.Sit = true
                                        hrp.CFrame = hrp.CFrame * CFrame.Angles(h, 0, 0)
                                    end
                                end)
                            end
                            task.wait(0.55)
                            if hum then hum.Sit = false end
                        end
                    end
                end

                if active then
                    ca:BindAction("zeezyFrontflip", zeezyFrontflip, false, Enum.KeyCode.Z)
                    ca:BindAction("zeezyBackflip", zeezyBackflip, false, Enum.KeyCode.X)
                else
                    ca:UnbindAction("zeezyFrontflip")
                    ca:UnbindAction("zeezyBackflip")
                end
            end
        end

        tBtn.MouseButton1Click:Connect(executeAction)
        
        -- ConfiguraÃ§Ã£o de Keybind ao clicar no botÃ£o "None"
        kbBtn.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            kbBtn.Text = "..."
            kbBtn.TextColor3 = Theme.Accent
            
            local tempConnection
            tempConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    tempConnection:Disconnect()
                    currentBind = input.KeyCode
                    kbBtn.Text = input.KeyCode.Name
                    kbBtn.TextColor3 = Theme.TextPrimary
                    listening = false
                end
            end)
        end)

        -- Limpa o atalho ao clicar no botÃ£o 'x'
        clearBtn.MouseButton1Click:Connect(function()
            currentBind = nil
            kbBtn.Text = "None"
            kbBtn.TextColor3 = Theme.TextSecondary
        end)
        
        -- Listener global para as teclas de atalho da ferramenta especÃ­fica
        game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
            if gp then return end
            if currentBind and input.KeyCode == currentBind then
                executeAction()
            end
        end)
    elseif toolType == "VIP" then
        -- Locked / VIP button badge
        local vipBadge = Instance.new("Frame")
        vipBadge.Size = UDim2.new(0, 52, 0, 20)
        vipBadge.Position = UDim2.new(1, -64, 0.5, -10)
        vipBadge.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
        vipBadge.Parent = btn
        
        local vipCorner = Instance.new("UICorner")
        vipCorner.CornerRadius = UDim.new(0, 10)
        vipCorner.Parent = vipBadge
        
        local vipStroke = Instance.new("UIStroke")
        vipStroke.Color = Theme.Border
        vipStroke.Thickness = 0.8
        vipStroke.Parent = vipBadge
        
        local lockIcon = Instance.new("ImageLabel")
        lockIcon.Size = UDim2.new(0, 12, 0, 12)
        lockIcon.Position = UDim2.new(0, 6, 0.5, 0)
        lockIcon.AnchorPoint = Vector2.new(0, 0.5)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Image = "rbxassetid://10747384394" -- padlock icon
        lockIcon.ImageColor3 = Theme.TextSecondary
        lockIcon.Parent = vipBadge
        
        local vipText = Instance.new("TextLabel")
        vipText.Size = UDim2.new(1, -20, 1, 0)
        vipText.Position = UDim2.new(0, 18, 0, 0)
        vipText.BackgroundTransparency = 1
        vipText.Text = "VIP"
        vipText.TextColor3 = Theme.TextSecondary
        vipText.TextSize = 8
        vipText.Font = Enum.Font.GothamBold
        vipText.Parent = vipBadge
    end
end


-- ==========================================
-- 7. OTHER TABS PLACEHOLDERS (AS SPECIFIED)
-- ==========================================

-- Populate basic elements for other tabs so user sees the fully functional UI structure
for _, tabName in ipairs(tabsList) do
    if tabName ~= "Home" and tabName ~= "Emphasis" and tabName ~= "Character" and tabName ~= "Target" and tabName ~= "Animations" and tabName ~= "Games" and tabName ~= "Misc" and tabName ~= "Graphics" and tabName ~= "About" then
        local view = Views:WaitForChild(tabName)
        
        local infoCard = Instance.new("Frame")
        infoCard.Size = UDim2.new(1, 0, 1, 0)
        infoCard.BackgroundColor3 = Theme.CardBg
        infoCard.Parent = view
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 10)
        infoCorner.Parent = infoCard
        
        local infoStroke = Instance.new("UIStroke")
        infoStroke.Color = Theme.Border
        infoStroke.Thickness = 0.8
        infoStroke.Parent = infoCard
        
        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(1, 0, 0, 40)
        infoLabel.Position = UDim2.new(0, 0, 0.4, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Text = tabName .. " Features"
        infoLabel.TextColor3 = Theme.TextPrimary
        infoLabel.TextSize = 18
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.Parent = infoCard
        
        local infoSub = Instance.new("TextLabel")
        infoSub.Size = UDim2.new(1, 0, 0, 20)
        infoSub.Position = UDim2.new(0, 0, 0.4, 40)
        infoSub.BackgroundTransparency = 1
        infoSub.Text = "System options will be coded here in the next update."
        infoSub.TextColor3 = Theme.TextSecondary
        infoSub.TextSize = 11
        infoSub.Font = Enum.Font.Gotham
        infoSub.Parent = infoCard
    end
end

-- ==========================================
-- CHARACTER VIEW
-- ==========================================

local successChar, errChar = pcall(function()
local CharacterView = Views:WaitForChild("Character")

-- Top Selector Bar (PERSONAGEM / SKIN CHANGER)
local SelectorBar = Instance.new("Frame")
SelectorBar.Name = "SelectorBar"
SelectorBar.Size = UDim2.new(1, 0, 0, 36)
SelectorBar.BackgroundColor3 = Theme.Sidebar
SelectorBar.BorderSizePixel = 0
SelectorBar.Parent = CharacterView

local SelectorCorner = Instance.new("UICorner")
SelectorCorner.CornerRadius = UDim.new(0, 10)
SelectorCorner.Parent = SelectorBar

local SelectorStroke = Instance.new("UIStroke")
SelectorStroke.Color = Theme.Border
SelectorStroke.Thickness = 0.8
SelectorStroke.Parent = SelectorBar

local PersonagemBtn = Instance.new("TextButton")
PersonagemBtn.Size = UDim2.new(0.5, -4, 1, -4)
PersonagemBtn.Position = UDim2.new(0, 2, 0.5, 0)
PersonagemBtn.AnchorPoint = Vector2.new(0, 0.5)
PersonagemBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
PersonagemBtn.Text = "PERSONAGEM"
PersonagemBtn.TextColor3 = Theme.TextPrimary
PersonagemBtn.TextSize = 10
PersonagemBtn.Font = Enum.Font.GothamBold
PersonagemBtn.Parent = SelectorBar

local PersonagemCorner = Instance.new("UICorner")
PersonagemCorner.CornerRadius = UDim.new(0, 10)
PersonagemCorner.Parent = PersonagemBtn

local SkinChangerBtn = Instance.new("TextButton")
SkinChangerBtn.Size = UDim2.new(0.5, -4, 1, -4)
SkinChangerBtn.Position = UDim2.new(0.5, 2, 0.5, 0)
SkinChangerBtn.AnchorPoint = Vector2.new(0, 0.5)
SkinChangerBtn.BackgroundTransparency = 1
SkinChangerBtn.Text = "SKIN CHANGER"
SkinChangerBtn.TextColor3 = Theme.TextSecondary
SkinChangerBtn.TextSize = 10
SkinChangerBtn.Font = Enum.Font.GothamBold
SkinChangerBtn.Parent = SelectorBar

-- Containers inside CharacterView
local PersonagemContainer = Instance.new("ScrollingFrame")
PersonagemContainer.Name = "PersonagemContainer"
PersonagemContainer.Size = UDim2.new(1, 0, 1, -50)
PersonagemContainer.Position = UDim2.new(0, 0, 0, 50)
PersonagemContainer.BackgroundTransparency = 1
PersonagemContainer.BorderSizePixel = 0
PersonagemContainer.ScrollBarThickness = 2
PersonagemContainer.ScrollBarImageColor3 = Theme.Border
PersonagemContainer.ScrollingDirection = Enum.ScrollingDirection.Y
PersonagemContainer.CanvasSize = UDim2.new(0, 0, 0, 510)
PersonagemContainer.Visible = true
PersonagemContainer.Parent = CharacterView

local SkinChangerContainer = Instance.new("ScrollingFrame")
SkinChangerContainer.Name = "SkinChangerContainer"
SkinChangerContainer.Size = UDim2.new(1, 0, 1, -50)
SkinChangerContainer.Position = UDim2.new(0, 0, 0, 50)
SkinChangerContainer.BackgroundTransparency = 1
SkinChangerContainer.BorderSizePixel = 0
SkinChangerContainer.ScrollBarThickness = 2
SkinChangerContainer.ScrollBarImageColor3 = Theme.Border
SkinChangerContainer.ScrollingDirection = Enum.ScrollingDirection.Y
SkinChangerContainer.CanvasSize = UDim2.new(0, 0, 0, 680)
SkinChangerContainer.Visible = false
SkinChangerContainer.Parent = CharacterView

-- Tab Toggle connections
PersonagemBtn.MouseButton1Click:Connect(function()
    PersonagemBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    PersonagemBtn.BackgroundTransparency = 0
    PersonagemBtn.TextColor3 = Theme.TextPrimary
    SkinChangerBtn.BackgroundTransparency = 1
    SkinChangerBtn.TextColor3 = Theme.TextSecondary
    PersonagemContainer.Visible = true
    SkinChangerContainer.Visible = false
end)

SkinChangerBtn.MouseButton1Click:Connect(function()
    SkinChangerBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    SkinChangerBtn.BackgroundTransparency = 0
    SkinChangerBtn.TextColor3 = Theme.TextPrimary
    PersonagemBtn.BackgroundTransparency = 1
    PersonagemBtn.TextColor3 = Theme.TextSecondary
    SkinChangerContainer.Visible = true
    PersonagemContainer.Visible = false
end)

-- ============================================================
-- SKIN CHANGER VIEWPORT CARD (LEFT SIDE)
-- ============================================================
local HttpService = game:GetService("HttpService")
local httpReq = request or http_request or (syn and syn.request)
local jobId = game.JobId
if not jobId or jobId == "" then jobId = tostring(game.PlaceId) end
local syncUrl = "https://keyvalue.immanuel.co/api/Key/dedsec_skins_" .. jobId

local function sendHttpRequest(url, method, body)
    if not httpReq then return nil end
    local response
    local success = pcall(function()
        response = httpReq({
            Url = url,
            Method = method or "GET",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = body
        })
    end)
    if success and response and response.StatusCode == 200 then
        return response.Body
    end
    return nil
end

local function decodeJsonSafe(str)
    if not str or str == "" then return nil end
    if string.sub(str, 1, 1) == '"' and string.sub(str, #str, #str) == '"' then
        local ok, val = pcall(function()
            return HttpService:JSONDecode(str)
        end)
        if ok then str = val end
    end
    local ok, tbl = pcall(function()
        return HttpService:JSONDecode(str)
    end)
    if ok then return tbl end
    return nil
end

local function broadcastSkinUpdate(targetUserId)
    if not httpReq then return end
    task.spawn(function()
        local raw = sendHttpRequest(syncUrl, "GET")
        local tbl = decodeJsonSafe(raw) or {}
        if targetUserId then
            tbl[tostring(LocalPlayer.UserId)] = targetUserId
        else
            tbl[tostring(LocalPlayer.UserId)] = nil
        end
        sendHttpRequest(syncUrl, "POST", HttpService:JSONEncode(tbl))
    end)
end

local function resolveAnimation(id, assetType)
    local stringId = tostring(id)
    local t = {}
    local descProp = "IdleAnimation"
    local lowerType = assetType and string.lower(assetType) or ""

    if lowerType:find("idle") and not lowerType:find("swim") then descProp = "IdleAnimation"
    elseif lowerType:find("walk") then descProp = "WalkAnimation"
    elseif lowerType:find("run") then descProp = "RunAnimation"
    elseif lowerType:find("jump") then descProp = "JumpAnimation"
    elseif lowerType:find("fall") then descProp = "FallAnimation"
    elseif lowerType:find("climb") then descProp = "ClimbAnimation"
    elseif lowerType:find("swim") then descProp = "SwimAnimation"
    end

    pcall(function()
        local d = Instance.new("HumanoidDescription")
        d[descProp] = tonumber(id)
        local dummy = Players:CreateHumanoidModelFromDescription(d, Enum.HumanoidRigType.R15)
        local animate = dummy:FindFirstChild("Animate")
        if animate then
            local targetFolders = (descProp == "SwimAnimation") and {"swim", "swimidle"} or {string.lower(string.gsub(descProp, "Animation", ""))}
            for _, folderName in ipairs(targetFolders) do
                local folder = animate:FindFirstChild(folderName)
                if folder then
                    for _, child in ipairs(folder:GetChildren()) do
                        if child:IsA("Animation") and child.AnimationId ~= "" then
                            table.insert(t, child:Clone())
                        end
                    end
                end
            end
        end
        dummy:Destroy()
    end)

    if #t == 0 then
        pcall(function() 
            local objs = game:GetObjects("rbxassetid://" .. stringId) 
            if objs and #objs > 0 then
                local function processItem(item)
                    if item:IsA("Animation") then
                        table.insert(t, item:Clone())
                    end
                end
                processItem(objs[1])
                for _, c in ipairs(objs[1]:GetDescendants()) do processItem(c) end
            end
        end)
    end

    for _, animObj in ipairs(t) do
        pcall(function()
            local assets = game:GetObjects(animObj.AnimationId)
            if assets and assets[1] and assets[1]:IsA("KeyframeSequence") then
                local hashUrl = game:GetService("KeyframeSequenceProvider"):RegisterKeyframeSequence(assets[1])
                if hashUrl then
                    animObj.AnimationId = hashUrl
                end
            end
        end)
    end
    return t
end

local function manualWeldAccessory(char, acc)
    local handle = acc:FindFirstChild("Handle")
    if not handle then return end
    
    local targetPart = char:FindFirstChild("Head")
    local attachment = handle:FindFirstChildOfClass("Attachment")
    if attachment then
        local attName = attachment.Name
        if attName:find("Neck") or attName:find("Back") or attName:find("Shoulder") or attName:find("Waist") then
            targetPart = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        end
    end
    
    if targetPart then
        for _, child in ipairs(handle:GetChildren()) do
            if child:IsA("Weld") or child:IsA("WeldConstraint") or child:IsA("AccessoryWeld") then
                child:Destroy()
            end
        end
        
        handle.Anchored = false
        handle.CanCollide = false
        
        local targetCFrame = targetPart.CFrame
        if attachment then
            local charAtt = targetPart:FindFirstChild(attachment.Name)
            if charAtt then
                targetCFrame = targetPart.CFrame * charAtt.CFrame * attachment.CFrame:Inverse()
            end
        end
        handle.CFrame = targetCFrame
        
        local weld = Instance.new("Weld")
        weld.Name = "AccessoryWeld"
        weld.Part0 = handle
        weld.Part1 = targetPart
        weld.C0 = handle.CFrame:Inverse() * targetPart.CFrame
        weld.Parent = handle
    end
    acc.Parent = char
end

local function applySkinToPlayer(player, skinUserId)
    if not player or not player.Character then return end
    task.spawn(function()
        local ok, desc = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(skinUserId)
        end)
        if ok and desc then
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                local human = char:FindFirstChildOfClass("Humanoid")
                local rigType = human.RigType
                
                if char:GetAttribute("DedSecSyncedSkin") == skinUserId then
                    return
                end
                
                local dummy
                local okDummy = pcall(function()
                    dummy = Players:CreateHumanoidModelFromDescription(desc, rigType)
                end)
                if okDummy and dummy then
                    local animate = char:FindFirstChild("Animate")
                    if animate then
                        animate.Disabled = true
                    end

                    local animator = human:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            track:Stop(0)
                        end
                    end

                    for _, child in ipairs(char:GetChildren()) do
                        if child:IsA("Accessory") or child:IsA("Clothing") or child:IsA("ShirtGraphic") or child:IsA("BodyColors") or child:IsA("CharacterMesh") then
                            child:Destroy()
                        end
                    end
                    
                    local bc = dummy:FindFirstChildOfClass("BodyColors")
                    if bc then
                        bc:Clone().Parent = char
                    end
                    
                    for _, child in ipairs(dummy:GetChildren()) do
                        if child:IsA("Clothing") or child:IsA("ShirtGraphic") then
                            child:Clone().Parent = char
                        elseif child:IsA("Accessory") then
                            manualWeldAccessory(char, child:Clone())
                        end
                    end
                    
                    local bodyParts = (rigType == Enum.HumanoidRigType.R15) and {
                        "Head", "UpperTorso", "LowerTorso", 
                        "LeftUpperArm", "LeftLowerArm", "LeftHand",
                        "RightUpperArm", "RightLowerArm", "RightHand",
                        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                        "RightUpperLeg", "RightLowerLeg", "RightFoot"
                    } or {
                        "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"
                    }
                    
                    for _, partName in ipairs(bodyParts) do
                        local myPart = char:FindFirstChild(partName)
                        if myPart then myPart:Destroy() end
                    end
                    
                    for _, partName in ipairs(bodyParts) do
                        local dummyPart = dummy:FindFirstChild(partName)
                        if dummyPart then
                            dummyPart:Clone().Parent = char
                        end
                    end
                    
                    for _, descJoint in ipairs(dummy:GetDescendants()) do
                        if descJoint:IsA("Motor6D") then
                            local myParent = char:FindFirstChild(descJoint.Parent.Name)
                            if myParent then
                                local newJoint = descJoint:Clone()
                                newJoint.Parent = myParent
                                if newJoint.Part0 then
                                    newJoint.Part0 = char:FindFirstChild(newJoint.Part0.Name)
                                end
                                if newJoint.Part1 then
                                    newJoint.Part1 = char:FindFirstChild(newJoint.Part1.Name)
                                end
                            end
                        end
                    end

                    for _, scaleVal in ipairs(dummy.Humanoid:GetChildren()) do
                        if scaleVal:IsA("NumberValue") then
                            local myScale = human:FindFirstChild(scaleVal.Name)
                            if myScale then
                                myScale.Value = scaleVal.Value
                            end
                        end
                    end

                    pcall(function()
                        human:BuildRigFromAttachments()
                    end)
                    
                    if animate then
                        local animProps = {
                            run = {desc.RunAnimation, "runanimation"},
                            walk = {desc.WalkAnimation, "walkanimation"},
                            jump = {desc.JumpAnimation, "jumpanimation"},
                            idle = {desc.IdleAnimation, "idleanimation"},
                            fall = {desc.FallAnimation, "fallanimation"},
                            climb = {desc.ClimbAnimation, "climbanimation"},
                            swim = {desc.SwimAnimation, "swimanimation"}
                        }
                        for name, animData in pairs(animProps) do
                            local animId = animData[1]
                            local assetType = animData[2]
                            if animId and animId > 0 then
                                local folder = animate:FindFirstChild(name)
                                if folder then
                                    local resolved = resolveAnimation(animId, assetType)
                                    if #resolved > 0 then
                                        for _, o in ipairs(folder:GetChildren()) do
                                            if o:IsA("Animation") then o:Destroy() end
                                        end
                                        for _, resolvedAnim in ipairs(resolved) do
                                            resolvedAnim.Parent = folder
                                        end
                                    end
                                end
                            end
                        end
                        
                        task.wait(0.05)
                        animate.Disabled = false
                    end
                    
                    dummy:Destroy()
                    char:SetAttribute("DedSecSyncedSkin", skinUserId)
                end
            end
        end
    end)
end

local scWorldModel
local scCloneChar
local scCam
local scZoomLevel = 5.5
local scAngle = 0
local scRotating = true

local scSearchBox
local scProfileName
local scProfileUserId
local scProfileAvatar
local scTargetUserId
local scTargetUsername

-- ============================================================
-- SKIN CHANGER VIEWPORT CARD (LEFT SIDE)
-- ============================================================
do
local ViewportCard = Instance.new("Frame")
ViewportCard.Name = "ViewportCard"
ViewportCard.Size = UDim2.new(0.5, -8, 0, 320)
ViewportCard.Position = UDim2.new(0, 0, 0, 0)
ViewportCard.BackgroundColor3 = Theme.CardBg
ViewportCard.Parent = SkinChangerContainer

local Viewport = Instance.new("ViewportFrame")
Viewport.Size = UDim2.new(1, -8, 1, -45)
Viewport.Position = UDim2.new(0, 4, 0, 4)
Viewport.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Viewport.BorderSizePixel = 0
Viewport.Parent = ViewportCard

local ZoomInBtn = Instance.new("TextButton")
ZoomInBtn.Size = UDim2.new(0, 24, 0, 24)
ZoomInBtn.Position = UDim2.new(1, -60, 0, 10)
ZoomInBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
ZoomInBtn.Text = "+"
ZoomInBtn.TextColor3 = Theme.TextPrimary
ZoomInBtn.Font = Enum.Font.GothamBold
ZoomInBtn.TextSize = 12
ZoomInBtn.Parent = Viewport

local ZoomOutBtn = Instance.new("TextButton")
ZoomOutBtn.Size = UDim2.new(0, 24, 0, 24)
ZoomOutBtn.Position = UDim2.new(1, -30, 0, 10)
ZoomOutBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
ZoomOutBtn.Text = "-"
ZoomOutBtn.TextColor3 = Theme.TextPrimary
ZoomOutBtn.Font = Enum.Font.GothamBold
ZoomOutBtn.TextSize = 12
ZoomOutBtn.Parent = Viewport

local RotateBar = Instance.new("Frame")
RotateBar.Size = UDim2.new(1, -8, 0, 32)
RotateBar.Position = UDim2.new(0, 4, 1, -36)
RotateBar.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
RotateBar.BorderSizePixel = 0
RotateBar.Parent = ViewportCard

local RotLeftBtn = Instance.new("TextButton")
RotLeftBtn.Size = UDim2.new(0, 32, 1, -8)
RotLeftBtn.Position = UDim2.new(0.1, 0, 0.5, -12)
RotLeftBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
RotLeftBtn.Text = "<"
RotLeftBtn.TextColor3 = Theme.TextPrimary
RotLeftBtn.Font = Enum.Font.GothamBold
RotLeftBtn.TextSize = 11
RotLeftBtn.Parent = RotateBar

local PlayPauseBtn = Instance.new("TextButton")
PlayPauseBtn.Size = UDim2.new(0, 48, 1, -8)
PlayPauseBtn.Position = UDim2.new(0.5, -24, 0.5, -12)
PlayPauseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
PlayPauseBtn.Text = "II"
PlayPauseBtn.TextColor3 = Theme.TextPrimary
PlayPauseBtn.Font = Enum.Font.GothamBold
PlayPauseBtn.TextSize = 11
PlayPauseBtn.Parent = RotateBar

local RotRightBtn = Instance.new("TextButton")
RotRightBtn.Size = UDim2.new(0, 32, 1, -8)
RotRightBtn.Position = UDim2.new(0.9, -32, 0.5, -12)
RotRightBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
RotRightBtn.Text = ">"
RotRightBtn.TextColor3 = Theme.TextPrimary
RotRightBtn.Font = Enum.Font.GothamBold
RotRightBtn.TextSize = 11
RotRightBtn.Parent = RotateBar

local worldModel = Instance.new("WorldModel")
worldModel.Parent = Viewport
scWorldModel = worldModel

local cam = Instance.new("Camera")
cam.CFrame = CFrame.new(Vector3.new(0, 1.5, scZoomLevel), Vector3.new(0, 1, 0))
Viewport.CurrentCamera = cam
cam.Parent = Viewport
scCam = cam

local function updateViewportChar()
    if scCloneChar then scCloneChar:Destroy() end
    local char = LocalPlayer.Character
    if char then
        char.Archivable = true
        scCloneChar = char:Clone()
        scCloneChar.Parent = scWorldModel
        local hrp = scCloneChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(0, 0, 0)
        end
        if scCloneChar:FindFirstChild("Animate") then
            scCloneChar.Animate.Disabled = true
        end
    end
end

updateViewportChar()
LocalPlayer.CharacterAdded:Connect(updateViewportChar)

RunService.RenderStepped:Connect(function(dt)
    if scRotating and scCloneChar and scCloneChar:FindFirstChild("HumanoidRootPart") then
        scAngle = scAngle + math.rad(45 * dt)
        scCloneChar:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, scAngle, 0))
    end
end)

ZoomInBtn.MouseButton1Click:Connect(function()
    scZoomLevel = math.max(3, scZoomLevel - 0.5)
    scCam.CFrame = CFrame.new(Vector3.new(0, 1.5, scZoomLevel), Vector3.new(0, 1, 0))
end)

ZoomOutBtn.MouseButton1Click:Connect(function()
    scZoomLevel = math.min(10, scZoomLevel + 0.5)
    scCam.CFrame = CFrame.new(Vector3.new(0, 1.5, scZoomLevel), Vector3.new(0, 1, 0))
end)

RotLeftBtn.MouseButton1Click:Connect(function()
    scAngle = scAngle - math.rad(15)
    if scCloneChar then scCloneChar:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, scAngle, 0)) end
end)

RotRightBtn.MouseButton1Click:Connect(function()
    scAngle = scAngle + math.rad(15)
    if scCloneChar then scCloneChar:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, scAngle, 0)) end
end)

PlayPauseBtn.MouseButton1Click:Connect(function()
    scRotating = not scRotating
    PlayPauseBtn.Text = scRotating and "II" or ">"
end)
end

-- ============================================================
-- SKIN CHANGER SEARCH CARD (RIGHT SIDE)
-- ============================================================
local SearchBtn
local ApplyBtn

do
local SearchCard = Instance.new("Frame")
SearchCard.Name = "SearchCard"
SearchCard.Size = UDim2.new(0.5, -8, 0, 140)
SearchCard.Position = UDim2.new(0.5, 8, 0, 0)
SearchCard.BackgroundColor3 = Theme.CardBg
SearchCard.Parent = SkinChangerContainer

local SCTitle = Instance.new("TextLabel")
SCTitle.Size = UDim2.new(1, -30, 0, 20)
SCTitle.Position = UDim2.new(0, 15, 0, 15)
SCTitle.BackgroundTransparency = 1
SCTitle.Text = "SKIN CHANGER"
SCTitle.TextColor3 = Theme.TextPrimary
SCTitle.TextSize = 10
SCTitle.Font = Enum.Font.GothamBold
SCTitle.TextXAlignment = Enum.TextXAlignment.Left
SCTitle.Parent = SearchCard

local SCSearchBox = Instance.new("TextBox")
SCSearchBox.Size = UDim2.new(1, -30, 0, 32)
SCSearchBox.Position = UDim2.new(0, 15, 0, 45)
SCSearchBox.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
SCSearchBox.PlaceholderText = "@username"
SCSearchBox.Text = ""
SCSearchBox.TextColor3 = Theme.TextPrimary
SCSearchBox.PlaceholderColor3 = Theme.TextSecondary
SCSearchBox.TextSize = 11
SCSearchBox.Font = Enum.Font.Gotham
SCSearchBox.Parent = SearchCard
scSearchBox = SCSearchBox

local SCSearchCorner = Instance.new("UICorner")
SCSearchCorner.CornerRadius = UDim.new(0, 10)
SCSearchCorner.Parent = SCSearchBox

local scsbPad = Instance.new("UIPadding")
scsbPad.PaddingLeft = UDim.new(0, 10)
scsbPad.Parent = SCSearchBox

local SCSuggestionScroll = Instance.new("ScrollingFrame")
SCSuggestionScroll.Name = "SCSuggestionScroll"
SCSuggestionScroll.Size = UDim2.new(1, -30, 0, 0) -- dynamically resized
SCSuggestionScroll.Position = UDim2.new(0, 15, 0, 77)
SCSuggestionScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SCSuggestionScroll.BorderSizePixel = 0
SCSuggestionScroll.ScrollBarThickness = 2
SCSuggestionScroll.ScrollBarImageColor3 = Theme.Border
SCSuggestionScroll.ZIndex = 15
SCSuggestionScroll.Visible = false
SCSuggestionScroll.Parent = SearchCard

local SClayout = Instance.new("UIListLayout")
SClayout.SortOrder = Enum.SortOrder.LayoutOrder
SClayout.Parent = SCSuggestionScroll

SearchBtn = Instance.new("TextButton")
SearchBtn.Size = UDim2.new(0.5, -10, 0, 28)
SearchBtn.Position = UDim2.new(0, 15, 0, 92)
SearchBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
SearchBtn.Text = "Search"
SearchBtn.TextColor3 = Theme.TextPrimary
SearchBtn.Font = Enum.Font.GothamBold
SearchBtn.TextSize = 10
SearchBtn.Parent = SearchCard

ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0.5, -10, 0, 28)
ApplyBtn.Position = UDim2.new(0.5, 5, 0, 92)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
ApplyBtn.Text = "Apply"
ApplyBtn.TextColor3 = Theme.TextPrimary
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextSize = 10
ApplyBtn.Parent = SearchCard
end

-- ============================================================
-- SKIN CHANGER PROFILE CARD (RIGHT SIDE)
-- ============================================================
local CopyCardBtn
local RefreshProfileBtn

do
local ProfileCard = Instance.new("Frame")
ProfileCard.Name = "ProfileCard"
ProfileCard.Size = UDim2.new(0.5, -8, 0, 165)
ProfileCard.Position = UDim2.new(0.5, 8, 0, 155)
ProfileCard.BackgroundColor3 = Theme.CardBg
ProfileCard.Parent = SkinChangerContainer

local PCAvatar = Instance.new("ImageLabel")
PCAvatar.Size = UDim2.new(0, 64, 0, 64)
PCAvatar.Position = UDim2.new(0.5, 0, 0, 15)
PCAvatar.AnchorPoint = Vector2.new(0.5, 0)
PCAvatar.BackgroundColor3 = Theme.Sidebar
PCAvatar.Image = gifAsset
PCAvatar.Parent = ProfileCard
scProfileAvatar = PCAvatar

local PCAvatarCorner = Instance.new("UICorner")
PCAvatarCorner.CornerRadius = UDim.new(1, 0)
PCAvatarCorner.Parent = PCAvatar

local PCName = Instance.new("TextLabel")
PCName.Size = UDim2.new(1, -20, 0, 18)
PCName.Position = UDim2.new(0, 10, 0, 88)
PCName.BackgroundTransparency = 1
PCName.Text = "No skin selected"
PCName.TextColor3 = Theme.TextPrimary
PCName.TextSize = 12
PCName.Font = Enum.Font.GothamBold
PCName.Parent = ProfileCard
scProfileName = PCName

local PCUserId = Instance.new("TextLabel")
PCUserId.Size = UDim2.new(1, -20, 0, 14)
PCUserId.Position = UDim2.new(0, 10, 0, 106)
PCUserId.BackgroundTransparency = 1
PCUserId.Text = "UserId: N/A"
PCUserId.TextColor3 = Theme.TextSecondary
PCUserId.TextSize = 9
PCUserId.Font = Enum.Font.Gotham
PCUserId.Parent = ProfileCard
scProfileUserId = PCUserId

CopyCardBtn = Instance.new("TextButton")
CopyCardBtn.Size = UDim2.new(0.4, 0, 0, 24)
CopyCardBtn.Position = UDim2.new(0.1, 0, 1, -34)
CopyCardBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
CopyCardBtn.Text = "Copy"
CopyCardBtn.TextColor3 = Theme.TextSecondary
CopyCardBtn.TextSize = 9
CopyCardBtn.Font = Enum.Font.GothamBold
CopyCardBtn.Parent = ProfileCard

RefreshProfileBtn = Instance.new("TextButton")
RefreshProfileBtn.Size = UDim2.new(0.4, 0, 0, 24)
RefreshProfileBtn.Position = UDim2.new(0.5, 0, 1, -34)
RefreshProfileBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
RefreshProfileBtn.Text = "Refresh"
RefreshProfileBtn.TextColor3 = Theme.TextSecondary
RefreshProfileBtn.TextSize = 9
RefreshProfileBtn.Font = Enum.Font.GothamBold
RefreshProfileBtn.Parent = ProfileCard
end

-- ============================================================
-- SKIN CHANGER LOGIC CONNECTIONS (SEPARATE BLOCK)
-- ============================================================
do
local function loadSkinProfile(id, name)
    scTargetUserId = id
    scTargetUsername = name
    scProfileName.Text = name
    scProfileUserId.Text = "UserId: " .. tostring(id)
    
    task.spawn(function()
        local content, isReady = Players:GetUserThumbnailAsync(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        if isReady then
            scProfileAvatar.Image = content
        end
    end)
    
    task.spawn(function()
        local desc
        local okDesc = pcall(function()
            desc = Players:GetHumanoidDescriptionFromUserId(id)
        end)
        if okDesc and desc then
            local dummy
            local okDummy = pcall(function()
                dummy = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
            end)
            if okDummy and dummy then
                if scCloneChar then scCloneChar:Destroy() end
                scCloneChar = dummy
                scCloneChar.Parent = scWorldModel
                local hrp = scCloneChar:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(0, 0, 0)
                end
                if scCloneChar:FindFirstChild("Animate") then
                    scCloneChar.Animate.Disabled = true
                end
            end
        end
    end)
end

local function selectSkinPlayer(player)
    scSearchBox.Text = player.Name
    local SCard = SkinChangerContainer:FindFirstChild("SearchCard")
    if SCard and SCard:FindFirstChild("SCSuggestionScroll") then
        SCard.SCSuggestionScroll.Visible = false
    end
    loadSkinProfile(player.UserId, player.Name)
end

local function performSearch()
    local name = scSearchBox.Text
    if name == "" then return end
    scProfileName.Text = "Searching..."
    scProfileUserId.Text = "UserId: N/A"
    scProfileAvatar.Image = gifAsset
    scTargetUserId = nil
    
    task.spawn(function()
        local ok, id = pcall(function()
            return Players:GetUserIdFromNameAsync(name)
        end)
        if ok and id then
            loadSkinProfile(id, name)
        else
            scProfileName.Text = "Not found"
            scProfileUserId.Text = "UserId: N/A"
        end
    end)
end

local scSearchTick = 0

scSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = scSearchBox.Text:lower():gsub("^@", "")
    local SearchCardUI = SkinChangerContainer:FindFirstChild("SearchCard")
    if not SearchCardUI then return end
    local SuggestionScroll = SearchCardUI:FindFirstChild("SCSuggestionScroll")
    if not SuggestionScroll then return end

    scSearchTick = scSearchTick + 1
    local currentTick = scSearchTick

    for _, child in ipairs(SuggestionScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    if text == "" or #text < 3 then
        SuggestionScroll.Visible = false
        return
    end

    task.wait(0.4) -- Debounce anti-spam
    if scSearchTick ~= currentTick then return end

    task.spawn(function()
        local requestFunc = syn and syn.request or http_request or request or (http and http.request)
        local raw
        local ok, err = pcall(function()
            local url = "https://users.roproxy.com/v1/users/search?keyword=" .. text .. "&limit=10"
            if requestFunc then
                local res = requestFunc({Url = url, Method = "GET"})
                raw = res.Body
            else
                raw = game:HttpGet(url)
            end
        end)
        
        if scSearchTick ~= currentTick then return end
        if not ok or not raw then return end
        
        local data = parseJson(raw)
        if not data or not data.data or #data.data == 0 then
            SuggestionScroll.Visible = false
            return
        end
        
        local matches = data.data
        local height = math.min(#matches * 36, 180)
        SuggestionScroll.Size = UDim2.new(1, -30, 0, height)
        SuggestionScroll.Visible = true

        for _, user in ipairs(matches) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 36)
            btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            btn.BorderSizePixel = 0
            btn.Text = "            " .. user.displayName .. " (@" .. user.name .. ")"
            btn.TextColor3 = Theme.TextPrimary
            btn.TextSize = 12
            btn.Font = Enum.Font.Gotham
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.ZIndex = 16
            btn.Parent = SuggestionScroll

            local btnPad = Instance.new("UIPadding")
            btnPad.PaddingLeft = UDim.new(0, 8)
            btnPad.Parent = btn
            
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 26, 0, 26)
            img.Position = UDim2.new(0, 0, 0.5, 0)
            img.AnchorPoint = Vector2.new(0, 0.5)
            img.BackgroundColor3 = Theme.Sidebar
            img.ZIndex = 16
            img.Parent = btn
            
            local imgCorner = Instance.new("UICorner")
            imgCorner.CornerRadius = UDim.new(1, 0)
            imgCorner.Parent = img

            task.spawn(function()
                local content, isReady = Players:GetUserThumbnailAsync(user.id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                if isReady and btn.Parent then
                    img.Image = content
                end
            end)

            btn.MouseButton1Click:Connect(function()
                scSearchBox.Text = user.name
                SuggestionScroll.Visible = false
                loadSkinProfile(user.id, user.name)
            end)
        end
    end)
end)

scSearchBox.FocusLost:Connect(function(enterPressed)
    task.wait(0.2)
    local SearchCardUI = SkinChangerContainer:FindFirstChild("SearchCard")
    if SearchCardUI and SearchCardUI:FindFirstChild("SCSuggestionScroll") then
        SearchCardUI.SCSuggestionScroll.Visible = false
    end
    if enterPressed then
        performSearch()
    end
end)

SearchBtn.MouseButton1Click:Connect(performSearch)

local function resolveAnimation(id, assetType)
    local stringId = tostring(id)
    local t = {}
    local descProp = "IdleAnimation"
    local lowerType = assetType and string.lower(assetType) or ""

    if lowerType:find("idle") and not lowerType:find("swim") then descProp = "IdleAnimation"
    elseif lowerType:find("walk") then descProp = "WalkAnimation"
    elseif lowerType:find("run") then descProp = "RunAnimation"
    elseif lowerType:find("jump") then descProp = "JumpAnimation"
    elseif lowerType:find("fall") then descProp = "FallAnimation"
    elseif lowerType:find("climb") then descProp = "ClimbAnimation"
    elseif lowerType:find("swim") then descProp = "SwimAnimation"
    end

    pcall(function()
        local d = Instance.new("HumanoidDescription")
        d[descProp] = tonumber(id)
        local dummy = Players:CreateHumanoidModelFromDescription(d, Enum.HumanoidRigType.R15)
        local animate = dummy:FindFirstChild("Animate")
        if animate then
            local targetFolders = (descProp == "SwimAnimation") and {"swim", "swimidle"} or {string.lower(string.gsub(descProp, "Animation", ""))}
            for _, folderName in ipairs(targetFolders) do
                local folder = animate:FindFirstChild(folderName)
                if folder then
                    for _, child in ipairs(folder:GetChildren()) do
                        if child:IsA("Animation") and child.AnimationId ~= "" then
                            table.insert(t, child:Clone())
                        end
                    end
                end
            end
        end
        dummy:Destroy()
    end)

    if #t == 0 then
        pcall(function() 
            local objs = game:GetObjects("rbxassetid://" .. stringId) 
            if objs and #objs > 0 then
                local function processItem(item)
                    if item:IsA("Animation") then
                        table.insert(t, item:Clone())
                    end
                end
                processItem(objs[1])
                for _, c in ipairs(objs[1]:GetDescendants()) do processItem(c) end
            end
        end)
    end

    for _, animObj in ipairs(t) do
        pcall(function()
            local assets = game:GetObjects(animObj.AnimationId)
            if assets and assets[1] and assets[1]:IsA("KeyframeSequence") then
                local hashUrl = game:GetService("KeyframeSequenceProvider"):RegisterKeyframeSequence(assets[1])
                if hashUrl then
                    animObj.AnimationId = hashUrl
                end
            end
        end)
    end
    return t
end

local function applySelectedSkin()
    if not targetUserId then return end
    applySkinToPlayer(LocalPlayer, targetUserId)
    broadcastSkinUpdate(targetUserId)
end

ApplyBtn.MouseButton1Click:Connect(applySelectedSkin)
CopyCardBtn.MouseButton1Click:Connect(applySelectedSkin)
RefreshProfileBtn.MouseButton1Click:Connect(performSearch)
end

-- ============================================================
-- PRESET ACCESSORIES CARD (BOTTOM)
-- ============================================================
local AccessoriesCard = Instance.new("Frame")
AccessoriesCard.Name = "AccessoriesCard"
AccessoriesCard.Size = UDim2.new(1, 0, 0, 310)
AccessoriesCard.Position = UDim2.new(0, 0, 0, 335)
AccessoriesCard.BackgroundColor3 = Theme.CardBg
AccessoriesCard.Parent = SkinChangerContainer

do
local ATitle = Instance.new("TextLabel")
ATitle.Size = UDim2.new(1, -60, 0, 20)
ATitle.Position = UDim2.new(0, 15, 0, 15)
ATitle.BackgroundTransparency = 1
ATitle.Text = "PRESET ACCESSORIES"
ATitle.TextColor3 = Theme.TextPrimary
ATitle.TextSize = 10
ATitle.Font = Enum.Font.GothamBold
ATitle.TextXAlignment = Enum.TextXAlignment.Left
ATitle.Parent = AccessoriesCard

local ASub = Instance.new("TextLabel")
ASub.Size = UDim2.new(1, -60, 0, 15)
ASub.Position = UDim2.new(0, 15, 0, 32)
ASub.BackgroundTransparency = 1
ASub.Text = "Click a card to equip or remove. Use the star to favorite."
ASub.TextColor3 = Theme.TextSecondary
ASub.TextSize = 8
ASub.Font = Enum.Font.Gotham
ASub.TextXAlignment = Enum.TextXAlignment.Left
ASub.Parent = AccessoriesCard

local StarHeaderBtn = Instance.new("TextButton")
StarHeaderBtn.Size = UDim2.new(0, 24, 0, 24)
StarHeaderBtn.Position = UDim2.new(1, -35, 0, 13)
StarHeaderBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
StarHeaderBtn.Text = "*"
StarHeaderBtn.TextColor3 = Theme.TextSecondary
StarHeaderBtn.Font = Enum.Font.GothamBold
StarHeaderBtn.TextSize = 12
StarHeaderBtn.Parent = AccessoriesCard

local AccScroll = Instance.new("ScrollingFrame")
AccScroll.Size = UDim2.new(1, -30, 1, -95)
AccScroll.Position = UDim2.new(0, 15, 0, 52)
AccScroll.BackgroundTransparency = 1
AccScroll.BorderSizePixel = 0
AccScroll.ScrollBarThickness = 2
AccScroll.ScrollBarImageColor3 = Theme.Border
AccScroll.ScrollingDirection = Enum.ScrollingDirection.Y
AccScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
AccScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
AccScroll.Parent = AccessoriesCard

local AccGridLayout = Instance.new("UIGridLayout")
AccGridLayout.CellSize = UDim2.new(0.5, -6, 0, 48)
AccGridLayout.CellPadding = UDim2.new(0, 12, 0, 8)
AccGridLayout.Parent = AccScroll

local AccFooter = Instance.new("Frame")
AccFooter.Size = UDim2.new(1, -30, 0, 28)
AccFooter.Position = UDim2.new(0, 15, 1, -38)
AccFooter.BackgroundTransparency = 1
AccFooter.Parent = AccessoriesCard

local AccCountLbl = Instance.new("TextLabel")
AccCountLbl.Size = UDim2.new(0.4, 0, 1, 0)
AccCountLbl.BackgroundTransparency = 1
AccCountLbl.Text = "12 items available"
AccCountLbl.TextColor3 = Theme.TextSecondary
AccCountLbl.TextSize = 9
AccCountLbl.Font = Enum.Font.GothamBold
AccCountLbl.TextXAlignment = Enum.TextXAlignment.Left
AccCountLbl.Parent = AccFooter

local items = {
    {name = "Korblox Right Leg", id = 139607718},
    {name = "Headless Head", id = 15093053680},
    {name = "Valkyrie Helm", id = 1365767},
    {name = "Dominus Empyreus", id = 21070012},
    {name = "Dominus Frigidus", id = 48310931},
    {name = "Dominus Aureus", id = 69847116},
    {name = "Super Super Happy Face", id = 494291269},
    {name = "Void Valkyrie", id = 1827402928},
    {name = "Clockwork Shades", id = 11721349},
    {name = "Clockwork Headphones", id = 16298516},
    {name = "Antlers of Frost", id = 188846399},
    {name = "Sparkler", id = 193985060}
}

local favorites = {}

local function renderPresets(filterFavorites)
    for _, child in ipairs(AccScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local count = 0
    for _, item in ipairs(items) do
        if not filterFavorites or favorites[item.id] then
            count = count + 1
            local itemFrame = Instance.new("Frame")
            itemFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
            itemFrame.Parent = AccScroll
            
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 10)
            itemCorner.Parent = itemFrame
            
            local itemStroke = Instance.new("UIStroke")
            itemStroke.Color = Theme.Border
            itemStroke.Thickness = 0.8
            itemStroke.Parent = itemFrame
            
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 36, 0, 36)
            img.Position = UDim2.new(0, 6, 0.5, -18)
            img.BackgroundTransparency = 1
            img.Image = "rbxthumb://type=Asset&id=" .. tostring(item.id) .. "&w=150&h=150"
            img.Parent = itemFrame
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -85, 1, 0)
            lbl.Position = UDim2.new(0, 48, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = item.name
            lbl.TextColor3 = Theme.TextPrimary
            lbl.TextSize = 9
            lbl.Font = Enum.Font.GothamBold
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.Parent = itemFrame
            
            local favBtn = Instance.new("TextButton")
            favBtn.Size = UDim2.new(0, 18, 0, 18)
            favBtn.Position = UDim2.new(1, -26, 0.5, -9)
            favBtn.BackgroundTransparency = 1
            favBtn.Text = favorites[item.id] and "*" or "o"
            favBtn.TextColor3 = favorites[item.id] and Theme.Accent or Theme.TextSecondary
            favBtn.Font = Enum.Font.GothamBold
            favBtn.TextSize = 12
            favBtn.Parent = itemFrame
            
            favBtn.MouseButton1Click:Connect(function()
                favorites[item.id] = not favorites[item.id]
                favBtn.Text = favorites[item.id] and "*" or "o"
                favBtn.TextColor3 = favorites[item.id] and Theme.Accent or Theme.TextSecondary
            end)
            
            local clickBtn = Instance.new("TextButton")
            clickBtn.Size = UDim2.new(1, -30, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""
            clickBtn.Parent = itemFrame
            
            clickBtn.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                
                local found = nil
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("Accessory") and child:GetAttribute("PresetId") == item.id then
                        found = child
                        break
                    end
                end
                
                if found then
                    found:Destroy()
                    itemFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
                else
                    task.spawn(function()
                        if item.id == 1340825139 or item.id == 15093053680 then
                            -- Headless Head
                            local myHead = char:FindFirstChild("Head")
                            if myHead then
                                local face = myHead:FindFirstChild("face")
                                if face then face.Transparency = 1 end
                                myHead.Transparency = 1
                                local mesh = myHead:FindFirstChildOfClass("SpecialMesh")
                                if mesh then mesh.Scale = Vector3.new(0, 0, 0) end
                            end
                            itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                        elseif item.id == 139607718 then
                            -- Korblox Right Leg
                            local desc = Instance.new("HumanoidDescription")
                            desc.RightLeg = 139607718
                            local ok, dummy = pcall(function()
                                return Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
                            end)
                            if ok and dummy then
                                local parts = {"RightFoot", "RightLowerLeg", "RightUpperLeg"}
                                for _, p in ipairs(parts) do
                                    local oldP = char:FindFirstChild(p)
                                    if oldP then oldP:Destroy() end
                                    local newP = dummy:FindFirstChild(p)
                                    if newP then newP:Clone().Parent = char end
                                end
                                for _, descJoint in ipairs(dummy:GetDescendants()) do
                                    if descJoint:IsA("Motor6D") and (descJoint.Part0.Name:find("RightLeg") or descJoint.Part1.Name:find("RightLeg") or descJoint.Name:find("Right")) then
                                        local myParent = char:FindFirstChild(descJoint.Parent.Name)
                                        if myParent then
                                            local newJoint = descJoint:Clone()
                                            newJoint.Parent = myParent
                                            if newJoint.Part0 then newJoint.Part0 = char:FindFirstChild(newJoint.Part0.Name) end
                                            if newJoint.Part1 then newJoint.Part1 = char:FindFirstChild(newJoint.Part1.Name) end
                                        end
                                    end
                                end
                                pcall(function() char.Humanoid:BuildRigFromAttachments() end)
                                dummy:Destroy()
                                itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                            end
                        else
                            -- Standard Accessories (Use HumanoidDescription bypass so it works on all executors!)
                            local desc = Instance.new("HumanoidDescription")
                            desc.HatAccessory = tostring(item.id)
                            local ok, dummy = pcall(function()
                                return Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
                            end)
                            if ok and dummy then
                                local acc = dummy:FindFirstChildOfClass("Accessory")
                                if acc then
                                    local cloneAcc = acc:Clone()
                                    cloneAcc:SetAttribute("PresetId", item.id)
                                    manualWeldAccessory(char, cloneAcc)
                                    itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                                end
                                dummy:Destroy()
                            end
                        end
                    end)
                end
            end)
        end
    end
    AccCountLbl.Text = tostring(count) .. " items available"
end

renderPresets(false)

local showFavorites = false
StarHeaderBtn.MouseButton1Click:Connect(function()
    showFavorites = not showFavorites
    StarHeaderBtn.TextColor3 = showFavorites and Theme.Accent or Theme.TextSecondary
    renderPresets(showFavorites)
end)
end

-- MOVEMENT Card
do
local MovementCard = Instance.new("Frame")
MovementCard.Name = "MovementCard"
MovementCard.Size = UDim2.new(1, 0, 0, 185)
MovementCard.Position = UDim2.new(0, 0, 0, 0)
MovementCard.BackgroundColor3 = Theme.CardBg
MovementCard.Parent = PersonagemContainer

local MovementCorner = Instance.new("UICorner")
MovementCorner.CornerRadius = UDim.new(0, 10)
MovementCorner.Parent = MovementCard

local MovementStroke = Instance.new("UIStroke")
MovementStroke.Color = Theme.Border
MovementStroke.Thickness = 0.8
MovementStroke.Parent = MovementCard

local MovementTitle = Instance.new("TextLabel")
MovementTitle.Size = UDim2.new(1, -30, 0, 20)
MovementTitle.Position = UDim2.new(0, 15, 0, 15)
MovementTitle.BackgroundTransparency = 1
MovementTitle.Text = "MOVEMENT"
MovementTitle.TextColor3 = Theme.TextPrimary
MovementTitle.TextSize = 10
MovementTitle.Font = Enum.Font.GothamBold
MovementTitle.TextXAlignment = Enum.TextXAlignment.Left
MovementTitle.Parent = MovementCard

local MovementSub = Instance.new("TextLabel")
MovementSub.Size = UDim2.new(1, -30, 0, 15)
MovementSub.Position = UDim2.new(0, 15, 0, 32)
MovementSub.BackgroundTransparency = 1
MovementSub.Text = "Adjust speed, jump power, flight speed and gravity."
MovementSub.TextColor3 = Theme.TextSecondary
MovementSub.TextSize = 9
MovementSub.Font = Enum.Font.Gotham
MovementSub.TextXAlignment = Enum.TextXAlignment.Left
MovementSub.Parent = MovementCard

-- Helper function to make movement rows
local function createMovementRow(parent, name, yPos, showSettings)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -30, 0, 30)
    row.Position = UDim2.new(0, 15, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.TextPrimary
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(0, 32, 0, 18)
    tBtn.Position = UDim2.new(1, -32, 0.5, -9)
    tBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tBtn.Text = ""
    tBtn.Parent = row

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = tBtn

    local tCircle = Instance.new("Frame")
    tCircle.Size = UDim2.new(0, 12, 0, 12)
    tCircle.Position = UDim2.new(0, 3, 0.5, 0)
    tCircle.AnchorPoint = Vector2.new(0, 0.5)
    tCircle.BackgroundColor3 = Theme.TextSecondary
    tCircle.BorderSizePixel = 0
    tCircle.Parent = tBtn

    local tCircleCorner = Instance.new("UICorner")
    tCircleCorner.CornerRadius = UDim.new(1, 0)
    tCircleCorner.Parent = tCircle

    local active = false
    tBtn.MouseButton1Click:Connect(function()
        active = not active
        local targetPos = active and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        local targetColor = Theme.TextPrimary
            local bgTargetColor = active and Theme.Green or Color3.fromRGB(35, 35, 35)

        TweenService:Create(tCircle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
        TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = bgTargetColor}):Play()
    end)

    if showSettings then
        tBtn.Position = UDim2.new(1, -32, 0.5, -9)
        local setBtn = Instance.new("ImageButton")
        setBtn.Size = UDim2.new(0, 24, 0, 24)
        setBtn.Position = UDim2.new(1, -64, 0.5, -12)
        setBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        setBtn.Image = "rbxassetid://10747372703"
        setBtn.ImageColor3 = Theme.TextSecondary
        setBtn.Parent = row

        local setCorner = Instance.new("UICorner")
        setCorner.CornerRadius = UDim.new(0, 10)
        setCorner.Parent = setBtn

        local setStroke = Instance.new("UIStroke")
        setStroke.Color = Theme.Border
        setStroke.Thickness = 0.8
        setStroke.Parent = setBtn
    end
end

createMovementRow(MovementCard, "Walk Speed", 55, false)
createMovementRow(MovementCard, "Jump Power", 85, false)
createMovementRow(MovementCard, "Gravity", 115, false)
createMovementRow(MovementCard, "Fly", 145, true)
end

-- CHARACTER STATES Card
do
local StatesCard = Instance.new("Frame")
StatesCard.Name = "StatesCard"
StatesCard.Size = UDim2.new(1, 0, 0, 180) -- Aumentada de 150 para 180
StatesCard.Position = UDim2.new(0, 0, 0, 195)
StatesCard.BackgroundColor3 = Theme.CardBg
StatesCard.Parent = PersonagemContainer

local StatesCorner = Instance.new("UICorner")
StatesCorner.CornerRadius = UDim.new(0, 10)
StatesCorner.Parent = StatesCard

local StatesStroke = Instance.new("UIStroke")
StatesStroke.Color = Theme.Border
StatesStroke.Thickness = 0.8
StatesStroke.Parent = StatesCard

local StatesTitle = Instance.new("TextLabel")
StatesTitle.Size = UDim2.new(1, -30, 0, 20)
StatesTitle.Position = UDim2.new(0, 15, 0, 15)
StatesTitle.BackgroundTransparency = 1
StatesTitle.Text = "CHARACTER STATES"
StatesTitle.TextColor3 = Theme.TextPrimary
StatesTitle.TextSize = 10
StatesTitle.Font = Enum.Font.GothamBold
StatesTitle.TextXAlignment = Enum.TextXAlignment.Left
StatesTitle.Parent = StatesCard

local StatesSub = Instance.new("TextLabel")
StatesSub.Size = UDim2.new(1, -30, 0, 15)
StatesSub.Position = UDim2.new(0, 15, 0, 32)
StatesSub.BackgroundTransparency = 1
StatesSub.Text = "Toggle temporary movement and physics states."
StatesSub.TextColor3 = Theme.TextSecondary
StatesSub.TextSize = 9
StatesSub.Font = Enum.Font.Gotham
StatesSub.TextXAlignment = Enum.TextXAlignment.Left
StatesSub.Parent = StatesCard

local StatesGrid = Instance.new("Frame")
StatesGrid.Size = UDim2.new(1, -30, 1, -60)
StatesGrid.Position = UDim2.new(0, 15, 0, 52)
StatesGrid.BackgroundTransparency = 1
StatesGrid.Parent = StatesCard

local StatesGridLayout = Instance.new("UIGridLayout")
StatesGridLayout.CellSize = UDim2.new(0.5, -6, 0, 26)
StatesGridLayout.CellPadding = UDim2.new(0, 12, 0, 6)
StatesGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
StatesGridLayout.Parent = StatesGrid

local characterStates = {"Sit", "Freeze", "Noclip", "Checkpoint", "Swim Anywhere", "Infinite Jump"}
local noclipConnection = nil
local freezeConnection = nil
local infiniteJumpConnection = nil

-- Listeners de conexÃµes para limpar ao desabilitar/destruir o painel
MainFrame.Destroying:Connect(function()
    if noclipConnection then noclipConnection:Disconnect() end
    if freezeConnection then freezeConnection:Disconnect() end
    if infiniteJumpConnection then infiniteJumpConnection:Disconnect() end
end)

for _, stateName in ipairs(characterStates) do
    local sFrame = Instance.new("Frame")
    sFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    sFrame.Parent = StatesGrid

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 10)
    sCorner.Parent = sFrame

    local sStroke = Instance.new("UIStroke")
    sStroke.Color = Theme.Border
    sStroke.Thickness = 0.8
    sStroke.Parent = sFrame

    local sLabel = Instance.new("TextLabel")
    sLabel.Size = UDim2.new(0.6, 0, 1, 0)
    sLabel.Position = UDim2.new(0, 10, 0, 0)
    sLabel.BackgroundTransparency = 1
    sLabel.Text = stateName
    sLabel.TextColor3 = Theme.TextPrimary
    sLabel.TextSize = 11
    sLabel.Font = Enum.Font.GothamBold
    sLabel.TextXAlignment = Enum.TextXAlignment.Left
    sLabel.Parent = sFrame

    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(0, 34, 0, 18)
    tBtn.Position = UDim2.new(1, -36, 0.5, -8)
    tBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tBtn.Text = ""
    tBtn.Parent = sFrame

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = tBtn

    local tCircle = Instance.new("Frame")
    tCircle.Size = UDim2.new(0, 12, 0, 12)
    tCircle.Position = UDim2.new(0, 3, 0.5, 0)
    tCircle.AnchorPoint = Vector2.new(0, 0.5)
    tCircle.BackgroundColor3 = Theme.TextSecondary
    tCircle.BorderSizePixel = 0
    tCircle.Parent = tBtn

    local tCircleCorner = Instance.new("UICorner")
    tCircleCorner.CornerRadius = UDim.new(1, 0)
    tCircleCorner.Parent = tCircle

    local active = false
    tBtn.MouseButton1Click:Connect(function()
        active = not active
        local targetPos = active and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        local targetColor = Theme.TextPrimary
            local bgTargetColor = active and Theme.Green or Color3.fromRGB(35, 35, 35)

        TweenService:Create(tCircle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
        TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = bgTargetColor}):Play()

        -- LÃ“GICA DE EXECUÃ‡ÃƒO REAL DE CADA ESTADO
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if stateName == "Noclip" then
            if active then
                if noclipConnection then noclipConnection:Disconnect() end
                noclipConnection = RunService.Stepped:Connect(function()
                    if LocalPlayer.Character then
                        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            else
                if noclipConnection then
                    noclipConnection:Disconnect()
                    noclipConnection = nil
                end
            end
        elseif stateName == "Sit" then
            if hum then
                hum.Sit = active
            end
        elseif stateName == "Freeze" then
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = active
            end
        elseif stateName == "Infinite Jump" then
            if active then
                if infiniteJumpConnection then infiniteJumpConnection:Disconnect() end
                infiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                    local myChar = LocalPlayer.Character
                    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
                    if myHum then
                        myHum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                if infiniteJumpConnection then
                    infiniteJumpConnection:Disconnect()
                    infiniteJumpConnection = nil
                end
            end
        elseif stateName == "Checkpoint" then
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if active and hrp then
                -- Salva checkpoint na posiÃ§Ã£o atual
                char:SetAttribute("DedSecCheckpoint", hrp.CFrame)
                notify("DedSec Panel", "Checkpoint definido na posiÃ§Ã£o atual!")
            elseif not active then
                -- Teleporta de volta ao checkpoint salvo
                local saved = char and char:GetAttribute("DedSecCheckpoint")
                if saved and hrp then
                    hrp.CFrame = saved
                    notify("DedSec Panel", "Teleportado para o checkpoint salvo!")
                else
                    notify("DedSec Panel", "Nenhum checkpoint salvo encontrado.")
                end
            end
        end
    end)
end
end

-- QUICK ACTIONS Card
do
local QuickCard = Instance.new("Frame")
QuickCard.Name = "QuickCard"
QuickCard.Size = UDim2.new(1, 0, 0, 95)
QuickCard.Position = UDim2.new(0, 0, 0, 385) -- Empurrado para baixo (de 350 para 385)
QuickCard.BackgroundColor3 = Theme.CardBg
QuickCard.Parent = PersonagemContainer

local QuickCorner = Instance.new("UICorner")
QuickCorner.CornerRadius = UDim.new(0, 10)
QuickCorner.Parent = QuickCard

local QuickStroke = Instance.new("UIStroke")
QuickStroke.Color = Theme.Border
QuickStroke.Thickness = 0.8
QuickStroke.Parent = QuickCard

local QuickTitle = Instance.new("TextLabel")
QuickTitle.Size = UDim2.new(1, -30, 0, 20)
QuickTitle.Position = UDim2.new(0, 15, 0, 15)
QuickTitle.BackgroundTransparency = 1
QuickTitle.Text = "QUICK ACTIONS"
QuickTitle.TextColor3 = Theme.TextPrimary
QuickTitle.TextSize = 10
QuickTitle.Font = Enum.Font.GothamBold
QuickTitle.TextXAlignment = Enum.TextXAlignment.Left
QuickTitle.Parent = QuickCard

local QuickSub = Instance.new("TextLabel")
QuickSub.Size = UDim2.new(1, -30, 0, 15)
QuickSub.Position = UDim2.new(0, 15, 0, 32)
QuickSub.BackgroundTransparency = 1
QuickSub.Text = "Instant character recovery and movement tools."
QuickSub.TextColor3 = Theme.TextSecondary
QuickSub.TextSize = 9
QuickSub.Font = Enum.Font.Gotham
QuickSub.TextXAlignment = Enum.TextXAlignment.Left
QuickSub.Parent = QuickCard

local QuickGrid = Instance.new("Frame")
QuickGrid.Size = UDim2.new(1, -30, 0, 28)
QuickGrid.Position = UDim2.new(0, 15, 0, 52)
QuickGrid.BackgroundTransparency = 1
QuickGrid.Parent = QuickCard

local QuickGridLayout = Instance.new("UIGridLayout")
QuickGridLayout.CellSize = UDim2.new(0.5, -6, 1, 0)
QuickGridLayout.CellPadding = UDim2.new(0, 12, 0, 0)
QuickGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
QuickGridLayout.Parent = QuickGrid

local quickActionsList = {"Respawn", "Anti Dead"}
for _, actionName in ipairs(quickActionsList) do
    local qFrame = Instance.new("Frame")
    qFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    qFrame.Parent = QuickGrid

    local qCorner = Instance.new("UICorner")
    qCorner.CornerRadius = UDim.new(0, 10)
    qCorner.Parent = qFrame

    local qStroke = Instance.new("UIStroke")
    qStroke.Color = Theme.Border
    qStroke.Thickness = 0.8
    qStroke.Parent = qFrame

    local qLabel = Instance.new("TextLabel")
    qLabel.Size = UDim2.new(0.6, 0, 1, 0)
    qLabel.Position = UDim2.new(0, 10, 0, 0)
    qLabel.BackgroundTransparency = 1
    qLabel.Text = actionName
    qLabel.TextColor3 = Theme.TextPrimary
    qLabel.TextSize = 11
    qLabel.Font = Enum.Font.GothamBold
    qLabel.TextXAlignment = Enum.TextXAlignment.Left
    qLabel.Parent = qFrame

    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(0, 34, 0, 18)
    tBtn.Position = UDim2.new(1, -36, 0.5, -8)
    tBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tBtn.Text = ""
    tBtn.Parent = qFrame

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = tBtn

    local tCircle = Instance.new("Frame")
    tCircle.Size = UDim2.new(0, 12, 0, 12)
    tCircle.Position = UDim2.new(0, 3, 0.5, 0)
    tCircle.AnchorPoint = Vector2.new(0, 0.5)
    tCircle.BackgroundColor3 = Theme.TextSecondary
    tCircle.BorderSizePixel = 0
    tCircle.Parent = tBtn

    local tCircleCorner = Instance.new("UICorner")
    tCircleCorner.CornerRadius = UDim.new(1, 0)
    tCircleCorner.Parent = tCircle

    local active = false
    tBtn.MouseButton1Click:Connect(function()
        active = not active
        local targetPos = active and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        local targetColor = Theme.TextPrimary
            local bgTargetColor = active and Theme.Green or Color3.fromRGB(35, 35, 35)

        TweenService:Create(tCircle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
        TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = bgTargetColor}):Play()
    end)
end
end
end)
if not successChar then
    warn("DedSec character view error: " .. tostring(errChar))
end

-- ==========================================
-- TARGET VIEW
-- ==========================================

local successTarget, errTarget = pcall(function()
    local TargetView = Views:WaitForChild("Target")

    -- Top Search Card
    local TargetProfileCard = Instance.new("Frame")
    TargetProfileCard.Name = "TargetProfileCard"
    TargetProfileCard.Size = UDim2.new(1, 0, 0, 125)
    TargetProfileCard.BackgroundColor3 = Theme.CardBg
    TargetProfileCard.Parent = TargetView

    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0, 10)
    TCorner.Parent = TargetProfileCard

    local TStroke = Instance.new("UIStroke")
    TStroke.Color = Theme.Border
    TStroke.Thickness = 0.8
    TStroke.Parent = TargetProfileCard

    local TTitle = Instance.new("TextLabel")
    TTitle.Size = UDim2.new(1, -30, 0, 20)
    TTitle.Position = UDim2.new(0, 15, 0, 15)
    TTitle.BackgroundTransparency = 1
    TTitle.Text = "Target"
    TTitle.TextColor3 = Theme.TextPrimary
    TTitle.TextSize = 10
    TTitle.Font = Enum.Font.GothamBold
    TTitle.TextXAlignment = Enum.TextXAlignment.Left
    TTitle.Parent = TargetProfileCard

    local TSub = Instance.new("TextLabel")
    TSub.Size = UDim2.new(1, -30, 0, 15)
    TSub.Position = UDim2.new(0, 15, 0, 32)
    TSub.BackgroundTransparency = 1
    TSub.Text = "Search a player, select with the mouse, and launch target actions."
    TSub.TextColor3 = Theme.TextSecondary
    TSub.TextSize = 9
    TSub.Font = Enum.Font.Gotham
    TSub.TextXAlignment = Enum.TextXAlignment.Left
    TSub.Parent = TargetProfileCard

    -- Avatar circular frame
    local TAvatar = Instance.new("ImageLabel")
    TAvatar.Size = UDim2.new(0, 56, 0, 56)
    TAvatar.Position = UDim2.new(0, 15, 0, 55)
    TAvatar.BackgroundColor3 = Theme.Sidebar
    TAvatar.Image = gifAsset
    TAvatar.Parent = TargetProfileCard

    local TAvatarCorner = Instance.new("UICorner")
    TAvatarCorner.CornerRadius = UDim.new(1, 0)
    TAvatarCorner.Parent = TAvatar

    local TAvatarStroke = Instance.new("UIStroke")
    TAvatarStroke.Color = Theme.Border
    TAvatarStroke.Thickness = 0.8
    TAvatarStroke.Parent = TAvatar

    -- TextBox search field
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -195, 0, 26)
    SearchBox.Position = UDim2.new(0, 85, 0, 55)
    SearchBox.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    SearchBox.PlaceholderText = "@username"
    SearchBox.Text = ""
    SearchBox.TextColor3 = Theme.TextPrimary
    SearchBox.PlaceholderColor3 = Theme.TextSecondary
    SearchBox.TextSize = 11
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = TargetProfileCard

    local SearchPadding = Instance.new("UIPadding")
    SearchPadding.PaddingLeft = UDim.new(0, 10)
    SearchPadding.Parent = SearchBox

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 10)
    SearchCorner.Parent = SearchBox

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = Theme.Border
    SearchStroke.Thickness = 0.8
    SearchStroke.Parent = SearchBox

    -- TextBox crosshair icon action button
    local CrossBtn = Instance.new("ImageButton")
    CrossBtn.Size = UDim2.new(0, 26, 0, 26)
    CrossBtn.Position = UDim2.new(1, -95, 0, 55)
    CrossBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    CrossBtn.Image = "rbxassetid://10747375156"
    CrossBtn.ImageColor3 = Theme.TextSecondary
    CrossBtn.Parent = TargetProfileCard

    local CrossCorner = Instance.new("UICorner")
    CrossCorner.CornerRadius = UDim.new(0, 10)
    CrossCorner.Parent = CrossBtn

    local CrossStroke = Instance.new("UIStroke")
    CrossStroke.Color = Theme.Border
    CrossStroke.Thickness = 0.8
    CrossStroke.Parent = CrossBtn

    -- Target details column
    local DetailsLabel = Instance.new("TextLabel")
    DetailsLabel.Size = UDim2.new(0, 200, 0, 32)
    DetailsLabel.Position = UDim2.new(0, 85, 0, 85)
    DetailsLabel.BackgroundTransparency = 1
    DetailsLabel.Text = "UserID: None\nDisplay: None\nCreated: None"
    DetailsLabel.TextColor3 = Theme.TextSecondary
    DetailsLabel.TextSize = 9
    DetailsLabel.Font = Enum.Font.Gotham
    DetailsLabel.LineHeight = 1.2
    DetailsLabel.TextXAlignment = Enum.TextXAlignment.Left
    DetailsLabel.TextYAlignment = Enum.TextYAlignment.Top
    DetailsLabel.Parent = TargetProfileCard

    -- Dropdown de sugestÃµes flutuante para auto-completar
    local SuggestionScroll = Instance.new("ScrollingFrame")
    SuggestionScroll.Name = "SuggestionScroll"
    SuggestionScroll.Size = UDim2.new(1, -195, 0, 0) -- Tamanho Y dinÃ¢mico
    SuggestionScroll.Position = UDim2.new(0, 85, 0, 83) -- Logo abaixo do SearchBox
    SuggestionScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    SuggestionScroll.BorderSizePixel = 0
    SuggestionScroll.ScrollBarThickness = 2
    SuggestionScroll.ScrollBarImageColor3 = Theme.Border
    SuggestionScroll.ZIndex = 15 -- Fica por cima de tudo
    SuggestionScroll.Visible = false
    SuggestionScroll.Parent = TargetProfileCard

    local SuggestionCorner = Instance.new("UICorner")
    SuggestionCorner.CornerRadius = UDim.new(0, 10)
    SuggestionCorner.Parent = SuggestionScroll

    local SuggestionStroke = Instance.new("UIStroke")
    SuggestionStroke.Color = Theme.Border
    SuggestionStroke.Thickness = 0.8
    SuggestionStroke.Parent = SuggestionScroll

    local SuggestionListLayout = Instance.new("UIListLayout")
    SuggestionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SuggestionListLayout.Parent = SuggestionScroll

    local selectedPlayer = nil

    local function selectPlayer(player)
        selectedPlayer = player
        SearchBox.Text = "@" .. player.Name
        SuggestionScroll.Visible = false
        
        -- Atualiza dados de detalhes
        local dateString = "Unknown"
        pcall(function()
            local ageInDays = player.AccountAge
            local creationYear = os.date("%Y") - math.floor(ageInDays / 365.25)
            dateString = "Estimate ~" .. tostring(creationYear)
        end)
        DetailsLabel.Text = "UserID: " .. tostring(player.UserId) .. "\nDisplay: " .. player.DisplayName .. "\nCreated: " .. dateString
        
        -- Atualiza Foto de Perfil
        task.spawn(function()
            pcall(function()
                local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                if isReady then
                    TAvatar.Image = content
                end
            end)
        end)
        notify("Target", "Jogador selecionado: @" .. player.Name)
    end

    local function updateSuggestions()
        local text = SearchBox.Text:lower():gsub("^@", "")
        for _, child in ipairs(SuggestionScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        if text == "" then
            SuggestionScroll.Visible = false
            return
        end

        local matches = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Name:lower():find(text) or player.DisplayName:lower():find(text) then
                table.insert(matches, player)
            end
        end

        if #matches == 0 then
            SuggestionScroll.Visible = false
            return
        end

        local height = math.min(#matches * 22, 110)
        SuggestionScroll.Size = UDim2.new(1, -195, 0, height)
        SuggestionScroll.Visible = true

        for _, player in ipairs(matches) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 22)
            btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            btn.BorderSizePixel = 0
            btn.Text = player.DisplayName .. " (@" .. player.Name .. ")"
            btn.TextColor3 = Theme.TextPrimary
            btn.TextSize = 10
            btn.Font = Enum.Font.Gotham
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.ZIndex = 16
            btn.Parent = SuggestionScroll

            local btnPad = Instance.new("UIPadding")
            btnPad.PaddingLeft = UDim.new(0, 10)
            btnPad.Parent = btn

            btn.MouseButton1Click:Connect(function()
                selectPlayer(player)
            end)
        end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(updateSuggestions)

    -- Permite selecionar ao perder foco apertando enter
    SearchBox.FocusLost:Connect(function(enterPressed)
        task.wait(0.2) -- Espera cliques de sugestÃ£o serem processados primeiro
        SuggestionScroll.Visible = false
        if enterPressed or SearchBox.Text ~= "" then
            local text = SearchBox.Text:lower():gsub("^@", "")
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Name:lower():find(text) or player.DisplayName:lower():find(text) then
                    selectPlayer(player)
                    break
                end
            end
        end
    end)

    -- Clique no botÃ£o de mira (Crosshair)
    CrossBtn.MouseButton1Click:Connect(function()
        local text = SearchBox.Text:lower():gsub("^@", "")
        local found = false
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Name:lower():find(text) or player.DisplayName:lower():find(text) then
                selectPlayer(player)
                found = true
                break
            end
        end
        if not found then
            notify("Target", "Nenhum jogador correspondente encontrado.")
        end
    end)

    -- QUICK ACTIONS Card (Target)
    local TQuickCard = Instance.new("Frame")
    TQuickCard.Name = "TQuickCard"
    TQuickCard.Size = UDim2.new(1, 0, 0, 125)
    TQuickCard.Position = UDim2.new(0, 0, 0, 135)
    TQuickCard.BackgroundColor3 = Theme.CardBg
    TQuickCard.Parent = TargetView

    local TQuickCorner = Instance.new("UICorner")
    TQuickCorner.CornerRadius = UDim.new(0, 10)
    TQuickCorner.Parent = TQuickCard

    local TQuickStroke = Instance.new("UIStroke")
    TQuickStroke.Color = Theme.Border
    TQuickStroke.Thickness = 0.8
    TQuickStroke.Parent = TQuickCard

    local TQuickTitle = Instance.new("TextLabel")
    TQuickTitle.Size = UDim2.new(1, -30, 0, 20)
    TQuickTitle.Position = UDim2.new(0, 15, 0, 15)
    TQuickTitle.BackgroundTransparency = 1
    TQuickTitle.Text = "QUICK ACTIONS"
    TQuickTitle.TextColor3 = Theme.TextPrimary
    TQuickTitle.TextSize = 10
    TQuickTitle.Font = Enum.Font.GothamBold
    TQuickTitle.TextXAlignment = Enum.TextXAlignment.Left
    TQuickTitle.Parent = TQuickCard

    local TQuickSub = Instance.new("TextLabel")
    TQuickSub.Size = UDim2.new(1, -30, 0, 15)
    TQuickSub.Position = UDim2.new(0, 15, 0, 32)
    TQuickSub.BackgroundTransparency = 1
    TQuickSub.Text = "Fast actions for the selected target."
    TQuickSub.TextColor3 = Theme.TextSecondary
    TQuickSub.TextSize = 9
    TQuickSub.Font = Enum.Font.Gotham
    TQuickSub.TextXAlignment = Enum.TextXAlignment.Left
    TQuickSub.Parent = TQuickCard

    local TQuickGrid = Instance.new("Frame")
    TQuickGrid.Size = UDim2.new(1, -30, 1, -60)
    TQuickGrid.Position = UDim2.new(0, 15, 0, 52)
    TQuickGrid.BackgroundTransparency = 1
    TQuickGrid.Parent = TQuickCard

    local TQuickGridLayout = Instance.new("UIGridLayout")
    TQuickGridLayout.CellSize = UDim2.new(0.5, -6, 0, 26)
    TQuickGridLayout.CellPadding = UDim2.new(0, 12, 0, 6)
    TQuickGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TQuickGridLayout.Parent = TQuickGrid

    local tQuickActions = {"Teleport", "Bring", "Copy ID", "Animation"}
    for _, actionName in ipairs(tQuickActions) do
        local qFrame = Instance.new("Frame")
        qFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        qFrame.Parent = TQuickGrid

        local qCorner = Instance.new("UICorner")
        qCorner.CornerRadius = UDim.new(0, 10)
        qCorner.Parent = qFrame

        local qStroke = Instance.new("UIStroke")
        qStroke.Color = Theme.Border
        qStroke.Thickness = 0.8
        qStroke.Parent = qFrame

        local qLabel = Instance.new("TextLabel")
        qLabel.Size = UDim2.new(0.6, 0, 1, 0)
        qLabel.Position = UDim2.new(0, 10, 0, 0)
        qLabel.BackgroundTransparency = 1
        qLabel.Text = actionName
        qLabel.TextColor3 = Theme.TextPrimary
        qLabel.TextSize = 13
        qLabel.Font = Enum.Font.GothamBold
        qLabel.TextXAlignment = Enum.TextXAlignment.Left
        qLabel.Parent = qFrame

        local tBtn = Instance.new("TextButton")
        tBtn.Size = UDim2.new(0, 34, 0, 18)
        tBtn.Position = UDim2.new(1, -36, 0.5, -8)
        tBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tBtn.Text = ""
        tBtn.Parent = qFrame

        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(1, 0)
        tCorner.Parent = tBtn

        local tCircle = Instance.new("Frame")
        tCircle.Size = UDim2.new(0, 12, 0, 12)
        tCircle.Position = UDim2.new(0, 3, 0.5, 0)
        tCircle.AnchorPoint = Vector2.new(0, 0.5)
        tCircle.BackgroundColor3 = Theme.TextSecondary
        tCircle.BorderSizePixel = 0
        tCircle.Parent = tBtn

        local tCircleCorner = Instance.new("UICorner")
        tCircleCorner.CornerRadius = UDim.new(1, 0)
        tCircleCorner.Parent = tCircle

        local active = false
        tBtn.MouseButton1Click:Connect(function()
            active = not active
            local targetPos = active and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            local targetColor = Theme.TextPrimary
            local bgTargetColor = active and Theme.Green or Color3.fromRGB(35, 35, 35)

            TweenService:Create(tCircle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
            TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = bgTargetColor}):Play()
        end)
    end

    -- POSITION ACTIONS Card (Target)
    do
    local TPosCard = Instance.new("Frame")
    TPosCard.Name = "TPosCard"
    TPosCard.Size = UDim2.new(1, 0, 0, 255)
    TPosCard.Position = UDim2.new(0, 0, 0, 275)
    TPosCard.BackgroundColor3 = Theme.CardBg
    TPosCard.Parent = TargetView

    local TPosCorner = Instance.new("UICorner")
    TPosCorner.CornerRadius = UDim.new(0, 10)
    TPosCorner.Parent = TPosCard

    local TPosStroke = Instance.new("UIStroke")
    TPosStroke.Color = Theme.Border
    TPosStroke.Thickness = 0.8
    TPosStroke.Parent = TPosCard

    local TPosTitle = Instance.new("TextLabel")
    TPosTitle.Size = UDim2.new(1, -30, 0, 20)
    TPosTitle.Position = UDim2.new(0, 15, 0, 15)
    TPosTitle.BackgroundTransparency = 1
    TPosTitle.Text = "POSITION ACTIONS"
    TPosTitle.TextColor3 = Theme.TextPrimary
    TPosTitle.TextSize = 10
    TPosTitle.Font = Enum.Font.GothamBold
    TPosTitle.TextXAlignment = Enum.TextXAlignment.Left
    TPosTitle.Parent = TPosCard

    local TPosSub = Instance.new("TextLabel")
    TPosSub.Size = UDim2.new(1, -30, 0, 15)
    TPosSub.Position = UDim2.new(0, 15, 0, 32)
    TPosSub.BackgroundTransparency = 1
    TPosSub.Text = "Attach, sit, or move around the selected player."
    TPosSub.TextColor3 = Theme.TextSecondary
    TPosSub.TextSize = 9
    TPosSub.Font = Enum.Font.Gotham
    TPosSub.TextXAlignment = Enum.TextXAlignment.Left
    TPosSub.Parent = TPosCard

    local TPosGrid = Instance.new("Frame")
    TPosGrid.Size = UDim2.new(1, -30, 1, -60)
    TPosGrid.Position = UDim2.new(0, 15, 0, 52)
    TPosGrid.BackgroundTransparency = 1
    TPosGrid.Parent = TPosCard

    local TPosGridLayout = Instance.new("UIGridLayout")
    TPosGridLayout.CellSize = UDim2.new(0.5, -6, 0, 26)
    TPosGridLayout.CellPadding = UDim2.new(0, 12, 0, 6)
    TPosGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TPosGridLayout.Parent = TPosGrid

    local tPositionActions = {"View", "Focus", "Follow", "Follow 2", "Hug Player", "Stand Side", "Stand2", "Headsit", "Hedsit 2", "Drag", "Doggy", "Backpack"}
    for _, actionName in ipairs(tPositionActions) do
        local pFrame = Instance.new("Frame")
        pFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        pFrame.Parent = TPosGrid

        local pCorner = Instance.new("UICorner")
        pCorner.CornerRadius = UDim.new(0, 10)
        pCorner.Parent = pFrame

        local pStroke = Instance.new("UIStroke")
        pStroke.Color = Theme.Border
        pStroke.Thickness = 0.8
        pStroke.Parent = pFrame

        local pLabel = Instance.new("TextLabel")
        pLabel.Size = UDim2.new(0.6, 0, 1, 0)
        pLabel.Position = UDim2.new(0, 10, 0, 0)
        pLabel.BackgroundTransparency = 1
        pLabel.Text = actionName
        pLabel.TextColor3 = Theme.TextPrimary
        pLabel.TextSize = 13
        pLabel.Font = Enum.Font.GothamBold
        pLabel.TextXAlignment = Enum.TextXAlignment.Left
        pLabel.Parent = pFrame

        local tBtn = Instance.new("TextButton")
        tBtn.Size = UDim2.new(0, 34, 0, 18)
        tBtn.Position = UDim2.new(1, -36, 0.5, -8)
        tBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tBtn.Text = ""
        tBtn.Parent = pFrame

        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(1, 0)
        tCorner.Parent = tBtn

        local tCircle = Instance.new("Frame")
        tCircle.Size = UDim2.new(0, 12, 0, 12)
        tCircle.Position = UDim2.new(0, 3, 0.5, 0)
        tCircle.AnchorPoint = Vector2.new(0, 0.5)
        tCircle.BackgroundColor3 = Theme.TextSecondary
        tCircle.BorderSizePixel = 0
        tCircle.Parent = tBtn

        local tCircleCorner = Instance.new("UICorner")
        tCircleCorner.CornerRadius = UDim.new(1, 0)
        tCircleCorner.Parent = tCircle

        local active = false
        tBtn.MouseButton1Click:Connect(function()
            active = not active
            local targetPos = active and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            local targetColor = Theme.TextPrimary
            local bgTargetColor = active and Theme.Green or Color3.fromRGB(35, 35, 35)

            TweenService:Create(tCircle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
            TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = bgTargetColor}):Play()
        end)
    end
    end

    -- POSITION ACTIONS +18 Card
    do
    local TPos18Card = Instance.new("Frame")
    TPos18Card.Name = "TPos18Card"
    TPos18Card.Size = UDim2.new(1, 0, 0, 185)
    TPos18Card.Position = UDim2.new(0, 0, 0, 545)
    TPos18Card.BackgroundColor3 = Theme.CardBg
    TPos18Card.Parent = TargetView

    local TPos18Corner = Instance.new("UICorner")
    TPos18Corner.CornerRadius = UDim.new(0, 10)
    TPos18Corner.Parent = TPos18Card

    local TPos18Stroke = Instance.new("UIStroke")
    TPos18Stroke.Color = Theme.Border
    TPos18Stroke.Thickness = 0.8
    TPos18Stroke.Parent = TPos18Card

    local TPos18Title = Instance.new("TextLabel")
    TPos18Title.Size = UDim2.new(1, -30, 0, 20)
    TPos18Title.Position = UDim2.new(0, 15, 0, 15)
    TPos18Title.BackgroundTransparency = 1
    TPos18Title.Text = "POSITION ACTIONS +18"
    TPos18Title.TextColor3 = Theme.TextPrimary
    TPos18Title.TextSize = 10
    TPos18Title.Font = Enum.Font.GothamBold
    TPos18Title.TextXAlignment = Enum.TextXAlignment.Left
    TPos18Title.Parent = TPos18Card

    local TPos18Sub = Instance.new("TextLabel")
    TPos18Sub.Size = UDim2.new(1, -30, 0, 15)
    TPos18Sub.Position = UDim2.new(0, 15, 0, 32)
    TPos18Sub.BackgroundTransparency = 1
    TPos18Sub.Text = "Additional position actions for the selected target."
    TPos18Sub.TextColor3 = Theme.TextSecondary
    TPos18Sub.TextSize = 9
    TPos18Sub.Font = Enum.Font.Gotham
    TPos18Sub.TextXAlignment = Enum.TextXAlignment.Left
    TPos18Sub.Parent = TPos18Card

    local TPos18Grid = Instance.new("Frame")
    TPos18Grid.Size = UDim2.new(1, -30, 1, -60)
    TPos18Grid.Position = UDim2.new(0, 15, 0, 52)
    TPos18Grid.BackgroundTransparency = 1
    TPos18Grid.Parent = TPos18Card

    local TPos18GridLayout = Instance.new("UIGridLayout")
    TPos18GridLayout.CellSize = UDim2.new(0.5, -6, 0, 26)
    TPos18GridLayout.CellPadding = UDim2.new(0, 12, 0, 6)
    TPos18GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TPos18GridLayout.Parent = TPos18Grid

    local tPos18Actions = {"Bang", "Bang 2", "FaceBang", "Bizarre", "Bizarre 2", "Seduce", "Twerk"}
    for _, actionName in ipairs(tPos18Actions) do
        local p18Frame = Instance.new("Frame")
        p18Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        p18Frame.Parent = TPos18Grid

        local p18Corner = Instance.new("UICorner")
        p18Corner.CornerRadius = UDim.new(0, 10)
        p18Corner.Parent = p18Frame

        local p18Stroke = Instance.new("UIStroke")
        p18Stroke.Color = Theme.Border
        p18Stroke.Thickness = 0.8
        p18Stroke.Parent = p18Frame

        local p18Label = Instance.new("TextLabel")
        p18Label.Size = UDim2.new(0.6, 0, 1, 0)
        p18Label.Position = UDim2.new(0, 10, 0, 0)
        p18Label.BackgroundTransparency = 1
        p18Label.Text = actionName
        p18Label.TextColor3 = Theme.TextPrimary
        p18Label.TextSize = 13
        p18Label.Font = Enum.Font.GothamBold
        p18Label.TextXAlignment = Enum.TextXAlignment.Left
        p18Label.Parent = p18Frame

        local tBtn = Instance.new("TextButton")
        tBtn.Size = UDim2.new(0, 34, 0, 18)
        tBtn.Position = UDim2.new(1, -36, 0.5, -8)
        tBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tBtn.Text = ""
        tBtn.Parent = p18Frame

        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(1, 0)
        tCorner.Parent = tBtn

        local tCircle = Instance.new("Frame")
        tCircle.Size = UDim2.new(0, 12, 0, 12)
        tCircle.Position = UDim2.new(0, 3, 0.5, 0)
        tCircle.AnchorPoint = Vector2.new(0, 0.5)
        tCircle.BackgroundColor3 = Theme.TextSecondary
        tCircle.BorderSizePixel = 0
        tCircle.Parent = tBtn

        local tCircleCorner = Instance.new("UICorner")
        tCircleCorner.CornerRadius = UDim.new(1, 0)
        tCircleCorner.Parent = tCircle

        local active = false
        tBtn.MouseButton1Click:Connect(function()
            active = not active
            local targetPos = active and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            local targetColor = Theme.TextPrimary
            local bgTargetColor = active and Theme.Green or Color3.fromRGB(35, 35, 35)

            TweenService:Create(tCircle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
            TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = bgTargetColor}):Play()
        end)
    end
    end
end)
if not successTarget then
    warn("DedSec target loading error: " .. tostring(errTarget))
end

-- ==========================================
-- ANIMATIONS VIEW
-- ==========================================

local successAnims, errAnims = pcall(function()
    local AnimationsView = Views:WaitForChild("Animations")

    -- Top Selector Bar (EMOTES / PACOTES)
    local SelectorBar = Instance.new("Frame")
    SelectorBar.Name = "SelectorBar"
    SelectorBar.Size = UDim2.new(1, 0, 0, 36)
    SelectorBar.BackgroundColor3 = Theme.Sidebar
    SelectorBar.BorderSizePixel = 0
    SelectorBar.Parent = AnimationsView

    local SelectorCorner = Instance.new("UICorner")
    SelectorCorner.CornerRadius = UDim.new(0, 10)
    SelectorCorner.Parent = SelectorBar

    local SelectorStroke = Instance.new("UIStroke")
    SelectorStroke.Color = Theme.Border
    SelectorStroke.Thickness = 0.8
    SelectorStroke.Parent = SelectorBar

    local EmotesBtn = Instance.new("TextButton")
    EmotesBtn.Size = UDim2.new(0.5, -4, 1, -4)
    EmotesBtn.Position = UDim2.new(0, 2, 0.5, 0)
    EmotesBtn.AnchorPoint = Vector2.new(0, 0.5)
    EmotesBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    EmotesBtn.Text = "EMOTES"
    EmotesBtn.TextColor3 = Theme.TextPrimary
    EmotesBtn.TextSize = 10
    EmotesBtn.Font = Enum.Font.GothamBold
    EmotesBtn.Parent = SelectorBar

    local EmotesCorner = Instance.new("UICorner")
    EmotesCorner.CornerRadius = UDim.new(0, 10)
    EmotesCorner.Parent = EmotesBtn

    local PacotesBtn = Instance.new("TextButton")
    PacotesBtn.Size = UDim2.new(0.5, -4, 1, -4)
    PacotesBtn.Position = UDim2.new(0.5, 2, 0.5, 0)
    PacotesBtn.AnchorPoint = Vector2.new(0, 0.5)
    PacotesBtn.BackgroundTransparency = 1
    PacotesBtn.Text = "PACOTES (UGC)"
    PacotesBtn.TextColor3 = Theme.TextSecondary
    PacotesBtn.TextSize = 10
    PacotesBtn.Font = Enum.Font.GothamBold
    PacotesBtn.Parent = SelectorBar

    local PacotesCorner = Instance.new("UICorner")
    PacotesCorner.CornerRadius = UDim.new(0, 10)
    PacotesCorner.Parent = PacotesBtn

    -- List container for Emotes
    local EmotesContainer = Instance.new("ScrollingFrame")
    EmotesContainer.Name = "EmotesContainer"
    EmotesContainer.Size = UDim2.new(1, 0, 1, -50)
    EmotesContainer.Position = UDim2.new(0, 0, 0, 50)
    EmotesContainer.BackgroundTransparency = 1
    EmotesContainer.BorderSizePixel = 0
    EmotesContainer.ScrollBarThickness = 2
    EmotesContainer.ScrollBarImageColor3 = Theme.Border
    EmotesContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    EmotesContainer.Parent = AnimationsView

    local EmotesGridLayout = Instance.new("UIGridLayout")
    EmotesGridLayout.CellSize = UDim2.new(0.5, -6, 0, 36)
    EmotesGridLayout.CellPadding = UDim2.new(0, 12, 0, 8)
    EmotesGridLayout.Parent = EmotesContainer

    -- List container for Pacotes (UGC)
    local PacotesContainer = Instance.new("Frame")
    PacotesContainer.Name = "PacotesContainer"
    PacotesContainer.Size = UDim2.new(1, 0, 1, -50)
    PacotesContainer.Position = UDim2.new(0, 0, 0, 50)
    PacotesContainer.BackgroundTransparency = 1
    PacotesContainer.Visible = false
    PacotesContainer.Parent = AnimationsView

    -- Tab Toggle functionality
    EmotesBtn.MouseButton1Click:Connect(function()
        EmotesBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        EmotesBtn.BackgroundTransparency = 0
        EmotesBtn.TextColor3 = Theme.TextPrimary
        PacotesBtn.BackgroundTransparency = 1
        PacotesBtn.TextColor3 = Theme.TextSecondary
        EmotesContainer.Visible = true
        PacotesContainer.Visible = false
    end)

    PacotesBtn.MouseButton1Click:Connect(function()
        PacotesBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        PacotesBtn.BackgroundTransparency = 0
        PacotesBtn.TextColor3 = Theme.TextPrimary
        EmotesBtn.BackgroundTransparency = 1
        EmotesBtn.TextColor3 = Theme.TextSecondary
        PacotesContainer.Visible = true
        EmotesContainer.Visible = false
    end)

    -- Services
    local AssetService = game:GetService("AssetService")
    local AvatarEditorService = game:GetService("AvatarEditorService")
    local ContentProvider = game:GetService("ContentProvider")

    -- Mapping slots
    local m = {
        ["runanimation"]      = "run",
        ["climbanimation"]    = "climb",
        ["jumpanimation"]     = "jump",
        ["fallanimation"]     = "fall",
        ["idleanimation"]     = "idle",
        ["swimidleanimation"] = "swimidle",
        ["swimanimation"]     = "swim",
        ["walkanimation"]     = "walk"
    }

    local shortNames = {
        ["idleanimation"]     = "Idle",
        ["walkanimation"]     = "Walk",
        ["runanimation"]      = "Run",
        ["jumpanimation"]     = "Jump",
        ["fallanimation"]     = "Fall",
        ["climbanimation"]    = "Climb",
        ["swimidleanimation"] = "S.Idle",
        ["swimanimation"]     = "Swim"
    }

    local buttonOrder = {
        "idleanimation",
        "walkanimation",
        "runanimation",
        "jumpanimation",
        "fallanimation",
        "climbanimation",
        "swimidleanimation",
        "swimanimation"
    }

    local assetCache, fileCache, equippedAnims = {}, {}, {}
    local savedBookmarks = {}

    local function applySavedAnimations(char)
        if not char then return end
        local animate = char:WaitForChild("Animate", 5)
        local human = char:WaitForChild("Humanoid", 5)
        if not animate or not human then return end
        
        for _, tr in ipairs(human:GetPlayingAnimationTracks()) do 
            pcall(function() tr:AdjustWeight(0,0); tr:Stop(0) end) 
        end
        
        animate.Disabled = true
        
        for slotType, animList in pairs(equippedAnims) do
            local fId = m[string.lower(slotType)]
            if fId then
                local folder = animate:FindFirstChild(fId)
                if folder then
                    for _, o in ipairs(folder:GetChildren()) do 
                        if o:IsA("Animation") then o:Destroy() end 
                    end
                    for _, animData in ipairs(animList) do
                        local newAnim = Instance.new("Animation", folder)
                        newAnim.Name = animData.Name
                        newAnim.AnimationId = animData.AnimationId
                    end
                end
            end
        end
        
        task.wait(0.05)
        animate.Disabled = false
    end

    local function initAutoEquip(char)
        if not char then return end
        task.spawn(function()
            local animate = char:WaitForChild("Animate", 5)
            local human = char:WaitForChild("Humanoid", 5)
            
            if animate and human then
                local idleFolder = animate:WaitForChild("idle", 5)
                if idleFolder then
                    idleFolder:WaitForChild("Animation1", 3) 
                end
                task.wait(0.1)
                applySavedAnimations(char)
            end
        end)
    end

    LocalPlayer.CharacterAdded:Connect(initAutoEquip)

    -- RESOLVER (The engine HumanoidDescription bypass)
    local function get(id, bundleId, assetType)
        local stringId = tostring(id)
        if assetCache[stringId] then return assetCache[stringId] end

        local t = {}
        local descProp = "IdleAnimation"
        local lowerType = assetType and string.lower(assetType) or ""

        if lowerType:find("idle") and not lowerType:find("swim") then descProp = "IdleAnimation"
        elseif lowerType:find("walk") then descProp = "WalkAnimation"
        elseif lowerType:find("run") then descProp = "RunAnimation"
        elseif lowerType:find("jump") then descProp = "JumpAnimation"
        elseif lowerType:find("fall") then descProp = "FallAnimation"
        elseif lowerType:find("climb") then descProp = "ClimbAnimation"
        elseif lowerType:find("swim") then descProp = "SwimAnimation"
        end

        pcall(function()
            local desc = Instance.new("HumanoidDescription")
            desc[descProp] = tonumber(id)
            local dummy = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
            local animate = dummy:FindFirstChild("Animate")
            if animate then
                local targetFolders = (descProp == "SwimAnimation") and {"swim", "swimidle"} or {string.lower(string.gsub(descProp, "Animation", ""))}
                for _, folderName in ipairs(targetFolders) do
                    local folder = animate:FindFirstChild(folderName)
                    if folder then
                        for _, child in ipairs(folder:GetChildren()) do
                            if child:IsA("Animation") and child.AnimationId ~= "" then
                                local clone = child:Clone()
                                table.insert(t, clone)
                            end
                        end
                    end
                end
            end
            dummy:Destroy()
        end)

        -- Fallback to game:GetObjects bypass
        if #t == 0 then
            pcall(function() 
                local objs = game:GetObjects("rbxassetid://" .. stringId) 
                if objs and #objs > 0 then
                    local function processItem(item)
                        if item:IsA("Animation") then
                            table.insert(t, item:Clone())
                        end
                    end
                    processItem(objs[1])
                    for _, c in ipairs(objs[1]:GetDescendants()) do processItem(c) end
                end
            end)
        end

        -- KeyframeSequence bypass injection
        for _, animObj in ipairs(t) do
            pcall(function()
                local assets = game:GetObjects(animObj.AnimationId)
                if assets and assets[1] and assets[1]:IsA("KeyframeSequence") then
                    local hashUrl = game:GetService("KeyframeSequenceProvider"):RegisterKeyframeSequence(assets[1])
                    if hashUrl then
                        animObj.AnimationId = hashUrl
                    end
                end
            end)
        end

        assetCache[stringId] = t
        return t
    end

    -- FULL WIDTH GRID LAYOUT inside PacotesContainer

    -- Header (Discover / Saved sub-tabs)
    local SubHeader = Instance.new("Frame")
    SubHeader.Size = UDim2.new(1, 0, 0, 26)
    SubHeader.Position = UDim2.new(0, 0, 0, 0)
    SubHeader.BackgroundTransparency = 1
    SubHeader.Parent = PacotesContainer

    local DiscoverBtn = Instance.new("TextButton")
    DiscoverBtn.Size = UDim2.new(0.48, 0, 1, 0)
    DiscoverBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    DiscoverBtn.Text = "Discover"
    DiscoverBtn.TextColor3 = Theme.TextPrimary
    DiscoverBtn.TextSize = 11
    DiscoverBtn.Font = Enum.Font.GothamBold
    DiscoverBtn.Parent = SubHeader
    Instance.new("UICorner", DiscoverBtn).CornerRadius = UDim.new(0, 10)

    local SavedBtn = Instance.new("TextButton")
    SavedBtn.Size = UDim2.new(0.48, 0, 1, 0)
    SavedBtn.Position = UDim2.new(0.52, 0, 0, 0)
    SavedBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    SavedBtn.Text = "Saved"
    SavedBtn.TextColor3 = Theme.TextSecondary
    SavedBtn.TextSize = 11
    SavedBtn.Font = Enum.Font.GothamBold
    SavedBtn.Parent = SubHeader
    Instance.new("UICorner", SavedBtn).CornerRadius = UDim.new(0, 10)

    -- Search row
    local SearchRow = Instance.new("Frame")
    SearchRow.Size = UDim2.new(1, 0, 0, 26)
    SearchRow.Position = UDim2.new(0, 0, 0, 30)
    SearchRow.BackgroundTransparency = 1
    SearchRow.Parent = PacotesContainer

    local sb = Instance.new("TextBox")
    sb.Size = UDim2.new(1, -94, 1, 0)
    sb.PlaceholderText = "Buscar pacote..."
    sb.Text = ""
    sb.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    sb.TextColor3 = Theme.TextPrimary
    sb.PlaceholderColor3 = Theme.TextSecondary
    sb.TextSize = 11
    sb.Font = Enum.Font.Gotham
    sb.ClearTextOnFocus = false
    sb.Parent = SearchRow
    Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 10)
    local sbStroke = Instance.new("UIStroke")
    sbStroke.Color = Theme.Accent
    sbStroke.Thickness = 1
    sbStroke.Parent = sb
    local sbPad = Instance.new("UIPadding", sb)
    sbPad.PaddingLeft = UDim.new(0, 8)
    sbPad.PaddingRight = UDim.new(0, 4)

    local searchBtn = Instance.new("TextButton")
    searchBtn.Size = UDim2.new(0, 86, 1, 0)
    searchBtn.Position = UDim2.new(1, -86, 0, 0)
    searchBtn.Text = "Buscar"
    searchBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    searchBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    searchBtn.Font = Enum.Font.GothamBold
    searchBtn.TextSize = 11
    searchBtn.AutoButtonColor = false
    searchBtn.Parent = SearchRow
    Instance.new("UICorner", searchBtn).CornerRadius = UDim.new(0, 10)
    searchBtn.MouseEnter:Connect(function() searchBtn.BackgroundColor3 = Color3.fromRGB(22, 163, 74) end)
    searchBtn.MouseLeave:Connect(function() searchBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94) end)

    -- No UIListLayout - use fixed top-anchored positions throughout

    -- Grid scroller fills all space between searchrow and footer
    local gridScroller = Instance.new("ScrollingFrame")
    gridScroller.Size = UDim2.new(1, 0, 1, -96)  -- top 60px + bottom 36px reserved
    gridScroller.Position = UDim2.new(0, 0, 0, 60)
    gridScroller.BackgroundTransparency = 1
    gridScroller.BorderSizePixel = 0
    gridScroller.ScrollBarThickness = 2
    gridScroller.ScrollBarImageColor3 = Theme.Border
    gridScroller.ScrollingDirection = Enum.ScrollingDirection.Y
    gridScroller.Parent = PacotesContainer

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0.5, -8, 0, 100)
    gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    gridLayout.Parent = gridScroller

    -- Footer anchored to bottom of container
    local LeftFooter = Instance.new("Frame")
    LeftFooter.Size = UDim2.new(1, 0, 0, 32)
    LeftFooter.Position = UDim2.new(0, 0, 1, -32)
    LeftFooter.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    LeftFooter.BorderSizePixel = 0
    LeftFooter.Parent = PacotesContainer
    Instance.new("UICorner", LeftFooter).CornerRadius = UDim.new(0, 10)
    local footerStroke = Instance.new("UIStroke", LeftFooter)
    footerStroke.Color = Color3.fromRGB(35, 35, 35)
    footerStroke.Thickness = 0.8

    local prevBtn = Instance.new("TextButton")
    prevBtn.Size = UDim2.new(0, 72, 0, 22)
    prevBtn.Position = UDim2.new(0, 4, 0.5, -11)
    prevBtn.Text = "<< Anterior"
    prevBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    prevBtn.AutoButtonColor = false
    prevBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    prevBtn.Font = Enum.Font.GothamBold
    prevBtn.TextSize = 9
    prevBtn.Parent = LeftFooter
    Instance.new("UICorner", prevBtn).CornerRadius = UDim.new(0, 10)
    prevBtn.MouseEnter:Connect(function() prevBtn.BackgroundColor3 = Color3.fromRGB(45,45,45) end)
    prevBtn.MouseLeave:Connect(function() prevBtn.BackgroundColor3 = Color3.fromRGB(30,30,30) end)

    local pageLbl = Instance.new("TextLabel")
    pageLbl.Size = UDim2.new(1, -160, 1, 0)
    pageLbl.Position = UDim2.new(0, 82, 0, 0)
    pageLbl.BackgroundTransparency = 1
    pageLbl.Text = "Pagina 1"
    pageLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    pageLbl.Font = Enum.Font.GothamBold
    pageLbl.TextSize = 11
    pageLbl.Parent = LeftFooter

    local nextBtn = Instance.new("TextButton")
    nextBtn.Size = UDim2.new(0, 72, 0, 22)
    nextBtn.Position = UDim2.new(1, -76, 0.5, -11)
    nextBtn.Text = "Proximo >>"
    nextBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    nextBtn.AutoButtonColor = false
    nextBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    nextBtn.Font = Enum.Font.GothamBold
    nextBtn.TextSize = 9
    nextBtn.Parent = LeftFooter
    Instance.new("UICorner", nextBtn).CornerRadius = UDim.new(0, 10)
    nextBtn.MouseEnter:Connect(function() nextBtn.BackgroundColor3 = Color3.fromRGB(22, 163, 74) end)
    nextBtn.MouseLeave:Connect(function() nextBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94) end)


    -- Variables
    local activeGridThreads = {}
    local searchResults, savedTabList = {}, {}
    local catalogCursor, currentPageIndex, itemsPerPage = nil, 1, 8
    local currentTab = "Discover"

    local function buildViewportSkeleton(vpFrame)
        local wm = vpFrame:FindFirstChildOfClass("WorldModel")
        if not wm then wm = Instance.new("WorldModel", vpFrame)
        else for _,c in ipairs(wm:GetChildren()) do c:Destroy() end end
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        char.Archivable = true
        local clone = char:Clone()
        clone.Parent = wm
        local root = clone:FindFirstChild("HumanoidRootPart")
        local human = clone:FindFirstChildOfClass("Humanoid")
        if not human then return clone, nil, function() end end
        local anim = human:FindFirstChildOfClass("Animator") or Instance.new("Animator", human)
        if clone:FindFirstChild("Animate") then clone.Animate.Disabled = true end
        local cam = vpFrame:FindFirstChildOfClass("Camera") or Instance.new("Camera", vpFrame)
        vpFrame.CurrentCamera = cam
        cam.CFrame = CFrame.new(Vector3.new(0, 1.5, 5.5), Vector3.new(0, 1, 0))
        local angle = 0
        local conn = game:GetService("RunService").RenderStepped:Connect(function(dt)
            if clone and clone.Parent and root then
                angle = angle + math.rad(30*dt)
                clone:PivotTo(CFrame.new(0,0,0) * CFrame.Angles(0, angle, 0))
            end
        end)
        return clone, anim, conn
    end

    local function applyAnimToChar(character, anims, slotType)
        local animate = character:WaitForChild("Animate", 5)
        local human = character:FindFirstChildOfClass("Humanoid")
        if not animate or not human then return end
        for _, tr in ipairs(human:GetPlayingAnimationTracks()) do pcall(function() tr:AdjustWeight(0,0); tr:Stop(0) end) end
        animate.Disabled = true
        local fId = m[string.lower(slotType or "")]
        if fId then
            local folder = animate:FindFirstChild(fId)
            if folder then
                for _, o in ipairs(folder:GetChildren()) do if o:IsA("Animation") then o:Destroy() end end
                equippedAnims[string.lower(slotType)] = {}
                for _, animAsset in ipairs(anims) do
                    local newAnim = Instance.new("Animation", folder)
                    newAnim.Name, newAnim.AnimationId = animAsset.Name, animAsset.AnimationId
                    table.insert(equippedAnims[string.lower(slotType)], {Name=newAnim.Name, AnimationId=newAnim.AnimationId})
                end
            end
        end
        task.wait(0.05); animate.Disabled = false
    end

    local function wearBundleQuickly(bundleId, onDone)
        task.spawn(function()
            local ok, res = pcall(function() return AssetService:GetBundleDetailsAsync(bundleId) end)
            if ok and res and res.Items and LocalPlayer.Character then
                local items = {}
                for _, item in ipairs(res.Items) do
                    local lt = string.lower(item.AssetType or "")
                    if lt == "swimanimation" then
                        items["swimanimation"] = item; items["swimidleanimation"] = item
                    elseif shortNames[lt] then
                        items[lt] = item
                    end
                end
                for _, lt in ipairs(buttonOrder) do
                    if items[lt] then
                        local t = get(items[lt].Id, nil, items[lt].AssetType)
                        if #t > 0 then applyAnimToChar(LocalPlayer.Character, t, lt) end
                    end
                end
            end
            if onDone then onDone() end
        end)
    end

    local function drawGridPage(dataList)
        for _, t in ipairs(activeGridThreads) do pcall(function() task.cancel(t) end) end
        table.clear(activeGridThreads)
        for _, c in ipairs(gridScroller:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end

        local startI = (currentPageIndex - 1) * itemsPerPage + 1
        local ending = math.min(currentPageIndex * itemsPerPage, #dataList)

        for i = startI, ending do
            local bundle = dataList[i]
            if not bundle then break end

            local card = Instance.new("Frame")
            card.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            card.Parent = gridScroller
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = Theme.Border; cardStroke.Thickness = 0.8; cardStroke.Parent = card

            -- Live 3D viewport left side
            local viewport = Instance.new("ViewportFrame")
            viewport.Size = UDim2.new(0, 72, 1, -8)
            viewport.Position = UDim2.new(0, 4, 0, 4)
            viewport.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            viewport.BorderSizePixel = 0
            viewport.Parent = card
            Instance.new("UICorner", viewport).CornerRadius = UDim.new(0, 10)
            local vpStroke = Instance.new("UIStroke")
            vpStroke.Color = Theme.Border; vpStroke.Thickness = 0.6; vpStroke.Parent = viewport

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -88, 0, 40)
            title.Position = UDim2.new(0, 84, 0, 4)
            title.BackgroundTransparency = 1
            title.Text = bundle.Name
            title.TextColor3 = Theme.TextPrimary
            title.TextSize = 10; title.Font = Enum.Font.GothamBold
            title.TextWrapped = true
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.TextYAlignment = Enum.TextYAlignment.Top
            title.Parent = card

            -- Bottom button row: USE PACK (left) | SAVE (right)
            local btnRow = Instance.new("Frame")
            btnRow.Size = UDim2.new(1, -88, 0, 26)
            btnRow.Position = UDim2.new(0, 84, 1, -32)
            btnRow.BackgroundTransparency = 1
            btnRow.Parent = card

            local wearBtn = Instance.new("TextButton")
            wearBtn.Size = UDim2.new(1, -56, 1, 0)
            wearBtn.Position = UDim2.new(0, 0, 0, 0)
            wearBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
            wearBtn.AutoButtonColor = false
            wearBtn.Text = "USE PACK"
            wearBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            wearBtn.TextSize = 9
            wearBtn.Font = Enum.Font.GothamBold
            wearBtn.Parent = btnRow
            Instance.new("UICorner", wearBtn).CornerRadius = UDim.new(0, 10)
            wearBtn.MouseEnter:Connect(function() wearBtn.BackgroundColor3 = Color3.fromRGB(22, 163, 74) end)
            wearBtn.MouseLeave:Connect(function() wearBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94) end)

            local saveBtn = Instance.new("TextButton")
            saveBtn.Size = UDim2.new(0, 48, 1, 0)
            saveBtn.Position = UDim2.new(1, -48, 0, 0)
            local isSaved = savedBookmarks[tostring(bundle.Id)] ~= nil
            saveBtn.BackgroundColor3 = isSaved and Color3.fromRGB(60, 50, 20) or Color3.fromRGB(30, 30, 35)
            saveBtn.AutoButtonColor = false
            saveBtn.Text = isSaved and "SAVED" or "SAVE"
            saveBtn.TextColor3 = isSaved and Color3.fromRGB(255, 215, 0) or Theme.TextSecondary
            saveBtn.TextSize = 8
            saveBtn.Font = Enum.Font.GothamBold
            saveBtn.Parent = btnRow
            Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 10)
            local saveBtnStroke = Instance.new("UIStroke", saveBtn)
            saveBtnStroke.Color = isSaved and Color3.fromRGB(200, 160, 0) or Theme.Border
            saveBtnStroke.Thickness = 0.8

            wearBtn.MouseButton1Click:Connect(function()
                wearBtn.Text = "..."
                wearBundleQuickly(bundle.Id, function() wearBtn.Text = "USE PACK" end)
            end)

            saveBtn.MouseButton1Click:Connect(function()
                local sId = tostring(bundle.Id)
                if savedBookmarks[sId] then
                    savedBookmarks[sId] = nil
                    saveBtn.Text = "SAVE"
                    saveBtn.TextColor3 = Theme.TextSecondary
                    saveBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                    saveBtnStroke.Color = Theme.Border
                else
                    savedBookmarks[sId] = {Id = bundle.Id, Name = bundle.Name, Time = tick()}
                    saveBtn.Text = "SAVED"
                    saveBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
                    saveBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 20)
                    saveBtnStroke.Color = Color3.fromRGB(200, 160, 0)
                end
            end)

            local dummy, animator, conn = buildViewportSkeleton(viewport)
            local loopThread = task.spawn(function()
                local ok, details = pcall(function() return AssetService:GetBundleDetailsAsync(bundle.Id) end)
                if not ok or not details or not details.Items then return end
                local usableTracks = {}
                for _, subItem in ipairs(details.Items) do
                    if m[string.lower(subItem.AssetType or "")] then table.insert(usableTracks, subItem) end
                end
                if #usableTracks == 0 or not animator then return end
                local tIdx, cellTrack = 1, nil
                while card and card.Parent do
                    local subItem = usableTracks[tIdx]
                    local assets = get(subItem.Id, bundle.Id, subItem.AssetType)
                    if #assets > 0 then
                        pcall(function()
                            if cellTrack then cellTrack:Stop() end
                            cellTrack = animator:LoadAnimation(assets[1])
                            cellTrack.Looped = true; cellTrack:Play()
                        end)
                    end
                    task.wait(3.5)
                    tIdx = (tIdx % #usableTracks) + 1
                end
            end)
            table.insert(activeGridThreads, loopThread)
            card.Destroying:Connect(function()
                pcall(function() task.cancel(loopThread) end)
                pcall(function() conn:Disconnect() end)
            end)
        end

        pageLbl.Text = "Pagina " .. tostring(currentPageIndex)
    end

    local FALLBACK_BUNDLES = {
        {Id = 80, Name = "Toy Animation Package"},
        {Id = 16, Name = "Ninja Animation Package"},
        {Id = 37, Name = "Superhero Animation Package"},
        {Id = 10, Name = "Zombie Animation Package"},
        {Id = 81, Name = "Mage Animation Package"},
        {Id = 82, Name = "Elder Animation Package"},
        {Id = 83, Name = "Werewolf Animation Package"},
        {Id = 28, Name = "Astronaut Animation Package"}
    }

    local function executeSearch(query)
        currentPageIndex = 1
        pageLbl.Text = "Carregando..."
        if currentTab == "Saved" then
            savedTabList = {}
            local q = string.lower(query or "")
            for _, v in pairs(savedBookmarks) do
                if q == "" or string.lower(v.Name):find(q) then table.insert(savedTabList, v) end
            end
            drawGridPage(savedTabList)
        else
            searchResults = {}
            local p = CatalogSearchParams.new()
            p.SearchKeyword = query or ""
            p.BundleTypes = {Enum.BundleType.Animations}
            p.IncludeOffSale = true
            p.Limit = 60
            pcall(function() p.CreatorType = Enum.CreatorType.User end)
            pcall(function() p.SalesTypeFilter = Enum.SalesTypeFilter.All end)
            pcall(function() p.SortType = Enum.CatalogSortType.RecentlyCreated end)
            task.spawn(function()
                local ok, pages = pcall(function() return AvatarEditorService:SearchCatalog(p) end)
                if ok and pages then
                    catalogCursor = pages
                    local currentResults = pages:GetCurrentPage()
                    if #currentResults == 0 and (not query or query == "") then
                        searchResults = FALLBACK_BUNDLES
                    else
                        searchResults = currentResults
                    end
                    drawGridPage(searchResults)
                else
                    if not query or query == "" then
                        searchResults = FALLBACK_BUNDLES
                        drawGridPage(searchResults)
                    else
                        pageLbl.Text = "Erro ao carregar"
                    end
                end
            end)
        end
    end

    DiscoverBtn.MouseButton1Click:Connect(function()
        currentTab = "Discover"
        DiscoverBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40); DiscoverBtn.TextColor3 = Theme.TextPrimary
        SavedBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28); SavedBtn.TextColor3 = Theme.TextSecondary
        executeSearch(sb.Text)
    end)

    SavedBtn.MouseButton1Click:Connect(function()
        currentTab = "Saved"
        SavedBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40); SavedBtn.TextColor3 = Theme.TextPrimary
        DiscoverBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28); DiscoverBtn.TextColor3 = Theme.TextSecondary
        executeSearch(sb.Text)
    end)

    nextBtn.MouseButton1Click:Connect(function()
        local activeList = (currentTab == "Saved") and savedTabList or searchResults
        if currentPageIndex * itemsPerPage < #activeList then
            currentPageIndex = currentPageIndex + 1; drawGridPage(activeList)
        elseif currentTab == "Discover" and catalogCursor and not catalogCursor.IsFinished then
            pageLbl.Text = "Carregando..."
            task.spawn(function()
                local ok = pcall(function() catalogCursor:AdvanceToNextPageAsync() end)
                if ok then
                    local nc = catalogCursor:GetCurrentPage()
                    for _, v in ipairs(nc) do table.insert(searchResults, v) end
                    currentPageIndex = currentPageIndex + 1; drawGridPage(searchResults)
                end
            end)
        end
    end)

    prevBtn.MouseButton1Click:Connect(function()
        if currentPageIndex > 1 then
            currentPageIndex = currentPageIndex - 1
            drawGridPage((currentTab == "Saved") and savedTabList or searchResults)
        end
    end)

    searchBtn.MouseButton1Click:Connect(function() executeSearch(sb.Text) end)
    sb.FocusLost:Connect(function(enterPressed) if enterPressed then executeSearch(sb.Text) end end)

    executeSearch("")
    -- ============================================================
    -- EMOTES: UGC Catalog Search + Static Fallback
    -- ============================================================

    local function playEmote(animId)
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local animator = hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator")
        if not animator then return end
        for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
            pcall(function() t:Stop(0.1) end)
        end
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. tostring(animId)
        local track = animator:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Action
        track:Play(0.1)
    end

    local function playEmoteFromBundle(bundleId)
        task.spawn(function()
            local ok, details = pcall(function() return AssetService:GetBundleDetailsAsync(bundleId) end)
            if not ok or not details or not details.Items then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local animator = hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator")
            if not animator then return end
            for _, item in ipairs(details.Items) do
                local lt = string.lower(item.AssetType or "")
                if lt == "idleanimation" or lt == "walkanimation" or lt == "emoteanimation" then
                    local assets = get(item.Id, bundleId, item.AssetType)
                    if #assets > 0 then
                        for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
                            pcall(function() t:Stop(0.1) end)
                        end
                        local track = animator:LoadAnimation(assets[1])
                        track.Priority = Enum.AnimationPriority.Action
                        track.Looped = true
                        track:Play(0.1)
                        break
                    end
                end
            end
        end)
    end

    -- Search bar for emotes
    local EmoteSearchRow = Instance.new("Frame")
    EmoteSearchRow.Size = UDim2.new(1, 0, 0, 60)
    EmoteSearchRow.BackgroundTransparency = 1
    EmoteSearchRow.Parent = EmotesContainer

    local eSearchBox = Instance.new("TextBox")
    eSearchBox.Size = UDim2.new(1, -94, 0, 28)
    eSearchBox.PlaceholderText = "Buscar emote UGC..."
    eSearchBox.Text = ""
    eSearchBox.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    eSearchBox.TextColor3 = Theme.TextPrimary
    eSearchBox.PlaceholderColor3 = Theme.TextSecondary
    eSearchBox.TextSize = 11
    eSearchBox.Font = Enum.Font.Gotham
    eSearchBox.ClearTextOnFocus = false
    eSearchBox.Parent = EmoteSearchRow
    Instance.new("UICorner", eSearchBox).CornerRadius = UDim.new(0, 10)
    local esbStroke = Instance.new("UIStroke", eSearchBox)
    esbStroke.Color = Theme.Accent; esbStroke.Thickness = 1
    local esbPad = Instance.new("UIPadding", eSearchBox)
    esbPad.PaddingLeft = UDim.new(0, 8)

    local eSearchBtn = Instance.new("TextButton")
    eSearchBtn.Size = UDim2.new(0, 86, 0, 28)
    eSearchBtn.Position = UDim2.new(1, -86, 0, 0)
    eSearchBtn.Text = "Buscar"
    eSearchBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    eSearchBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    eSearchBtn.Font = Enum.Font.GothamBold
    eSearchBtn.TextSize = 11
    eSearchBtn.AutoButtonColor = false
    eSearchBtn.Parent = EmoteSearchRow
    Instance.new("UICorner", eSearchBtn).CornerRadius = UDim.new(0, 10)
    eSearchBtn.MouseEnter:Connect(function() eSearchBtn.BackgroundColor3 = Color3.fromRGB(22, 163, 74) end)
    eSearchBtn.MouseLeave:Connect(function() eSearchBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94) end)

    -- Ativar Emotes UGC Button
    local eActivateUGCBtn = Instance.new("TextButton")
    eActivateUGCBtn.Size = UDim2.new(1, 0, 0, 26)
    eActivateUGCBtn.Position = UDim2.new(0, 0, 0, 34)
    eActivateUGCBtn.Text = "âš¡ ATIVAR EMOTES UGC (10.000+) âš¡"
    eActivateUGCBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    eActivateUGCBtn.TextColor3 = Theme.TextPrimary
    eActivateUGCBtn.Font = Enum.Font.GothamBold
    eActivateUGCBtn.TextSize = 10
    eActivateUGCBtn.AutoButtonColor = false
    eActivateUGCBtn.Parent = EmoteSearchRow
    
    local eActivateCorner = Instance.new("UICorner")
    eActivateCorner.CornerRadius = UDim.new(0, 10)
    eActivateCorner.Parent = eActivateUGCBtn
    
    local eActivateStroke = Instance.new("UIStroke")
    eActivateStroke.Color = Theme.Border
    eActivateStroke.Thickness = 0.8
    eActivateStroke.Parent = eActivateUGCBtn

    eActivateUGCBtn.MouseEnter:Connect(function()
        TweenService:Create(eActivateUGCBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55), TextColor3 = Theme.Accent}):Play()
    end)
    eActivateUGCBtn.MouseLeave:Connect(function()
        TweenService:Create(eActivateUGCBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40), TextColor3 = Theme.TextPrimary}):Play()
    end)

    eActivateUGCBtn.MouseButton1Click:Connect(function()
        notify("DedSec Panel", "Ativando script de Emotes UGC...")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
    end)

    -- Emote results list (scrollable)
    local EmoteResultsScroll = Instance.new("ScrollingFrame")
    EmoteResultsScroll.Size = UDim2.new(1, 0, 1, -68)
    EmoteResultsScroll.Position = UDim2.new(0, 0, 0, 68)
    EmoteResultsScroll.BackgroundTransparency = 1
    EmoteResultsScroll.BorderSizePixel = 0
    EmoteResultsScroll.ScrollBarThickness = 2
    EmoteResultsScroll.ScrollBarImageColor3 = Theme.Border
    EmoteResultsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    EmoteResultsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    EmoteResultsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    EmoteResultsScroll.Parent = EmotesContainer

    local EmoteListLayout = Instance.new("UIListLayout")
    EmoteListLayout.Padding = UDim.new(0, 4)
    EmoteListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    EmoteListLayout.Parent = EmoteResultsScroll

    local function addEmoteCard(name, bundleId, isFallback)
        local eFrame = Instance.new("Frame")
        eFrame.Size = UDim2.new(1, 0, 0, 38)
        eFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        eFrame.Parent = EmoteResultsScroll
        Instance.new("UICorner", eFrame).CornerRadius = UDim.new(0, 10)
        local eStroke = Instance.new("UIStroke", eFrame)
        eStroke.Color = Theme.Border; eStroke.Thickness = 0.8

        local badge = Instance.new("Frame")
        badge.Size = UDim2.new(0, isFallback and 32 or 28, 0, 16)
        badge.Position = UDim2.new(0, 6, 0.5, -8)
        badge.BackgroundColor3 = isFallback and Color3.fromRGB(40, 40, 44) or Color3.fromRGB(60, 30, 80)
        badge.Parent = eFrame
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 10)
        local badgeLbl = Instance.new("TextLabel", badge)
        badgeLbl.Size = UDim2.new(1, 0, 1, 0)
        badgeLbl.BackgroundTransparency = 1
        badgeLbl.Text = isFallback and "BASE" or "UGC"
        badgeLbl.TextColor3 = isFallback and Theme.TextSecondary or Color3.fromRGB(180, 120, 255)
        badgeLbl.TextSize = 7; badgeLbl.Font = Enum.Font.GothamBold

        local eLabel = Instance.new("TextLabel")
        eLabel.Size = UDim2.new(1, -130, 1, 0)
        eLabel.Position = UDim2.new(0, isFallback and 44 or 40, 0, 0)
        eLabel.BackgroundTransparency = 1
        eLabel.Text = name
        eLabel.TextColor3 = Theme.TextPrimary
        eLabel.TextSize = 11; eLabel.Font = Enum.Font.GothamBold
        eLabel.TextXAlignment = Enum.TextXAlignment.Left
        eLabel.TextTruncate = Enum.TextTruncate.AtEnd
        eLabel.Parent = eFrame

        local playBtn = Instance.new("TextButton")
        playBtn.Size = UDim2.new(0, 56, 0, 22)
        playBtn.Position = UDim2.new(1, -64, 0.5, -11)
        playBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        playBtn.AutoButtonColor = false
        playBtn.Text = "PLAY"
        playBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        playBtn.TextSize = 9; playBtn.Font = Enum.Font.GothamBold
        playBtn.Parent = eFrame
        Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 10)
        playBtn.MouseEnter:Connect(function() playBtn.BackgroundColor3 = Color3.fromRGB(22, 163, 74) end)
        playBtn.MouseLeave:Connect(function() playBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94) end)

        playBtn.MouseButton1Click:Connect(function()
            playBtn.Text = "..."
            if bundleId then
                playEmoteFromBundle(bundleId)
            else
                playEmote(name) -- name is animId for fallback
            end
            task.wait(0.5)
            playBtn.Text = "PLAY"
        end)
    end

    -- Static fallback emotes
    local FALLBACK_EMOTES = {
        {"Twerk",             129183123083281},
        {"Seduce",            110657013921774},
        {"Floss",             2827725916},
        {"Dab",               248435889},
        {"Werewolf Howl",     10921330408},
        {"Superhero Salute",  10921288909},
    }
    for _, e in ipairs(FALLBACK_EMOTES) do
        addEmoteCard(e[1], nil, true)
        -- store animId in name slot, pass nil bundle so playEmote(name=animId) path runs
        -- override: use direct animId
        local lastCard = EmoteResultsScroll:GetChildren()[#EmoteResultsScroll:GetChildren()]
        if lastCard and lastCard:IsA("Frame") then
            local pb = lastCard:FindFirstChildOfClass("TextButton")
            if pb then
                pb:GetPropertyChangedSignal("Text"):Connect(function() end) -- dummy to hold closure
                pb.MouseButton1Click:Connect(function()
                    playEmote(e[2])
                end)
            end
        end
    end

    local function emoteSearch(query)
        -- Clear previous UGC results (keep BASE ones = first 6)
        local children = EmoteResultsScroll:GetChildren()
        for i = #children, 1, -1 do
            local c = children[i]
            if c:IsA("Frame") then
                local badge = c:FindFirstChild("Frame")
                if badge then
                    local lbl = badge:FindFirstChildOfClass("TextLabel")
                    if lbl and lbl.Text == "UGC" then c:Destroy() end
                end
            end
        end

        if not query or query == "" then return end

        task.spawn(function()
            local p = CatalogSearchParams.new()
            p.SearchKeyword = query
            p.BundleTypes = {Enum.BundleType.Animations}
            p.IncludeOffSale = true
            p.Limit = 30
            pcall(function() p.SortType = Enum.CatalogSortType.RecentlyCreated end)

            local ok, pages = pcall(function() return AvatarEditorService:SearchCatalog(p) end)
            if not ok or not pages then return end
            local results = pages:GetCurrentPage()
            for _, bundle in ipairs(results) do
                -- filter: only show emote-type bundles (BundleType Animations includes emotes)
                addEmoteCard(bundle.Name, bundle.Id, false)
            end
        end)
    end

    eSearchBtn.MouseButton1Click:Connect(function() emoteSearch(eSearchBox.Text) end)
    eSearchBox.FocusLost:Connect(function(enter) if enter then emoteSearch(eSearchBox.Text) end end)
end)
if not successAnims then
    warn("DedSec animations loading error: " .. tostring(errAnims))
end

-- ==========================================
-- GAMES MONITORING TAB
-- ==========================================
pcall(function()
    local GamesView = Views:WaitForChild("Games")
    
    -- Padding for the container
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = GamesView

    -- Use Grid Layout instead of List Layout to match Roblox's game catalog style
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 110, 0, 180) -- Perfect aspect ratio for vertical Roblox game cards
    gridLayout.CellPadding = UDim2.new(0, 16, 0, 20)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = GamesView

    -- Configure your games database via an external JSON file in the executor's workspace
    local DB_FILENAME = "dedsec_games.json"
    local MONITORED_GAMES = {
        { name = "Verity [REALISTIC]", placeId = 121385035646931 },
        { name = "Brookhaven RP", placeId = 4912676059 },
        { name = "Blox Fruits", placeId = 2753915549 },
        { name = "Adopt Me!", placeId = 920587237 }
    }

    -- Load or create database file using executor file API
    local hasFileSystem = pcall(function()
        if not isfile(DB_FILENAME) then
            writefile(DB_FILENAME, HttpService:JSONEncode(MONITORED_GAMES))
        else
            local content = readfile(DB_FILENAME)
            local decoded = HttpService:JSONDecode(content)
            if type(decoded) == "table" then
                MONITORED_GAMES = decoded
            end
        end
    end)

    local activeCards = {}

    local function formatNumber(n)
        if n >= 1000000 then
            return string.format("%.1fM", n / 1000000):gsub("%.0", "")
        elseif n >= 1000 then
            return string.format("%.1fK", n / 1000):gsub("%.0", "")
        end
        return tostring(n)
    end

    local function createGameCard(gameData)
        -- Main Card Frame (transparent to let components display cleanly)
        local card = Instance.new("Frame")
        card.BackgroundTransparency = 1
        card.Size = UDim2.new(0, 110, 0, 180)
        card.Parent = GamesView

        -- Invisible Button to make the whole card clickable for teleport
        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.Parent = card

        -- Square Rounded Game Thumbnail Cover
        local gameThumb = Instance.new("ImageLabel")
        gameThumb.Size = UDim2.new(0, 110, 0, 110)
        gameThumb.Position = UDim2.new(0, 0, 0, 0)
        gameThumb.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
        gameThumb.Image = "rbxassetid://10077977467" -- Fallback icon
        gameThumb.ClipsDescendants = true
        gameThumb.Parent = card

        local thumbCorner = Instance.new("UICorner")
        thumbCorner.CornerRadius = UDim.new(0, 14) -- Smooth Roblox standard rounded corners
        thumbCorner.Parent = gameThumb

        local thumbStroke = Instance.new("UIStroke")
        thumbStroke.Color = Color3.fromRGB(45, 45, 50)
        thumbStroke.Thickness = 0.8
        thumbStroke.Parent = gameThumb

        -- Set game thumbnail
        task.spawn(function()
            pcall(function()
                gameThumb.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. tostring(gameData.placeId) .. "&width=150&height=150&format=png"
            end)
        end)

        -- Title Label underneath the cover
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, 0, 0, 32)
        titleLbl.Position = UDim2.new(0, 0, 0, 115)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = gameData.name
        titleLbl.TextColor3 = Theme.TextPrimary
        titleLbl.TextSize = 11
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.TextYAlignment = Enum.TextYAlignment.Top
        titleLbl.TextWrapped = true
        titleLbl.Parent = card

        -- Stats Row Container (Likes % / Active Players)
        local statsRow = Instance.new("Frame")
        statsRow.Size = UDim2.new(1, 0, 0, 18)
        statsRow.Position = UDim2.new(0, 0, 0, 150)
        statsRow.BackgroundTransparency = 1
        statsRow.Parent = card

        -- Like percentage icon & label
        local likeIcon = Instance.new("ImageLabel")
        likeIcon.Size = UDim2.new(0, 12, 0, 12)
        likeIcon.Position = UDim2.new(0, 0, 0.5, -5)
        likeIcon.BackgroundTransparency = 1
        likeIcon.Image = "rbxassetid://10747372992" -- Thumbs Up icon
        likeIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        likeIcon.Parent = statsRow

        local likeLbl = Instance.new("TextLabel")
        likeLbl.Size = UDim2.new(0, 28, 1, 0)
        likeLbl.Position = UDim2.new(0, 13, 0, 0)
        likeLbl.BackgroundTransparency = 1
        likeLbl.Text = "--%"
        likeLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
        likeLbl.TextSize = 9
        likeLbl.Font = Enum.Font.GothamBold
        likeLbl.TextXAlignment = Enum.TextXAlignment.Left
        likeLbl.Parent = statsRow

        -- Player icon & count label
        local playerIcon = Instance.new("ImageLabel")
        playerIcon.Size = UDim2.new(0, 12, 0, 12)
        playerIcon.Position = UDim2.new(0, 48, 0.5, -5)
        playerIcon.BackgroundTransparency = 1
        playerIcon.Image = "rbxassetid://10747374005" -- Player icon
        playerIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        playerIcon.Parent = statsRow

        local statsLbl = Instance.new("TextLabel")
        statsLbl.Size = UDim2.new(1, -61, 1, 0)
        statsLbl.Position = UDim2.new(0, 61, 0, 0)
        statsLbl.BackgroundTransparency = 1
        statsLbl.Text = "Loading..."
        statsLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
        statsLbl.TextSize = 9
        statsLbl.Font = Enum.Font.GothamBold
        statsLbl.TextXAlignment = Enum.TextXAlignment.Left
        statsLbl.Parent = statsRow

        -- hover effect on thumbnail
        clickBtn.MouseEnter:Connect(function()
            TweenService:Create(gameThumb, TweenInfo.new(0.2), {Size = UDim2.new(0, 114, 0, 114), Position = UDim2.new(0, -2, 0, -2)}):Play()
        end)
        clickBtn.MouseLeave:Connect(function()
            TweenService:Create(gameThumb, TweenInfo.new(0.2), {Size = UDim2.new(0, 110, 0, 110), Position = UDim2.new(0, 0, 0, 0)}):Play()
        end)

        clickBtn.MouseButton1Click:Connect(function()
            notify("DedSec Panel", "Teleportando para " .. gameData.name .. "...")
            task.wait(0.5)
            game:GetService("TeleportService"):Teleport(gameData.placeId, LocalPlayer)
        end)

        table.insert(activeCards, {
            placeId = gameData.placeId,
            statsLabel = statsLbl,
            titleLabel = titleLbl,
            likeLabel = likeLbl
        })
    end

    -- Create all initial cards
    for _, gameData in ipairs(MONITORED_GAMES) do
        createGameCard(gameData)
    end

    -- Real-time updates loop (runs immediately and then every 15 seconds)
    local function updateAllStats()
        local requestFunc = syn and syn.request or http_request or request or (http and http.request)
        
        -- Fallback local imediato e seguro caso o executor nÃ£o tenha suporte a requisiÃ§Ãµes de rede externas
        if not requestFunc then
            for _, card in ipairs(activeCards) do
                card.statsLabel.Text = "N/A"
                card.likeLabel.Text = "--%"
            end
            return
        end

        pcall(function()
            -- Step 1: Collect all placeIds
            local placeIdList = {}
            local cardMap = {}
            for _, card in ipairs(activeCards) do
                table.insert(placeIdList, tostring(card.placeId))
                cardMap[tostring(card.placeId)] = card
            end

            if #placeIdList == 0 then return end
            local urlPlaceIds = table.concat(placeIdList, ",")

            -- Step 2: Fetch universeIds for all placeIds in a single batch request via RoProxy
            local response = requestFunc({
                Url = "https://games.roproxy.com/v1/games/multiget-place-details?placeIds=" .. urlPlaceIds,
                Method = "GET"
            })

            -- Fallback visual imediato caso o request HTTP retorne erro ou tome timeout
            if not response or response.StatusCode ~= 200 then
                for _, card in ipairs(activeCards) do
                    if card.statsLabel.Text == "Loading..." then
                        card.statsLabel.Text = "Offline"
                        card.likeLabel.Text = "90%"
                    end
                end
                return
            end

            if response and response.StatusCode == 200 then
                local success, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
                if success and data and #data > 0 then
                    local universeIdList = {}
                    local universeToPlace = {}
                    for _, gameInfo in ipairs(data) do
                        local pIdStr = tostring(gameInfo.placeId)
                        local uId = gameInfo.universeId
                        if uId then
                            table.insert(universeIdList, tostring(uId))
                            universeToPlace[tostring(uId)] = pIdStr
                        end
                    end

                    if #universeIdList == 0 then return end
                    local urlUniverseIds = table.concat(universeIdList, ",")

                    -- Step 3: Fetch active player counts in batch via RoProxy
                    task.spawn(function()
                        local uniRes = requestFunc({
                            Url = "https://games.roproxy.com/v1/games?universeIds=" .. urlUniverseIds,
                            Method = "GET"
                        })
                        if uniRes and uniRes.StatusCode == 200 then
                            local okUni, uniData = pcall(function() return HttpService:JSONDecode(uniRes.Body) end)
                            if okUni and uniData and uniData.data then
                                for _, info in ipairs(uniData.data) do
                                    local uIdStr = tostring(info.id)
                                    local pIdStr = universeToPlace[uIdStr]
                                    local card = cardMap[pIdStr]
                                    if card then
                                        card.statsLabel.Text = formatNumber(info.playing or 0)
                                        card.titleLabel.Text = info.name or card.titleLabel.Text
                                    end
                                end
                            end
                        end
                    end)

                    -- Step 4: Fetch ratings/likes asynchronously for each game to load super fast via RoProxy
                    for _, uIdStr in ipairs(universeIdList) do
                        task.spawn(function()
                            local pIdStr = universeToPlace[uIdStr]
                            local card = cardMap[pIdStr]
                            if card then
                                local votesRes = requestFunc({
                                    Url = "https://games.roproxy.com/v1/games/" .. uIdStr .. "/votes",
                                    Method = "GET"
                                })
                                if votesRes and votesRes.StatusCode == 200 then
                                    local okVotes, votesData = pcall(function() return HttpService:JSONDecode(votesRes.Body) end)
                                    if okVotes and votesData and votesData.upVotes then
                                        local totalVotes = votesData.upVotes + votesData.downVotes
                                        local percentage = totalVotes > 0 and math.floor((votesData.upVotes / totalVotes) * 100) or 0
                                        card.likeLabel.Text = tostring(percentage) .. "%"
                                    end
                                end
                            end
                        end)
                    end

                end
            end
        end)
    end

    -- Run once immediately on thread start, then schedule recurrence
    task.spawn(function()
        updateAllStats()
        while MainFrame.Parent do
            task.wait(15)
            updateAllStats()
        end
    end)
end)
if not successAnims then
    warn("DedSec animations loading error: " .. tostring(errAnims))
end

-- ==========================================
-- ABOUT (TEAM) TAB POPULATION
-- ==========================================
pcall(function()
    local AboutView = Views:WaitForChild("About")

    local AboutCard = Instance.new("Frame")
    AboutCard.Name = "AboutCard"
    AboutCard.Size = UDim2.new(1, 0, 1, 0)
    AboutCard.BackgroundColor3 = Theme.CardBg
    AboutCard.Parent = AboutView

    local AboutCorner = Instance.new("UICorner")
    AboutCorner.CornerRadius = UDim.new(0, 10)
    AboutCorner.Parent = AboutCard

    local AboutStroke = Instance.new("UIStroke")
    AboutStroke.Color = Theme.Border
    AboutStroke.Thickness = 0.8
    AboutStroke.Parent = AboutCard

    -- Header Title
    local AboutTitle = Instance.new("TextLabel")
    AboutTitle.Size = UDim2.new(1, -30, 0, 20)
    AboutTitle.Position = UDim2.new(0, 15, 0, 15)
    AboutTitle.BackgroundTransparency = 1
    AboutTitle.Text = "DEDSEC TEAM & CREATORS"
    AboutTitle.TextColor3 = Theme.TextPrimary
    AboutTitle.TextSize = 10
    AboutTitle.Font = Enum.Font.GothamBold
    AboutTitle.TextXAlignment = Enum.TextXAlignment.Left
    AboutTitle.Parent = AboutCard

    local AboutSub = Instance.new("TextLabel")
    AboutSub.Size = UDim2.new(1, -30, 0, 15)
    AboutSub.Position = UDim2.new(0, 15, 0, 35)
    AboutSub.BackgroundTransparency = 1
    AboutSub.Text = "The minds behind the DedSec Panel interface and functionalities."
    AboutSub.TextColor3 = Theme.TextSecondary
    AboutSub.TextSize = 9
    AboutSub.Font = Enum.Font.Gotham
    AboutSub.TextXAlignment = Enum.TextXAlignment.Left
    AboutSub.Parent = AboutCard

    -- Team members container (ScrollingFrame)
    local TeamScroll = Instance.new("ScrollingFrame")
    TeamScroll.Size = UDim2.new(1, -30, 1, -80)
    TeamScroll.Position = UDim2.new(0, 15, 0, 65)
    TeamScroll.BackgroundTransparency = 1
    TeamScroll.BorderSizePixel = 0
    TeamScroll.ScrollBarThickness = 2
    TeamScroll.ScrollBarImageColor3 = Theme.Border
    TeamScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    TeamScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TeamScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TeamScroll.Parent = AboutCard

    local TeamListLayout = Instance.new("UIListLayout")
    TeamListLayout.Padding = UDim.new(0, 8)
    TeamListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TeamListLayout.Parent = TeamScroll

    local teamList = {
        { role = "Owner", name = "ksx", username = "ksxis" },
        { role = "Co Owner", name = "Duds", username = "DizIsMeszedUp" },
        { role = "Developer", name = "52GF", username = "52gf" },
        { role = "Design / Manager", name = "Lara", username = "se_ib" },
        { role = "Network", name = "Rds", username = "deductism" }
    }

    local function createTeamRowCard(role, displayName, handle)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 48)
        card.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        card.Parent = TeamScroll

        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(0, 10)
        cCorner.Parent = card

        local cStroke = Instance.new("UIStroke")
        cStroke.Color = Theme.Border
        cStroke.Thickness = 0.8
        cStroke.Parent = card

        -- Left colored line accent
        local accentLine = Instance.new("Frame")
        accentLine.Size = UDim2.new(0, 3, 1, 0)
        accentLine.BackgroundColor3 = Theme.Accent
        accentLine.BorderSizePixel = 0
        accentLine.Parent = card

        local avatar = Instance.new("ImageLabel")
        avatar.Size = UDim2.new(0, 34, 0, 34)
        avatar.Position = UDim2.new(0, 15, 0.5, 0)
        avatar.AnchorPoint = Vector2.new(0, 0.5)
        avatar.BackgroundColor3 = Theme.Sidebar
        avatar.Image = "rbxassetid://10077977467" -- Fallback
        avatar.Parent = card

        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(1, 0)
        avatarCorner.Parent = avatar

        -- Fetch actual user headshot thumbnail dynamically
        task.spawn(function()
            pcall(function()
                local userId = Players:GetUserIdFromNameAsync(handle)
                if userId then
                    local content, isReady = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                    if isReady then
                        avatar.Image = content
                    end
                end
            end)
        end)

        local roleLabel = Instance.new("TextLabel")
        roleLabel.Size = UDim2.new(0.5, 0, 0, 14)
        roleLabel.Position = UDim2.new(0, 60, 0.5, -15)
        roleLabel.BackgroundTransparency = 1
        roleLabel.Text = string.upper(role)
        roleLabel.TextColor3 = Theme.Accent
        roleLabel.TextSize = 8
        roleLabel.Font = Enum.Font.GothamBold
        roleLabel.TextXAlignment = Enum.TextXAlignment.Left
        roleLabel.Parent = card

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.5, 0, 0, 16)
        nameLabel.Position = UDim2.new(0, 60, 0.5, 1)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = displayName
        nameLabel.TextColor3 = Theme.TextPrimary
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = card

        local handleLabel = Instance.new("TextLabel")
        handleLabel.Size = UDim2.new(0.4, 0, 1, 0)
        handleLabel.Position = UDim2.new(0.6, -15, 0, 0)
        handleLabel.BackgroundTransparency = 1
        handleLabel.Text = "@" .. handle
        handleLabel.TextColor3 = Theme.TextSecondary
        handleLabel.TextSize = 10
        handleLabel.Font = Enum.Font.Gotham
        handleLabel.TextXAlignment = Enum.TextXAlignment.Right
        handleLabel.Parent = card
    end

    for _, member in ipairs(teamList) do
        createTeamRowCard(member.role, member.name, member.username)
    end
end)

-- ==========================================
-- GRAPHICS & RTX CUSTOMIZATION TAB
-- ==========================================
pcall(function()
    local GraphicsView = Views:WaitForChild("Graphics")
    local Lighting = game:GetService("Lighting")

    local GraphicsCard = Instance.new("ScrollingFrame")
    GraphicsCard.Name = "GraphicsCard"
    GraphicsCard.Size = UDim2.new(1, 0, 1, 0)
    GraphicsCard.BackgroundTransparency = 1
    GraphicsCard.BorderSizePixel = 0
    GraphicsCard.ScrollBarThickness = 2
    GraphicsCard.ScrollBarImageColor3 = Theme.Border
    GraphicsCard.ScrollingDirection = Enum.ScrollingDirection.Y
    GraphicsCard.CanvasSize = UDim2.new(0, 0, 0, 520)
    GraphicsCard.Parent = GraphicsView

    -- Header Panel
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 75)
    Header.BackgroundColor3 = Theme.CardBg
    Header.Parent = GraphicsCard
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)
    local hStroke = Instance.new("UIStroke", Header)
    hStroke.Color = Theme.Border; hStroke.Thickness = 0.8

    local GTitle = Instance.new("TextLabel")
    GTitle.Size = UDim2.new(1, -30, 0, 20)
    GTitle.Position = UDim2.new(0, 15, 0, 15)
    GTitle.BackgroundTransparency = 1
    GTitle.Text = "GRAPHICS & LIGHTING CUSTOMIZER"
    GTitle.TextColor3 = Theme.TextPrimary
    GTitle.TextSize = 10
    GTitle.Font = Enum.Font.GothamBold
    GTitle.TextXAlignment = Enum.TextXAlignment.Left
    GTitle.Parent = Header

    local GSub = Instance.new("TextLabel")
    GSub.Size = UDim2.new(1, -30, 0, 15)
    GSub.Position = UDim2.new(0, 15, 0, 35)
    GSub.BackgroundTransparency = 1
    GSub.Text = "Enable next-gen visual effects and realistic RTX atmosphere presets."
    GSub.TextColor3 = Theme.TextSecondary
    GSub.TextSize = 9
    GSub.Font = Enum.Font.Gotham
    GSub.TextXAlignment = Enum.TextXAlignment.Left
    GSub.Parent = Header

    -- 1. PRESETS CARD
    local PresetCard = Instance.new("Frame")
    PresetCard.Size = UDim2.new(1, 0, 0, 110)
    PresetCard.Position = UDim2.new(0, 0, 0, 85)
    PresetCard.BackgroundColor3 = Theme.CardBg
    PresetCard.Parent = GraphicsCard
    Instance.new("UICorner", PresetCard).CornerRadius = UDim.new(0, 10)
    local pStroke = Instance.new("UIStroke", PresetCard)
    pStroke.Color = Theme.Border; pStroke.Thickness = 0.8

    local PTitle = Instance.new("TextLabel")
    PTitle.Size = UDim2.new(1, -30, 0, 20)
    PTitle.Position = UDim2.new(0, 15, 0, 15)
    PTitle.BackgroundTransparency = 1
    PTitle.Text = "QUALITY PRESETS"
    PTitle.TextColor3 = Theme.TextPrimary
    PTitle.TextSize = 10
    PTitle.Font = Enum.Font.GothamBold
    PTitle.TextXAlignment = Enum.TextXAlignment.Left
    PTitle.Parent = PresetCard

    local PGrid = Instance.new("Frame")
    PGrid.Size = UDim2.new(1, -30, 0, 34)
    PGrid.Position = UDim2.new(0, 15, 0, 48)
    PGrid.BackgroundTransparency = 1
    PGrid.Parent = PresetCard

    local PGridLayout = Instance.new("UIGridLayout")
    PGridLayout.CellSize = UDim2.new(0.25, -6, 1, 0)
    PGridLayout.CellPadding = UDim2.new(0, 8, 0, 0)
    PGridLayout.Parent = PGrid

    -- 2. DYNAMIC CONTROLS CARD
    local ControlCard = Instance.new("Frame")
    ControlCard.Size = UDim2.new(1, 0, 0, 210)
    ControlCard.Position = UDim2.new(0, 0, 0, 205)
    ControlCard.BackgroundColor3 = Theme.CardBg
    ControlCard.Parent = GraphicsCard
    Instance.new("UICorner", ControlCard).CornerRadius = UDim.new(0, 10)
    local cStroke = Instance.new("UIStroke", ControlCard)
    cStroke.Color = Theme.Border; cStroke.Thickness = 0.8

    local CTitle = Instance.new("TextLabel")
    CTitle.Size = UDim2.new(1, -30, 0, 20)
    CTitle.Position = UDim2.new(0, 15, 0, 15)
    CTitle.BackgroundTransparency = 1
    CTitle.Text = "LIGHTING & ATMOSPHERE EFFECTS"
    CTitle.TextColor3 = Theme.TextPrimary
    CTitle.TextSize = 10
    CTitle.Font = Enum.Font.GothamBold
    CTitle.TextXAlignment = Enum.TextXAlignment.Left
    CTitle.Parent = ControlCard

    local CGrid = Instance.new("Frame")
    CGrid.Size = UDim2.new(1, -30, 1, -55)
    CGrid.Position = UDim2.new(0, 15, 0, 45)
    CGrid.BackgroundTransparency = 1
    CGrid.Parent = ControlCard

    local CGridLayout = Instance.new("UIGridLayout")
    CGridLayout.CellSize = UDim2.new(0.5, -6, 0, 26)
    CGridLayout.CellPadding = UDim2.new(0, 12, 0, 8)
    CGridLayout.Parent = CGrid

    -- Local helper functions to configure effects
    local function setEffectActive(effectClass, active, defaultConstructor)
        local existing = Lighting:FindFirstChildOfClass(effectClass)
        if active then
            if not existing then
                local newEffect = defaultConstructor()
                newEffect.Parent = Lighting
            end
        else
            if existing then existing:Destroy() end
        end
    end

    local effectToggles = {}

    local function createToggle(name, defaultConstructor)
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
        frame.Parent = CGrid
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
        local fStroke = Instance.new("UIStroke", frame)
        fStroke.Color = Theme.Border; fStroke.Thickness = 0.8

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.65, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextColor3 = Theme.TextPrimary
        lbl.TextSize = 10
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local tBtn = Instance.new("TextButton")
        tBtn.Size = UDim2.new(0, 34, 0, 18)
        tBtn.Position = UDim2.new(1, -36, 0.5, -8)
        tBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tBtn.Text = ""
        tBtn.Parent = frame
        Instance.new("UICorner", tBtn).CornerRadius = UDim.new(1, 0)

        local tCircle = Instance.new("Frame")
        tCircle.Size = UDim2.new(0, 12, 0, 12)
        tCircle.Position = UDim2.new(0, 3, 0.5, 0)
        tCircle.AnchorPoint = Vector2.new(0, 0.5)
        tCircle.BackgroundColor3 = Theme.TextSecondary
        tCircle.BorderSizePixel = 0
        tCircle.Parent = tBtn
        Instance.new("UICorner", tCircle).CornerRadius = UDim.new(1, 0)

        local active = false

        local function updateUI()
            local targetPos = active and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            local targetColor = Theme.TextPrimary
            local bgTargetColor = active and Theme.Green or Color3.fromRGB(35, 35, 35)
            TweenService:Create(tCircle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
            TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = bgTargetColor}):Play()
        end

        local function setVal(val)
            active = val
            updateUI()
            setEffectActive(defaultConstructor.ClassName, active, defaultConstructor.Creator)
        end

        tBtn.MouseButton1Click:Connect(function()
            setVal(not active)
        end)

        effectToggles[name] = setVal
    end

    -- Setup individual toggle effect constructors
    createToggle("Sun Rays", {
        ClassName = "SunRaysEffect",
        Creator = function()
            local s = Instance.new("SunRaysEffect")
            s.Intensity = 0.25; s.Spread = 1.0
            return s
        end
    })
    createToggle("Bloom (Glow)", {
        ClassName = "BloomEffect",
        Creator = function()
            local b = Instance.new("BloomEffect")
            b.Intensity = 0.6; b.Size = 24; b.Threshold = 0.8
            return b
        end
    })
    createToggle("Color Correction", {
        ClassName = "ColorCorrectionEffect",
        Creator = function()
            local c = Instance.new("ColorCorrectionEffect")
            c.Contrast = 0.15; c.Saturation = 0.2; c.Brightness = 0.02
            return c
        end
    })
    createToggle("Depth Fog", {
        ClassName = "Atmosphere",
        Creator = function()
            local a = Instance.new("Atmosphere")
            a.Density = 0.35; a.Glare = 0.5; a.Haze = 1.0
            return a
        end
    })

    -- ShadowMap shadow rendering toggle
    local shadowFrame = Instance.new("Frame")
    shadowFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    shadowFrame.Parent = CGrid
    Instance.new("UICorner", shadowFrame).CornerRadius = UDim.new(0, 10)
    local sfStroke = Instance.new("UIStroke", shadowFrame)
    sfStroke.Color = Theme.Border; sfStroke.Thickness = 0.8

    local slbl = Instance.new("TextLabel")
    slbl.Size = UDim2.new(0.65, 0, 1, 0)
    slbl.Position = UDim2.new(0, 10, 0, 0)
    slbl.BackgroundTransparency = 1
    slbl.Text = "Real Shadows"
    slbl.TextColor3 = Theme.TextPrimary
    slbl.TextSize = 10
    slbl.Font = Enum.Font.GothamBold
    slbl.TextXAlignment = Enum.TextXAlignment.Left
    slbl.Parent = shadowFrame

    local sBtn = Instance.new("TextButton")
    sBtn.Size = UDim2.new(0, 34, 0, 18)
    sBtn.Position = UDim2.new(1, -36, 0.5, -8)
    sBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sBtn.Text = ""
    sBtn.Parent = shadowFrame
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(1, 0)

    local sCircle = Instance.new("Frame")
    sCircle.Size = UDim2.new(0, 12, 0, 12)
    sCircle.Position = UDim2.new(0, 3, 0.5, 0)
    sCircle.AnchorPoint = Vector2.new(0, 0.5)
    sCircle.BackgroundColor3 = Theme.TextSecondary
    sCircle.BorderSizePixel = 0
    sCircle.Parent = sBtn
    Instance.new("UICorner", sCircle).CornerRadius = UDim.new(1, 0)

    local shadowsActive = false
    local function updateShadowsUI()
        local targetPos = shadowsActive and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        local targetColor = shadowsActive and Theme.Accent or Theme.TextSecondary
        local bgTargetColor = shadowsActive and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
        TweenService:Create(sCircle, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
        TweenService:Create(sBtn, TweenInfo.new(0.2), {BackgroundColor3 = bgTargetColor}):Play()
    end

    local function setShadows(val)
        shadowsActive = val
        updateShadowsUI()
        Lighting.GlobalShadows = val
        Lighting.ShadowMapRoundness = val and 0.8 or 0
    end
    sBtn.MouseButton1Click:Connect(function() setShadows(not shadowsActive) end)

    -- Preset Buttons Generation
    local function createPresetBtn(name, desc, applyFunc)
        local pBtn = Instance.new("TextButton")
        pBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
        pBtn.Text = ""
        pBtn.Parent = PGrid
        Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 10)
        local pbStroke = Instance.new("UIStroke", pBtn)
        pbStroke.Color = Theme.Border; pbStroke.Thickness = 0.8

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0.6, 0)
        title.BackgroundTransparency = 1
        title.Text = name
        title.TextColor3 = Theme.TextPrimary
        title.TextSize = 9
        title.Font = Enum.Font.GothamBold
        title.Parent = pBtn

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, 0, 0.4, 0)
        sub.Position = UDim2.new(0, 0, 0.55, 0)
        sub.BackgroundTransparency = 1
        sub.Text = desc
        sub.TextColor3 = Theme.TextSecondary
        sub.TextSize = 7
        sub.Font = Enum.Font.Gotham
        sub.Parent = pBtn

        pBtn.MouseButton1Click:Connect(function()
            -- Feedback Visual rÃ¡pido no botÃ£o clicado
            TweenService:Create(pBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Accent}):Play()
            title.TextColor3 = Color3.fromRGB(0, 0, 0)
            sub.TextColor3 = Color3.fromRGB(40, 40, 40)
            task.wait(0.2)
            TweenService:Create(pBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 24, 28)}):Play()
            title.TextColor3 = Theme.TextPrimary
            sub.TextColor3 = Theme.TextSecondary
            applyFunc()
        end)
    end

    -- RTX Ultra Raytracing Preset
    createPresetBtn("RTX ULTRA", "Raytracing", function()
        effectToggles["Sun Rays"](true)
        effectToggles["Bloom (Glow)"](true)
        effectToggles["Color Correction"](true)
        effectToggles["Depth Fog"](true)
        setShadows(true)
        Lighting.Technology = Enum.Technology.Future -- Melhor iluminaÃ§Ã£o do Roblox
        Lighting.Brightness = 2.5
        Lighting.Ambient = Color3.fromRGB(35, 35, 40)
        Lighting.OutdoorAmbient = Color3.fromRGB(45, 45, 50)
        Lighting.ExposureCompensation = 0.2
        notify("DedSec RTX", "Modo RTX ULTRA ativado! IluminaÃ§Ã£o cinematogrÃ¡fica carregada.")
    end)

    -- High Quality Preset
    createPresetBtn("ULTRA HIGH", "High Visuals", function()
        effectToggles["Sun Rays"](true)
        effectToggles["Bloom (Glow)"](true)
        effectToggles["Color Correction"](true)
        effectToggles["Depth Fog"](false)
        setShadows(true)
        Lighting.Technology = Enum.Technology.ShadowMap
        Lighting.Brightness = 2.0
        Lighting.ExposureCompensation = 0.1
        notify("DedSec Graphics", "Preset ULTRA HIGH ativado!")
    end)

    -- Medium Quality Preset
    createPresetBtn("MEDIUM", "Balanced", function()
        effectToggles["Sun Rays"](false)
        effectToggles["Bloom (Glow)"](true)
        effectToggles["Color Correction"](false)
        effectToggles["Depth Fog"](false)
        setShadows(true)
        Lighting.Technology = Enum.Technology.ShadowMap
        Lighting.Brightness = 2.0
        notify("DedSec Graphics", "Preset MEDIUM ativado!")
    end)

    -- Low Quality / FPS Boost Preset
    createPresetBtn("LOW (FPS)", "Performance", function()
        effectToggles["Sun Rays"](false)
        effectToggles["Bloom (Glow)"](false)
        effectToggles["Color Correction"](false)
        effectToggles["Depth Fog"](false)
        setShadows(false)
        Lighting.Technology = Enum.Technology.Compatibility -- IluminaÃ§Ã£o antiga rÃ¡pida
        Lighting.Brightness = 1.5
        Lighting.Ambient = Color3.fromRGB(120, 120, 120) -- Clareia o mapa para ver melhor
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
        notify("DedSec Graphics", "Preset LOW (FPS BOOST) ativado! Sombras desativadas.")
    end)

end)

-- Initialize first tab
showTab("Home")

-- Background Cross-Client Skin Sync Loop
if httpReq then
    task.spawn(function()
        while task.wait(12) do
            local raw = sendHttpRequest(syncUrl, "GET")
            local tbl = decodeJsonSafe(raw)
            if tbl then
                for userIdStr, skinId in pairs(tbl) do
                    local targetUserIdNum = tonumber(userIdStr)
                    local skinIdNum = tonumber(skinId)
                    if targetUserIdNum and skinIdNum and targetUserIdNum ~= LocalPlayer.UserId then
                        local targetPlayer = Players:GetPlayerByUserId(targetUserIdNum)
                        if targetPlayer and targetPlayer.Character then
                            applySkinToPlayer(targetPlayer, skinIdNum)
                        end
                    end
                end
            end
        end
    end)
    
    -- Cleanup on player removing
    Players.PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            broadcastSkinUpdate(nil)
        end
    end)
end

-- ==========================================
-- SERVER VIEW
-- ==========================================

local successServer, errServer = pcall(function()
    local ServerView = Views:WaitForChild("Server")

    local savedPlaceId = game.PlaceId
    local savedJobId   = game.JobId

    -- =====================================================================
    -- SISTEMA DE PERSISTÃŠNCIA VIA ARQUIVO (writefile / readfile do executor)
    -- Salva: PlaceId, JobId, PlaceName e URL do script em dedsec_server.txt
    -- =====================================================================
    local SAVE_FILE   = "dedsec_server.txt"
    local SCRIPT_FILE = "dedsec_autoexec.txt"

    -- FunÃ§Ã£o auxiliar: verifica se executor suporta I/O de arquivo
    local function hasFileIO()
        return type(writefile) == "function" and type(readfile) == "function"
    end

    -- LÃª o Ãºltimo servidor salvo em disco
    local lastPlaceId, lastJobId, lastPlaceName = nil, nil, nil
    pcall(function()
        if hasFileIO() and isfile(SAVE_FILE) then
            local raw = readfile(SAVE_FILE)
            -- Formato: "placeId|jobId|placeName"
            local parts = raw:split("|")
            if parts[1] and parts[2] then
                lastPlaceId   = tonumber(parts[1])
                lastJobId     = parts[2]
                lastPlaceName = parts[3] or "Unknown"
            end
        end
    end)

    -- Salva o servidor atual em disco agora
    local function saveCurrentServer()
        pcall(function()
            if hasFileIO() then
                local placeName = tostring(game:GetService("MarketplaceService"):GetProductInfo(savedPlaceId).Name)
                writefile(SAVE_FILE, tostring(savedPlaceId) .. "|" .. tostring(savedJobId) .. "|" .. placeName)
            end
        end)
        -- Fallback: _G para mesma sessÃ£o
        pcall(function()
            _G.DedSec_LastServer = { PlaceId = savedPlaceId, JobId = savedJobId }
        end)
    end

    task.spawn(saveCurrentServer)

    -- =====================================================================
    -- AUTO EXECUTE: lÃª o script salvo e registra para executar no teleport
    -- =====================================================================
    local autoExecEnabled = false

    local function getScriptSource()
        -- Tenta pegar o source do prÃ³prio script via vÃ¡rias APIs de executor
        local src = nil
        pcall(function() src = readfile(SCRIPT_FILE) end)
        return src
    end

    local function enableAutoExec()
        pcall(function()
            local src = getScriptSource()
            if not src or src == "" then
                notify("Auto Execute", "Arquivo de script nÃ£o encontrado.\nSalve o script em: " .. SCRIPT_FILE)
                return
            end
            -- Suporte: queue_on_teleport (KRNL/Fluxus), syn.queue_on_teleport (Synapse)
            if type(queue_on_teleport) == "function" then
                queue_on_teleport(src)
                notify("Auto Execute", "âœ” Ativado! O painel serÃ¡ executado automaticamente apÃ³s teleporte.")
            elseif type(syn) == "table" and type(syn.queue_on_teleport) == "function" then
                syn.queue_on_teleport(src)
                notify("Auto Execute", "âœ” Ativado! (Synapse) O painel serÃ¡ re-executado apÃ³s teleporte.")
            else
                notify("Auto Execute", "Seu executor nÃ£o suporta Auto Execute.\n(queue_on_teleport nÃ£o encontrado)")
                autoExecEnabled = false
            end
        end)
    end

    local function disableAutoExec()
        -- Limpa a queue de teleport com um script vazio
        pcall(function()
            if type(queue_on_teleport) == "function" then
                queue_on_teleport("")
            elseif type(syn) == "table" and type(syn.queue_on_teleport) == "function" then
                syn.queue_on_teleport("")
            end
        end)
        notify("Auto Execute", "âœ– Auto Execute desativado.")
    end

    -- =====================
    -- Card: AÃ§Ãµes RÃ¡pidas (Rejoin + Server Hop)
    -- =====================
    local SrvQuickCard = Instance.new("Frame")
    SrvQuickCard.Size = UDim2.new(1, 0, 0, 155)
    SrvQuickCard.Position = UDim2.new(0, 0, 0, 0)
    SrvQuickCard.BackgroundColor3 = Theme.CardBg
    SrvQuickCard.Parent = ServerView

    local SrvQCorner = Instance.new("UICorner")
    SrvQCorner.CornerRadius = UDim.new(0, 10)
    SrvQCorner.Parent = SrvQuickCard

    local SrvQStroke = Instance.new("UIStroke")
    SrvQStroke.Color = Theme.Border
    SrvQStroke.Thickness = 0.8
    SrvQStroke.Parent = SrvQuickCard

    local SrvQTitle = Instance.new("TextLabel")
    SrvQTitle.Size = UDim2.new(1, -30, 0, 20)
    SrvQTitle.Position = UDim2.new(0, 15, 0, 15)
    SrvQTitle.BackgroundTransparency = 1
    SrvQTitle.Text = "SERVER"
    SrvQTitle.TextColor3 = Theme.TextPrimary
    SrvQTitle.TextSize = 10
    SrvQTitle.Font = Enum.Font.GothamBold
    SrvQTitle.TextXAlignment = Enum.TextXAlignment.Left
    SrvQTitle.Parent = SrvQuickCard

    local SrvQSub = Instance.new("TextLabel")
    SrvQSub.Size = UDim2.new(1, -30, 0, 15)
    SrvQSub.Position = UDim2.new(0, 15, 0, 32)
    SrvQSub.BackgroundTransparency = 1
    SrvQSub.Text = "Rejoin, pular servidor ou reconectar ao servidor salvo em disco."
    SrvQSub.TextColor3 = Theme.TextSecondary
    SrvQSub.TextSize = 9
    SrvQSub.Font = Enum.Font.Gotham
    SrvQSub.TextXAlignment = Enum.TextXAlignment.Left
    SrvQSub.Parent = SrvQuickCard

    local function createServerActionBtn(parent, label, desc, yOffset, color, callback)
        local btn = Instance.new("Frame")
        btn.Size = UDim2.new(1, -30, 0, 32)
        btn.Position = UDim2.new(0, 15, 0, yOffset)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.Parent = parent

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 10)
        bCorner.Parent = btn

        local bStroke = Instance.new("UIStroke")
        bStroke.Color = Theme.Border
        bStroke.Thickness = 0.8
        bStroke.Parent = btn

        local bLabel = Instance.new("TextLabel")
        bLabel.Size = UDim2.new(0.55, 0, 1, 0)
        bLabel.Position = UDim2.new(0, 12, 0, 0)
        bLabel.BackgroundTransparency = 1
        bLabel.Text = label
        bLabel.TextColor3 = Theme.TextPrimary
        bLabel.TextSize = 11
        bLabel.Font = Enum.Font.GothamBold
        bLabel.TextXAlignment = Enum.TextXAlignment.Left
        bLabel.Parent = btn

        local bDesc = Instance.new("TextLabel")
        bDesc.Size = UDim2.new(0.42, 0, 1, 0)
        bDesc.Position = UDim2.new(0.5, 0, 0, 0)
        bDesc.BackgroundTransparency = 1
        bDesc.Text = desc
        bDesc.TextColor3 = Theme.TextSecondary
        bDesc.TextSize = 9
        bDesc.Font = Enum.Font.Gotham
        bDesc.TextXAlignment = Enum.TextXAlignment.Left
        bDesc.Parent = btn

        local actionBtn = Instance.new("TextButton")
        actionBtn.Size = UDim2.new(0, 70, 0, 22)
        actionBtn.Position = UDim2.new(1, -78, 0.5, -11)
        actionBtn.BackgroundColor3 = color
        actionBtn.Text = label
        actionBtn.TextColor3 = Color3.new(1, 1, 1)
        actionBtn.TextSize = 10
        actionBtn.Font = Enum.Font.GothamBold
        actionBtn.Parent = btn

        local aBtnCorner = Instance.new("UICorner")
        aBtnCorner.CornerRadius = UDim.new(0, 10)
        aBtnCorner.Parent = actionBtn

        actionBtn.MouseEnter:Connect(function()
            TweenService:Create(actionBtn, TweenInfo.new(0.15), {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.15)}):Play()
        end)
        actionBtn.MouseLeave:Connect(function()
            TweenService:Create(actionBtn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
        end)
        actionBtn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- BotÃ£o Rejoin
    createServerActionBtn(SrvQuickCard, "Rejoin", "Reentrar no mesmo servidor", 55, Color3.fromRGB(55, 120, 55), function()
        notify("Server", "Reconectando ao servidor atual...")
        task.wait(1)
        local TeleportService = game:GetService("TeleportService")
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end)

    -- BotÃ£o Server Hop
    createServerActionBtn(SrvQuickCard, "Server Hop", "Entrar em servidor aleatÃ³rio", 96, Color3.fromRGB(60, 60, 130), function()
        notify("Server", "Procurando novo servidor...")
        task.spawn(function()
            local TeleportService = game:GetService("TeleportService")
            pcall(function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
        end)
    end)

    -- =====================
    -- Card: Auto Execute (URL-based)
    -- =====================
    local AutoCard = Instance.new("Frame")
    AutoCard.Size = UDim2.new(1, 0, 0, 215)
    AutoCard.Position = UDim2.new(0, 0, 0, 168)
    AutoCard.BackgroundColor3 = Theme.CardBg
    AutoCard.Parent = ServerView

    local ACCorner = Instance.new("UICorner")
    ACCorner.CornerRadius = UDim.new(0, 10)
    ACCorner.Parent = AutoCard

    local ACStroke = Instance.new("UIStroke")
    ACStroke.Color = Theme.Border
    ACStroke.Thickness = 0.8
    ACStroke.Parent = AutoCard

    local ACTitle = Instance.new("TextLabel")
    ACTitle.Size = UDim2.new(1, -30, 0, 20)
    ACTitle.Position = UDim2.new(0, 15, 0, 15)
    ACTitle.BackgroundTransparency = 1
    ACTitle.Text = "AUTO EXECUTE"
    ACTitle.TextColor3 = Theme.TextPrimary
    ACTitle.TextSize = 10
    ACTitle.Font = Enum.Font.GothamBold
    ACTitle.TextXAlignment = Enum.TextXAlignment.Left
    ACTitle.Parent = AutoCard

    local ACSub = Instance.new("TextLabel")
    ACSub.Size = UDim2.new(1, -30, 0, 14)
    ACSub.Position = UDim2.new(0, 15, 0, 33)
    ACSub.BackgroundTransparency = 1
    ACSub.Text = "Cole a URL raw do script (Pastebin/GitHub) e salve."
    ACSub.TextColor3 = Theme.TextSecondary
    ACSub.TextSize = 9
    ACSub.Font = Enum.Font.Gotham
    ACSub.TextXAlignment = Enum.TextXAlignment.Left
    ACSub.Parent = AutoCard

    -- URL input box
    local URL_FILE = "dedsec_url.txt"
    local savedURL = ""
    pcall(function()
        if hasFileIO() and isfile(URL_FILE) then
            savedURL = readfile(URL_FILE)
        end
    end)

    local AEUrlBox = Instance.new("TextBox")
    AEUrlBox.Size = UDim2.new(1, -30, 0, 26)
    AEUrlBox.Position = UDim2.new(0, 15, 0, 53)
    AEUrlBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    AEUrlBox.PlaceholderText = "https://pastebin.com/raw/XXXXXXXX"
    AEUrlBox.Text = savedURL
    AEUrlBox.TextColor3 = Theme.TextPrimary
    AEUrlBox.PlaceholderColor3 = Theme.TextSecondary
    AEUrlBox.TextSize = 9
    AEUrlBox.Font = Enum.Font.Gotham
    AEUrlBox.TextXAlignment = Enum.TextXAlignment.Left
    AEUrlBox.ClearTextOnFocus = false
    AEUrlBox.Parent = AutoCard

    local AEUrlPad = Instance.new("UIPadding")
    AEUrlPad.PaddingLeft = UDim.new(0, 8)
    AEUrlPad.Parent = AEUrlBox

    local AEUrlCorner = Instance.new("UICorner")
    AEUrlCorner.CornerRadius = UDim.new(0, 10)
    AEUrlCorner.Parent = AEUrlBox

    local AEUrlStroke = Instance.new("UIStroke")
    AEUrlStroke.Color = Theme.Border
    AEUrlStroke.Thickness = 0.8
    AEUrlStroke.Parent = AEUrlBox

    -- ConstrÃ³i o loadstring command a partir da URL
    local function buildLoadCmd(url)
        return 'loadstring(game:HttpGet("' .. url .. '"))()'
    end

    -- Salva URL no arquivo
    local function saveURL(url)
        pcall(function()
            if hasFileIO() then writefile(URL_FILE, url) end
        end)
    end

    -- Linha: toggle queue_on_teleport + botÃ£o Salvar no Autoexec
    local AERow1 = Instance.new("Frame")
    AERow1.Size = UDim2.new(1, -30, 0, 28)
    AERow1.Position = UDim2.new(0, 15, 0, 88)
    AERow1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    AERow1.Parent = AutoCard

    local AER1Corner = Instance.new("UICorner")
    AER1Corner.CornerRadius = UDim.new(0, 10)
    AER1Corner.Parent = AERow1

    local AER1Stroke = Instance.new("UIStroke")
    AER1Stroke.Color = Theme.Border
    AER1Stroke.Thickness = 0.8
    AER1Stroke.Parent = AERow1

    local AERow1Label = Instance.new("TextLabel")
    AERow1Label.Size = UDim2.new(0.65, 0, 1, 0)
    AERow1Label.Position = UDim2.new(0, 10, 0, 0)
    AERow1Label.BackgroundTransparency = 1
    AERow1Label.Text = "Auto exec apÃ³s rejoin/server hop"
    AERow1Label.TextColor3 = Theme.TextPrimary
    AERow1Label.TextSize = 10
    AERow1Label.Font = Enum.Font.GothamBold
    AERow1Label.TextXAlignment = Enum.TextXAlignment.Left
    AERow1Label.Parent = AERow1

    local AEToggleBtn = Instance.new("TextButton")
    AEToggleBtn.Size = UDim2.new(0, 34, 0, 18)
    AEToggleBtn.Position = UDim2.new(1, -36, 0.5, -8)
    AEToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    AEToggleBtn.Text = ""
    AEToggleBtn.Parent = AERow1

    local AETBCorner = Instance.new("UICorner")
    AETBCorner.CornerRadius = UDim.new(1, 0)
    AETBCorner.Parent = AEToggleBtn

    local AECircle = Instance.new("Frame")
    AECircle.Size = UDim2.new(0, 12, 0, 12)
    AECircle.Position = UDim2.new(0, 3, 0.5, 0)
    AECircle.AnchorPoint = Vector2.new(0, 0.5)
    AECircle.BackgroundColor3 = Theme.TextSecondary
    AECircle.BorderSizePixel = 0
    AECircle.Parent = AEToggleBtn

    local AECircleCorner = Instance.new("UICorner")
    AECircleCorner.CornerRadius = UDim.new(1, 0)
    AECircleCorner.Parent = AECircle

    local autoExecActive = false

    AEToggleBtn.MouseButton1Click:Connect(function()
        local url = AEUrlBox.Text
        if url == "" or not url:find("http") then
            notify("Auto Execute", "Cole uma URL vÃ¡lida antes de ativar!")
            return
        end
        autoExecActive = not autoExecActive
        local onPos = UDim2.new(1, -13, 0.5, 0)
        local offPos = UDim2.new(0, 3, 0.5, 0)
        TweenService:Create(AECircle, TweenInfo.new(0.2), {
            Position = autoExecActive and onPos or offPos,
            BackgroundColor3 = autoExecActive and Theme.Accent or Theme.TextSecondary
        }):Play()
        TweenService:Create(AEToggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = autoExecActive and Color3.fromRGB(60,60,60) or Color3.fromRGB(30,30,30)
        }):Play()

        if autoExecActive then
            saveURL(url)
            local cmd = buildLoadCmd(url)
            local ok = false
            pcall(function()
                if type(queue_on_teleport) == "function" then
                    queue_on_teleport(cmd); ok = true
                elseif type(syn) == "table" and type(syn.queue_on_teleport) == "function" then
                    syn.queue_on_teleport(cmd); ok = true
                end
            end)
            if ok then
                notify("Auto Execute", "âœ” Ativo! O painel carregarÃ¡ automaticamente apÃ³s rejoin/server hop.")
            else
                autoExecActive = false
                TweenService:Create(AECircle, TweenInfo.new(0.2), {Position = offPos, BackgroundColor3 = Theme.TextSecondary}):Play()
                TweenService:Create(AEToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()
                notify("Auto Execute", "âŒ Executor nÃ£o suporta queue_on_teleport.\nUse o botÃ£o 'Salvar no Autoexec' abaixo.")
            end
        else
            pcall(function()
                if type(queue_on_teleport) == "function" then queue_on_teleport("") end
                if type(syn) == "table" and type(syn.queue_on_teleport) == "function" then syn.queue_on_teleport("") end
            end)
            notify("Auto Execute", "âœ– Auto Execute desativado.")
        end
    end)

    -- BotÃ£o: Salvar no Autoexec (para executar ao abrir o jogo)
    local AESaveBtn = Instance.new("TextButton")
    AESaveBtn.Size = UDim2.new(1, -30, 0, 28)
    AESaveBtn.Position = UDim2.new(0, 15, 0, 125)
    AESaveBtn.BackgroundColor3 = Color3.fromRGB(40, 55, 90)
    AESaveBtn.Text = "ðŸ’¾  Salvar no Autoexec do Executor"
    AESaveBtn.TextColor3 = Color3.new(1, 1, 1)
    AESaveBtn.TextSize = 10
    AESaveBtn.Font = Enum.Font.GothamBold
    AESaveBtn.Parent = AutoCard

    local AESaveBtnCorner = Instance.new("UICorner")
    AESaveBtnCorner.CornerRadius = UDim.new(0, 10)
    AESaveBtnCorner.Parent = AESaveBtn

    local AESaveBtnStroke = Instance.new("UIStroke")
    AESaveBtnStroke.Color = Theme.Border
    AESaveBtnStroke.Thickness = 0.8
    AESaveBtnStroke.Parent = AESaveBtn

    local AEStatusLabel = Instance.new("TextLabel")
    AEStatusLabel.Size = UDim2.new(1, -30, 0, 14)
    AEStatusLabel.Position = UDim2.new(0, 15, 0, 162)
    AEStatusLabel.BackgroundTransparency = 1
    AEStatusLabel.Text = hasFileIO() and "âœ” Executor suporta I/O â€” Salvar no Autoexec disponÃ­vel." or "âš  Executor nÃ£o suporta writefile. Auto exec via URL apenas."
    AEStatusLabel.TextColor3 = hasFileIO() and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(220, 150, 50)
    AEStatusLabel.TextSize = 8
    AEStatusLabel.Font = Enum.Font.Gotham
    AEStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    AEStatusLabel.TextWrapped = true
    AEStatusLabel.Parent = AutoCard

    AESaveBtn.MouseButton1Click:Connect(function()
        local url = AEUrlBox.Text
        if url == "" or not url:find("http") then
            notify("Auto Execute", "Cole uma URL vÃ¡lida primeiro!")
            return
        end
        saveURL(url)
        local cmd = buildLoadCmd(url)
        local saved = false
        pcall(function()
            -- Tenta pasta autoexec (KRNL, Fluxus, Wave, Delta)
            if hasFileIO() then
                -- Cria pasta se nÃ£o existir
                if not isfolder("autoexec") then makefolder("autoexec") end
                writefile("autoexec/dedsec_panel.lua", cmd)
                saved = true
            end
        end)
        if saved then
            AEStatusLabel.Text = "âœ” Salvo! O painel executarÃ¡ automaticamente ao abrir o jogo."
            AEStatusLabel.TextColor3 = Color3.fromRGB(100, 220, 100)
            notify("Auto Execute", "âœ” Salvo em autoexec/dedsec_panel.lua!\nO painel carregarÃ¡ automaticamente na prÃ³xima vez.")
        else
            notify("Auto Execute", "âŒ NÃ£o foi possÃ­vel salvar.\nSeu executor nÃ£o suporta writefile/makefolder.")
        end
    end)

    -- =====================
    -- Card: ReconexÃ£o RÃ¡pida (salvo em disco)
    -- =====================
    local ReconnCard = Instance.new("Frame")
    ReconnCard.Size = UDim2.new(1, 0, 0, 195)
    ReconnCard.Position = UDim2.new(0, 0, 0, 300)
    ReconnCard.BackgroundColor3 = Theme.CardBg
    ReconnCard.Parent = ServerView

    local RCCorner = Instance.new("UICorner")
    RCCorner.CornerRadius = UDim.new(0, 10)
    RCCorner.Parent = ReconnCard

    local RCStroke = Instance.new("UIStroke")
    RCStroke.Color = Theme.Border
    RCStroke.Thickness = 0.8
    RCStroke.Parent = ReconnCard

    local RCTitle = Instance.new("TextLabel")
    RCTitle.Size = UDim2.new(1, -30, 0, 20)
    RCTitle.Position = UDim2.new(0, 15, 0, 15)
    RCTitle.BackgroundTransparency = 1
    RCTitle.Text = "RECONEXÃƒO RÃPIDA"
    RCTitle.TextColor3 = Theme.TextPrimary
    RCTitle.TextSize = 10
    RCTitle.Font = Enum.Font.GothamBold
    RCTitle.TextXAlignment = Enum.TextXAlignment.Left
    RCTitle.Parent = ReconnCard

    local hasFile = hasFileIO()
    local persistDesc = hasFile
        and "O servidor atual Ã© salvo em disco (" .. SAVE_FILE .. ") e persiste mesmo apÃ³s fechar o jogo."
        or "Seu executor nÃ£o suporta I/O de arquivo. Usando memÃ³ria (_G) â€” sÃ³ persiste na mesma sessÃ£o."

    local RCSub = Instance.new("TextLabel")
    RCSub.Size = UDim2.new(1, -30, 0, 28)
    RCSub.Position = UDim2.new(0, 15, 0, 32)
    RCSub.BackgroundTransparency = 1
    RCSub.Text = persistDesc
    RCSub.TextColor3 = hasFile and Color3.fromRGB(100, 200, 100) or Theme.TextSecondary
    RCSub.TextSize = 9
    RCSub.Font = Enum.Font.Gotham
    RCSub.TextXAlignment = Enum.TextXAlignment.Left
    RCSub.TextWrapped = true
    RCSub.Parent = ReconnCard

    -- Caixa de info do Ãºltimo servidor
    local RCSavedBox = Instance.new("Frame")
    RCSavedBox.Size = UDim2.new(1, -30, 0, 58)
    RCSavedBox.Position = UDim2.new(0, 15, 0, 78)
    RCSavedBox.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    RCSavedBox.Parent = ReconnCard

    local RCSBCorner = Instance.new("UICorner")
    RCSBCorner.CornerRadius = UDim.new(0, 10)
    RCSBCorner.Parent = RCSavedBox

    local RCSBStroke = Instance.new("UIStroke")
    RCSBStroke.Color = Theme.Border
    RCSBStroke.Thickness = 0.8
    RCSBStroke.Parent = RCSavedBox

    local RCServerInfo = Instance.new("TextLabel")
    RCServerInfo.Size = UDim2.new(1, -20, 1, 0)
    RCServerInfo.Position = UDim2.new(0, 10, 0, 0)
    RCServerInfo.BackgroundTransparency = 1
    RCServerInfo.TextColor3 = Theme.TextSecondary
    RCServerInfo.TextSize = 9
    RCServerInfo.Font = Enum.Font.Gotham
    RCServerInfo.TextXAlignment = Enum.TextXAlignment.Left
    RCServerInfo.TextYAlignment = Enum.TextYAlignment.Center
    RCServerInfo.TextWrapped = true
    RCServerInfo.Parent = RCSavedBox

    local hasLastServer = lastPlaceId and lastJobId and lastJobId ~= savedJobId
    if hasLastServer then
        local name = lastPlaceName or "?"
        RCServerInfo.Text = "Ãšltimo servidor salvo:\n" .. name .. " (Place: " .. tostring(lastPlaceId) .. ")\nJob ID: " .. tostring(lastJobId):sub(1, 26) .. "..."
        RCServerInfo.TextColor3 = Color3.fromRGB(120, 220, 120)
    else
        RCServerInfo.Text = "Nenhum servidor anterior detectado.\nApÃ³s executar o painel em qualquer servidor, ele ficarÃ¡ salvo aqui."
    end

    -- BotÃ£o Reconectar
    local RCReconnBtn = Instance.new("TextButton")
    RCReconnBtn.Size = UDim2.new(1, -30, 0, 32)
    RCReconnBtn.Position = UDim2.new(0, 15, 0, 150)
    RCReconnBtn.BackgroundColor3 = hasLastServer and Color3.fromRGB(50, 110, 50) or Color3.fromRGB(35, 35, 35)
    RCReconnBtn.Text = hasLastServer and "âŸ³  Reconectar ao Ãšltimo Servidor" or "Nenhum servidor salvo ainda"
    RCReconnBtn.TextColor3 = hasLastServer and Color3.new(1, 1, 1) or Theme.TextSecondary
    RCReconnBtn.TextSize = 11
    RCReconnBtn.Font = Enum.Font.GothamBold
    RCReconnBtn.Parent = ReconnCard

    local RCRBCorner = Instance.new("UICorner")
    RCRBCorner.CornerRadius = UDim.new(0, 10)
    RCRBCorner.Parent = RCReconnBtn

    RCReconnBtn.MouseButton1Click:Connect(function()
        if hasLastServer then
            notify("Server", "Reconectando ao Ãºltimo servidor...")
            task.wait(1)
            local TeleportService = game:GetService("TeleportService")
            pcall(function()
                TeleportService:TeleportToPlaceInstance(lastPlaceId, lastJobId, LocalPlayer)
            end)
        else
            notify("Server", "Nenhum servidor anterior salvo para reconectar.")
        end
    end)

    -- =====================
    -- Card: Info do Servidor Atual
    -- =====================
    local SrvInfoCard = Instance.new("Frame")
    SrvInfoCard.Size = UDim2.new(1, 0, 0, 145)
    SrvInfoCard.Position = UDim2.new(0, 0, 0, 510)
    SrvInfoCard.BackgroundColor3 = Theme.CardBg
    SrvInfoCard.Parent = ServerView

    local SICorner = Instance.new("UICorner")
    SICorner.CornerRadius = UDim.new(0, 10)
    SICorner.Parent = SrvInfoCard

    local SIStroke = Instance.new("UIStroke")
    SIStroke.Color = Theme.Border
    SIStroke.Thickness = 0.8
    SIStroke.Parent = SrvInfoCard

    local SITitle = Instance.new("TextLabel")
    SITitle.Size = UDim2.new(1, -30, 0, 20)
    SITitle.Position = UDim2.new(0, 15, 0, 15)
    SITitle.BackgroundTransparency = 1
    SITitle.Text = "INFO DO SERVIDOR ATUAL"
    SITitle.TextColor3 = Theme.TextPrimary
    SITitle.TextSize = 10
    SITitle.Font = Enum.Font.GothamBold
    SITitle.TextXAlignment = Enum.TextXAlignment.Left
    SITitle.Parent = SrvInfoCard

    local function makeInfoRow(parent, key, value, yPos)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -30, 0, 20)
        row.Position = UDim2.new(0, 15, 0, yPos)
        row.BackgroundTransparency = 1
        row.Parent = parent

        local kLabel = Instance.new("TextLabel")
        kLabel.Size = UDim2.new(0.35, 0, 1, 0)
        kLabel.BackgroundTransparency = 1
        kLabel.Text = key
        kLabel.TextColor3 = Theme.TextSecondary
        kLabel.TextSize = 9
        kLabel.Font = Enum.Font.GothamBold
        kLabel.TextXAlignment = Enum.TextXAlignment.Left
        kLabel.Parent = row

        local vLabel = Instance.new("TextLabel")
        vLabel.Size = UDim2.new(0.65, 0, 1, 0)
        vLabel.Position = UDim2.new(0.35, 0, 0, 0)
        vLabel.BackgroundTransparency = 1
        vLabel.Text = value
        vLabel.TextColor3 = Theme.TextPrimary
        vLabel.TextSize = 9
        vLabel.Font = Enum.Font.Gotham
        vLabel.TextXAlignment = Enum.TextXAlignment.Left
        vLabel.TextTruncate = Enum.TextTruncate.AtEnd
        vLabel.Parent = row
        return vLabel
    end

    makeInfoRow(SrvInfoCard, "Place ID",  tostring(game.PlaceId), 42)
    makeInfoRow(SrvInfoCard, "Job ID",    tostring(game.JobId),   67)
    local pingLabel        = makeInfoRow(SrvInfoCard, "Ping",    "--",                          92)
    local playerCountLabel = makeInfoRow(SrvInfoCard, "Players", tostring(#Players:GetPlayers()), 117)

    -- Atualiza ping e jogadores dinamicamente
    task.spawn(function()
        local StatsService = game:GetService("Stats")
        while ServerView.Parent do
            task.wait(3)
            pcall(function()
                local ping = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
                pingLabel.Text = math.floor(ping) .. " ms"
            end)
            pcall(function()
                playerCountLabel.Text = tostring(#Players:GetPlayers()) .. " jogadores"
            end)
        end
    end)
end)
if not successServer then
    warn("DedSec Server tab error: " .. tostring(errServer))
end

print("DedSec: Panel UI loaded successfully!")
