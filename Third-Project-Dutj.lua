-- Dịch vụ Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI chính
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AimbotMenu"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 260)
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

-- Toggle helper
local function createToggle(name, yPos, default, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 14
	btn.Text = name .. ": " .. (default and "ON" or "OFF")

	local state = default
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = name .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)
end

-- Slider helper
local function createSlider(name, yPos, min, max, default, callback)
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -10, 0, 20)
	label.Position = UDim2.new(0, 5, 0, yPos)
	label.Text = name .. ": " .. tostring(default)
	label.TextColor3 = Color3.new(1,1,1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.SourceSans
	label.TextSize = 14

	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(1, -10, 0, 25)
	box.Position = UDim2.new(0, 5, 0, yPos + 20)
	box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.SourceSans
	box.TextSize = 14
	box.Text = tostring(default)

	box.FocusLost:Connect(function()
		local value = tonumber(box.Text)
		if value then
			value = math.clamp(value, min, max)
			label.Text = name .. ": " .. tostring(value)
			callback(value)
		end
	end)
end

-- Cài đặt mặc định
local aimbotEnabled = true
local silentAimEnabled = true
local espEnabled = true
local circleRadius = 120
local wallCheckEnabled = true
local teamCheckEnabled = true

createToggle("Aimbot", 35, aimbotEnabled, function(v) aimbotEnabled = v end)
createToggle("Silent Aim", 70, silentAimEnabled, function(v) silentAimEnabled = v end)
createToggle("ESP", 105, espEnabled, function(v) espEnabled = v end)
createSlider("Circle Size", 140, 30, 300, circleRadius, function(v) circleRadius = v end)
createToggle("Wall Check", 180, wallCheckEnabled, function(v) wallCheckEnabled = v end)
createToggle("Team Check", 215, teamCheckEnabled, function(v) teamCheckEnabled = v end)

-- Box ESP
local function createBoxESP(player)
	local box = Drawing.new("Square")
	box.Thickness = 2
	box.Color = Color3.fromRGB(255, 0, 0)
	box.Transparency = 1
	box.Filled = false
	box.Visible = false
	return box
end

local ESPBoxes = {}

RunService.RenderStepped:Connect(function()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if not ESPBoxes[player] then
				ESPBoxes[player] = createBoxESP(player)
			end

			local espBox = ESPBoxes[player]
			local hrp = player.Character.HumanoidRootPart
			local humanoid = player.Character:FindFirstChild("Humanoid")
			
			if hrp and humanoid and humanoid.Health > 0 and espEnabled then
				local cf = hrp.CFrame
				local size = Vector3.new(2, 3, 1.5) * 1.5 -- Box size (width, height, depth)
				local corners = {
					cf:pointToWorldSpace(Vector3.new(-size.X, size.Y, -size.Z)), -- top left
					cf:pointToWorldSpace(Vector3.new(size.X, size.Y, -size.Z)), -- top right
					cf:pointToWorldSpace(Vector3.new(-size.X, -size.Y, -size.Z)), -- bottom left
					cf:pointToWorldSpace(Vector3.new(size.X, -size.Y, -size.Z)), -- bottom right
				}

				local screenCorners = {}
				local onScreen = true
				for _, corner in pairs(corners) do
					local screenPos, visible = Camera:WorldToViewportPoint(corner)
					if not visible then
						onScreen = false
						break
					end
					table.insert(screenCorners, Vector2.new(screenPos.X, screenPos.Y))
				end

				if onScreen then
					local topLeft = screenCorners[1]
					local bottomRight = screenCorners[4]
					local width = bottomRight.X - topLeft.X
					local height = bottomRight.Y - topLeft.Y
					espBox.Size = Vector2.new(width, height)
					espBox.Position = topLeft
					espBox.Visible = true
				else
					espBox.Visible = false
				end
			else
				espBox.Visible = false
			end
		end
	end
end)

if player.Team ~= LocalPlayer.Team then
    espBox.Color = Color3.fromRGB(255, 0, 0) -- Đối thủ: đỏ
else
    espBox.Color = Color3.fromRGB(0, 255, 0) -- Đồng đội: xanh lá
end

-- Red Circle
local redCircle = Drawing.new("Circle")
redCircle.Color = Color3.fromRGB(255, 0, 0)
redCircle.Thickness = 1.5
redCircle.NumSides = 100
redCircle.Transparency = 1

RunService.RenderStepped:Connect(function()
	local vs = Camera.ViewportSize
	redCircle.Position = Vector2.new(vs.X / 2, vs.Y / 2)
	redCircle.Radius = circleRadius
	redCircle.Visible = true
end)

-- Wall Check
local function isVisible(part)
	if not wallCheckEnabled then return true end
	local origin = Camera.CFrame.Position
	local direction = (part.Position - origin)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	local result = workspace:Raycast(origin, direction, raycastParams)
	return not result
end

-- Get Closest Target
local function getClosestTarget()
	local closest, shortest = nil, circleRadius
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			if teamCheckEnabled and player.Team == LocalPlayer.Team then continue end
			local head = player.Character.Head
			local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local dist = (Vector2.new(headPos.X, headPos.Y) - center).Magnitude
				if dist < shortest and isVisible(head) then
					shortest = dist
					closest = player
				end
			end
		end
	end

	return closest
end

-- Aimbot/Silent Aim
RunService.RenderStepped:Connect(function()
	if aimbotEnabled or silentAimEnabled then
		local target = getClosestTarget()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			if aimbotEnabled then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
			end
			-- Silent Aim hook sẽ cần thêm tùy game
		end
	end
end)

-- Menu toggle
local toggleVisible = true
local toggleMenu = function()
	toggleVisible = not toggleVisible
	frame.Visible = toggleVisible
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.M then
		toggleMenu()
	end
end)

local phoneBtn = Instance.new("TextButton", screenGui)
phoneBtn.Size = UDim2.new(0, 60, 0, 30)
phoneBtn.Position = UDim2.new(1, -70, 0, 20)
phoneBtn.Text = "Menu"
phoneBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
phoneBtn.TextColor3 = Color3.new(1, 1, 1)
phoneBtn.Font = Enum.Font.SourceSans
phoneBtn.TextSize = 14
phoneBtn.MouseButton1Click:Connect(toggleMenu)
