local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage.Shared
local Server = ServerScriptService.Server

local Signal = require(Shared.Signal)
local ReplicaService = require(Server.ReplicaService)

local DataManager = {}

function DataManager:Create(Player: Player, LoadedData: any): any
    if LoadedData == nil then
        repeat
            task.wait()
        until 
        DataManager[Player] ~= nil

        return DataManager[Player]
    end

    if DataManager[Player] == nil and Player ~= nil then
        DataManager[Player] = {}
        DataManager[Player].Replica = ReplicaService.NewReplica({
            ClassToken = ReplicaService.NewClassToken("DataKey"..Player.UserId),
            Data = LoadedData,
            Replication = Player,
        })
        DataManager[Player].Changed = Signal.new()
    end
    return DataManager[Player]
end

function DataManager:SetData(Player: Player, Path: any, NewData: any): boolean
    if typeof(NewData) == "function" then
        NewData = NewData(DataManager[Player].Replica.Data) 
        if NewData == nil then
            return false
        end
    end
    
    DataManager[Player].Replica:SetValues(Path, NewData[2])
    DataManager[Player].Changed:Fire(Player, NewData[1])
    return true
end

Players.PlayerRemoving:Connect(function(Player: Player)
    local Replica = DataManager:Create(Player).Replica
    Replica:Destroy()
    if DataManager[Player] ~= nil then
        DataManager[Player] = nil
    end
end)

return DataManager