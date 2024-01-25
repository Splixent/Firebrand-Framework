--Strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage.Shared
local Server = ServerScriptService.Server

require(Server.Datastore)
require(Server.Datastore.DataObject)
require(Server.SyncedTime)

local PlayerEntityManager = require(Server.PlayerEntityManager)
local Events = require(Shared.Events)

local InGame = Events.InGame:Server()

InGame:On(function(player: Player)
    local PlayerEntity = PlayerEntityManager.new(player)

    assert(player, "player is nil")
    assert(PlayerEntity, "PlayerEntity is nil")

    PlayerEntity:SetValue({"inGame"}, true)
end)