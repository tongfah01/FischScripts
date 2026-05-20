--// Fisch Mobile Full UI
--// Mobile + PC Support
--// Auto Cast / Auto Shake / Auto Reel
--// Drag UI / Close UI

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

-- Remove old UI
if guiParent:FindFirstChild("FischMobileUI") then
	guiParent.FischMobileUI:Destroy()
end

----------------------------------------------------
-- SETTINGS
----------------------------------------------------

local AutoCast = false
local AutoShake = false
local AutoReel = false

----------------------------------------------------
-- GUI
----------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "FischMobileUI"
gui.ResetOnSpawn = false
gui.Parent = guiParent

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,310,0,260)
frame.Position = UDim2.new(0.5,-155,0.5,-130)
frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

----------------------------------------------------
-- Title
----------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,0,40)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "Fisch Mobile Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

----------------------------------------------------
-- Close Button
----------------------------------------------------

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

----------------------------------------------------
-- Helper
----------------------------------------------------

local function createToggle(name, posY)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,270,0,48)
	btn.Position = UDim2.new(0.5,-135,0,posY)
	btn.BackgroundColor3 = Color3.fromRGB(55,55,55)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 19
	btn.Text = name .. " : OFF"
	btn.Parent = frame

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

	return btn
end

local castBtn = createToggle("Auto Cast", 60)
local shakeBtn = createToggle("Auto Shake", 120)
local reelBtn = createToggle("Auto Reel", 180)

----------------------------------------------------
-- AUTO CAST
----------------------------------------------------

castBtn.MouseButton1Click:Connect(function()

	AutoCast = not AutoCast

	if AutoCast then

		castBtn.Text = "Auto Cast : ON"
		castBtn.BackgroundColor3 = Color3.fromRGB(60,170,90)

		task.spawn(function()

			while AutoCast do

				-- จำลองกดค้าง
				mouse1press()

				task.wait(1.1)

				mouse1release()

				task.wait(2.2)
			end
		end)

	else

		castBtn.Text = "Auto Cast : OFF"
		castBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
	end
end)

----------------------------------------------------
-- AUTO SHAKE
----------------------------------------------------

shakeBtn.MouseButton1Click:Connect(function()

	AutoShake = not AutoShake

	if AutoShake then

		shakeBtn.Text = "Auto Shake : ON"
		shakeBtn.BackgroundColor3 = Color3.fromRGB(60,170,90)

		task.spawn(function()

			while AutoShake do

				local shakeButton = nil

				for _,v in pairs(player.PlayerGui:GetDescendants()) do

					if v:IsA("ImageButton")
					or v:IsA("TextButton") then

						if string.find(string.lower(v.Name),"shake")
						or string.find(string.lower(v.Text),"shake") then

							shakeButton = v
							break
						end
					end
				end

				if shakeButton then
					pcall(function()
						shakeButton:Activate()
					end)
				end

				task.wait(0.05)
			end
		end)

	else

		shakeBtn.Text = "Auto Shake : OFF"
		shakeBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
	end
end)

----------------------------------------------------
-- AUTO REEL
----------------------------------------------------

reelBtn.MouseButton1Click:Connect(function()

	AutoReel = not AutoReel

	if AutoReel then

		reelBtn.Text = "Auto Reel : ON"
		reelBtn.BackgroundColor3 = Color3.fromRGB(60,170,90)

		task.spawn(function()

			while AutoReel do

				mouse1press()
				task.wait(0.04)
				mouse1release()

				task.wait(0.04)
			end
		end)

	else

		reelBtn.Text = "Auto Reel : OFF"
		reelBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
	end
end)

----------------------------------------------------
-- CLOSE
----------------------------------------------------

close.MouseButton1Click:Connect(function()

	AutoCast = false
	AutoShake = false
	AutoReel = false

	gui:Destroy()
end)

----------------------------------------------------
-- DRAG SYSTEM
----------------------------------------------------

local dragging = false
local dragStart
local startPos
local dragInput

frame.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.Touch
	or input.UserInputType == Enum.UserInputType.MouseButton1 then

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

	if input.UserInputType == Enum.UserInputType.Touch
	or input.UserInputType == Enum.UserInputType.MouseMovement then

		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)

	if dragging and input == dragInput then

		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
