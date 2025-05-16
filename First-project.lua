
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Dutj"
ScreenGui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Name = "main"
main.Parent = ScreenGui
main.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
main.Position = UDim2.new(0.4, 0, 0.3, 0)
main.Size = UDim2.new(0, 220, 0, 350)
main.Active = true
main.Draggable = true

local label = Instance.new("TextLabel")
label.Name = "label"
label.Parent = main
label.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
label.Size = UDim2.new(1, 0, 0, 30)
label.Font = Enum.Font.SourceSansBold
label.Text = "Dutj GUI"
label.TextColor3 = Color3.fromRGB(0, 0, 0)
label.TextScaled = true
label.TextWrapped = true

local madeBy = Instance.new("TextLabel")
madeBy.Name = "madeBy"
madeBy.Parent = main
madeBy.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
madeBy.BackgroundTransparency = 1
madeBy.Position = UDim2.new(0, 0, 0, 310)
madeBy.Size = UDim2.new(1, 0, 0, 30)
madeBy.Font = Enum.Font.SourceSansItalic
madeBy.Text = "Made by Dutj"
madeBy.TextColor3 = Color3.fromRGB(0, 0, 0)
madeBy.TextScaled = true
madeBy.TextWrapped = true

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "toggleBtn"
toggleBtn.Parent = ScreenGui
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.Text = "Toggle Menu"
toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.TextScaled = true

toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Variables
local hitboxEnabled = false
local hitboxSize = 5

local espEnabled = false
local espBoxes = {}

local aimbotEnabled = false
local antiWallEnabled = false
local teamCheckEnabled = false
local aimSensitivity = 0.3

-- UI Elements

-- Hitbox Section
local hitboxLabel = Instance.new("TextLabel")
hitboxLabel.Parent = main
hitboxLabel.BackgroundTransparency = 1
hitboxLabel.Position = UDim2.new(0, 10, 0, 50)
hitboxLabel.Size = UDim2.new(1, -20, 0, 20)
hitboxLabel.Font = Enum.Font.SourceSansBold
hitboxLabel.Text = "Hitbox"
hitboxLabel.TextColor3 = Color3.new(0,0,0)
hitboxLabel.TextScaled = true

local hitboxToggle = Instance.new("TextButton")
hitboxToggle.Parent = main
hitboxToggle.Position = UDim2.new(0, 10, 0, 75)
hitboxToggle.Size = UDim2.new(0, 80, 0, 30)
hitboxToggle.Text = "Toggle Hitbox"
hitboxToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
hitboxToggle.TextColor3 = Color3.new(0,0,0)

local hitboxSizeInput = Instance.new("TextBox")
hitboxSizeInput.Parent = main
hitboxSizeInput.Position = UDim2.new(0, 100, 0, 75)
hitboxSizeInput.Size = UDim2.new(0, 80, 0, 30)
hitboxSizeInput.Text = tostring(hitboxSize)
hitboxSizeInput.ClearTextOnFocus = false

-- ESP Section
local espLabel = Instance.new("TextLabel")
espLabel.Parent = main
espLabel.BackgroundTransparency = 1
espLabel.Position = UDim2.new(0, 10, 0, 115)
espLabel.Size = UDim2.new(1, -20, 0, 20)
espLabel.Font = Enum.Font.SourceSansBold
espLabel.Text = "ESP"
espLabel.TextColor3 = Color3.new(0,0,0)
espLabel.TextScaled = true

local espToggle = Instance.new("TextButton")
espToggle.Parent = main
espToggle.Position = UDim2.new(0, 10, 0, 140)
espToggle.Size = UDim2.new(0, 170, 0, 30)
espToggle.Text = "Toggle ESP"
espToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
espToggle.TextColor3 = Color3.new(0,0,0)

-- Aimbot Section
local aimbotLabel = Instance.new("TextLabel")
aimbotLabel.Parent = main
aimbotLabel.BackgroundTransparency = 1
aimbotLabel.Position = UDim2.new(0, 10, 0, 180)
aimbotLabel.Size = UDim2.new(1, -20, 0, 20)
aimbotLabel.Font = Enum.Font.SourceSansBold
aimbotLabel.Text = "Aimbot"
aimbotLabel.TextColor3 = Color3.new(0,0,0)
aimbotLabel.TextScaled = true

local aimbotToggle = Instance.new("TextButton")
aimbotToggle.Parent = main
aimbotToggle.Position = UDim2.new(0, 10, 0, 205)
aimbotToggle.Size = UDim2.new(0, 80, 0, 30)
aimbotToggle.Text = "Toggle Aimbot"
aimbotToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
aimbotToggle.TextColor3 = Color3.new(0,0,0)

local antiWallToggle = Instance.new("TextButton")
antiWallToggle.Parent = main
antiWallToggle.Position = UDim2.new(0, 100, 0, 205)
antiWallToggle.Size = UDim2.new(0, 80, 0, 30)
antiWallToggle.Text = "Anti Wall"
antiWallToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
antiWallToggle.TextColor3 = Color3.new(0,0,0)

