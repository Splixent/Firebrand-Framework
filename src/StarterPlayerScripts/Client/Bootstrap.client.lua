--Strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local Client = Players.LocalPlayer.StarterPlayerScripts.Client

local BootstrapModules = {
    Communication = require(Client.Communication)
}

return BootstrapModules