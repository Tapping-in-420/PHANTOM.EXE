local PhantomKeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/main/key-system.lua"))()
local success = PhantomKeySystem.init()
if success then
    print("🚀 Loading main script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/main/PHANTOM.EXE"))()
else
    print("❌ Key validation failed")
    game.Players.LocalPlayer:Kick("Get a valid key from Discord!")
end
