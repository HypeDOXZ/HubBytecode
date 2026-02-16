-- ================= FOLLOW CHECK CONFIG =================
local targetId = 12946759
local profileLink = "https://www.roblox.com/users/12946759/profile"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Function to check follow status
local function isFollowingTarget()
    if player.UserId == targetId then 
        return true 
    end

    local url = "https://friends.roblox.com/v1/users/" .. player.UserId .. "/followings?limit=100&sortOrder=Desc"
    
    local success, response = pcall(function()
        local req = (syn and syn.request) or (http and http.request) or request or http_request
        if req then
            local res = req({Url = url, Method = "GET"})
            return res.Body
        end
        return game:HttpGet(url)
    end)

    if success and response then
        local data = HttpService:JSONDecode(response)
        if data and data.data then
            for _, follow in ipairs(data.data) do
                if tonumber(follow.id) == targetId then
                    return true
                end
            end
        end
    end
    
    return false
end

if not isFollowingTarget() then
    if setclipboard then
        setclipboard(profileLink)
    end
    task.wait(0.5)
    player:Kick("FOLLOW REQUIRED: Follow the creator to use this script. Profile link copied to clipboard. (Privacy must be set to 'Everyone')")
    return 
end

task.spawn(function()
    while task.wait(120) do
        if player.UserId ~= targetId and not isFollowingTarget() then
            player:Kick("UNFOLLOWED DETECTED: Stay followed if you want to use this script.")
        end
    end
end)

-- ================= SLIM MODERN GUI =================
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local remote = RS:WaitForChild("LilBa")

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Name = "VerifiedHub"
gui.Parent = player:WaitForChild("PlayerGui")

-- ================= MINIMAL TOGGLE =================
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(0, 15, 0.5, -22.5)
toggleBtn.Text = "≡"
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,25)
toggleBtn.TextColor3 = Color3.fromRGB(0,220,255)
toggleBtn.BackgroundTransparency = 0.15
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

-- ================= ULTRA SLIM HUB =================
local hub = Instance.new("Frame", gui)
hub.Size = UDim2.new(0, 340, 0, 280)
hub.Position = UDim2.new(0.5, -170, 0.5, -140)
hub.BackgroundColor3 = Color3.fromRGB(18,18,24)
hub.BackgroundTransparency = 0.2
hub.Visible = false
hub.Active = true
hub.Draggable = true
Instance.new("UICorner", hub).CornerRadius = UDim.new(0,12)

local blur = Instance.new("BlurEffect", gui)
blur.Size = 12
blur.Parent = hub

local stroke = Instance.new("UIStroke", hub)
stroke.Color = Color3.fromRGB(0,220,255)
stroke.Thickness = 1.2
stroke.Transparency = 0.4

toggleBtn.MouseButton1Click:Connect(function()
	hub.Visible = not hub.Visible
end)

local closeBtn = Instance.new("TextButton", hub)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 8)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)
closeBtn.BackgroundTransparency = 0.3
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

closeBtn.MouseButton1Click:Connect(function()
	hub.Visible = false
end)

local sidebar = Instance.new("Frame", hub)
sidebar.Size = UDim2.new(0, 85, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(22,22,30)
sidebar.BackgroundTransparency = 0.35
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,12)

local content = Instance.new("Frame", hub)
content.Position = UDim2.new(0, 85, 0, 0)
content.Size = UDim2.new(1, -85, 1, -40)
content.BackgroundTransparency = 1

-- ================= MICRO CREDITS =================
local credits = Instance.new("TextLabel", hub)
credits.Size = UDim2.new(1, 0, 0, 28)
credits.Position = UDim2.new(0, 0, 1, -28)
credits.BackgroundColor3 = Color3.fromRGB(25,25,35)
credits.BackgroundTransparency = 0.4
credits.Text = "made by chemicals"
credits.TextColor3 = Color3.fromRGB(120, 120, 255)
credits.Font = Enum.Font.GothamSemibold
credits.TextScaled = true
Instance.new("UICorner", credits).CornerRadius = UDim.new(0,8)

local pages = {}

local function createPage(name)
	local s = Instance.new("ScrollingFrame", content)
	s.Size = UDim2.new(1, -16, 1, -16)
	s.Position = UDim2.new(0,8,0,8)
	s.CanvasSize = UDim2.new(0,0,0,400)
	s.ScrollBarImageTransparency = 0.8
	s.Visible = false
	s.BackgroundTransparency = 1
	pages[name] = s
	return s
end

