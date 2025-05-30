-- KeyAuth.cc API 1.3 Integration for Phantom.exe
print("🚀 Starting Phantom.exe KeyAuth 1.3 System...")

local function createKeyAuthSystem()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    
    -- KeyAuth Configuration (API 1.3 - No secret needed!)
    local KEYAUTH_CONFIG = {
        name = "PHANTOM.EXE",        -- Your KeyAuth app name
        ownerid = "a3htS88XUH",      -- Your KeyAuth owner ID
        version = "1.0"              -- Your app version
    }
    
    local function initializeKeyAuth()
        local url = "https://keyauth.win/api/1.3/"
        local params = "?type=init&name=" .. KEYAUTH_CONFIG.name .. 
                      "&ownerid=" .. KEYAUTH_CONFIG.ownerid .. 
                      "&version=" .. KEYAUTH_CONFIG.version
        
        print("🔍 Initializing KeyAuth API 1.3...")
        print("📡 Init URL:", url .. params)
        
        local success, response = pcall(function()
            return game:HttpGet(url .. params)
        end)
        
        if success then
            print("📥 Init response:", response)
            local parseSuccess, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(response)
            end)
            
            if parseSuccess and data.success then
                print("✅ KeyAuth 1.3 initialized successfully")
                return data.sessionid, data.message
            else
                print("❌ KeyAuth init failed:", data.message or "Unknown error")
                return false, data.message or "Initialization failed"
            end
        else
            print("❌ Network error during KeyAuth init:", response)
            return false, "Network error"
        end
    end
    
    local function validateLicense(license, sessionid)
        local url = "https://keyauth.win/api/1.3/"
        local params = "?type=license&key=" .. license .. 
                      "&sessionid=" .. sessionid .. 
                      "&name=" .. KEYAUTH_CONFIG.name .. 
                      "&ownerid=" .. KEYAUTH_CONFIG.ownerid .. 
                      "&hwid=" .. hwid
        
        print("🔍 Validating license:", license)
        print("📡 License URL:", url .. params)
        
        local success, response = pcall(function()
            return game:HttpGet(url .. params)
        end)
        
        if success then
            print("📥 License response:", response)
            local parseSuccess, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(response)
            end)
            
            if parseSuccess then
                if data.success then
                    return true, "License valid! Welcome " .. (data.info and data.info.username or "User")
                else
                    return false, data.message or "License validation failed"
                end
            else
                return false, "Invalid response format"
            end
        else
            print("❌ Network error during license validation:", response)
            return false, "Network error"
        end
    end
    
    local function validateLogin(username, password, sessionid)
        local url = "https://keyauth.win/api/1.3/"
        local params = "?type=login&username=" .. username .. 
                      "&pass=" .. password .. 
                      "&sessionid=" .. sessionid .. 
                      "&name=" .. KEYAUTH_CONFIG.name .. 
                      "&ownerid=" .. KEYAUTH_CONFIG.ownerid .. 
                      "&hwid=" .. hwid
        
        print("🔍 Validating login:", username)
        print("📡 Login URL:", url .. params)
        
        local success, response = pcall(function()
            return game:HttpGet(url .. params)
        end)
        
        if success then
            print("📥 Login response:", response)
            local parseSuccess, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(response)
            end)
            
            if parseSuccess then
                if data.success then
                    return true, "Login successful! Welcome " .. (data.info and data.info.username or username)
                else
                    return false, data.message or "Login failed"
                end
            else
                return false, "Invalid response format"
            end
        else
            print("❌ Network error during login:", response)
            return false, "Network error"
        end
    end
    
    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
    local PasswordBox = Instance.new("TextBox")
    local LicenseBox = Instance.new("TextBox")
    local LoginButton = Instance.new("TextButton")
    local LicenseButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    local StatusLabel = Instance.new("TextLabel")
    local HWIDLabel = Instance.new("TextLabel")
    local InfoLabel = Instance.new("TextLabel")
    local Divider = Instance.new("Frame")
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "PhantomKeyAuth13System"
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 450, 0, 500)
    Frame.Position = UDim2.new(0.5, -225, 0.5, -250)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    
    -- Add corner radius and glow effect
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = Frame
    
    -- Title
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.Text = "🔐 Phantom.exe KeyAuth"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    
    -- Info Label
    InfoLabel.Parent = Frame
    InfoLabel.Size = UDim2.new(0.9, 0, 0, 30)
    InfoLabel.Position = UDim2.new(0.05, 0, 0.14, 0)
    InfoLabel.Text = "Choose your authentication method:"
    InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextSize = 12
    InfoLabel.Font = Enum.Font.Gotham
    
    -- HWID Display
    HWIDLabel.Parent = Frame
    HWIDLabel.Size = UDim2.new(0.9, 0, 0, 30)
    HWIDLabel.Position = UDim2.new(0.05, 0, 0.2, 0)
    HWIDLabel.Text = "HWID: " .. hwid:sub(1, 30) .. "..."
    HWIDLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    HWIDLabel.BackgroundTransparency = 1
    HWIDLabel.TextSize = 9
    HWIDLabel.Font = Enum.Font.Gotham
    
    -- License Key Section
    local licenseLabel = Instance.new("TextLabel")
    licenseLabel.Parent = Frame
    licenseLabel.Size = UDim2.new(0.9, 0, 0, 25)
    licenseLabel.Position = UDim2.new(0.05, 0, 0.28, 0)
    licenseLabel.Text = "🎫 License Key Authentication"
    licenseLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    licenseLabel.BackgroundTransparency = 1
    licenseLabel.TextSize = 14
    licenseLabel.Font = Enum.Font.GothamBold
    
    -- License Input
    LicenseBox.Parent = Frame
    LicenseBox.Size = UDim2.new(0.85, 0, 0, 40)
    LicenseBox.Position = UDim2.new(0.075, 0, 0.34, 0)
    LicenseBox.PlaceholderText = "Enter your license key..."
    LicenseBox.Text = ""
    LicenseBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    LicenseBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    LicenseBox.BorderSizePixel = 0
    LicenseBox.TextSize = 13
    LicenseBox.Font = Enum.Font.Gotham
    
    local licenseCorner = Instance.new("UICorner")
    licenseCorner.CornerRadius = UDim.new(0, 6)
    licenseCorner.Parent = LicenseBox
    
    -- License Button
    LicenseButton.Parent = Frame
    LicenseButton.Size = UDim2.new(0.85, 0, 0, 40)
    LicenseButton.Position = UDim2.new(0.075, 0, 0.42, 0)
    LicenseButton.Text = "🎫 Validate License"
    LicenseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LicenseButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    LicenseButton.BorderSizePixel = 0
    LicenseButton.TextSize = 14
    LicenseButton.Font = Enum.Font.GothamBold
    
    local licenseButtonCorner = Instance.new("UICorner")
    licenseButtonCorner.CornerRadius = UDim.new(0, 6)
    licenseButtonCorner.Parent = LicenseButton
    
    -- Divider
    Divider.Parent = Frame
    Divider.Size = UDim2.new(0.9, 0, 0, 2)
    Divider.Position = UDim2.new(0.05, 0, 0.52, 0)
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Divider.BorderSizePixel = 0
    
    -- Login Section
    local loginLabel = Instance.new("TextLabel")
    loginLabel.Parent = Frame
    loginLabel.Size = UDim2.new(0.9, 0, 0, 25)
    loginLabel.Position = UDim2.new(0.05, 0, 0.56, 0)
    loginLabel.Text = "👤 Username/Password Authentication"
    loginLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    loginLabel.BackgroundTransparency = 1
    loginLabel.TextSize = 14
    loginLabel.Font = Enum.Font.GothamBold
    
    -- Username Input
    TextBox.Parent = Frame
    TextBox.Size = UDim2.new(0.85, 0, 0, 35)
    TextBox.Position = UDim2.new(0.075, 0, 0.62, 0)
    TextBox.PlaceholderText = "Username..."
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TextBox.BorderSizePixel = 0
    TextBox.TextSize = 13
    TextBox.Font = Enum.Font.Gotham
    
    local usernameCorner = Instance.new("UICorner")
    usernameCorner.CornerRadius = UDim.new(0, 6)
    usernameCorner.Parent = TextBox
    
    -- Password Input
    PasswordBox.Parent = Frame
    PasswordBox.Size = UDim2.new(0.85, 0, 0, 35)
    PasswordBox.Position = UDim2.new(0.075, 0, 0.69, 0)
    PasswordBox.PlaceholderText = "Password..."
    PasswordBox.Text = ""
    PasswordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    PasswordBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    PasswordBox.BorderSizePixel = 0
    PasswordBox.TextSize = 13
    PasswordBox.Font = Enum.Font.Gotham
    PasswordBox.TextTransparency = 0 -- Will be made secure in click handler
    
    local passwordCorner = Instance.new("UICorner")
    passwordCorner.CornerRadius = UDim.new(0, 6)
    passwordCorner.Parent = PasswordBox
    
    -- Login Button
    LoginButton.Parent = Frame
    LoginButton.Size = UDim2.new(0.85, 0, 0, 40)
    LoginButton.Position = UDim2.new(0.075, 0, 0.76, 0)
    LoginButton.Text = "👤 Login"
    LoginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoginButton.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
    LoginButton.BorderSizePixel = 0
    LoginButton.TextSize = 14
    LoginButton.Font = Enum.Font.GothamBold
    
    local loginButtonCorner = Instance.new("UICorner")
    loginButtonCorner.CornerRadius = UDim.new(0, 6)
    loginButtonCorner.Parent = LoginButton
    
    -- Status Label
    StatusLabel.Parent = Frame
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 80)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.84, 0)
    StatusLabel.Text = "🔄 Initializing KeyAuth 1.3 connection..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    
    -- Initialize KeyAuth on startup
    local sessionid, initMessage = initializeKeyAuth()
    
    if sessionid then
        StatusLabel.Text = "✅ KeyAuth 1.3 connected! Choose authentication method above."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        StatusLabel.Text = "❌ KeyAuth connection failed: " .. (initMessage or "Unknown error")
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        LicenseButton.Text = "⚠️ Connection Failed"
        LoginButton.Text = "⚠️ Connection Failed"
        LicenseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        LoginButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        return
    end
    
    -- License Button Logic
    LicenseButton.MouseButton1Click:Connect(function()
        local license = LicenseBox.Text
        
        if license == "" then
            StatusLabel.Text = "❌ Please enter a license key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        if not sessionid then
            StatusLabel.Text = "❌ KeyAuth not properly initialized!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        StatusLabel.Text = "🔄 Validating license with KeyAuth..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        LicenseButton.Text = "Validating..."
        LicenseButton.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
        
        wait(0.5)
        
        local success, message = validateLicense(license, sessionid)
        
        if success then
            StatusLabel.Text = "✅ License validation successful!\n" .. message
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            LicenseButton.Text = "Loading Phantom.exe..."
            LicenseButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            
            wait(1.5)
            ScreenGui:Destroy()
            
            print("🎉 KeyAuth license validation passed! Loading Phantom.exe...")
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "❌ License validation failed:\n" .. message
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            LicenseButton.Text = "🎫 Validate License"
            LicenseButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            LicenseBox.Text = ""
        end
    end)
    
    -- Login Button Logic
    LoginButton.MouseButton1Click:Connect(function()
        local username = TextBox.Text
        local password = PasswordBox.Text
        
        if username == "" or password == "" then
            StatusLabel.Text = "❌ Please enter both username and password!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        if not sessionid then
            StatusLabel.Text = "❌ KeyAuth not properly initialized!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        StatusLabel.Text = "🔄 Authenticating with KeyAuth..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        LoginButton.Text = "Authenticating..."
        LoginButton.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
        
        wait(0.5)
        
        local success, message = validateLogin(username, password, sessionid)
        
        if success then
            StatusLabel.Text = "✅ Login successful!\n" .. message
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            LoginButton.Text = "Loading Phantom.exe..."
            LoginButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            
            wait(1.5)
            ScreenGui:Destroy()
            
            print("🎉 KeyAuth login successful! Loading Phantom.exe...")
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "❌ Authentication failed:\n" .. message
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            LoginButton.Text = "👤 Login"
            LoginButton.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
            TextBox.Text = ""
            PasswordBox.Text = ""
        end
    end)
    
    print("✅ KeyAuth 1.3 system loaded successfully")
    print("📋 App Name:", KEYAUTH_CONFIG.name)
    print("👤 Owner ID:", KEYAUTH_CONFIG.ownerid)
    print("🔑 Session ID:", sessionid or "Failed to initialize")
end

createKeyAuthSystem()
