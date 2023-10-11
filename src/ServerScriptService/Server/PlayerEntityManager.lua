--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage.Shared
local Server = ServerScriptService.Server

local ReplicaService = require(Server.ReplicaService)
local Constants = require(Server.Constants)
local ScriptUtils = require(Shared.ScriptUtils)
local Maid = require(Shared.Maid)
local DataManager = require(Server.Datastore.DataManager)

local PlayerEntityManager = {}

function PlayerEntityManager.Create(Player: Player): any
    if PlayerEntityManager[Player] == nil and Player ~= nil then
        local PlayerEntityInfo = {}
        PlayerEntityInfo.Player = Player
        PlayerEntityInfo.Replica = ReplicaService.NewReplica({
            ClassToken = ReplicaService.NewClassToken("States"..Player.UserId),
            Data = ScriptUtils.DeepCopy(Constants.States),
            Replication = Player,
        })
        PlayerEntityManager[Player] = PlayerEntityInfo
    end
    return PlayerEntityManager[Player]
end

function PlayerEntityManager.SetupCharacter(Player: Player)
    if Player == nil then return end
    Player:LoadCharacter()

    local Character = Player.Character or Player.CharacterAdded:Wait()
    local PlayerData = DataManager:Create(Player)

    local NewMaid = Maid.new()

    NewMaid:GiveTask(Player.Character.Humanoid.Died:Connect(function()
        PlayerEntityManager:OnDied(Player)
        NewMaid:Destroy() 
    end))
end

function PlayerEntityManager.OnDied(Player)
    PlayerEntityManager:SetupCharacter(Player)
end

Players.PlayerRemoving:Connect(function(Player)
    local Replica = PlayerEntityManager:Create(Player).Replica
    Replica:Destroy()
    if PlayerEntityManager[Player] ~= nil then
        PlayerEntityManager[Player] = nil
    end
end)

return PlayerEntityManager