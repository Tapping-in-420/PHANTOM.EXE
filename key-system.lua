-- Correct Auth.gg Integration for Phantom.exe
print("🚀 Starting Phantom.exe Auth.gg System (Correct Method)...")

local function createKeySystem()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    
    -- Your Auth.gg credentials from screenshots
    local APP_ID = "34033"
    local APP_SECRET = "BDzsD5aoli0c70lFcSDm1YgfmVqfaqWa573"
    local AUTH_KEY = "GENJMYJCFPJP"
    
    local function validateLicense(license)
        print("🔍 Validating license:", license)
        print("🔍 User HWID:", hwid)
        
        -- Method 1: Try register with license as username
        local function tryRegister()
            local url = "https://api.auth.gg/v1/"
            local postData = "type=register&aid=" .. APP_ID .. "&apikey=" .. AUTH_KEY .. "&secret=" .. APP_SECRET .. "&username=" .. license .. "&password=" .. license .. "&email=" .. license .. "@phantom.exe&hwid=" .. hwid
            
            print("📡 Register attempt URL:", url)
            print("📤 Register POST data:", postData)
            
            local success, response = pcall(function()
                return game:HttpGet(url .. "?" .. postData, true)
            end)
            
            if success then
                print("📥 Register response:", response)
                local parseSuccess, data = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(response)
                end)
                
                if parseSuccess then
                    if data.result == "success" then
                        return true, "Registered successfully"
                    elseif data.result == "failed" and data.message == "User already exists" then
                        -- User exists, try login
                        return "login", "User exists, trying login"
                    else
                        return false, data.message or "Registration failed"
                    end
                end
            end
            return false, "Network error during registration"
        end
        
        -- Method 2: Try login with license as username
        local function tryLogin()
            local url = "https://api.auth.gg/v1/"
            local postData = "type=login&aid=" .. APP_ID .. "&apikey=" .. AUTH_KEY .. "&secret=" .. APP_SECRET .. "&username=" .. license .. "&password=" .. license .. "&hwid=" .. hwid
            
            print("📡 Login attempt URL:", url)
            print("📤 Login POST data:", postData)
            
            local success, response = pcall(function()
                return game:HttpGet(url .. "?" .. postData, true)
            end)
            
            if success then
                print("📥 Login response:", response)
                local parseSuccess, data = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(response)
                end)
                
                if parseSuccess then
                    if data.result == "success" then
                        return true, "Login successful"
                    else
                        return false, data.message or "Login failed"
                    end
                end
            end
            return false, "Network error during login"
        end
        
        -- Try register first
        local regResult, regMessage = tryRegister()
        
        if regResult == true then
            -- Registration successful
            return true, regMessage
        elseif regResult == "login" then
            -- User exists, try login
            local loginResult, loginMessage = tryLogin()
            return loginResult, loginMessage
        else
            -- Registration failed, try login anyway
            local loginResult, loginMessage = tryLogin()
            if loginResult then
                return true, loginMessage
            else
                return false, "Both registration and login failed: " .. (regMessage or "Unknown error")
            end
        end
    end
    
    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
    local SubmitButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    local StatusLabel = Instance.new("TextLabel")
    local HWIDLabel = Instance.new("TextLabel")
    local InfoLabel = Instance.new("TextLabel")
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "PhantomAuthGGSystem"
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 420, 0, 380)
    Frame.Position = UDim2.new(0.5, -210, 0.5, -190)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = Frame
    
    -- Title
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.Text = "🔐 Phantom.exe Auth.gg"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    
    -- Info Label
    InfoLabel.Parent = Frame
    InfoLabel.Size = UDim2.new(0.9, 0, 0, 35)
    InfoLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
    InfoLabel.Text = "Enter your Auth.gg license key below:"
    InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextSize = 12
    InfoLabel.Font = Enum.Font.Gotham
    
    -- HWID Display
    HWIDLabel.Parent = Frame
    HWIDLabel.Size = UDim2.new(0.9, 0, 0, 40)
    HWIDLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
    HWIDLabel.Text = "HWID: " .. hwid:sub(1, 20) .. "..."
    HWIDLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    HWIDLabel.BackgroundTransparency = 1
    HWIDLabel.TextSize = 10
    HWIDLabel.Font = Enum.Font.Gotham
    
    -- License Input
    TextBox.Parent = Frame
    TextBox.Size = UDim2.new(0.85, 0, 0, 45)
    TextBox.Position = UDim2.new(0.075, 0, 0.4, 0)
    TextBox.PlaceholderText = "Enter Auth.gg license key..."
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TextBox.BorderSizePixel = 0
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.Gotham
    
    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 6)
    textboxCorner.Parent = TextBox
    
    -- Submit Button
    SubmitButton.Parent = Frame
    SubmitButton.Size = UDim2.new(0.85, 0, 0, 45)
    SubmitButton.Position = UDim2.new(0.075, 0, 0.55, 0)
    SubmitButton.Text = "🚀 Validate License"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    SubmitButton.BorderSizePixel = 0
    SubmitButton.TextSize = 16
    SubmitButton.Font = Enum.Font.GothamBold
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = SubmitButton
    
    -- Status Label
    StatusLabel.Parent = Frame
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 80)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
    StatusLabel.Text = "Ready to validate license..."
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    
    -- Button Logic
    SubmitButton.MouseButton1Click:Connect(function()
        local license = TextBox.Text:upper() -- Convert to uppercase
        
        if license == "" then
            StatusLabel.Text = "❌ Please enter a license key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        StatusLabel.Text = "🔄 Connecting to Auth.gg servers..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        SubmitButton.Text = "Validating..."
        SubmitButton.BackgroundColor3 = Color3.fromRGB(150, 150, 0)
        
        wait(0.5) -- Small delay for UX
        
        local success, message = validateLicense(license)
        
        if success then
            StatusLabel.Text = "✅ Auth.gg validation successful!\n" .. message
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            SubmitButton.Text = "Loading Phantom.exe..."
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            
            wait(1.5)
            ScreenGui:Destroy()
            
            -- Load your main script
            print("🎉 Auth.gg validation passed! Loading Phantom.exe...")
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "❌ Auth.gg validation failed:\n" .. message
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            SubmitButton.Text = "🚀 Validate License"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            TextBox.Text = ""
        end
    end)
    
    print("✅ Auth.gg system loaded successfully")
    print("📋 App ID:", APP_ID)
    print("🔑 Auth Key:", AUTH_KEY)
end

createKeySystem()
