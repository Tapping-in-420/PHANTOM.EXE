-- Simple Auth.gg Key System for Phantom.exe
local function createKeySystem()
    -- Get user's computer ID
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    
    -- Your Auth.gg App ID (replace 34033 with yours if different)
    local APP_ID = "34033"
    
    -- Function to check if key is valid
    local function checkKey(key)
        local url = "https://developers.auth.gg/HWID/?type=key&authorization=" .. key .. "&app=" .. APP_ID
        
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success then
            local data = game:GetService("HttpService"):JSONDecode(response)
            return data.status == "success"
        end
        
        return false
    end
    
    -- Create the key input window
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
        
        if checkKey(key) then
            ScreenGui:Destroy()
            -- Load your main script
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            TextBox.Text = ""
            TextBox.PlaceholderText = "Invalid key! Try again..."
        end
    end)
end

createKeySystem()
