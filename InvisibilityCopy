
--!strict

-- Configuration
local CONFIG = {
	TOGGLE_KEY = Enum.KeyCode.X,
	DEFAULT_SPEED = 16,
	BOOSTED_SPEED = 48,
	SOUND_ID = "rbxassetid://942127495",
	INVISIBILITY_POSITION = Vector3.new(-25.95, 84, 3537.55),
	NOTIFICATION_DURATION = 3,
	-- UI Colors
	BACKGROUND_COLOR = Color3.fromRGB(25, 25, 25),
	ACCENT_COLOR = Color3.fromRGB(45, 45, 45),
	PRIMARY_COLOR = Color3.fromRGB(0, 170, 255),
	SUCCESS_COLOR = Color3.fromRGB(46, 204, 113),
	DANGER_COLOR = Color3.fromRGB(231, 76, 60),
	WARNING_COLOR = Color3.fromRGB(241, 196, 15),
	TEXT_COLOR = Color3.fromRGB(255, 255, 255),
	SECONDARY_TEXT_COLOR = Color3.fromRGB(189, 195, 199),
}

-- Types
type PlayerState = {
	isInvisible: boolean,
	isSpeedBoosted: boolean,
	originalSpeed: number,
}

-- Services
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables
local player = Players.LocalPlayer
local playerState: PlayerState = {
	isInvisible = false,
	isSpeedBoosted = false,
	originalSpeed = CONFIG.DEFAULT_SPEED,
}

-- GUI Elements
local screenGui: ScreenGui
local mainFrame: Frame
local toggleButton: TextButton
local speedButton: TextButton
local closeButton: TextButton
local signatureLabel: TextLabel
local sound: Sound

-- Utility Functions
local function createNotification(title: string, text: string): ()
	StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Duration = CONFIG.NOTIFICATION_DURATION,
	})
end

local function setCharacterTransparency(character: Model, transparency: number): ()
	for _, descendant in character:GetDescendants() do
		if descendant:IsA("BasePart") or descendant:IsA("Decal") then
			descendant.Transparency = transparency
		end
	end
end

local function getHumanoid(): Humanoid?
	local character = player.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("Humanoid") :: Humanoid?
end

local function getHumanoidRootPart(): BasePart?
	local character = player.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart") :: BasePart?
end

local function playSound(): ()
	if sound then
		sound:Play()
	end
end

-- Core Functions
local function toggleInvisibility(): ()
	if not player.Character then
		warn("Character not found")
		return
	end

	playerState.isInvisible = not playerState.isInvisible
	playSound()

	if playerState.isInvisible then
		local humanoidRootPart = getHumanoidRootPart()
		if not humanoidRootPart then
			warn("HumanoidRootPart not found")
			return
		end

		local savedPosition = humanoidRootPart.CFrame

		-- Move to invisibility position
		player.Character:MoveTo(CONFIG.INVISIBILITY_POSITION)
		task.wait(0.15)

		-- Create invisible seat
		local seat = Instance.new("Seat")
		seat.Name = "invischair"
		seat.Anchored = false
		seat.CanCollide = false
		seat.Transparency = 1
		seat.Position = CONFIG.INVISIBILITY_POSITION
		seat.Parent = workspace

		-- Weld seat to character
		local weld = Instance.new("Weld")
		weld.Part0 = seat
		weld.Part1 = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
		weld.Parent = seat

		task.wait()
		seat.CFrame = savedPosition

		-- Set character transparency
		setCharacterTransparency(player.Character, 0.5)

		-- Update button appearance
		toggleButton.BackgroundColor3 = CONFIG.SUCCESS_COLOR
		toggleButton.Text = "VISIBLE"
		if _G.statusLabel then
			_G.statusLabel.Text = "Invisible Mode Active"
			_G.statusLabel.TextColor3 = CONFIG.SUCCESS_COLOR
		end

		createNotification("Invisibility ON", "You are now invisible")
	else
		-- Remove invisible chair
		local invisChair = workspace:FindFirstChild("invischair")
		if invisChair then
			invisChair:Destroy()
		end

		-- Restore character visibility
		if player.Character then
			setCharacterTransparency(player.Character, 0)
		end

		-- Update button appearance
		toggleButton.BackgroundColor3 = CONFIG.PRIMARY_COLOR
		toggleButton.Text = "INVISIBLE"
		if _G.statusLabel then
			_G.statusLabel.Text = "Visible Mode Active"
			_G.statusLabel.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
		end

		createNotification("Invisibility OFF", "You are now visible")
	end
