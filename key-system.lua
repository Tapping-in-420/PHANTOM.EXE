-- Hybrid Key System - Auth.gg + Backup validation
print("🚀 Starting Phantom.exe Hybrid Key System...")

local function createKeySystem()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    
    -- Your Auth.gg credentials
    local APP_ID = "34033"
    local APP_SECRET = "BDzsD5aoli0c70lFcSDm1YgfmVqfaqWa573"
    local AUTH_KEY = "GENJMYJCFPJP"
    
    -- Backup key validation (in case Auth.gg fails)
    local validLicenses = {
        ["MRZ5MKCU"] = {hwid = nil, expires = nil}, -- Your Auth.gg license
        ["PHANTOM_VIP_2024"] = {hwid = nil, expires = nil},
        ["ELITE_ACCESS_777"] = {hwid = nil, expires = nil}
    }
    
    print("✅ App ID:", APP_ID)
    print("✅ HWID:", hwid)
    
    -- Try Auth.gg first, then backup
    local function validateLicense(licenseKey)
        print("🔍 Validating license:", licenseKey)
        
        -- Method 1: Try Auth.gg
        local authGGSuccess, authGGResult = pcall(function()
            local url = "https://api.auth.gg/v1/"
            local postData = "type=info&aid=" .. APP_ID .. "&apikey=" .. AUTH_KEY .. "&secret=" .. APP_SECRET
            
            print("📡 Testing Auth.gg connection...")
            local response = game:HttpGet(url .. "?" .. postData, true)
            print("📥 Auth.gg response:", response)
            
            local data = game:GetService("HttpService"):JSONDecode(response)
            if data.status == "Enabled" then
                print("✅ Auth.gg connection successful")
                -- Now try license validation with login method
                local loginData = "type=login&aid=" .. APP_ID .. "&apikey=" .. AUTH_KEY .. "&secret=" .. APP_SECRET .. "&username=" .. licenseKey .. "&password=" .. licenseKey
                local loginResponse = game:HttpGet(url .. "?" .. loginData, true)
                print("📥 License check response:", loginResponse)
                
                local loginResult = game:GetService("HttpService"):JSONDecode(loginResponse)
                return loginResult.result == "success"
            end
            return false
        end)
        
        if authGGSuccess and authGGResult then
            print("✅ Auth.gg validation successful!")
            return true
        else
            print("⚠️ Auth.gg failed, trying backup validation...")
            
            -- Method 2: Backup validation with HWID locking
            if validLicenses[licenseKey] then
                local license = validLicenses[licenseKey]
                
                if license.hwid == nil then
                    -- First time use - bind to this HWID
                    license.hwid = hwid
                    print("🔒 License bound to HWID:", hwid)
                    return true
                elseif license.hwid == hwid then
                    -- Same computer - allow access
                    print("✅ HWID match - access granted")
                    return true
                else
                    -- Different computer - deny access
                    print("❌ HWID mismatch - access denied")
                    return false
                end
            end
        end
        
        print("❌ Invalid license")
        return false
    end
    
    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
    local SubmitButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    local StatusLabel = Instance.new("TextLabel")
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "PhantomHybridAuth"
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 400, 0, 300)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = Frame
    
    -- Title
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Text = "🔐 Phantom.exe License System"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    
    -- License Input
    TextBox.Parent = Frame
    TextBox.Size = UDim2.new(0.85, 0, 0, 45)
    TextBox.Position = UDim2.new(0.075, 0, 0.3, 0)
    TextBox.PlaceholderText = "Enter your license key..."
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TextBox.BorderSizePixel = 0
    TextBox.TextSize = 14
    TextBox.Font = Enum.Font.Gotham
    
    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 8)
    textboxCorner.Parent = TextBox
    
    -- Submit Button
    SubmitButton.Parent = Frame
    SubmitButton.Size = UDim2.new(0.85, 0, 0, 45)
    SubmitButton.Position = UDim2.new(0.075, 0, 0.55, 0)
    SubmitButton.Text = "🚀 Validate License"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    SubmitButton.BorderSizePixel = 0
    SubmitButton.TextSize = 16
    SubmitButton.Font = Enum.Font.GothamBold
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = SubmitButton
    
    -- Status Label
    StatusLabel.Parent = Frame
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 50)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
    StatusLabel.Text = "Ready to validate license..."
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    
    -- Button Logic
    SubmitButton.MouseButton1Click:Connect(function()
        local licenseKey = TextBox.Text
        
        if licenseKey == "" then
            StatusLabel.Text = "❌ Please enter a license key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        StatusLabel.Text = "🔄 Validating license..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        SubmitButton.Text = "Validating..."
        SubmitButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        wait(1)
        
        if validateLicense(licenseKey) then
            StatusLabel.Text = "✅ License valid! Loading Phantom.exe..."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            SubmitButton.Text = "Loading Script..."
            
            wait(1)
            ScreenGui:Destroy()
            
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "❌ Invalid license or HWID mismatch!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            SubmitButton.Text = "🚀 Validate License"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            TextBox.Text = ""
        end
    end)
    
    TextBox:CaptureFocus()
    print("✅ Hybrid key system loaded!")
end

local success, error = pcall(createKeySystem)
if not success then
    print("❌ Error:", error)
end