local presets = createPage("PRESETS")
local custom = createPage("CUSTOM")
local fade = createPage("FADE")
local control = createPage("CONTROL")

local function showPage(name)
	for _,p in pairs(pages) do p.Visible = false end
	pages[name].Visible = true
end

local function sideBtn(text,y,page)
	local b = Instance.new("TextButton", sidebar)
	b.Size = UDim2.new(1,-12,0,26)
	b.Position = UDim2.new(0,6,0,y)
	b.Text = text
	b.Font = Enum.Font.GothamSemibold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(35,35,45)
	b.BackgroundTransparency = 0.4
	b.TextColor3 = Color3.new(1,1,1)
	b.TextStrokeTransparency = 0.8
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	b.MouseButton1Click:Connect(function()
		showPage(page)
	end)
end

sideBtn("PRESETS", 15, "PRESETS")
sideBtn("CUSTOM", 48, "CUSTOM")
sideBtn("FADE", 81, "FADE")
sideBtn("CONTROL", 114, "CONTROL")
showPage("PRESETS")

local running = false
local mode = nil
local speed = 0.03
local R,G,B = 255,0,0
local fadeColor1R, fadeColor1G, fadeColor1B = 0, 100, 255
local fadeColor2R, fadeColor2G, fadeColor2B = 100, 255, 0

local function button(parent,text,y)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1,-32,0,26)
	b.Position = UDim2.new(0,16,0,y)
	b.Text = text
	b.Font = Enum.Font.GothamSemibold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,55)
	b.BackgroundTransparency = 0.35
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	return b
end

local function slider(parent,y,min,max,value,callback)
	local bar = Instance.new("Frame", parent)
	bar.Size = UDim2.new(1,-32,0,6)
	bar.Position = UDim2.new(0,16,0,y)
	bar.BackgroundColor3 = Color3.fromRGB(60,60,80)
	bar.BackgroundTransparency = 0.5
	Instance.new("UICorner", bar)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(0,220,255)
	fill.BorderSizePixel = 0
	Instance.new("UICorner", fill)

	local dot = Instance.new("Frame", bar)
	dot.Size = UDim2.new(0,10,0,10)
	dot.Position = UDim2.new((value-min)/(max-min), -5, 0.5, -5)
	dot.BackgroundColor3 = Color3.fromRGB(0,220,255)
	dot.BorderSizePixel = 0
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

	local dragging = false

	local function update(x)
		local pct = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		fill.Size = UDim2.new(pct,0,1,0)
		dot.Position = UDim2.new(pct, -5, 0.5, -5)
		callback(min + (max-min)*pct)
	end

	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			update(i.Position.X)
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			update(i.Position.X)
		end
	end)

	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- ================= PRESETS =================
button(presets,"BLACK & WHITE",12).MouseButton1Click:Connect(function()
	mode="BW"
	running=true
end)

button(presets,"RAINBOW",45).MouseButton1Click:Connect(function()
	mode="RB"
	running=true
end)

-- ================= CUSTOM =================
local preview = Instance.new("Frame", custom)
preview.Size = UDim2.new(1,-32,0,28)
preview.Position = UDim2.new(0,16,0,12)
preview.BackgroundColor3 = Color3.fromRGB(R,G,B)
preview.BackgroundTransparency = 0.2
Instance.new("UICorner", preview)

slider(custom,50,0,255,R,function(v) R=v preview.BackgroundColor3=Color3.fromRGB(R,G,B) end)
slider(custom,68,0,255,G,function(v) G=v preview.BackgroundColor3=Color3.fromRGB(R,G,B) end)  -- +18px spacing
slider(custom,86,0,255,B,function(v) B=v preview.BackgroundColor3=Color3.fromRGB(R,G,B) end)  -- +18px spacing

button(custom,"START CUSTOM",120).MouseButton1Click:Connect(function()
	mode="CUSTOM"
	running=true
end)

-- ================= FADE TAB =================
local fadePreview1 = Instance.new("Frame", fade)
fadePreview1.Size = UDim2.new(0.45, -20, 0, 28)
fadePreview1.Position = UDim2.new(0, 16, 0, 12)
fadePreview1.BackgroundColor3 = Color3.fromRGB(fadeColor1R, fadeColor1G, fadeColor1B)
fadePreview1.BackgroundTransparency = 0.2
Instance.new("UICorner", fadePreview1)

