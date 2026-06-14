local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared.Remotes)
local RoundPrompts = require(Shared.RoundPrompts)

local RoundHud = {}

local started = false
local debugConnection: RBXScriptConnection? = nil
local connection: RBXScriptConnection? = nil
local stopFeedbackConnection: RBXScriptConnection? = nil

local function createLabel(parent: Instance, name: string, textSize: number): TextLabel
	local label = Instance.new("TextLabel")
	label.Name = name
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamMedium
	label.Text = ""
	label.TextColor3 = Color3.fromRGB(245, 247, 250)
	label.TextSize = textSize
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Size = UDim2.fromScale(1, 0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Parent = parent

	return label
end

local function getOrCreateHud(playerGui: PlayerGui): ScreenGui
	local existing = playerGui:FindFirstChild("FreezeTagCircleHud")

	if existing then
		return existing :: ScreenGui
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FreezeTagCircleHud"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = false
	screenGui.Parent = playerGui

	local panel = Instance.new("Frame")
	panel.Name = "PromptPanel"
	panel.AnchorPoint = Vector2.new(0.5, 0)
	panel.BackgroundColor3 = Color3.fromRGB(23, 28, 34)
	panel.BackgroundTransparency = 0.08
	panel.BorderSizePixel = 0
	panel.Position = UDim2.fromScale(0.5, 0.035)
	panel.Size = UDim2.new(0.9, 0, 0, 132)
	panel.AutomaticSize = Enum.AutomaticSize.Y
	panel.Parent = screenGui

	local widthConstraint = Instance.new("UISizeConstraint")
	widthConstraint.MaxSize = Vector2.new(440, 180)
	widthConstraint.MinSize = Vector2.new(260, 108)
	widthConstraint.Parent = panel

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = panel

	local padding = Instance.new("UIPadding")
	padding.PaddingBottom = UDim.new(0, 14)
	padding.PaddingLeft = UDim.new(0, 16)
	padding.PaddingRight = UDim.new(0, 16)
	padding.PaddingTop = UDim.new(0, 14)
	padding.Parent = panel

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Parent = panel

	local title = createLabel(panel, "Title", 24)
	title.Font = Enum.Font.GothamBold
	title.LayoutOrder = 1

	local body = createLabel(panel, "Body", 18)
	body.LayoutOrder = 2

	local detail = createLabel(panel, "Detail", 14)
	detail.LayoutOrder = 3
	detail.TextColor3 = Color3.fromRGB(190, 199, 210)

	local debugStatus = createLabel(panel, "DebugStatus", 12)
	debugStatus.LayoutOrder = 4
	debugStatus.TextColor3 = Color3.fromRGB(142, 154, 170)

	return screenGui
end

local function getRemotes(): (RemoteEvent, RemoteFunction, StringValue, RemoteEvent)
	local remoteFolder = ReplicatedStorage:WaitForChild(Remotes.FolderName, 10)
	assert(remoteFolder ~= nil, "FreezeTagCircle remotes did not load")

	return remoteFolder:WaitForChild(Remotes.RoundStateChanged) :: RemoteEvent,
		remoteFolder:WaitForChild(Remotes.RequestRoundSnapshot) :: RemoteFunction,
		remoteFolder:WaitForChild(Remotes.RoundDebugStatus) :: StringValue,
		remoteFolder:WaitForChild(Remotes.StopFeedback) :: RemoteEvent
end

local function getLocalPlayerCount(): number
	return #Players:GetPlayers()
end

local function setDebugStatus(screenGui: ScreenGui, text: string)
	local panel = screenGui:WaitForChild("PromptPanel")
	local debugStatus = panel:WaitForChild("DebugStatus") :: TextLabel

	debugStatus.Text = `Local players {getLocalPlayerCount()} | {text}`
end

local function renderPrompt(screenGui: ScreenGui, snapshot)
	local player = Players.LocalPlayer
	local prompt = RoundPrompts.getPrompt(snapshot, player.UserId)
	local panel = screenGui:WaitForChild("PromptPanel")
	local title = panel:WaitForChild("Title") :: TextLabel
	local body = panel:WaitForChild("Body") :: TextLabel
	local detail = panel:WaitForChild("Detail") :: TextLabel

	title.Text = prompt.title
	body.Text = prompt.body
	detail.Text = prompt.detail
	setDebugStatus(
		screenGui,
		`Snapshot {snapshot.state} | players {snapshot.activePlayerCount or "?"}/{snapshot.minimumPlayers or "?"}`
	)
end

local function getOrCreateStopOverlay(screenGui: ScreenGui): Frame
	local existing = screenGui:FindFirstChild("StopOverlay")

	if existing then
		return existing :: Frame
	end

	local overlay = Instance.new("Frame")
	overlay.Name = "StopOverlay"
	overlay.BackgroundColor3 = Color3.fromRGB(255, 38, 38)
	overlay.BackgroundTransparency = 1
	overlay.BorderSizePixel = 0
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.Visible = false
	overlay.ZIndex = 20
	overlay.Parent = screenGui

	local stopText = Instance.new("TextLabel")
	stopText.Name = "StopText"
	stopText.AnchorPoint = Vector2.new(0.5, 0.5)
	stopText.BackgroundTransparency = 1
	stopText.Font = Enum.Font.GothamBlack
	stopText.Position = UDim2.fromScale(0.5, 0.42)
	stopText.Size = UDim2.fromScale(0.9, 0.28)
	stopText.Text = "STOP!"
	stopText.TextColor3 = Color3.fromRGB(255, 244, 82)
	stopText.TextScaled = true
	stopText.TextStrokeColor3 = Color3.fromRGB(32, 0, 0)
	stopText.TextStrokeTransparency = 0.05
	stopText.Visible = false
	stopText.ZIndex = 21
	stopText.Parent = overlay

	local instruction = Instance.new("TextLabel")
	instruction.Name = "Instruction"
	instruction.AnchorPoint = Vector2.new(0.5, 0.5)
	instruction.BackgroundTransparency = 1
	instruction.Font = Enum.Font.GothamBold
	instruction.Position = UDim2.fromScale(0.5, 0.61)
	instruction.Size = UDim2.fromScale(0.84, 0.08)
	instruction.Text = "Freeze where you are"
	instruction.TextColor3 = Color3.fromRGB(255, 255, 255)
	instruction.TextScaled = true
	instruction.TextStrokeColor3 = Color3.fromRGB(32, 0, 0)
	instruction.TextStrokeTransparency = 0.25
	instruction.Visible = false
	instruction.ZIndex = 21
	instruction.Parent = overlay

	return overlay
end

local function playStopSound()
	local sound = Instance.new("Sound")
	sound.Name = "FreezeTagCircleStopCue"
	sound.SoundId = "rbxassetid://9118823101"
	sound.Volume = 0.35
	sound.PlaybackSpeed = 0.92
	sound.Parent = SoundService

	sound.Ended:Connect(function()
		sound:Destroy()
	end)

	sound:Play()

	task.delay(2, function()
		if sound.Parent then
			sound:Destroy()
		end
	end)
end

local function playStopFeedback(screenGui: ScreenGui)
	local overlay = getOrCreateStopOverlay(screenGui)
	local stopText = overlay:WaitForChild("StopText") :: TextLabel
	local instruction = overlay:WaitForChild("Instruction") :: TextLabel

	overlay.Visible = true
	stopText.Visible = true
	instruction.Visible = true
	overlay.BackgroundTransparency = 1
	stopText.TextTransparency = 1
	instruction.TextTransparency = 1

	playStopSound()

	TweenService:Create(
		overlay,
		TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ BackgroundTransparency = 0.34 }
	):Play()
	TweenService:Create(
		stopText,
		TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ TextTransparency = 0 }
	):Play()
	TweenService:Create(
		instruction,
		TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ TextTransparency = 0 }
	):Play()

	task.delay(0.9, function()
		if not overlay.Parent then
			return
		end

		TweenService:Create(
			overlay,
			TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ BackgroundTransparency = 1 }
		):Play()
		TweenService:Create(
			stopText,
			TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ TextTransparency = 1 }
		):Play()
		TweenService:Create(
			instruction,
			TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ TextTransparency = 1 }
		):Play()
	end)

	task.delay(1.45, function()
		if overlay.Parent then
			overlay.Visible = false
			stopText.Visible = false
			instruction.Visible = false
		end
	end)
