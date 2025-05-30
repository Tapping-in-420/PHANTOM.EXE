-- Fixed Auth.gg Key System for Phantom.exe
local function createKeySystem()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local APP_ID = "34033"
    
    local function checkKey(key)
        -- Updated API endpoint format
        local url = "https://developers.auth.gg/HWID/?type=key&authorization=" .. key .. "&app=" .. APP_ID .. "&hwid=" .. hwid
        print("🔍 Debug - Checking URL:", url)
        
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success then
            print("🔍 Debug - Raw response:", response)
            local parseSuccess, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(response)
            end)
            
            if parseSuccess then
                print("🔍 Debug - Parsed data:", data)
                print("🔍 Debug - Status:", data.status)
                -- Check for both "success" and "key_valid" responses
                return data.status == "success" or data.status == "key_valid"
            else
                print("🔍 Debug - JSON parse failed:", data)
            end
        else
            print("🔍 Debug - HTTP request failed:", response)
        end
        
        return false
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
    local SubmitButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 350, 0, 200)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0.3, 0)
    Title.Text = "Phantom.exe Key System"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextSize = 18
    
    TextBox.Parent = Frame
    TextBox.Size = UDim2.new(0.8, 0, 0.25, 0)
    TextBox.Position = UDim2.new(0.1, 0, 0.4, 0)
    TextBox.PlaceholderText = "Enter your key here..."
    TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    SubmitButton.Parent = Frame
    SubmitButton.Size = UDim2.new(0.8, 0, 0.25, 0)
    SubmitButton.Position = UDim2.new(0.1, 0, 0.7, 0)
    SubmitButton.Text = "Submit Key"
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    SubmitButton.MouseButton1Click:Connect(function()
        local key = TextBox.Text
        print("🔑 Attempting to validate key:", key)
        
        if checkKey(key) then
            print("✅ Key validation successful!")
            ScreenGui:Destroy()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            print("❌ Key validation failed!")
            TextBox.Text = ""
            TextBox.PlaceholderText = "Invalid key! Try again..."
        end
    end)
    
    print("🚀 Key system loaded. App ID:", APP_ID)
end

createKeySystem()
