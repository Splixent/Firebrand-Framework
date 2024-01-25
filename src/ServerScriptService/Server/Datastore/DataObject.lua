--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage.Shared
local Server = ServerScriptService.Server

local Signal = require(Shared.Signal)
local ReplicaService = require(Server.ReplicaService)

local DataObject = {}

function DataObject.new(player: Player?, loadedData: any, extraInfo: boolean?) : any
    assert(player, "player is nil")
    if loadedData == nil then
        repeat
            task.wait()
        until 
        DataObject[player] ~= nil

        return DataObject[player]
    end

    if DataObject[player] == nil then
        DataObject[player] = {}
        DataObject[player].Replica = ReplicaService.NewReplica({
            ClassToken = ReplicaService.NewClassToken("DataKey"..player.UserId),
            Data = loadedData,
            Replication = player,
        })
        DataObject[player].Changed = Signal.new()
    end
    return if extraInfo then DataObject[player] else DataObject[player].Replica
end

function DataObject.SetData(player: Player?, path: any, newData: any): boolean?
    assert(player, "Player is nil")
    if typeof(newData) == "function" then
        newData = newData(DataObject[player].Replica.Data) 
        if newData == nil then
            return false
        end
    end
    
    DataObject[player].Replica:SetValues(path, newData[2])
    DataObject[player].Changed:Fire(player, newData[1])
    return true
end

Players.PlayerRemoving:Connect(function(player: Player?)
    local Replica = DataObject.new(player)
    
    assert(player, "player is nil")
    assert(Replica, "playerData is nil")

    Replica:Destroy()
    if DataObject[player] ~= nil then
        DataObject[player] = nil
    end
end)

return DataObject