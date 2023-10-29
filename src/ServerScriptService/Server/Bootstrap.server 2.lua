--Strict

local Shared = game:GetService("ReplicatedStorage").Shared
local Server = game:GetService("ServerScriptService").Server

local BootstrapModules = {
    Red = require (Shared.Red),
    PlayerEntityManager = require(Server.PlayerEntityManager),
    Datastore = require(Server.Datastore),
    SyncedTime = require(Server.SyncedTime)
}

return BootstrapModules