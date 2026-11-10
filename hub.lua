local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Cam = workspace.CurrentCamera

-- Clean up old GUI
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "ProMaxHub" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProMaxHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- [[ COLOR THEME ]] --
local THEME = {
    Bg = Color3.fromRGB(15, 15, 22),
    Sidebar = Color3.fromRGB(20, 20, 30),
    Card = Color3.fromRGB(28, 28, 42),
    Accent = Color3.fromRGB(255, 45, 85),
    AccentCyan = Color3.fromRGB(0, 240, 255),
    Text = Color3.fromRGB(240, 240, 255),
    TextDark = Color3.fromRGB(140, 140, 170),
    Stroke = Color3.fromRGB(50, 50, 75)
}

-- [[ NOTIFICATION SYSTEM ]] --
local NotificationHolder = Instance.new("Frame", ScreenGui)
NotificationHolder.Size = UDim2.new(0, 220, 1, 0)
NotificationHolder.Position = UDim2.new(1, -230, 0, 10)
NotificationHolder.BackgroundTransparency = 1

local NotifList = Instance.new("UIListLayout", NotificationHolder)
NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifList.Padding = UDim.new(0, 8)

local function SendNotif(title, text)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1, 0, 0, 48)
    n.BackgroundColor3 = THEME.Card
    n.Position = UDim2.new(1.2, 0, 0, 0)
    n.Parent = NotificationHolder
    
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", n)
    stroke.Color = THEME.Accent
    stroke.Thickness = 1.2
    
    local titleLbl = Instance.new("TextLabel", n)
    titleLbl.Size = UDim2.new(1, -16, 0, 18)
    titleLbl.Position = UDim2.new(0, 10, 0, 6)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "💀 " .. string.upper(title or "HUB")
    titleLbl.TextColor3 = THEME.Accent
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local msgLbl = Instance.new("TextLabel", n)
    msgLbl.Size = UDim2.new(1, -16, 0, 20)
    msgLbl.Position = UDim2.new(0, 10, 0, 22)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text = text
    msgLbl.TextColor3 = THEME.Text
    msgLbl.Font = Enum.Font.GothamSemibold
    msgLbl.TextSize = 11
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.delay(2.8, function()
        local tw = TweenService:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1.2, 0, 0, 0)})
        tw:Play()
        tw.Completed:Connect(function() n:Destroy() end)
    end)
end

-- [[ MAIN GUI FRAME ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = THEME.Bg
Main.Active = true
Main.ClipsDescendants = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = THEME.Stroke
MainStroke.Thickness = 1.5

local TopGradient = Instance.new("Frame", Main)
TopGradient.Size = UDim2.new(1, 0, 0, 3)
TopGradient.BackgroundColor3 = THEME.Accent
TopGradient.BorderSizePixel = 0

local UIGradient = Instance.new("UIGradient", TopGradient)
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, THEME.Accent),
    ColorSequenceKeypoint.new(1, THEME.AccentCyan)
})

-- [[ SIDEBAR ]] --
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, -3)
Sidebar.Position = UDim2.new(0, 0, 0, 3)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.BorderSizePixel = 0

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 4)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ USER PROFILE FRAME ]] --
local ProfileFrame = Instance.new("Frame", Sidebar)
ProfileFrame.Size = UDim2.new(1, 0, 0, 52)
ProfileFrame.BackgroundTransparency = 1

local AvatarImg = Instance.new("ImageLabel", ProfileFrame)
AvatarImg.Size = UDim2.new(0, 36, 0, 36)
AvatarImg.Position = UDim2.new(0, 8, 0.5, -18)
AvatarImg.BackgroundColor3 = THEME.Card
AvatarImg.Image = "rbxassetid://0"
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
local AvatarStroke = Instance.new("UIStroke", AvatarImg)
AvatarStroke.Color = THEME.Accent
AvatarStroke.Thickness = 1.5

