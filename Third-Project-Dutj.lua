local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI Setup
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AimbotMenu"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 220)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Aimbot Menu - Made by Dutj"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.BorderSizePixel = 0
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16

-- Toggle Buttons & Sensitivity
local function createToggle(name, yPosition, default, callback)
	local button = Instance.new("TextButton", frame)
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Position = UDim2.new(0, 5, 0, yPosition)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 14
	button.Text = name .. ": " .. (default and "ON" or "OFF")
	
	local state = default
	button.MouseButton1Click:Connect(function()
		state = not state
		button.Text = name .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)
	
	return state
end

local function createSlider(name, yPosition, minValue, maxValue, default, callback)
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -10, 0, 20)
	label.Position = UDim2.new(0, 5, 0, yPosition)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.SourceSans
	label.TextSize = 14
	label.Text = name .. ": " .. tostring(default)

	local slider = Instance.new("TextBox", frame)
	slider.Size = UDim2.new(1, -10, 0, 25)
	slider.Position = UDim2.new(0, 5, 0, yPosition + 20)
	slider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	slider.TextColor3 = Color3.new(1, 1, 1)
	slider.Font = Enum.Font.SourceSans
	slider.TextSize = 14
	slider.Text = tostring(default)

	slider.FocusLost:Connect(function()
		local value = tonumber(slider.Text)
		if value then
			value = math.clamp(value, minValue, maxValue)
			label.Text = name .. ": " .. tostring(value)
			callback(value)
		end
	end)
end

-- Settings
local aimbotEnabled = true
local silentAimEnabled = true
local espEnabled = true
local aimSensitivity = 1
local circleRadius = 100

-- Create toggles and sliders
createToggle("Aimbot", 35, true, function(state) aimbotEnabled = state end)
createToggle("Silent Aim", 70, true, function(state) silentAimEnabled = state end)
createToggle("ESP", 105, true, function(state) espEnabled = state end)
createSlider("Circle Size", 140, 30, 300, 100, function(value) circleRadius = value end)

-- ESP Drawing
local function createESP(player)
	local box = Drawing.new("Text")
	box.Text = player.Name
	box.Size = 16
	box.Center = true
	box.Outline = true
	box.Color = Color3.new(1, 1, 1)
	box.Visible = false
	return box
end

local ESPObjects = {}

RunService.RenderStepped:Connect(function()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if not ESPObjects[player] then
				ESPObjects[player] = createESP(player)
			end
			local esp = ESPObjects[player]
			local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
			if onScreen and espEnabled then
				esp.Position = Vector2.new(pos.X, pos.Y)
				esp.Visible = true
			else
				esp.Visible = false
			end
		end
	end
end)

-- Aimbot Targeting
local function getClosestTarget()
	local closest = nil
	local shortest = math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local pos, visible = Camera:WorldToViewportPoint(player.Character.Head.Position)
			local dist = (Vector2.new(pos.X / 2, pos.Y / 2) - UserInputService:Camera.ViewportSize()).Magnitude
			if visible and dist < circleRadius then
				if dist < shortest then
					closest = player
					shortest = dist
				end
			end
		end
	end
	return closest
end

-- Aimbot + Silent Aim
RunService.RenderStepped:Connect(function()
	if aimbotEnabled or silentAimEnabled then
		local target = getClosestTarget()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			if aimbotEnabled then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
			end
			-- Silent Aim logic would go here (server-side dependent)
		end
	end
end)

-- Draw red circle
local redCircle = Drawing.new("Circle")
redCircle.Color = Color3.fromRGB(255, 0, 0)
redCircle.Thickness = 1.5
redCircle.NumSides = 100
redCircle.Radius = circleRadius
redCircle.Transparency = 1

RunService.RenderStepped:Connect(function()
	local viewportSize = Camera.ViewportSize
redCircle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
	redCircle.Radius = circleRadius
	redCircle.Visible = true
end)

-- Menu toggle (desktop + phone)
local visible = true
function toggleMenu()
	visible = not visible
	frame.Visible = visible
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.M then
		toggleMenu()
	end
end)

-- Helper to check if player is valid target
local function IsValidTarget(player)
    if player == LocalPlayer then return false end
    if _G.TeamCheck and player.Team == LocalPlayer.Team then return false end
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Humanoid").Health <= 0 then
        return false
    end
    return true
end

-- Aim at target inside red circle
RunService.RenderStepped:Connect(function()
    circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    circle.Radius = _G.AimRadius

    if _G.AimbotEnabled then
        local target = GetClosestPlayer()
        if target and target.Character then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- Get closest player to red circle center
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = _G.AimRadius
    for _, player in pairs(Players:GetPlayers()) do
        if IsValidTarget(player) then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - circle.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Phone button
local phoneButton = Instance.new("TextButton", screenGui)
phoneButton.Size = UDim2.new(0, 60, 0, 30)
phoneButton.Position = UDim2.new(1, -70, 0, 20)
phoneButton.Text = "Menu"
phoneButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
phoneButton.TextColor3 = Color3.new(1, 1, 1)
phoneButton.Font = Enum.Font.SourceSans
phoneButton.TextSize = 14
phoneButton.Visible = true
phoneButton.MouseButton1Click:Connect(toggleMenu)
