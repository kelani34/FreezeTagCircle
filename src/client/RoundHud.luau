local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared.Remotes)
local RoundPrompts = require(Shared.RoundPrompts)

local RoundHud = {}

local started = false
local connection: RBXScriptConnection? = nil

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

	return screenGui
end

local function getRemotes(): (RemoteEvent, RemoteFunction)
	local remoteFolder = ReplicatedStorage:WaitForChild(Remotes.FolderName)

	return remoteFolder:WaitForChild(Remotes.RoundStateChanged) :: RemoteEvent,
		remoteFolder:WaitForChild(Remotes.RequestRoundSnapshot) :: RemoteFunction
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
end

function RoundHud.start()
	if started then
		return
	end

	started = true

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui") :: PlayerGui
	local screenGui = getOrCreateHud(playerGui)
	local roundStateChanged, requestRoundSnapshot = getRemotes()

	connection = roundStateChanged.OnClientEvent:Connect(function(snapshot)
		renderPrompt(screenGui, snapshot)
	end)

	local ok, snapshot = pcall(function()
		return requestRoundSnapshot:InvokeServer()
	end)

	if ok and snapshot ~= nil then
		renderPrompt(screenGui, snapshot)
	end
end

function RoundHud.stop()
	started = false

	if connection then
		connection:Disconnect()
		connection = nil
	end
end

return table.freeze(RoundHud)
