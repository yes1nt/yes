local Script = {}
Script.Cache = {}
Script.File = loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Script%20Tools/File%20System.lua"))()
Script.Cache.Config = {
    AutoFarming = false
}
Script.File.Save("FriedPotato/DeadRails/config.json", Script.Cache.Config)
loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Deadrails/Main.lua"))()
local ToggleButton = loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Script%20Tools/Toggler.lua"))()
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local toggle = ToggleButton.MakeToggle("Friedpotato", function()
	local gui = PlayerGui:FindFirstChild("PremiumUI")
	if not gui then return end
	local frame = gui:FindFirstChild("MainFrame")
	if not frame then return end
	frame.Visible = not frame.Visible
end)
