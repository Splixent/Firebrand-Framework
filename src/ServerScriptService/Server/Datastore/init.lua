--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Shared = ReplicatedStorage.Shared
local Server = ServerScriptService.Server

local ProfileService = require(Server.ProfileService)
local Constants = require(Server.Constants)
local DataObject = require(script.DataObject)
local PlayerEntityManager = require(Server.PlayerEntityManager)
local ScriptUtils = require(Shared.ScriptUtils)

local Datastore = {}
local Profiles = {}

local gameProfileStore = ProfileService.GetProfileStore(
    "default",
    ScriptUtils.DeepCopy(Constants.profileSettings.profileTemplate)
).Mock


function Datastore:PlayerAdded(player: Player)
    local profile = gameProfileStore:LoadProfileAsync("dataKey"..player.UserId)
    if profile ~= nil then
        profile:AddUserId(player.UserId)
        profile:Reconcile()
        profile:ListenToRelease(function()
            Profiles[player] = nil
            player:Kick()
        end)

        if player:IsDescendantOf(Players) == true then
            Profiles[player] = profile

            Datastore:LoadData(player)
            Datastore:SaveData(player)
        else
            profile:Release()
        end
    else
        player:Kick()
    end
end

function Datastore:LoadData(player: Player)
    if Profiles[player].Data.loginInfo.totalLogins < 1 then
        self:SetupData(Profiles[player])
    end

    Profiles[player].Data.loginInfo.totalLogins += 1
    Profiles[player].Data.loginInfo.lastLogin = os.time()
    
    Datastore[player].DataObject = DataObject.new(player, Profiles[player].Data, true)
    Datastore[player].PlayerEntity = PlayerEntityManager.new(player)

    PlayerEntityManager.SetupCharacter(player)

    Datastore[player].PlayerEntity:SetValue({"loaded"}, true)
end

function Datastore:SaveData(player: Player)
    Datastore[player].DataObject.Changed:Connect(function(player, UpdatedData)
        Profiles[player].Data = UpdatedData
    end)
end

function Datastore:SetupData(Profile: any)
    Profile.Data.Save = ScriptUtils.DeepCopy(Constants.profileSettings.saveTemplate)
end

for _, player in ipairs (Players:GetPlayers()) do
    task.spawn(function()
        Datastore[player] = {}
        Datastore:PlayerAdded(player)
    end)
end

Players.PlayerAdded:Connect(function(player: Player)
    Datastore[player] = {}
    Datastore:PlayerAdded(player)
end)

Players.PlayerRemoving:Connect(function(player: Player?)
    assert(player, "player is nil")

    local profile = Profiles[player]
    DataObject[player] = nil

    if profile then
        profile.Data.loginInfo.totalPlaytime += (os.time() -  profile.Data.loginInfo.lastLogin) 
    end

    if profile ~= nil then
        profile:Release()
    end
end)

return Datastore