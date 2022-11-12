local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProxPromptService = game:GetService("ProximityPromptService")

local ChangeCarColor = require(script.ChangeCarColor)

local CarEvents = ReplicatedStorage:WaitForChild("CarEvents")
local ProxServiceEvent = CarEvents.ProxServiceEvent
local DriveSeatEvent = CarEvents.DriveSeatEvent
local VehicleGuiEvent = CarEvents.VehicleGuiEvent
local ExitButtonEvet = CarEvents.ExitButtonEvent

local player = Players.LocalPlayer
local PlayerGui = player.PlayerGui
local VehicleGui = PlayerGui:WaitForChild("VehicleGui")

local connections = {}

-- disconnects connections when player exit drive seat
local function disconnectConnections()
	for connectionName, connection in pairs(connections) do
		connection:Disconnect()
	end
	table.clear(connections)
end

local function handleProxPromptEvent(bool)
	ProxPromptService.Enabled = bool
end

local function handleDriveSeatEvent(driveSeat, bool)
	driveSeat.Disabled = bool
end

local function handleVehicleGui(args)
	
	local enabled = args.enabled
	
	VehicleGui.Enabled = enabled
	
	if enabled == false then
		
		disconnectConnections()
		
	else
		local car = args.car
		
		local Effects = car:WaitForChild("Effects")
		local Lights = car.Body.Lights
		
		local Options = VehicleGui.Vehicle.Options
		
		local function onExitClick()
			ExitButtonEvet:FireServer()
		end
		
		local function onHornClick(car)
			local sound = Effects.Horn
			sound:Play()
		end

		local function onSirenClick(car)
			local sound = Effects.Siren
			if not sound.IsPlaying then
				sound:Play()
			else
				sound:Stop()
			end
		end
		
		local function onHeadLightClick()
			if Lights:FindFirstChild("FLI") then
				Lights.FLI.L.Enabled = not Lights.FLI.L.Enabled
			end
			if Lights:FindFirstChild("FRI") then
				Lights.FRI.L.Enabled = not Lights.FRI.L.Enabled
			end
		end
		
		local function onHazardLightClick()
			if Lights:FindFirstChild("F") then
				Lights.F.L.Enabled = not Lights.F.L.Enabled
			end
		end
		
		local function onChangeColorClick()
			local changeColorFrame = Options.ChangeColorButton["ChangeColorFrameValue"].Value
			
			changeColorFrame.Visible = not changeColorFrame.Visible
			ChangeCarColor(changeColorFrame, car)
		end
		
		-- bindings 
		connections[Options.ExitButton] = Options.ExitButton.MouseButton1Up:Connect(onExitClick)
		connections[Options.HornButton] = Options.HornButton.MouseButton1Up:Connect(onHornClick)
		connections[Options.Siren] = Options.Siren.MouseButton1Up:Connect(onSirenClick)
		connections[Options.HeadLightButton] = Options.HeadLightButton.MouseButton1Up:Connect(onHeadLightClick)
		connections[Options.HazardLightButton] = Options.HazardLightButton.MouseButton1Up:Connect(onHazardLightClick)
		connections[Options.ChangeColorButton] = Options.ChangeColorButton.MouseButton1Up:Connect(onChangeColorClick)
		
	end
end

local function onPlayerRemoving()
	if #connections > 0 then
		disconnectConnections()
	end
end

-- bindings
ProxServiceEvent.OnClientEvent:Connect(handleProxPromptEvent)
DriveSeatEvent.OnClientEvent:Connect(handleDriveSeatEvent)
VehicleGuiEvent.OnClientEvent:Connect(handleVehicleGui)
Players.PlayerRemoving:Connect(onPlayerRemoving)
