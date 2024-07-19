local plr = game:GetService("Players").LocalPlayer
local Notification = require(game:GetService("ReplicatedStorage").Notification)
local Data = plr:WaitForChild("Data")
local EXPFunction = require(game.ReplicatedStorage:WaitForChild("EXPFunction"))
local LevelUp = require(game:GetService("ReplicatedStorage").Effect.Container.LevelUp)
local Sound = require(game:GetService("ReplicatedStorage").Util.Sound)
local LevelUpSound = game:GetService("ReplicatedStorage").Util.Sound.Storage.Other:FindFirstChild("LevelUp_Proxy") or game:GetService("ReplicatedStorage").Util.Sound.Storage.Other:FindFirstChild("LevelUp")

local playerName = plr.DisplayName

Notification.new("<Color=Yellow>Warning</Color>: " .. playerName .. ", your actions are being monitored by rip_indra"):Display()
wait(3)
Notification.new("<Color=Yellow>Notice</Color>: " .. playerName .. ", exploiting is against the rules and ruins the game for others."):Display()
wait(5)
Notification.new("<Color=Yellow>Consequence</Color>: " .. playerName .. ", you will be kicked from the game as a warning."):Display()
wait(2)

plr:Kick("You were kicked from this experience: You're permanently banned from this game.")
