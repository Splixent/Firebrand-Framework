local Players = game:GetService("Players")

local Client = Players.LocalPlayer.PlayerScripts.Client

local ReplicaController = require(Client.ReplicaController)

local Player = Players.LocalPlayer

local Replication = {}

function Replication:GetInfo(Info, Details)
	if Details then
		return self[Info] 
	elseif self[Info] ~= nil then
		return self[Info].Data 
	else
		return nil
	end
end

ReplicaController.NewReplicaSignal:Connect(function(Replica)
	if Replica.Class == "States"..Player.UserId then
		Replication["States"] = Replica
	elseif Replica.Class == "DataKey"..Player.UserId then
		Replication["Data"] = Replica
	else
		Replication[Replica.Class] = Replica
	end
end)

function Replication.LoadedChanged(Handler)
	Replication.States:ListenToChange({"Loaded"}, Handler)
end

while game:IsLoaded() == false do
	task.wait()
end

ReplicaController.RequestData()

return Replication