task.spawn(function()
    local success, imgUrl = pcall(function()
        return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    if success and imgUrl then AvatarImg.Image = imgUrl end
end)

local NameLbl = Instance.new("TextLabel", ProfileFrame)
NameLbl.Size = UDim2.new(1, -50, 0, 18)
NameLbl.Position = UDim2.new(0, 48, 0, 10)
NameLbl.BackgroundTransparency = 1
NameLbl.Text = LP.Name
NameLbl.TextColor3 = THEME.Text
NameLbl.Font = Enum.Font.GothamBold
NameLbl.TextSize = 11
NameLbl.TextXAlignment = Enum.TextXAlignment.Left
NameLbl.TextTruncate = Enum.TextTruncate.AtEnd

local RankLbl = Instance.new("TextLabel", ProfileFrame)
RankLbl.Size = UDim2.new(1, -50, 0, 16)
RankLbl.Position = UDim2.new(0, 48, 0, 26)
RankLbl.BackgroundTransparency = 1
RankLbl.Text = "👑 VIP USER"
RankLbl.TextColor3 = THEME.Accent
RankLbl.Font = Enum.Font.GothamBold
RankLbl.TextSize = 9
RankLbl.TextXAlignment = Enum.TextXAlignment.Left

-- [[ CONTENT FRAME ]] --
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -135, 1, -10)
Content.Position = UDim2.new(0, 132, 0, 8)
Content.BackgroundTransparency = 1

local Tabs = {}
local ActiveTab = nil

local function CreateTab(name)
    local tabBtn = Instance.new("TextButton", Sidebar)
    tabBtn.Size = UDim2.new(1, -12, 0, 30)
    tabBtn.Position = UDim2.new(0, 6, 0, 0)
    tabBtn.BackgroundColor3 = THEME.Sidebar
    tabBtn.Text = name
    tabBtn.TextColor3 = THEME.TextDark
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 11
    tabBtn.AutoButtonColor = false
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local tabScroll = Instance.new("ScrollingFrame", Content)
    tabScroll.Size = UDim2.new(1, 0, 1, 0)
    tabScroll.BackgroundTransparency = 1
    tabScroll.ScrollBarThickness = 2
    tabScroll.ScrollBarImageColor3 = THEME.Accent
    tabScroll.Visible = false
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout", tabScroll)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = THEME.Sidebar
            t.Btn.TextColor3 = THEME.TextDark
            t.Container.Visible = false
        end
        tabBtn.BackgroundColor3 = THEME.Card
        tabBtn.TextColor3 = THEME.Accent
        tabScroll.Visible = true
        ActiveTab = tabScroll
    end)

    local tabObj = {Btn = tabBtn, Container = tabScroll}
    table.insert(Tabs, tabObj)

    if #Tabs == 1 then
        tabBtn.BackgroundColor3 = THEME.Card
        tabBtn.TextColor3 = THEME.Accent
        tabScroll.Visible = true
        ActiveTab = tabScroll
    end

    return tabScroll
end

local function AddSection(parent, name)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = string.upper(name)
    lbl.TextColor3 = THEME.TextDark
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function AddButton(parent, name, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = THEME.Card
    btn.Text = name
    btn.TextColor3 = THEME.Text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = THEME.Stroke
    stroke.Thickness = 1

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = THEME.Accent}):Play()
        task.delay(0.1, function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Card}):Play()
        end)
        callback()
    end)
end

local function AddToggle(parent, name, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.BackgroundColor3 = THEME.Card
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = THEME.Stroke
    stroke.Thickness = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = THEME.Text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBg = Instance.new("Frame", frame)
    toggleBg.Size = UDim2.new(0, 32, 0, 16)
    toggleBg.Position = UDim2.new(1, -40, 0.5, -8)
    toggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", toggleBg)
    circle.Size = UDim2.new(0, 12, 0, 12)
    circle.Position = UDim2.new(0, 2, 0.5, -6)
    circle.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Accent}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -14, 0.5, -6), BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
        else
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Color3.fromRGB(200, 200, 220)}):Play()
        end
        SendNotif(name, toggled and "Enabled (ON)" or "Disabled (OFF)")
        task.spawn(callback, toggled)
    end)
end

local function AddInput(parent, name, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 34)
    frame.BackgroundColor3 = THEME.Card
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = THEME.Stroke
    stroke.Thickness = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = THEME.Text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.25, 0, 0, 22)
    box.Position = UDim2.new(0.72, 0, 0.5, -11)
    box.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    box.Text = tostring(default)
    box.TextColor3 = THEME.AccentCyan
    box.Font = Enum.Font.GothamBold
    box.TextSize = 11
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    
    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color = THEME.Stroke

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then
            SendNotif(name, "Value: " .. num)
            callback(num)
        else
            box.Text = tostring(default)
            callback(default)
            SendNotif("Warning", "Numbers only!")
        end
    end)
end

-- [[ TOGGLE MENU BUTTON ]] --
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 44, 0, 44)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = THEME.Bg
ToggleBtn.Text = "💀"
ToggleBtn.TextColor3 = THEME.Accent
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = THEME.Accent
ToggleStroke.Thickness = 1.5

