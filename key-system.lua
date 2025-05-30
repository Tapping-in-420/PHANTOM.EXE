-- KeyAuth.cc License-Only System for Phantom.exe
print("🚀 Starting Phantom.exe KeyAuth License System...")

local function createKeyAuthSystem()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    
    -- KeyAuth Configuration (API 1.3)
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
                print("✅ KeyAuth initialized successfully")
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
                    return true, "License activated successfully! Welcome to Phantom.exe"
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
    
    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local LicenseBox = Instance.new("TextBox")
    local SubmitButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    local StatusLabel = Instance.new("TextLabel")
    local HWIDLabel = Instance.new("TextLabel")
    local InfoLabel = Instance.new("TextLabel")
    
    -- Create animated background frames for wave effect
    local WaveFrame1 = Instance.new("Frame")
    local WaveFrame2 = Instance.new("Frame")
    local WaveFrame3 = Instance.new("Frame")
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "PhantomKeyAuthLicense"
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 400, 0, 320)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -160)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.ClipsDescendants = true
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = Frame
    
    -- Wave Layer 1 (Bottom layer - darkest)
    WaveFrame1.Parent = Frame
    WaveFrame1.Size = UDim2.new(2, 0, 1.2, 0)
    WaveFrame1.Position = UDim2.new(-0.5, 0, -0.1, 0)
    WaveFrame1.BackgroundColor3 = Color3.fromRGB(8, 8, 15)
    WaveFrame1.BorderSizePixel = 0
    WaveFrame1.ZIndex = 1
    
    local waveCorner1 = Instance.new("UICorner")
    waveCorner1.CornerRadius = UDim.new(0, 15)
    waveCorner1.Parent = WaveFrame1
    
    -- Wave Layer 2 (Middle layer)
    WaveFrame2.Parent = Frame
    WaveFrame2.Size = UDim2.new(2, 0, 1.2, 0)
    WaveFrame2.Position = UDim2.new(-0.5, 0, -0.1, 0)
    WaveFrame2.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
    WaveFrame2.BorderSizePixel = 0
    WaveFrame2.ZIndex = 2
    WaveFrame2.BackgroundTransparency = 0.3
    
    local waveCorner2 = Instance.new("UICorner")
    waveCorner2.CornerRadius = UDim.new(0, 15)
    waveCorner2.Parent = WaveFrame2
    
    -- Wave Layer 3 (Top layer - purple tint)
    WaveFrame3.Parent = Frame
    WaveFrame3.Size = UDim2.new(2, 0, 1.2, 0)
    WaveFrame3.Position = UDim2.new(-0.5, 0, -0.1, 0)
    WaveFrame3.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
    WaveFrame3.BorderSizePixel = 0
    WaveFrame3.ZIndex = 3
    WaveFrame3.BackgroundTransparency = 0.6
    
    local waveCorner3 = Instance.new("UICorner")
    waveCorner3.CornerRadius = UDim.new(0, 15)
    waveCorner3.Parent = WaveFrame3
    
    -- Create wave animations
    local TweenService = game:GetService("TweenService")
    
    -- Wave 1 Animation (Slow horizontal movement)
    local wave1Tween = TweenService:Create(
        WaveFrame1,
        TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(-0.3, 0, -0.15, 0)}
    )
    
    -- Wave 2 Animation (Medium speed, opposite direction)
    local wave2Tween = TweenService:Create(
        WaveFrame2,
        TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(-0.7, 0, -0.05, 0)}
    )
    
    -- Wave 3 Animation (Fast, vertical movement)
    local wave3Tween = TweenService:Create(
        WaveFrame3,
        TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(-0.4, 0, -0.2, 0)}
    )
    
    -- Start wave animations
    wave1Tween:Play()
    wave2Tween:Play()
    wave3Tween:Play()
    
    -- Title
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Text = "🔐 Phantom.exe License"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 10
    
    -- Info Label
    InfoLabel.Parent = Frame
    InfoLabel.Size = UDim2.new(0.9, 0, 0, 30)
    InfoLabel.Position = UDim2.new(0.05, 0, 0.22, 0)
    InfoLabel.Text = "Enter your premium license key to access Phantom.exe"
    InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextSize = 12
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextWrapped = true
    InfoLabel.ZIndex = 10
    
    -- HWID Display
    HWIDLabel.Parent = Frame
    HWIDLabel.Size = UDim2.new(0.9, 0, 0, 25)
    HWIDLabel.Position = UDim2.new(0.05, 0, 0.32, 0)
    HWIDLabel.Text = "Hardware ID: " .. hwid:sub(1, 32) .. "..."
    HWIDLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    HWIDLabel.BackgroundTransparency = 1
    HWIDLabel.TextSize = 9
    HWIDLabel.Font = Enum.Font.Gotham
    HWIDLabel.ZIndex = 10
    
    -- License Input
    LicenseBox.Parent = Frame
    LicenseBox.Size = UDim2.new(0.85, 0, 0, 45)
    LicenseBox.Position = UDim2.new(0.075, 0, 0.45, 0)
    LicenseBox.PlaceholderText = "Enter your license key here..."
    LicenseBox.Text = ""
    LicenseBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    LicenseBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    LicenseBox.BorderSizePixel = 0
    LicenseBox.TextSize = 14
    LicenseBox.Font = Enum.Font.Gotham
    LicenseBox.ClearTextOnFocus = false
    LicenseBox.ZIndex = 10
    
    local licenseCorner = Instance.new("UICorner")
    licenseCorner.CornerRadius = UDim.new(0, 8)
    licenseCorner.Parent = LicenseBox
    
    -- Submit Button (REMOVED ROCKET EMOJI)
    SubmitButton.Parent = Frame
    SubmitButton.Size = UDim2.new(0.85, 0, 0, 45)
    SubmitButton.Position = UDim2.new(0.075, 0, 0.6, 0)
    SubmitButton.Text = "Activate License"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
    SubmitButton.BorderSizePixel = 0
    SubmitButton.TextSize = 16
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.ZIndex = 10
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = SubmitButton
    
    -- Hover effect for button
    SubmitButton.MouseEnter:Connect(function()
        SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    end)
    
    SubmitButton.MouseLeave:Connect(function()
        if SubmitButton.Text == "Activate License" then
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
        end
    end)
    
    -- Status Label
    StatusLabel.Parent = Frame
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 60)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
    StatusLabel.Text = "🔄 Connecting to KeyAuth servers..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    StatusLabel.ZIndex = 10
    
    -- Initialize KeyAuth on startup
    local sessionid, initMessage = initializeKeyAuth()
    
    if sessionid then
        StatusLabel.Text = "✅ Connected to KeyAuth! Ready to validate your license."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        StatusLabel.Text = "❌ Failed to connect to KeyAuth: " .. (initMessage or "Unknown error")
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        SubmitButton.Text = "Connection Failed"
        SubmitButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        LicenseBox.PlaceholderText = "KeyAuth connection failed..."
        return
    end
    
    -- Submit Button Logic
    SubmitButton.MouseButton1Click:Connect(function()
        local license = LicenseBox.Text:gsub("%s+", "") -- Remove spaces
        
        if license == "" then
            StatusLabel.Text = "❌ Please enter your license key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            -- Shake animation for empty input
            local originalPos = LicenseBox.Position
            for i = 1, 3 do
                LicenseBox.Position = originalPos + UDim2.new(0, 5, 0, 0)
                wait(0.05)
                LicenseBox.Position = originalPos + UDim2.new(0, -5, 0, 0)
                wait(0.05)
            end
            LicenseBox.Position = originalPos
            return
        end
        
        if not sessionid then
            StatusLabel.Text = "❌ KeyAuth not properly initialized!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        -- Update UI for validation
        StatusLabel.Text = "🔄 Validating license with KeyAuth servers..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        SubmitButton.Text = "Validating..."
        SubmitButton.BackgroundColor3 = Color3.fromRGB(150, 150, 0)
        LicenseBox.TextEditable = false
        
        wait(0.8) -- Realistic delay
        
        local success, message = validateLicense(license, sessionid)
        
        if success then
            StatusLabel.Text = "✅ " .. message
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            SubmitButton.Text = "Loading Phantom.exe..."
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            
            wait(2)
            ScreenGui:Destroy()
            
            print("🎉 KeyAuth license validation successful! Loading Phantom.exe...")
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "❌ License validation failed:\n" .. message
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            SubmitButton.Text = "Activate License"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
            LicenseBox.TextEditable = true
            LicenseBox.Text = ""
            
            -- Reset after 2 seconds
        end
    end)
    
    -- Enter key support
    LicenseBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and LicenseBox.Text ~= "" then
            SubmitButton.MouseButton1Click:Fire()
        end
    end)
    
    print("✅ KeyAuth License-Only system loaded successfully")
    print("📋 App Name:", KEYAUTH_CONFIG.name)
    print("👤 Owner ID:", KEYAUTH_CONFIG.ownerid)
    print("🔑 Session ID:", sessionid or "Failed to initialize")
end

createKeyAuthSystem()