end

local function toggleSpeedBoost(): ()
	local humanoid = getHumanoid()
	if not humanoid then
		warn("Humanoid not found")
		return
	end

	playerState.isSpeedBoosted = not playerState.isSpeedBoosted
	playSound()

	if playerState.isSpeedBoosted then
		humanoid.WalkSpeed = CONFIG.BOOSTED_SPEED
		speedButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		speedButton.Text = "SPEED ON"
		createNotification("Speed Boost ON", `Speed: {CONFIG.BOOSTED_SPEED}`)
	else
		humanoid.WalkSpeed = playerState.originalSpeed
		speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		speedButton.Text = "SPEED BOOST"
		createNotification("Speed Boost OFF", `Speed: {playerState.originalSpeed}`)
	end
end

local function resetPlayerState(): ()
	playerState.isInvisible = false
	playerState.isSpeedBoosted = false

	-- Reset button appearances
	if toggleButton then
		toggleButton.BackgroundColor3 = CONFIG.PRIMARY_COLOR
		toggleButton.Text = "INVISIBLE"
	end

	if speedButton then
		speedButton.BackgroundColor3 = CONFIG.DANGER_COLOR
		speedButton.Text = "SPEED BOOST"
	end

	-- Reset status
	if _G.statusLabel then
		_G.statusLabel.Text = "Ready"
		_G.statusLabel.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
	end
end

-- GUI Creation
local function createGUI(): ()
	-- Main ScreenGui
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "InvisibilityGUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player:WaitForChild("PlayerGui")

	-- Main Frame
	mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 160, 0, 180)
	mainFrame.Position = UDim2.new(0.5, -80, 0.5, -90)
	mainFrame.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = screenGui

	-- Add corner rounding and shadow effect
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame

	-- Add stroke for better definition
	local stroke = Instance.new("UIStroke")
	stroke.Color = CONFIG.ACCENT_COLOR
	stroke.Thickness = 2
	stroke.Parent = mainFrame

	-- Title Label
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, -20, 0, 25)
	titleLabel.Position = UDim2.new(0, 10, 0, 10)
	titleLabel.Text = "INVISIBILITY TOOL"
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = CONFIG.TEXT_COLOR
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 12
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = mainFrame

	-- Toggle Button
	toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Size = UDim2.new(1, -20, 0, 35)
	toggleButton.Position = UDim2.new(0, 10, 0, 45)
	toggleButton.Text = "INVISIBLE"
	toggleButton.BackgroundColor3 = CONFIG.PRIMARY_COLOR
	toggleButton.TextColor3 = CONFIG.TEXT_COLOR
	toggleButton.Font = Enum.Font.GothamBold
	toggleButton.TextScaled = true
	toggleButton.BorderSizePixel = 0
	toggleButton.Parent = mainFrame

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 8)
	toggleCorner.Parent = toggleButton

	-- Add hover effect for toggle button
	local toggleStroke = Instance.new("UIStroke")
	toggleStroke.Color = Color3.fromRGB(255, 255, 255)
	toggleStroke.Thickness = 0
	toggleStroke.Transparency = 0.8
	toggleStroke.Parent = toggleButton

	-- Speed Button
	speedButton = Instance.new("TextButton")
	speedButton.Name = "SpeedButton"
	speedButton.Size = UDim2.new(1, -20, 0, 35)
	speedButton.Position = UDim2.new(0, 10, 0, 90)
	speedButton.Text = "SPEED BOOST"
	speedButton.BackgroundColor3 = CONFIG.DANGER_COLOR
	speedButton.TextColor3 = CONFIG.TEXT_COLOR
	speedButton.Font = Enum.Font.GothamBold
	speedButton.TextScaled = true
	speedButton.BorderSizePixel = 0
	speedButton.Parent = mainFrame

	local speedCorner = Instance.new("UICorner")
	speedCorner.CornerRadius = UDim.new(0, 8)
	speedCorner.Parent = speedButton

	-- Add hover effect for speed button
	local speedStroke = Instance.new("UIStroke")
	speedStroke.Color = Color3.fromRGB(255, 255, 255)
	speedStroke.Thickness = 0
	speedStroke.Transparency = 0.8
	speedStroke.Parent = speedButton

	-- Close Button
	closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 25, 0, 25)
	closeButton.Position = UDim2.new(1, -30, 0, 5)
	closeButton.Text = "×"
	closeButton.BackgroundColor3 = CONFIG.DANGER_COLOR
	closeButton.TextColor3 = CONFIG.TEXT_COLOR
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 16
	closeButton.BorderSizePixel = 0
	closeButton.Parent = mainFrame

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 6)
	closeCorner.Parent = closeButton

	-- Status Indicator
	local statusFrame = Instance.new("Frame")
	statusFrame.Name = "StatusFrame"
	statusFrame.Size = UDim2.new(1, -20, 0, 20)
	statusFrame.Position = UDim2.new(0, 10, 0, 135)
	statusFrame.BackgroundColor3 = CONFIG.ACCENT_COLOR
	statusFrame.BorderSizePixel = 0
	statusFrame.Parent = mainFrame

	local statusCorner = Instance.new("UICorner")
	statusCorner.CornerRadius = UDim.new(0, 6)
	statusCorner.Parent = statusFrame

	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(1, -10, 1, 0)
	statusLabel.Position = UDim2.new(0, 5, 0, 0)
	statusLabel.Text = "Ready"
	statusLabel.BackgroundTransparency = 1
	statusLabel.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.TextSize = 10
	statusLabel.TextXAlignment = Enum.TextXAlignment.Left
	statusLabel.Parent = statusFrame

	-- Signature Label
	signatureLabel = Instance.new("TextLabel")
	signatureLabel.Name = "SignatureLabel"
	signatureLabel.Size = UDim2.new(1, -20, 0, 15)
	signatureLabel.Position = UDim2.new(0, 10, 1, -20)
	signatureLabel.Text = "By: xXHaNdEROXx TG@MK14CFG"
	signatureLabel.BackgroundTransparency = 1
	signatureLabel.TextColor3 = CONFIG.SECONDARY_TEXT_COLOR
	signatureLabel.Font = Enum.Font.Gotham
	signatureLabel.TextSize = 8
	signatureLabel.TextTransparency = 0.5
	signatureLabel.TextXAlignment = Enum.TextXAlignment.Center
	signatureLabel.Parent = mainFrame

	-- Sound
	sound = Instance.new("Sound")
	sound.Name = "ToggleSound"
	sound.SoundId = CONFIG.SOUND_ID
	sound.Volume = 0.5
	sound.Parent = screenGui

	-- Store status label for updates
	_G.statusLabel = statusLabel
