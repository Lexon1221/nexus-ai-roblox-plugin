-- Nexus AI Studio Plugin
-- Version 1.0.0
-- Connect Roblox Studio to the Nexus AI Platform

local HttpService = game:GetService("HttpService")
local Selection = game:GetService("Selection")
local StudioService = game:GetService("StudioService")
local CoreGui = game:GetService("CoreGui")

local NEXUS_API_URL = "https://app.base44.com/api/functions/nexusStudioPlugin"

-- Plugin setup
local plugin = script:FindFirstAncestorWhichIsA("Plugin")
if not plugin then
	warn("[Nexus AI] Must be run as a Plugin")
	return
end

local toolbar = plugin:CreateToolbar("Nexus AI")

-- Buttons
local btnOpen = toolbar:CreateButton(
	"Nexus AI",
	"Open Nexus AI Panel",
	"rbxassetid://11963836530"  -- Roblox star icon as placeholder
)

-- GUI
local screenGui
local isOpen = false

local function createGui()
	if screenGui then screenGui:Destroy() end

	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "NexusAIPanel"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- Main frame
	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0, 420, 0, 560)
	frame.Position = UDim2.new(1, -440, 0.5, -280)
	frame.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(40, 50, 80)
	stroke.Thickness = 1
	stroke.Parent = frame

	-- Header
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 48)
	header.BackgroundColor3 = Color3.fromRGB(15, 18, 30)
	header.BorderSizePixel = 0
	header.Parent = frame

	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 12)
	headerCorner.Parent = header

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -60, 1, 0)
	title.Position = UDim2.new(0, 16, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "⚡ Nexus AI"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 16
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 32, 0, 32)
	closeBtn.Position = UDim2.new(1, -40, 0, 8)
	closeBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(200, 80, 80)
	closeBtn.TextSize = 14
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.BorderSizePixel = 0
	closeBtn.Parent = header

	local closeBtnCorner = Instance.new("UICorner")
	closeBtnCorner.CornerRadius = UDim.new(0, 8)
	closeBtnCorner.Parent = closeBtn

	closeBtn.MouseButton1Click:Connect(function()
		plugin:SetSetting("NexusOpen", false)
		screenGui:Destroy()
		isOpen = false
	end)

	-- API Key input area
	local apiSection = Instance.new("Frame")
	apiSection.Size = UDim2.new(1, -24, 0, 80)
	apiSection.Position = UDim2.new(0, 12, 0, 60)
	apiSection.BackgroundColor3 = Color3.fromRGB(18, 22, 36)
	apiSection.BorderSizePixel = 0
	apiSection.Parent = frame

	local apiCorner = Instance.new("UICorner")
	apiCorner.CornerRadius = UDim.new(0, 8)
	apiCorner.Parent = apiSection

	local apiLabel = Instance.new("TextLabel")
	apiLabel.Size = UDim2.new(1, -12, 0, 20)
	apiLabel.Position = UDim2.new(0, 12, 0, 8)
	apiLabel.BackgroundTransparency = 1
	apiLabel.Text = "API Key"
	apiLabel.TextColor3 = Color3.fromRGB(120, 140, 180)
	apiLabel.TextSize = 11
	apiLabel.Font = Enum.Font.GothamBold
	apiLabel.TextXAlignment = Enum.TextXAlignment.Left
	apiLabel.Parent = apiSection

	local savedKey = plugin:GetSetting("NexusAPIKey") or ""

	local apiInput = Instance.new("TextBox")
	apiInput.Size = UDim2.new(1, -80, 0, 30)
	apiInput.Position = UDim2.new(0, 12, 0, 32)
	apiInput.BackgroundColor3 = Color3.fromRGB(8, 10, 18)
	apiInput.Text = savedKey
	apiInput.PlaceholderText = "nxs_studio_..."
	apiInput.TextColor3 = Color3.fromRGB(100, 220, 160)
	apiInput.PlaceholderColor3 = Color3.fromRGB(60, 80, 100)
	apiInput.TextSize = 11
	apiInput.Font = Enum.Font.Code
	apiInput.TextXAlignment = Enum.TextXAlignment.Left
	apiInput.ClearTextOnFocus = false
	apiInput.BorderSizePixel = 0
	apiInput.Parent = apiSection

	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 6)
	inputCorner.Parent = apiInput

	local saveKeyBtn = Instance.new("TextButton")
	saveKeyBtn.Size = UDim2.new(0, 56, 0, 30)
	saveKeyBtn.Position = UDim2.new(1, -68, 0, 32)
	saveKeyBtn.BackgroundColor3 = Color3.fromRGB(20, 120, 80)
	saveKeyBtn.Text = "Save"
	saveKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	saveKeyBtn.TextSize = 11
	saveKeyBtn.Font = Enum.Font.GothamBold
	saveKeyBtn.BorderSizePixel = 0
	saveKeyBtn.Parent = apiSection

	local saveBtnCorner = Instance.new("UICorner")
	saveBtnCorner.CornerRadius = UDim.new(0, 6)
	saveBtnCorner.Parent = saveKeyBtn

	saveKeyBtn.MouseButton1Click:Connect(function()
		plugin:SetSetting("NexusAPIKey", apiInput.Text)
		saveKeyBtn.Text = "✓"
		saveKeyBtn.BackgroundColor3 = Color3.fromRGB(20, 160, 80)
		task.wait(1.5)
		saveKeyBtn.Text = "Save"
		saveKeyBtn.BackgroundColor3 = Color3.fromRGB(20, 120, 80)
	end)

	-- AI Prompt area
	local promptSection = Instance.new("Frame")
	promptSection.Size = UDim2.new(1, -24, 0, 160)
	promptSection.Position = UDim2.new(0, 12, 0, 152)
	promptSection.BackgroundColor3 = Color3.fromRGB(18, 22, 36)
	promptSection.BorderSizePixel = 0
	promptSection.Parent = frame

	local promptCorner = Instance.new("UICorner")
	promptCorner.CornerRadius = UDim.new(0, 8)
	promptCorner.Parent = promptSection

	local promptLabel = Instance.new("TextLabel")
	promptLabel.Size = UDim2.new(1, -12, 0, 20)
	promptLabel.Position = UDim2.new(0, 12, 0, 8)
	promptLabel.BackgroundTransparency = 1
	promptLabel.Text = "AI Prompt"
	promptLabel.TextColor3 = Color3.fromRGB(120, 140, 180)
	promptLabel.TextSize = 11
	promptLabel.Font = Enum.Font.GothamBold
	promptLabel.TextXAlignment = Enum.TextXAlignment.Left
	promptLabel.Parent = promptSection

	local promptBox = Instance.new("TextBox")
	promptBox.Size = UDim2.new(1, -24, 0, 90)
	promptBox.Position = UDim2.new(0, 12, 0, 32)
	promptBox.BackgroundColor3 = Color3.fromRGB(8, 10, 18)
	promptBox.Text = ""
	promptBox.PlaceholderText = "Describe the script you need..."
	promptBox.TextColor3 = Color3.fromRGB(220, 230, 255)
	promptBox.PlaceholderColor3 = Color3.fromRGB(60, 80, 100)
	promptBox.TextSize = 12
	promptBox.Font = Enum.Font.Gotham
	promptBox.TextXAlignment = Enum.TextXAlignment.Left
	promptBox.TextYAlignment = Enum.TextYAlignment.Top
	promptBox.MultiLine = true
	promptBox.TextWrapped = true
	promptBox.ClearTextOnFocus = false
	promptBox.BorderSizePixel = 0
	promptBox.Parent = promptSection

	local promptBoxCorner = Instance.new("UICorner")
	promptBoxCorner.CornerRadius = UDim.new(0, 6)
	promptBoxCorner.Parent = promptBox

	local generateBtn = Instance.new("TextButton")
	generateBtn.Size = UDim2.new(1, -24, 0, 32)
	generateBtn.Position = UDim2.new(0, 12, 0, 128)  -- was 124
	generateBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 200)
	generateBtn.Text = "⚡ Generate Script"
	generateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	generateBtn.TextSize = 13
	generateBtn.Font = Enum.Font.GothamBold
	generateBtn.BorderSizePixel = 0
	generateBtn.Parent = promptSection

	local generateCorner = Instance.new("UICorner")
	generateCorner.CornerRadius = UDim.new(0, 8)
	generateCorner.Parent = generateBtn

	-- Output area
	local outputSection = Instance.new("Frame")
	outputSection.Size = UDim2.new(1, -24, 0, 230)
	outputSection.Position = UDim2.new(0, 12, 0, 324)
	outputSection.BackgroundColor3 = Color3.fromRGB(8, 10, 18)
	outputSection.BorderSizePixel = 0
	outputSection.Parent = frame

	local outputCorner = Instance.new("UICorner")
	outputCorner.CornerRadius = UDim.new(0, 8)
	outputCorner.Parent = outputSection

	local outputLabel = Instance.new("TextLabel")
	outputLabel.Size = UDim2.new(1, -12, 0, 20)
	outputLabel.Position = UDim2.new(0, 12, 0, 8)
	outputLabel.BackgroundTransparency = 1
	outputLabel.Text = "Output"
	outputLabel.TextColor3 = Color3.fromRGB(120, 140, 180)
	outputLabel.TextSize = 11
	outputLabel.Font = Enum.Font.GothamBold
	outputLabel.TextXAlignment = Enum.TextXAlignment.Left
	outputLabel.Parent = outputSection

	local outputText = Instance.new("TextLabel")
	outputText.Size = UDim2.new(1, -24, 1, -60)
	outputText.Position = UDim2.new(0, 12, 0, 30)
	outputText.BackgroundTransparency = 1
	outputText.Text = "Waiting for generation..."
	outputText.TextColor3 = Color3.fromRGB(160, 190, 160)
	outputText.TextSize = 11
	outputText.Font = Enum.Font.Code
	outputText.TextXAlignment = Enum.TextXAlignment.Left
	outputText.TextYAlignment = Enum.TextYAlignment.Top
	outputText.TextWrapped = true
	outputText.Parent = outputSection

	local insertBtn = Instance.new("TextButton")
	insertBtn.Size = UDim2.new(1, -24, 0, 30)
	insertBtn.Position = UDim2.new(0, 12, 1, -38)
	insertBtn.BackgroundColor3 = Color3.fromRGB(20, 100, 60)
	insertBtn.Text = "Insert into Studio"
	insertBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	insertBtn.TextSize = 12
	insertBtn.Font = Enum.Font.GothamBold
	insertBtn.BorderSizePixel = 0
	insertBtn.Visible = false
	insertBtn.Parent = outputSection

	local insertCorner = Instance.new("UICorner")
	insertCorner.CornerRadius = UDim.new(0, 8)
	insertCorner.Parent = insertBtn

	local lastGeneratedScript = ""

	-- Generate button logic
	generateBtn.MouseButton1Click:Connect(function()
		local apiKey = plugin:GetSetting("NexusAPIKey") or ""
		if apiKey == "" then
			outputText.Text = "⚠ Please save your API Key first!"
			outputText.TextColor3 = Color3.fromRGB(255, 200, 60)
			return
		end
		if promptBox.Text == "" then
			outputText.Text = "⚠ Please enter a prompt first!"
			outputText.TextColor3 = Color3.fromRGB(255, 200, 60)
			return
		end

		outputText.Text = "⏳ Generating..."
		outputText.TextColor3 = Color3.fromRGB(120, 160, 255)
		insertBtn.Visible = false
		generateBtn.Text = "⏳ Generating..."
		generateBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 80)

		local success, result = pcall(function()
			local response = HttpService:RequestAsync({
				Url = NEXUS_API_URL,
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					["Authorization"] = "Bearer " .. apiKey
				},
				Body = HttpService:JSONEncode({
					prompt = promptBox.Text,
					mode = "roblox_script"
				})
			})
			return HttpService:JSONDecode(response.Body)
		end)

		generateBtn.Text = "⚡ Generate Script"
		generateBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 200)

		if success and result and result.script then
			lastGeneratedScript = result.script
			-- Show first 800 chars
			local preview = result.script:sub(1, 800)
			if #result.script > 800 then preview = preview .. "\n..." end
			outputText.Text = preview
			outputText.TextColor3 = Color3.fromRGB(100, 220, 160)
			insertBtn.Visible = true
		elseif success and result and result.error then
			outputText.Text = "Error: " .. tostring(result.error)
			outputText.TextColor3 = Color3.fromRGB(255, 100, 100)
		else
			outputText.Text = "Error connecting to Nexus AI. Check HTTP requests are enabled in Studio settings."
			outputText.TextColor3 = Color3.fromRGB(255, 100, 100)
		end
	end)

	-- Insert into Studio
	insertBtn.MouseButton1Click:Connect(function()
		if lastGeneratedScript == "" then return end
		local selected = Selection:Get()
		local parent = selected[1] or game.Workspace

		local script = Instance.new("Script")
		script.Name = "NexusAI_Generated"
		script.Source = lastGeneratedScript
		script.Parent = parent

		Selection:Set({script})
		insertBtn.Text = "✓ Inserted!"
		insertBtn.BackgroundColor3 = Color3.fromRGB(20, 160, 80)
		task.wait(2)
		insertBtn.Text = "Insert into Studio"
		insertBtn.BackgroundColor3 = Color3.fromRGB(20, 100, 60)
	end)

	screenGui.Parent = CoreGui
	return screenGui
end

-- Toggle open/close
btnOpen.Click:Connect(function()
	isOpen = not isOpen
	if isOpen then
		createGui()
		plugin:SetSetting("NexusOpen", true)
	else
		if screenGui then
			screenGui:Destroy()
			screenGui = nil
		end
		plugin:SetSetting("NexusOpen", false)
	end
end)

-- Restore if was open
if plugin:GetSetting("NexusOpen") then
	isOpen = true
	createGui()
end

print("[Nexus AI] Plugin loaded successfully! Click the Nexus AI button in the toolbar.")
