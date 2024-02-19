local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local Client = Players.LocalPlayer.PlayerScripts.Client

local Fusion = require(Shared.Fusion)
local Functions = require(script.Functions)

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

return New "Frame" {
    Name = "Frame",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    BorderSizePixel = 0,
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(400, 400),

    [Children] = {
        New "ImageButton" {
            Name = "ImageButton",
            Image = "rbxassetid://15043829202",
            ScaleType = Enum.ScaleType.Fit,
            AutoButtonColor = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
        },
    }
}