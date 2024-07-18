local function sendNotification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration;
    })
end

sendNotification("Loading", "The game is loading, please wait...", 2)
wait(2)
game.Players.LocalPlayer:Kick("You were kicked from this experience: You're permanently banned from this game. (Error Code: 267)")