local fadePreview2 = Instance.new("Frame", fade)
fadePreview2.Size = UDim2.new(0.45, -20, 0, 28)
fadePreview2.Position = UDim2.new(0.55, -4, 0, 12)
fadePreview2.BackgroundColor3 = Color3.fromRGB(fadeColor2R, fadeColor2G, fadeColor2B)
fadePreview2.BackgroundTransparency = 0.2
Instance.new("UICorner", fadePreview2)

local fadeLabel1 = Instance.new("TextLabel", fade)
fadeLabel1.Size = UDim2.new(0.45, -20, 0, 16)
fadeLabel1.Position = UDim2.new(0, 16, 0, 45)
fadeLabel1.Text = "COLOR 1"
fadeLabel1.BackgroundTransparency = 1
fadeLabel1.Font = Enum.Font.GothamSemibold
fadeLabel1.TextScaled = true
fadeLabel1.TextColor3 = Color3.new(1,1,1)

local fadeLabel2 = Instance.new("TextLabel", fade)
fadeLabel2.Size = UDim2.new(0.45, -20, 0, 16)
fadeLabel2.Position = UDim2.new(0.55, -4, 0, 45)
fadeLabel2.Text = "COLOR 2"
fadeLabel2.BackgroundTransparency = 1
fadeLabel2.Font = Enum.Font.GothamSemibold
fadeLabel2.TextScaled = true
fadeLabel2.TextColor3 = Color3.new(1,1,1)

-- SPACED OUT COLOR 1 SLIDERS
slider(fade,75,0,255,fadeColor1R,function(v) fadeColor1R=v fadePreview1.BackgroundColor3=Color3.fromRGB(fadeColor1R,fadeColor1G,fadeColor1B) end)
slider(fade,93,0,255,fadeColor1G,function(v) fadeColor1G=v fadePreview1.BackgroundColor3=Color3.fromRGB(fadeColor1R,fadeColor1G,fadeColor1B) end)
slider(fade,111,0,255,fadeColor1B,function(v) fadeColor1B=v fadePreview1.BackgroundColor3=Color3.fromRGB(fadeColor1R,fadeColor1G,fadeColor1B) end)

-- SPACED OUT COLOR 2 SLIDERS  
slider(fade,140,0,255,fadeColor2R,function(v) fadeColor2R=v fadePreview2.BackgroundColor3=Color3.fromRGB(fadeColor2R,fadeColor2G,fadeColor2B) end)
slider(fade,158,0,255,fadeColor2G,function(v) fadeColor2G=v fadePreview2.BackgroundColor3=Color3.fromRGB(fadeColor2R,fadeColor2G,fadeColor2B) end)
slider(fade,176,0,255,fadeColor2B,function(v) fadeColor2B=v fadePreview2.BackgroundColor3=Color3.fromRGB(fadeColor2R,fadeColor2G,fadeColor2B) end)

button(fade,"START FADE",210).MouseButton1Click:Connect(function()
	mode="FADE"
	running=true
end)

-- ================= CONTROL =================
slider(control,20,0.01,0.1,speed,function(v) speed=v end)

button(control,"STOP",55).MouseButton1Click:Connect(function()
	running=false
end)

-- ================= MAIN LOOP =================
task.spawn(function()
	while true do
		if running then
			if mode=="BW" then
				for i=0,1,0.08 do remote:FireServer("co",Color3.new(1-i,1-i,1-i)) task.wait(speed) end
				for i=0,1,0.08 do remote:FireServer("co",Color3.new(i,i,i)) task.wait(speed) end
			elseif mode=="RB" then
				for h=0,1,0.03 do remote:FireServer("co",Color3.fromHSV(h,1,1)) task.wait(speed) end
			elseif mode=="CUSTOM" then
				local c = Color3.fromRGB(R,G,B)
				for i=0,1,0.08 do remote:FireServer("co",c:Lerp(Color3.new(0,0,0),i)) task.wait(speed) end
				for i=0,1,0.08 do remote:FireServer("co",Color3.new(0,0,0):Lerp(c,i)) task.wait(speed) end
			elseif mode=="FADE" then
				local c1 = Color3.fromRGB(fadeColor1R, fadeColor1G, fadeColor1B)
				local c2 = Color3.fromRGB(fadeColor2R, fadeColor2G, fadeColor2B)
				for i=0,1,0.08 do remote:FireServer("co", c1:Lerp(c2, i)) task.wait(speed) end
				for i=0,1,0.08 do remote:FireServer("co", c2:Lerp(c1, i)) task.wait(speed) end
			end
		end
		task.wait()
	end
end)
