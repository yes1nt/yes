if getgenv().Password then
	return
end

local KeySystemUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Script%20Tools/KeySystem%20V2"))()
local LootLabs = loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Script%20Tools/Lootlabs%20Module"))()
KeySystemUI("Friedpotato Key System", "Key expires after 24 hours.", nil, LootLabs.GetKeyLink, "https://discord.gg/mhFwYE4aG4", LootLabs.VerifyKey)
