local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")

local StarterCharacterScripts = StarterPlayer.StarterCharacterScripts

local CarSdk = {}

function CarSdk.init()
	
	-- creating remote events
	local CarEvents = Instance.new("Folder", ReplicatedStorage)
	CarEvents.Name = "CarEvents"
	
	local proxServiceEvent = Instance.new("RemoteEvent", CarEvents)
	proxServiceEvent.Name = "ProxServiceEvent"
	local driveSeatEvent = Instance.new("RemoteEvent", CarEvents)
	driveSeatEvent.Name = "DriveSeatEvent"
	local vehicleGuiEvent = Instance.new("RemoteEvent", CarEvents)
	vehicleGuiEvent.Name = "VehicleGuiEvent"
	local exitButtonEvent = Instance.new("RemoteEvent", CarEvents)
	exitButtonEvent.Name = "ExitButtonEvent"
	
	-- setting locations
	script.CarHandlerLocal.Parent = StarterCharacterScripts
	script.VehicleGui.Parent = StarterGui
	
end

return CarSdk