end

function RoundHud.start()
	if started then
		return
	end

	started = true

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui") :: PlayerGui
	local screenGui = getOrCreateHud(playerGui)

	renderPrompt(screenGui, {
		state = "WaitingForPlayers",
		activePlayerCount = getLocalPlayerCount(),
		minimumPlayers = 2,
	})

	local ok, roundStateChanged, requestRoundSnapshot, roundDebugStatus, stopFeedback =
		pcall(getRemotes)

	if not ok then
		renderPrompt(screenGui, {
			state = "Unknown",
		})
		warn(roundStateChanged)
		return
	end

	setDebugStatus(screenGui, roundDebugStatus.Value)
	debugConnection = roundDebugStatus:GetPropertyChangedSignal("Value"):Connect(function()
		setDebugStatus(screenGui, roundDebugStatus.Value)
	end)

	connection = roundStateChanged.OnClientEvent:Connect(function(snapshot)
		renderPrompt(screenGui, snapshot)
	end)

	stopFeedbackConnection = stopFeedback.OnClientEvent:Connect(function()
		playStopFeedback(screenGui)
	end)

	task.spawn(function()
		for _ = 1, 10 do
			if not started then
				return
			end

			local snapshotOk, snapshot = pcall(function()
				return requestRoundSnapshot:InvokeServer()
			end)

			if snapshotOk and snapshot ~= nil then
				renderPrompt(screenGui, snapshot)

				if snapshot.state ~= "WaitingForPlayers" then
					return
				end
			end

			task.wait(0.5)
		end
	end)
end

function RoundHud.stop()
	started = false

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if debugConnection then
		debugConnection:Disconnect()
		debugConnection = nil
	end

	if stopFeedbackConnection then
		stopFeedbackConnection:Disconnect()
		stopFeedbackConnection = nil
	end
end

return table.freeze(RoundHud)
