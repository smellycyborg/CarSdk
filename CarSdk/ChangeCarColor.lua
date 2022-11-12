local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"))

local VehicleService
Knit.OnStart():andThen(function()
	VehiclesService = Knit.GetService("VehiclesService")
end)

return function(frame, car)
	local colourWheel = frame:WaitForChild("ColourWheel")
	local wheelPicker = colourWheel:WaitForChild("Picker")

	local darknessPicker = frame:WaitForChild("DarknessPicker")
	local darknessSlider = darknessPicker:WaitForChild("Slider")

	local colourDisplay = frame:WaitForChild("ColourDisplay")

	local buttonDown
	local movingSlider

	local function updateColour(centreOfWheel)
		local colourPickerCentre = Vector2.new(
			colourWheel.Picker.AbsolutePosition.X + (colourWheel.Picker.AbsoluteSize.X/2),
			colourWheel.Picker.AbsolutePosition.Y + (colourWheel.Picker.AbsoluteSize.Y/2)
		)

		local h = (math.pi - math.atan2(colourPickerCentre.Y - centreOfWheel.Y, colourPickerCentre.X - centreOfWheel.X)) / (math.pi * 2)
		local s = (centreOfWheel - colourPickerCentre).Magnitude / (colourWheel.AbsoluteSize.X/2)
		local v = math.abs((darknessSlider.AbsolutePosition.Y - darknessPicker.AbsolutePosition.Y) / darknessPicker.AbsoluteSize.Y - 1)
		local hsv = Color3.fromHSV(math.clamp(h, 0, 1), math.clamp(s, 0, 1), math.clamp(v, 0, 1))

		colourDisplay.ImageColor3 = hsv
		darknessPicker.UIGradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, hsv),
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
		}

		VehiclesService:ChangeColor(car, hsv)
	end

	colourWheel.MouseButton1Down:Connect(function()
		buttonDown = true
	end)

	darknessPicker.MouseButton1Down:Connect(function()
		movingSlider = true
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then 
			return 
		end

		buttonDown = false
		movingSlider = false
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then 
			return
		end

		local mousePos = UserInputService:GetMouseLocation() - Vector2.new(0, game:GetService("GuiService"):GetGuiInset().Y)
		local centreOfWheel = Vector2.new(colourWheel.AbsolutePosition.X + (colourWheel.AbsoluteSize.X/2), colourWheel.AbsolutePosition.Y + (colourWheel.AbsoluteSize.Y/2))
		local distanceFromWheel = (mousePos - centreOfWheel).Magnitude

		if distanceFromWheel <= colourWheel.AbsoluteSize.X/2 and buttonDown then
			wheelPicker.Position = UDim2.new(0, mousePos.X - colourWheel.AbsolutePosition.X, 0, mousePos.Y - colourWheel.AbsolutePosition.Y)
		elseif movingSlider then
			darknessSlider.Position = UDim2.new(darknessSlider.Position.X.Scale, 0, 0, 
				math.clamp(
					mousePos.Y - darknessPicker.AbsolutePosition.Y, 
					0, 
					darknessPicker.AbsoluteSize.Y)
			)
		end

		if buttonDown or movingSlider then
			updateColour(centreOfWheel)
		end
	end)
end
