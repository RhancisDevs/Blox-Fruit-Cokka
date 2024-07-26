local plr = game:GetService("Players").LocalPlayer
local Notification = require(game:GetService("ReplicatedStorage").Notification)
local Data = plr:WaitForChild("Data")
local EXPFunction = require(game.ReplicatedStorage:WaitForChild("EXPFunction"))
local LevelUp = require(game:GetService("ReplicatedStorage").Effect.Container.LevelUp)
local Sound = require(game:GetService("ReplicatedStorage").Util.Sound)
local LevelUpSound = game:GetService("ReplicatedStorage").Util.Sound.Storage.Other:FindFirstChild("LevelUp_Proxy") or game:GetService("ReplicatedStorage").Util.Sound.Storage.Other:FindFirstChild("LevelUp")

local playerName = plr.DisplayName

Notification.new("Warning: " .. playerName .. ", your actions are monitored."):Display()
wait(3)
Notification.new("Notice: " .. playerName .. ", exploiting ruins the game."):Display()
wait(5)
Notification.new("Consequence: " .. playerName .. ", you will be kicked."):Display()
wait(2)

plr:Kick("You're permanently banned from this game.")
