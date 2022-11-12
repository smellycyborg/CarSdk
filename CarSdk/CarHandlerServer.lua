local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProxPromptService = game:GetService("ProximityPromptService")

local CarEvents = ReplicatedStorage:WaitForChild("CarEvents")
local ProxServiceEvent = CarEvents.ProxServiceEvent
local DriveSeatEvent = CarEvents.DriveSeatEvent
local VehicleGuiEvent = CarEvents.VehicleGuiEvent
local ExitButtonEvent = CarEvents.ExitButtonEvent

local ON_CHILD_ADDED_MESSAGE = "MESSAGE/Info:  ProximityPromptSevice -> SeatWeld has been added to DriveSeat.."
local ON_CHILD_REMOVED_MESSAGE = "MESSAGE/Info:  ProximityPromptSevice -> SeatWeld has been removed from DriveSeat.."

local DriveSeat = script.Parent
local Car = DriveSeat.Parent
local VehiclesFolder = Car.Parent

local playerId = Car:FindFirstChild("OwnerId").Value

local player
for _, child in pairs(game.Players:GetPlayers()) do
	if child.UserId == playerId then
		player = child
	end
end

local function onChildAdded(child)
	local isSeatWeld = child.Name == "SeatWeld"
	if isSeatWeld then
		ProxServiceEvent:FireClient(player, false)
		VehicleGuiEvent:FireClient(player, { enabled = true, car = Car })
		
		print(ON_CHILD_ADDED_MESSAGE)
	end
end

local function onChildRemoved(child)
	local isSeatWeld = child.Name == "SeatWeld"
	if isSeatWeld then
		ProxServiceEvent:FireClient(player, true)
		DriveSeatEvent:FireClient(player, DriveSeat, true)
		VehicleGuiEvent:FireClient(player, { enabled = false, car = Car })
		
		print(ON_CHILD_REMOVED_MESSAGE)
	end
end

local function onPromxPromptTriggered(promptObject, _plr)
	local isDriveSeatProxPrompt = promptObject.Name == "DriveSeatProximityPrompt"
	if isDriveSeatProxPrompt then
		DriveSeatEvent:FireClient(player, DriveSeat, false)

		local humanoid = player.Character:FindFirstChild("Humanoid")
		DriveSeat:Sit(humanoid)
	end
end

local function onExitButtonEvent(_plr)
	local humanoid = player.Character:FindFirstChild("Humanoid")
	DriveSeat.SeatWeld:Destroy()
end

-- bindings
DriveSeat.ChildAdded:Connect(onChildAdded)
DriveSeat.ChildRemoved:Connect(onChildRemoved)
ProxPromptService.PromptTriggered:Connect(onPromxPromptTriggered)
ExitButtonEvent.OnServerEvent:Connect(onExitButtonEvent)