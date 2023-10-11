local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local Client = Players.LocalPlayer.StarterPlayerScripts.Client

local Replication = require(Client.Replication)
local Red = require(Shared.Red)

local FullyLoaded = {}

function FullyLoaded:Init()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)

    task.spawn(function()
        if game:IsLoaded() == false then
            game.Loaded:Wait()
        end
    
        repeat task.wait() until Replication:GetInfo("States")
        
        local States = Replication:GetInfo("States")

        if States.Loaded == false then
            Replication:LoadedChanged(function(NewValue)
                if NewValue == true then
                    --
                    task.wait(1)
                    self.Load:set(1)
                end
            end)
        elseif States.Loaded == true then
            --
            task.wait(1)
        end
    end)

end

FullyLoaded:Init()

return FullyLoaded