local teamCheckToggle = Instance.new("TextButton")
teamCheckToggle.Parent = main
teamCheckToggle.Position = UDim2.new(0, 10, 0, 245)
teamCheckToggle.Size = UDim2.new(0, 80, 0, 30)
teamCheckToggle.Text = "Team Check"
teamCheckToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
teamCheckToggle.TextColor3 = Color3.new(0,0,0)

local sensitivityLabel = Instance.new("TextLabel")
sensitivityLabel.Parent = main
sensitivityLabel.BackgroundTransparency = 1
sensitivityLabel.Position = UDim2.new(0, 100, 0, 245)
sensitivityLabel.Size = UDim2.new(0, 80, 0, 30)
sensitivityLabel.Font = Enum.Font.SourceSans
sensitivityLabel.Text = "Aim Sens:"
sensitivityLabel.TextColor3 = Color3.new(0,0,0)
sensitivityLabel.TextScaled = true

local sensitivityInput = Instance.new("TextBox")
sensitivityInput.Parent = main
sensitivityInput.Position = UDim2.new(0, 180, 0, 245)
sensitivityInput.Size = UDim2.new(0, 40, 0, 30)
sensitivityInput.Text = tostring(aimSensitivity)
sensitivityInput.ClearTextOnFocus = false

-- ESP Box creation
local function createBox(player)
    local box = Drawing and Drawing.new and Drawing.new("Square")
    if not box then return end
    box.Visible = false
    box.Transparency = 1
    box.Thickness = 1
    box.Color = Color3.new(1, 0, 0)
    box.Filled = false
    espBoxes[player] = box
end

local function removeBox(player)
    if espBoxes[player] then
        espBoxes[player]:Remove()
        espBoxes[player] = nil
    end
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            if not espBoxes[player] then
                createBox(player)
            end
            local rootPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local size = 50 * (1 / rootPos.Z)
                local box = espBoxes[player]
                box.Position = Vector2.new(rootPos.X - size / 2, rootPos.Y - size / 2)
                box.Size = Vector2.new(size, size)
                box.Visible = true
            else
                if espBoxes[player] then
                    espBoxes[player].Visible = false
                end
            end
        else
            removeBox(player)
        end
    end
end

-- HITBOX update
local function updateHitbox()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if hitboxEnabled then
                player.Character.HumanoidRootPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                player.Character.HumanoidRootPart.Transparency = 0.5
                player.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
                player.Character.HumanoidRootPart.Material = Enum.Material.Neon
                player.Character.HumanoidRootPart.CanCollide = false
            else
                player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                player.Character.HumanoidRootPart.Transparency = 0
                player.Character.HumanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
                player.Character.HumanoidRootPart.Material = Enum.Material.Plastic
                player.Character.HumanoidRootPart.CanCollide = true
            end
        end
    end
end

-- AIMBOT FUNCTIONS
local function isTeamMate(player)
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team == LocalPlayer.Team
end

local function getClosestTarget()
    local closestPlayer = nil
    local closestDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
            if teamCheckEnabled and isTeamMate(player) then continue end
            if antiWallEnabled then
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                local rayResult = workspace:Raycast(Camera.CFrame.Position, (player.Character.Head.Position - Camera.CFrame.Position).Unit * 500, rayParams)
                if rayResult and rayResult.Instance and not rayResult.Instance:IsDescendantOf(player.Character) then
                    continue
                end
            end
            local headPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if not onScreen then continue end
            local mousePos = UserInputService:GetMouseLocation()
            local dist = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

local function aimAt(target)
    if not target or not target.Character then return end
    local head = target.Character:FindFirstChild("Head")
    if not head then return end
    local newLook = CFrame.new(Camera.CFrame.Position, head.Position)
    Camera.CFrame = Camera.CFrame:Lerp(newLook, aimSensitivity)
end

-- CALLBACKS
hitboxToggle.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    updateHitbox()
end)

hitboxSizeInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(hitboxSizeInput.Text)
        if val and val >= 1 and val <= 20 then
            hitboxSize = val
            if hitboxEnabled then
                updateHitbox()
            end
        else
            hitboxSizeInput.Text = tostring(hitboxSize)
        end
    end
end)

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if not espEnabled then
        for player,_ in pairs(espBoxes) do
            removeBox(player)
        end
    end
end)

aimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
end)

antiWallToggle.MouseButton1Click:Connect(function()
    antiWallEnabled = not antiWallEnabled
end)

teamCheckToggle.MouseButton1Click:Connect(function()
    teamCheckEnabled = not teamCheckEnabled
end)

sensitivityInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(sensitivityInput.Text)
        if val and val >= 0 and val <= 1 then
            aimSensitivity = val
        else
            sensitivityInput.Text = tostring(aimSensitivity)
        end
    end
end)

-- RUN LOOP
RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    end
    if aimbotEnabled then
        local target = getClosestTarget()
        aimAt(target)
    end
end)

-- CLEANUP
Players.PlayerRemoving:Connect(function(player)
    removeBox(player)
end)



