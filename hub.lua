-- ================= FOLLOW CHECK CONFIG =================
local targetId = 12946759
local profileLink = "https://www.roblox.com/users/12946759/profile"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Function to check if the local player is following the target ID
local function isFollowingTarget()
    local url = "https://friends.roblox.com/v1/users/" .. player.UserId .. "/followings?limit=100&sortOrder=Desc"
    local success, response = pcall(function()
        -- Most executors use game:HttpGet for web requests
        return game:HttpGet(url)
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        if data and data.data then
            for _, follow in ipairs(data.data) do
                if follow.id == targetId then
                    return true
                end
            end
        end
    end
    return false
end

-- Initial Check
if not isFollowingTarget() then
    if setclipboard then
        setclipboard(profileLink)
    end
    player:Kick("Please follow the creator to use this script. Profile link copied to clipboard.")
    return -- Stop execution
end

-- Background Monitor (Checks every 60 seconds)
task.spawn(function()
    while task.wait(60) do
        if not isFollowingTarget() then
            player:Kick("UNFOLLOWED DETECTD AFTER EXECUTING, STAY FOLLOWED IF YOU WANT TO USE THIS SCRIPT")
        end
    end
end)

-- ================= ORIGINAL SCRIPT START =================
-- SERVICES
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local remote = RS:WaitForChild("LilBa")

-- ================= GUI ROOT =================
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ================= TOGGLE BUTTON =================
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 52, 0, 52)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -26)
toggleBtn.Text = "≡"
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BackgroundColor3 = Color3.fromRGB(15,15,20)
toggleBtn.TextColor3 = Color3.fromRGB(0,200,255)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

-- ================= HUB =================
local hub = Instance.new("Frame", gui)
hub.Size = UDim2.new(0, 420, 0, 300)
hub.Position = UDim2.new(0.5, -210, 0.5, -150)
hub.BackgroundColor3 = Color3.fromRGB(18,18,24)
hub.Visible = false
hub.Active = true
hub.Draggable = true
Instance.new("UICorner", hub).CornerRadius = UDim.new(0,18)

-- Static neon stroke
local stroke = Instance.new("UIStroke", hub)
stroke.Color = Color3.fromRGB(0,200,255)
stroke.Thickness = 2
stroke.Transparency = 0.3

toggleBtn.MouseButton1Click:Connect(function()
	hub.Visible = not hub.Visible
end)

-- ================= CLOSE BUTTON =================
local closeBtn = Instance.new("TextButton", hub)
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0, 10)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

closeBtn.MouseButton1Click:Connect(function()
	hub.Visible = false
end)

-- ================= SIDEBAR =================
local sidebar = Instance.new("Frame", hub)
sidebar.Size = UDim2.new(0, 110, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(22,22,30)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,18)

-- ================= CONTENT =================
local content = Instance.new("Frame", hub)
content.Position = UDim2.new(0, 110, 0, 0)
content.Size = UDim2.new(1, -110, 1, 0)
content.BackgroundTransparency = 1

-- ================= PAGES =================
local pages = {}

local function createPage(name)
	local s = Instance.new("ScrollingFrame", content)
	s.Size = UDim2.new(1, -20, 1, -20)
	s.Position = UDim2.new(0,10,0,10)
	s.CanvasSize = UDim2.new(0,0,0,500)
	s.ScrollBarImageTransparency = 0
	s.Visible = false
	s.BackgroundTransparency = 1
	pages[name] = s
	return s
end

local presets = createPage("PRESETS")
local custom = createPage("CUSTOM")
local control = createPage("CONTROL")

local function showPage(name)
	for _,p in pairs(pages) do p.Visible = false end
	pages[name].Visible = true
end

-- ================= SIDEBAR BUTTONS =================
local function sideBtn(text,y,page)
	local b = Instance.new("TextButton", sidebar)
	b.Size = UDim2.new(1,-20,0,36)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(35,35,45)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	b.MouseButton1Click:Connect(function()
		showPage(page)
	end)
end

sideBtn("PRESETS", 20, "PRESETS")
sideBtn("CUSTOM", 70, "CUSTOM")
sideBtn("CONTROL", 120, "CONTROL")
showPage("PRESETS")

-- ================= STATE =================
local running = false
local mode = nil
local speed = 0.03
local R,G,B = 255,0,0

-- ================= HELPERS =================
local function button(parent,text,y)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1,-40,0,36)
	b.Position = UDim2.new(0,20,0,y)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,55)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

-- ================= SLIDER =================
local function slider(parent,y,min,max,value,callback)
	local bar = Instance.new("Frame", parent)
	bar.Size = UDim2.new(1,-40,0,8)
	bar.Position = UDim2.new(0,20,0,y)
	bar.BackgroundColor3 = Color3.fromRGB(60,60,80)
	Instance.new("UICorner", bar)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(0,200,255)
	Instance.new("UICorner", fill)

	local dragging = false

	local function update(x)
		local pct = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		fill.Size = UDim2.new(pct,0,1,0)
		callback(min + (max-min)*pct)
	end

	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
		or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			update(i.Position.X)
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
		or i.UserInputType == Enum.UserInputType.Touch) then
			update(i.Position.X)
		end
	end)

	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
		or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- ================= PRESETS =================
button(presets,"BLACK & WHITE",10).MouseButton1Click:Connect(function()
	mode="BW"
	running=true
end)

button(presets,"RAINBOW",60).MouseButton1Click:Connect(function()
	mode="RB"
	running=true
end)

-- ================= CUSTOM =================
local preview = Instance.new("Frame", custom)
preview.Size = UDim2.new(1,-40,0,40)
preview.Position = UDim2.new(0,20,0,10)
preview.BackgroundColor3 = Color3.fromRGB(R,G,B)
Instance.new("UICorner", preview)

slider(custom,70,0,255,R,function(v)
	R = v
	preview.BackgroundColor3 = Color3.fromRGB(R,G,B)
end)

slider(custom,100,0,255,G,function(v)
	G = v
	preview.BackgroundColor3 = Color3.fromRGB(R,G,B)
end)

slider(custom,130,0,255,B,function(v)
	B = v
	preview.BackgroundColor3 = Color3.fromRGB(R,G,B)
end)

button(custom,"START CUSTOM",180).MouseButton1Click:Connect(function()
	mode="CUSTOM"
	running=true
end)

-- ================= CONTROL =================
slider(control,20,0.01,0.1,speed,function(v)
	speed = v
end)

button(control,"STOP",80).MouseButton1Click:Connect(function()
	running=false
end)

-- ================= LOOP =================
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
			end
		end
		task.wait()
	end
end)
