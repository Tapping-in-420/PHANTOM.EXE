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
    
    -- Create animated neon background with wave effect
    local BackgroundFrame = Instance.new("Frame")
    local WaveFrame1 = Instance.new("Frame")
    local WaveFrame2 = Instance.new("Frame")
    local WaveFrame3 = Instance.new("Frame")
    local NeonOverlay = Instance.new("Frame")
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "PhantomKeyAuthLicense"
    ScreenGui.ResetOnSpawn = false
    
    -- Background Frame (Dark base)
    BackgroundFrame.Parent = ScreenGui
    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    BackgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    BackgroundFrame.BackgroundColor3 = Color3.fromRGB(5, 10, 25)
    BackgroundFrame.BorderSizePixel = 0
    BackgroundFrame.ZIndex = 1
    
    -- Main Frame (Transparent with neon border)
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 420, 0, 340)
    Frame.Position = UDim2.new(0.5, -210, 0.5, -170)
    Frame.BackgroundColor3 = Color3.fromRGB(8, 12, 30)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 3
    Frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
    Frame.Active = true
    Frame.Draggable = true
    Frame.ClipsDescendants = true
    Frame.ZIndex = 5
    
    -- Add corner radius and neon glow effect
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = Frame
    
    -- Neon glow stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = Frame
    
    -- Animated wave backgrounds
    -- Wave Layer 1 (Cyan wave)
    WaveFrame1.Parent = BackgroundFrame
    WaveFrame1.Size = UDim2.new(1.5, 0, 0.3, 0)
    WaveFrame1.Position = UDim2.new(-0.25, 0, 0.7, 0)
    WaveFrame1.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    WaveFrame1.BackgroundTransparency = 0.8
    WaveFrame1.BorderSizePixel = 0
    WaveFrame1.ZIndex = 2
    
    local waveCorner1 = Instance.new("UICorner")
    waveCorner1.CornerRadius = UDim.new(1, 0)
    waveCorner1.Parent = WaveFrame1
    
    -- Wave Layer 2 (Magenta wave)
    WaveFrame2.Parent = BackgroundFrame
    WaveFrame2.Size = UDim2.new(1.5, 0, 0.4, 0)
    WaveFrame2.Position = UDim2.new(-0.25, 0, 0.5, 0)
    WaveFrame2.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    WaveFrame2.BackgroundTransparency = 0.7
    WaveFrame2.BorderSizePixel = 0
    WaveFrame2.ZIndex = 3
    
    local waveCorner2 = Instance.new("UICorner")
    waveCorner2.CornerRadius = UDim.new(1, 0)
    waveCorner2.Parent = WaveFrame2
    
    -- Wave Layer 3 (Blue wave)
    WaveFrame3.Parent = BackgroundFrame
    WaveFrame3.Size = UDim2.new(1.5, 0, 0.35, 0)
    WaveFrame3.Position = UDim2.new(-0.25, 0, 0.3, 0)
    WaveFrame3.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    WaveFrame3.BackgroundTransparency = 0.6
    WaveFrame3.BorderSizePixel = 0
    WaveFrame3.ZIndex = 4
    
    local waveCorner3 = Instance.new("UICorner")
    waveCorner3.CornerRadius = UDim.new(1, 0)
    waveCorner3.Parent = WaveFrame3
    
    -- Create smooth wave animations
    local TweenService = game:GetService("TweenService")
    
    -- Cyan wave animation (flowing right to left)
    local wave1Tween = TweenService:Create(
        WaveFrame1,
        TweenInfo.new(10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(-0.75, 0, 0.65, 0)}
    )
    
    -- Magenta wave animation (flowing left to right)
    local wave2Tween = TweenService:Create(
        WaveFrame2,
        TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(0.25, 0, 0.45, 0)}
    )
    
    -- Blue wave animation (vertical movement)
    local wave3Tween = TweenService:Create(
        WaveFrame3,
        TweenInfo.new(12, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = UDim2.new(-0.5, 0, 0.25, 0)}
    )
    
    -- Neon border color animation
    local borderColorTween = TweenService:Create(
        stroke,
        TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Color = Color3.fromRGB(0, 255, 255)}
    )
    
    -- Start all animations
    wave1Tween:Play()
    wave2Tween:Play()
    wave3Tween:Play()
    borderColorTween:Play()
    
    -- Title (Neon styled)
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Text = "🔐 PHANTOM.EXE LICENSE"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 10
    
    -- Add text stroke for neon glow
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.fromRGB(255, 0, 255)
    titleStroke.Thickness = 1
    titleStroke.Transparency = 0.5
    titleStroke.Parent = Title
    
    -- Info Label (Neon styled)
    InfoLabel.Parent = Frame
    InfoLabel.Size = UDim2.new(0.9, 0, 0, 30)
    InfoLabel.Position = UDim2.new(0.05, 0, 0.22, 0)
    InfoLabel.Text = "▸ Enter your premium license key to access Phantom.exe"
    InfoLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextSize = 12
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextWrapped = true
    InfoLabel.ZIndex = 10
    
    -- HWID Display (Futuristic style)
    HWIDLabel.Parent = Frame
    HWIDLabel.Size = UDim2.new(0.9, 0, 0, 25)
    HWIDLabel.Position = UDim2.new(0.05, 0, 0.32, 0)
    HWIDLabel.Text = "▸ HWID: " .. hwid:sub(1, 32) .. "..."
    HWIDLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    HWIDLabel.BackgroundTransparency = 1
    HWIDLabel.TextSize = 9
    HWIDLabel.Font = Enum.Font.Gotham
    HWIDLabel.ZIndex = 10
    
    -- License Input (Neon styled)
    LicenseBox.Parent = Frame
    LicenseBox.Size = UDim2.new(0.85, 0, 0, 45)
    LicenseBox.Position = UDim2.new(0.075, 0, 0.45, 0)
    LicenseBox.PlaceholderText = "Enter your license key here..."
    LicenseBox.Text = ""
    LicenseBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    LicenseBox.BackgroundColor3 = Color3.fromRGB(10, 15, 35)
    LicenseBox.BorderSizePixel = 2
    LicenseBox.BorderColor3 = Color3.fromRGB(0, 150, 255)
    LicenseBox.TextSize = 14
    LicenseBox.Font = Enum.Font.Gotham
    LicenseBox.ClearTextOnFocus = false
    LicenseBox.ZIndex = 10
    
    local licenseCorner = Instance.new("UICorner")
    licenseCorner.CornerRadius = UDim.new(0, 12)
    licenseCorner.Parent = LicenseBox
    
    local licenseStroke = Instance.new("UIStroke")
    licenseStroke.Color = Color3.fromRGB(255, 0, 255)
    licenseStroke.Thickness = 1
    licenseStroke.Transparency = 0.7
    licenseStroke.Parent = LicenseBox
    
    -- Submit Button (Futuristic neon style)
    SubmitButton.Parent = Frame
    SubmitButton.Size = UDim2.new(0.85, 0, 0, 45)
    SubmitButton.Position = UDim2.new(0.075, 0, 0.6, 0)
    SubmitButton.Text = "► ACTIVATE LICENSE"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
    SubmitButton.BorderSizePixel = 0
    SubmitButton.TextSize = 16
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.ZIndex = 10
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 12)
    buttonCorner.Parent = SubmitButton
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(0, 255, 255)
    buttonStroke.Thickness = 2
    buttonStroke.Transparency = 0.3
    buttonStroke.Parent = SubmitButton
    
    -- Button glow animation
    local buttonGlowTween = TweenService:Create(
        buttonStroke,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Color = Color3.fromRGB(255, 0, 255)}
    )
    buttonGlowTween:Play()
    
    -- Hover effect for button
    SubmitButton.MouseEnter:Connect(function()
        SubmitButton.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
        buttonStroke.Thickness = 3
    end)
    
    SubmitButton.MouseLeave:Connect(function()
        if SubmitButton.Text == "► ACTIVATE LICENSE" then
            SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
            buttonStroke.Thickness = 2
        end
    end)
    
    -- Status Label (Neon styled)
    StatusLabel.Parent = Frame
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 60)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
    StatusLabel.Text = "⟨ ⟩ Connecting to KeyAuth servers..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    StatusLabel.ZIndex = 10
    
    -- Initialize KeyAuth on startup
    local sessionid, initMessage = initializeKeyAuth()
    
    if sessionid then
        StatusLabel.Text = "⟨ ✓ ⟩ Connected to KeyAuth! Ready to validate your license."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    else
        StatusLabel.Text = "⟨ ✗ ⟩ Failed to connect to KeyAuth: " .. (initMessage or "Unknown error")
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        SubmitButton.Text = "► CONNECTION FAILED"
        SubmitButton.BackgroundColor3 = Color3.fromRGB(150, 0, 50)
        LicenseBox.PlaceholderText = "KeyAuth connection failed..."
        return
    end
    
    -- Submit Button Logic
    SubmitButton.MouseButton1Click:Connect(function()
        local license = LicenseBox.Text:gsub("%s+", "") -- Remove spaces
        
        if license == "" then
            StatusLabel.Text = "⟨ ! ⟩ Please enter your license key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
            
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
            StatusLabel.Text = "⟨ ✗ ⟩ KeyAuth not properly initialized!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        -- Update UI for validation
        StatusLabel.Text = "⟨ ⟩ Validating license with KeyAuth servers..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        SubmitButton.Text = "► VALIDATING..."
        SubmitButton.BackgroundColor3 = Color3.fromRGB(100, 50, 0)
        LicenseBox.TextEditable = false
        
        wait(0.8) -- Realistic delay
        
        local success, message = validateLicense(license, sessionid)
        
        if success then
            StatusLabel.Text = "⟨ ✓ ⟩ " .. message
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            SubmitButton.Text = "► LOADING PHANTOM.EXE..."
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            
            wait(2)
            ScreenGui:Destroy()
            
            print("🎉 KeyAuth license validation successful! Loading Phantom.exe...")
        if success then
            StatusLabel.Text = "⟨ ✓ ⟩ " .. message
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            SubmitButton.Text = "► LOADING PHANTOM.EXE..."
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            
            wait(2)
            ScreenGui:Destroy()
            
            print("🎉 KeyAuth license validation successful! Loading Phantom.exe...")
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "⟨ ✗ ⟩ License validation failed:\n" .. message
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            SubmitButton.Text = "► ACTIVATE LICENSE"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
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

createKeyAuthSystem()com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "⟨ ✗ ⟩ License validation failed:\n" .. message
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            SubmitButton.Text = "► ACTIVATE LICENSE"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
            LicenseBox.TextEditable = true
            LicenseBox.Text = ""
            
            -- Reset after 2 seconds
        endcom/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
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
