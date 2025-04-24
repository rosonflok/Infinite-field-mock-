local player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")

--// Intro Splash
local splash = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
splash.Name = "InfiniteFieldIntro"

local bg = Instance.new("Frame", splash)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local label = Instance.new("TextLabel", bg)
label.Size = UDim2.new(1, 0, 0.3, 0)
label.Position = UDim2.new(0, 0, 0.35, 0)
label.TextColor3 = Color3.new(0, 1, 0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.Code
label.TextSize = 26
label.Text = ""
label.TextWrapped = true

local loadingBar = Instance.new("Frame", bg)
loadingBar.Position = UDim2.new(0.1, 0, 0.7, 0)
loadingBar.Size = UDim2.new(0.8, 0, 0.03, 0)
loadingBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local fill = Instance.new("Frame", loadingBar)
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.new(0, 1, 0)

local beep = Instance.new("Sound", splash)
beep.SoundId = "rbxassetid://9118823105"
beep.Volume = 0.4

task.spawn(function()
	local fullText = "INFINITE FIELD\nInitializing"
	for i = 1, #fullText do
		label.Text = string.sub(fullText, 1, i)
		beep:Play()
		wait(0.05)
	end
	wait(0.4)
	for i = 1, 3 do
		label.Text = label.Text .. "."
		beep:Play()
		wait(0.3)
	end
	wait(0.5)
	for _ = 1, 6 do
		label.TextTransparency = math.random()
		label.Rotation = math.random(-2, 2)
		wait(0.06)
	end
	label.TextTransparency = 0
	label.Rotation = 0
	for i = 0, 1, 0.02 do
		fill.Size = UDim2.new(i, 0, 1, 0)
		beep:Play()
		wait(0.03)
	end
	wait(0.5)
	for i = 0, 1, 0.05 do
		bg.BackgroundTransparency = i
		label.TextTransparency = i
		fill.BackgroundTransparency = i
		loadingBar.BackgroundTransparency = i
		wait(0.02)
	end
	splash:Destroy()
end)

--// Command UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "InfiniteField"

local cmdBar = Instance.new("TextBox", gui)
cmdBar.Size = UDim2.new(1, 0, 0, 30)
cmdBar.Position = UDim2.new(0, 0, 1, -30)
cmdBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
cmdBar.TextColor3 = Color3.fromRGB(0, 255, 0)
cmdBar.Font = Enum.Font.Code
cmdBar.TextSize = 18
cmdBar.Text = ">_"
cmdBar.ClearTextOnFocus = false
cmdBar.Visible = false

--// Command logic
local history = {}
local index = 0
local cmds = {
	speed = "Boost walk speed",
	reset = "Respawn your character",
	fly = "Fly upwards",
	[":cmds"] = "List available commands"
}

local function execute(cmd)
	cmd = cmd:lower()
	if cmd == "speed" then
		player.Character.Humanoid.WalkSpeed = 100
	elseif cmd == "reset" then
		player:LoadCharacter()
	elseif cmd == "fly" then
		player.Character:MoveTo(player.Character:GetPivot().Position + Vector3.new(0, 50, 0))
	elseif cmd == ":cmds" then
		print("Infinite Field - Available Commands:")
		for k, v in pairs(cmds) do
			print(">", k, "-", v)
		end
	else
		warn("Unknown command:", cmd)
	end
end

--// Toggle & Input
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		cmdBar.Visible = not cmdBar.Visible
		if cmdBar.Visible then
			cmdBar:CaptureFocus()
		end
	elseif input.KeyCode == Enum.KeyCode.Up and cmdBar:IsFocused() then
		if #history > 0 then
			index = math.max(1, index - 1)
			cmdBar.Text = ">_" .. history[index]
		end
	elseif input.KeyCode == Enum.KeyCode.Down and cmdBar:IsFocused() then
		if #history > 0 then
			index = math.min(#history, index + 1)
			cmdBar.Text = ">_" .. history[index]
		end
	end
end)

cmdBar.FocusLost:Connect(function(enter)
	if not enter then return end
	local input = cmdBar.Text:sub(3)
	table.insert(history, input)
	index = #history + 1
	execute(input)
	cmdBar.Text = ">_"
end)
