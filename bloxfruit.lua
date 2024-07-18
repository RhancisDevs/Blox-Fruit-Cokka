local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local playerName = player.DisplayName
local playerId = player.UserId

local discordWebhookUrl = "https://discord.com/api/webhooks/1068114144928219177/t7L1Zo9V8nhfJcuz58OCSs6qnQp2hGFLXc-958qX8zmsq3qC_3-kABdGax0fI6rjUAXN"

local function sendNotification(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration;
    })
end

local function sendToDiscord(name, id)
    local data = {
        ["content"] = "Exploit attempt detected!",
        ["embeds"] = {{
            ["title"] = "Exploit Attempt",
            ["description"] = "Player Details:",
            ["fields"] = {
                {["name"] = "Username", ["value"] = name, ["inline"] = true},
                {["name"] = "UserId", ["value"] = tostring(id), ["inline"] = true}
            },
            ["color"] = 16711680
        }}
    }
    
    local headers = {
        ["Content-Type"] = "application/json"
    }
    
    local jsonData = HttpService:JSONEncode(data)
    HttpService:PostAsync(discordWebhookUrl, jsonData, Enum.HttpContentType.ApplicationJson, false, headers)
end

sendNotification("Warning", playerName .. ", your actions are being monitored...", 3)
wait(3)
sendNotification("Notice", playerName .. ", exploiting is against the rules and ruins the game for others.", 5)
wait(5)
sendNotification("Consequence", playerName .. ", you will be kicked from the game as a warning.", 2)
wait(2)

sendToDiscord(playerName, playerId)

player:Kick("You were kicked from this experience: Exploiting is not allowed, " .. playerName .. ". Please play fair. (Error Code: 267)")
