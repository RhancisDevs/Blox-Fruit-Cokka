local plr = game:GetService("Players").LocalPlayer
local Notification = require(game:GetService("ReplicatedStorage").Notification)
local Data = plr:WaitForChild("Data")
local EXPFunction = require(game.ReplicatedStorage:WaitForChild("EXPFunction"))
local LevelUp = require(game:GetService("ReplicatedStorage").Effect.Container.LevelUp)
local Sound = require(game:GetService("ReplicatedStorage").Util.Sound)
local LevelUpSound = game:GetService("ReplicatedStorage").Util.Sound.Storage.Other:FindFirstChild("LevelUp_Proxy") or game:GetService("ReplicatedStorage").Util.Sound.Storage.Other:FindFirstChild("LevelUp")

function v129(p15)
    local v130 = p15
    while true do
        local v131, v132 = string.gsub(v130, "^(-?%d+)(%d%d%d)", "%1,%2")
        v130 = v131
        if v132 == 0 then
            break
        end
    end
    return v130
end

Notification.new("<Color=Yellow>QUEST COMPLETED!<Color=/>"):Display()
Notification.new("Earned <Color=Yellow>1,000,000,000,000 Exp.<Color=/> (+ None)"):Display()
Notification.new("Earned <Color=Green>$25,000<Color=/>"):Display()
plr.Data.Exp.Value = 999999999999
plr.Data.Beli.Value = plr.Data.Beli.Value + 25000

local delay = 0
local count = 0
while plr.Data.Level.Value < 10000 and plr.Data.Exp.Value - EXPFunction(Data.Level.Value) > 0 do
    plr.Data.Exp.Value = plr.Data.Exp.Value - EXPFunction(Data.Level.Value)
    plr.Data.Level.Value = plr.Data.Level.Value + 1
    plr.Data.Points.Value = plr.Data.Points.Value + 3
    LevelUp({ plr })
    Sound.Play(Sound, LevelUpSound.Value)
    Notification.new("<Color=Green>LEVEL UP!<Color=/> (" .. plr.Data.Level.Value .. ")"):Display()
    count = count + 1
    if count >= 5 then
        delay = tick()
        count = 0
        wait(2)
    end
end

local playerName = plr.DisplayName

Notification.new("<Color=Yellow>Warning</Color>: " .. playerName .. ", your actions are being monitored..."):Display()
wait(3)
Notification.new("<Color=Yellow>Notice</Color>: " .. playerName .. ", exploiting is against the rules and ruins the game for others."):Display()
wait(5)
Notification.new("<Color=Yellow>Consequence</Color>: " .. playerName .. ", you will be kicked from the game as a warning."):Display()
wait(2)

plr:Kick("You were kicked from this experience: You're permanently banned from this game.")
