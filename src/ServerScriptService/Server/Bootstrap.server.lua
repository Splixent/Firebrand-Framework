--Strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage.Shared
local Server = ServerScriptService.Server

local BootstrapModules = {
    Red = require (Shared.Red),
    PlayerEntityManager = require(Server.PlayerEntityManager),
    Datastore = require(Server.Datastore),
    SyncedTime = require(Server.SyncedTime)
}

return BootstrapModules