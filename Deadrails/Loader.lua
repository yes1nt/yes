local Script = {}
Script.Cache = {}
Script.File = loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Script%20Tools/File%20System.lua"))()
Script.Cache.Config = {
    AutoFarming = false
}
Script.File.Save("FriedPotato/DeadRails/config.json", Script.Cache.Config)
loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Deadrails/Main.lua"))()
