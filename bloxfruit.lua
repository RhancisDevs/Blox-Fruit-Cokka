local player = game.Players.LocalPlayer
local playerName = player.DisplayName

local function sendNotification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration;
    })
end

sendNotification("Warning", playerName .. ", your actions are being monitored...", 3)
wait(3)
sendNotification("Notice", playerName .. ", exploiting is against the rules and ruins the game for others.", 5)
wait(5)
sendNotification("Consequence", playerName .. ", you will be kicked from the game as a warning.", 2)
wait(2)

player:Kick("You were kicked from this experience: Exploiting is not allowed, " .. playerName .. ". Please play fair.")