end

-- Event Connections
local function connectEvents(): ()
	-- Button connections
	toggleButton.MouseButton1Click:Connect(toggleInvisibility)
	speedButton.MouseButton1Click:Connect(toggleSpeedBoost)
	closeButton.MouseButton1Click:Connect(function()
		screenGui.Enabled = false
	end)

	-- Keyboard input
	UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
		if gameProcessed then
			return
		end

		if input.KeyCode == CONFIG.TOGGLE_KEY then
			toggleInvisibility()
		end
	end)

	-- Character respawn handling
	player.CharacterAdded:Connect(function(character: Model)
		resetPlayerState()

		local humanoid = character:WaitForChild("Humanoid") :: Humanoid
		playerState.originalSpeed = humanoid.WalkSpeed
		humanoid.WalkSpeed = CONFIG.DEFAULT_SPEED

		-- Clean up any existing invisible chairs
		local invisChair = workspace:FindFirstChild("invischair")
		if invisChair then
			invisChair:Destroy()
		end
	end)

	-- Handle player leaving
	Players.PlayerRemoving:Connect(function(leavingPlayer: Player)
		if leavingPlayer == player then
			local invisChair = workspace:FindFirstChild("invischair")
			if invisChair then
				invisChair:Destroy()
			end
		end
	end)
end

-- Initialize
local function initialize(): ()
	-- Wait for character to load
	if not player.Character then
		player.CharacterAdded:Wait()
	end

	-- Store original speed
	local humanoid = getHumanoid()
	if humanoid then
		playerState.originalSpeed = humanoid.WalkSpeed
	end

	-- Create GUI and connect events
	createGUI()
	connectEvents()

	print("Enhanced Invisibility Script loaded successfully!")
end

-- Start the script
initialize()
