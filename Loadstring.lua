-- Replace YOURUSERNAME and YOURREPO with your actual GitHub info
local PhantomKeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tapping-in-420/YOURREPO/main/PhantomKeySystem.lua"))()

local success = PhantomKeySystem.init()

if success then
    print("🚀 Loading main script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSERNAME/YOURREPO/main/MainScript.lua"))()
else
    print("❌ Key validation failed")
    game.Players.LocalPlayer:Kick("Get a valid key from Discord!")
end
