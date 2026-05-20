--// Fisch Hub Mobile + PC
--// F1 Toggle UI
--// Master Toggle
--// Auto Cast / Shake / Reel

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

-- Remove old
if guiParent:FindFirstChild("FischHub") then
	guiParent.FischHub:Destroy()
end

---------------------------------------------------
-- SETTINGS
---------------------------------------------------

local AutoCast = false
local AutoShake = false
local AutoReel = false
local EverythingEnabled = false

---------------------------------------------------
-- GUI
---------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "FischHub"
gui.ResetOnSpawn = false
gui.Parent = guiParent

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,320,0,330)
frame.Position = UDim2.new(0.5,-160,0.5,-165)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

---------------------------------------------------
-- TITLE
---------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,0,40)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "Fisch Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

---------------------------------------------------
-- CLOSE
---------------------------------------------------

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,35,0,35)
close.Position = UDim2.new(1,-42,0,5)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = frame

Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

---------------------------------------------------
-- TOGGLE CREATOR
---------------------------------------------------

local function createToggle(text, y)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,280,0,48)
	btn.Position = UDim2.new(0.5,-140,0,y)
	btn.BackgroundColor3 = Color3.fromRGB(55,55,55)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 19
	btn.Text = text .. " : OFF"
	btn.Parent = frame

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

	return btn
end

---------------------------------------------------
-- BUTTONS
---------------------------------------------------

local masterBtn = createToggle("MASTER", 55)
local castBtn = createToggle("Auto Cast", 115)
local shakeBtn = createToggle("Auto Shake", 175)
local reelBtn = createToggle("Auto Reel", 235)

---------------------------------------------------
-- UPDATE UI
---------------------------------------------------

local function updateButton(btn, text, state)

	if state then
		btn.Text = text .. " : ON"
		btn.BackgroundColor3 = Color3.fromRGB(60,170,90)
	else
		btn.Text = text .. " : OFF"
		btn.BackgroundColor3 = Color3.fromRGB(55,55,55)
	end
end

---------------------------------------------------
-- MASTER TOGGLE
---------------------------------------------------

masterBtn.MouseButton1Click:Connect(function()

	EverythingEnabled = not EverythingEnabled

	AutoCast = EverythingEnabled
	AutoShake = EverythingEnabled
	AutoReel = EverythingEnabled

	updateButton(masterBtn,"MASTER",EverythingEnabled)
	updateButton(castBtn,"Auto Cast",AutoCast)
	updateButton(shakeBtn,"Auto Shake",AutoShake)
	updateButton(reelBtn,"Auto Reel",AutoReel)
end)

---------------------------------------------------
-- AUTO CAST
---------------------------------------------------

castBtn.MouseButton1Click:Connect(function()

	AutoCast = not AutoCast
	updateButton(castBtn,"Auto Cast",AutoCast)

	task.spawn(function()

		while AutoCast do

			mouse1press()

			task.wait(1.1)

			mouse1release()

			task.wait(2)
		end
	end)
end)

---------------------------------------------------
-- AUTO SHAKE
---------------------------------------------------

shakeBtn.MouseButton1Click:Connect(function()

	AutoShake = not AutoShake
	updateButton(shakeBtn,"Auto Shake",AutoShake)

	task.spawn(function()

		while AutoShake do

			for _,v in pairs(player.PlayerGui:GetDescendants()) do

				if v:IsA("TextButton")
				or v:IsA("ImageButton") then

					local lower = string.lower(v.Name)

					if string.find(lower,"shake") then

						pcall(function()
							v:Activate()
						end)
					end
				end
			end

			task.wait(0.05)
		end
	end)
end)

---------------------------------------------------
-- AUTO REEL
---------------------------------------------------

reelBtn.MouseButton1Click:Connect(function()

	AutoReel = not AutoReel
	updateButton(reelBtn,"Auto Reel",AutoReel)

	task.spawn(function()

		while AutoReel do

			mouse1press()
			task.wait(0.05)
			mouse1release()

			task.wait(0.05)
		end
	end)
end)

---------------------------------------------------
-- CLOSE
---------------------------------------------------

close.MouseButton1Click:Connect(function()

	AutoCast = false
	AutoShake = false
	AutoReel = false

	gui:Destroy()
end)

---------------------------------------------------
-- F1 SHOW/HIDE UI
---------------------------------------------------

UIS.InputBegan:Connect(function(input,gp)

	if gp then return end

	if input.KeyCode == Enum.KeyCode.F1 then

		frame.Visible = not frame.Visible
	end
end)

---------------------------------------------------
-- DRAG SYSTEM
---------------------------------------------------

local dragging = false
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then

		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)

	if input == dragInput and dragging then

		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