local function MakeSmartDrag(UIElement, isToggle)
    local dragStart, startPos, dragging
    local hasMoved = false
    UIElement.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = UIElement.Position; hasMoved = false
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if isToggle and not hasMoved then Main.Visible = not Main.Visible end
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(UIElement, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end)
end

MakeSmartDrag(ToggleBtn, true)
MakeSmartDrag(Main, false)

-- [[ TABS & FEATURES ]] --
local TabMove = CreateTab("Movement")
local TabPlayer = CreateTab("Player")
local TabCombat = CreateTab("Combat")
local TabVisual = CreateTab("Visuals")

AddSection(TabMove, "Low Player Server")
AddButton(TabMove, "🌐 Hop Low Server (1-3)", function()
    SendNotif("Server Hop", "Searching server...")
    task.spawn(function()
        local placeId = game.PlaceId
        local foundServer = nil
        local success, result = pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if success and result and result.data then
            for _, s in ipairs(result.data) do
                if s.playing and s.playing >= 1 and s.playing <= 3 and s.id ~= game.JobId then
                    foundServer = s.id
                    break
                end
            end
        end
        if foundServer then
            TeleportService:TeleportToPlaceInstance(placeId, foundServer, LP)
        else
            SendNotif("Notice", "No server found!")
        end
    end)
end)

AddSection(TabMove, "Teleport")
local savedPos = nil
AddButton(TabMove, "📍 Save Current Position", function()
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        savedPos = LP.Character.HumanoidRootPart.CFrame
        SendNotif("Teleport", "Success")
    end
end)
AddButton(TabMove, "🚀 Teleport to Saved Pos", function()
    if savedPos and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = savedPos
    end
end)

local ClickTPConn = nil
AddToggle(TabMove, "Click TP", function(state)
    if ClickTPConn then ClickTPConn:Disconnect() end
    if state then
        ClickTPConn = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp and Mouse.Hit then
                    hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end
        end)
    end
end)

AddSection(TabMove, "Fly / Air")
local FlySpeed = 50
local Flying = false
local flyConnection

AddInput(TabMove, "Fly Speed", 50, function(val) FlySpeed = val end)
AddToggle(TabMove, "Enable Fly", function(state)
    Flying = state
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if Flying and hrp and hum then
        hum.PlatformStand = true
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "StandardFlyVelocity"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        local bg = Instance.new("BodyGyro", hrp)
        bg.Name = "StandardFlyGyro"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = hrp.CFrame
        
        flyConnection = RunService.RenderStepped:Connect(function()
            if not Flying or not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
                if hum then hum.PlatformStand = false end
                if flyConnection then flyConnection:Disconnect() end
                return
            end
            
            bg.CFrame = Cam.CFrame
            local moveDir = Vector3.new(0, 0, 0)
            
            if UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.Up) then
                moveDir = moveDir + Cam.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.Down) then
                moveDir = moveDir - Cam.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) or UIS:IsKeyDown(Enum.KeyCode.Left) then
                moveDir = moveDir - Cam.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) or UIS:IsKeyDown(Enum.KeyCode.Right) then
                moveDir = moveDir + Cam.CFrame.RightVector
            end
            
            bv.Velocity = moveDir * FlySpeed
        end)
    else
        if hrp then
            if hrp:FindFirstChild("StandardFlyVelocity") then hrp.StandardFlyVelocity:Destroy() end
            if hrp:FindFirstChild("StandardFlyGyro") then hrp.StandardFlyGyro:Destroy() end
        end
        if hum then hum.PlatformStand = false end
    end
end)

local AirWalkPart, AirWalkConn
AddToggle(TabMove, "Air Walk", function(state)
    if AirWalkConn then AirWalkConn:Disconnect(); AirWalkConn = nil end
    if AirWalkPart then AirWalkPart:Destroy(); AirWalkPart = nil end
    if state and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LP.Character.HumanoidRootPart
        local lockedY = hrp.Position.Y - 3.5
        AirWalkPart = Instance.new("Part", workspace)
        AirWalkPart.Size = Vector3.new(60, 1, 60)
        AirWalkPart.Transparency = 1
        AirWalkPart.Anchored = true
        AirWalkPart.CanCollide = true
        AirWalkConn = RunService.Stepped:Connect(function()
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                AirWalkPart.Position = Vector3.new(LP.Character.HumanoidRootPart.Position.X, lockedY, LP.Cha
