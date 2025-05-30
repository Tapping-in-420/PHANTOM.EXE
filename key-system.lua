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
    local BackgroundImage = Instance.new("ImageLabel")
    local LicenseBox = Instance.new("TextBox")
    local SubmitButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    local StatusLabel = Instance.new("TextLabel")
    local HWIDLabel = Instance.new("TextLabel")
    local InfoLabel = Instance.new("TextLabel")
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "PhantomKeyAuthLicense"
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame (Futuristic style without complex animations)
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 420, 0, 340)
    Frame.Position = UDim2.new(0.5, -210, 0.5, -170)
    Frame.BackgroundColor3 = Color3.fromRGB(8, 12, 30)
    Frame.BorderSizePixel = 3
    Frame.BorderColor3 = Color3.fromRGB(0, 255, 255)
    Frame.Active = true
    Frame.Draggable = true
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = Frame
    
    -- Neon glow stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = Frame
    
    -- Background Image (Replace the URL with your desired neon futuristic background)
    BackgroundImage.Parent = Frame
    BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
    BackgroundImage.Image = "https://images.unsplash.com/photo-1518709268805-4e9042af2176?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80" -- Replace with your image URL
    BackgroundImage.BackgroundTransparency = 1
    BackgroundImage.ImageTransparency = 0.3 -- Semi-transparent overlay
    BackgroundImage.ScaleType = Enum.ScaleType.Crop
    BackgroundImage.ZIndex = 1
    
    -- Add corner radius to background image
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 20)
    bgCorner.Parent = BackgroundImage
    
    -- Title (Neon styled) - Higher ZIndex to appear above background
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Text = "🔐 PHANTOM.EXE LICENSE"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 2
    
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
    InfoLabel.ZIndex = 2
    
    -- HWID Display (Futuristic style)
    HWIDLabel.Parent = Frame
    HWIDLabel.Size = UDim2.new(0.9, 0, 0, 25)
    HWIDLabel.Position = UDim2.new(0.05, 0, 0.32, 0)
    HWIDLabel.Text = "▸ HWID: " .. hwid:sub(1, 32) .. "..."
    HWIDLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    HWIDLabel.BackgroundTransparency = 1
    HWIDLabel.TextSize = 9
    HWIDLabel.Font = Enum.Font.Gotham
    HWIDLabel.ZIndex = 2
    
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
    LicenseBox.ZIndex = 2
    
    local licenseCorner = Instance.new("UICorner")
    licenseCorner.CornerRadius = UDim.new(0, 12)
    licenseCorner.Parent = LicenseBox
    
    local licenseStroke = Instance.new("UIStroke")
    licenseStroke.Color = Color3.fromRGB(255, 0, 255)
    licenseStroke.Thickness = 1
    licenseStroke.Transparency = 0.7
    licenseStroke.Parent = LicenseBox
    
    -- Submit Button (BRIGHT GLOSSY NEON STYLE)
    SubmitButton.Parent = Frame
    SubmitButton.Size = UDim2.new(0.85, 0, 0, 45)
    SubmitButton.Position = UDim2.new(0.075, 0, 0.6, 0)
    SubmitButton.Text = "Activate License"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Bright white text
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255) -- Bright cyan neon
    SubmitButton.BorderSizePixel = 0
    SubmitButton.TextSize = 16
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.ZIndex = 2
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 12)
    buttonCorner.Parent = SubmitButton
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(100, 255, 255) -- Bright cyan stroke
    buttonStroke.Thickness = 2
    buttonStroke.Transparency = 0.2
    buttonStroke.Parent = SubmitButton
    
    -- Add bright glossy gradient effect
    local buttonGradient = Instance.new("UIGradient")
    buttonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 255)),  -- Bright cyan at top
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),  -- Pure cyan in middle
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 200))     -- Slightly darker cyan at bottom
    }
    buttonGradient.Rotation = 90 -- Vertical gradient
    buttonGradient.Parent = SubmitButton
    
    -- Add bright shine/highlight effect (balanced)
    local shineFrame = Instance.new("Frame")
    shineFrame.Parent = SubmitButton
    shineFrame.Size = UDim2.new(1, 0, 0.35, 0)  -- Good shine coverage
    shineFrame.Position = UDim2.new(0, 0, 0, 0)
    shineFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shineFrame.BackgroundTransparency = 0.6  -- Balanced transparency
    shineFrame.BorderSizePixel = 0
    shineFrame.ZIndex = SubmitButton.ZIndex + 1
    
    local shineCorner = Instance.new("UICorner")
    shineCorner.CornerRadius = UDim.new(0, 12)
    shineCorner.Parent = shineFrame
    
    local shineGradient = Instance.new("UIGradient")
    shineGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 255, 255))  -- Slight cyan tint
    }
    shineGradient.Transparency = NumberSequence.new{
        ColorSequenceKeypoint.new(0, 0.4),  -- Visible but not overpowering
        NumberSequenceKeypoint.new(1, 1)     -- Fade to invisible
    }
    shineGradient.Rotation = 90
    shineGradient.Parent = shineFrame
    
    -- Hover effect for button (darker gloomy style)
    SubmitButton.MouseEnter:Connect(function()
        buttonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 60)),  -- Slightly lighter on hover
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 35, 45)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
        }
        buttonStroke.Thickness = 3
        buttonStroke.Color = Color3.fromRGB(80, 80, 100)
        SubmitButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        shineGradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.5),  -- More visible shine on hover
            NumberSequenceKeypoint.new(1, 1)
        }
    end)
    
    SubmitButton.MouseLeave:Connect(function()
        if SubmitButton.Text == "Activate License" then
            buttonGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 35)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
            }
            buttonStroke.Thickness = 2
            buttonStroke.Color = Color3.fromRGB(60, 60, 80)
            SubmitButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            shineGradient.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.7),
                NumberSequenceKeypoint.new(1, 1)
            }
        end
    end)
    
    -- Status Label (Neon styled)
    StatusLabel.Parent = Frame
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 60)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
    StatusLabel.Text = "Connecting to KeyAuth servers..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    StatusLabel.ZIndex = 2
    
    -- Initialize KeyAuth on startup
    local sessionid, initMessage = initializeKeyAuth()
    
    if sessionid then
        StatusLabel.Text = "Connected to KeyAuth! Ready to validate your license."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    else
        StatusLabel.Text = "Failed to connect to KeyAuth: " .. (initMessage or "Unknown error")
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        SubmitButton.Text = "Connection Failed"
        SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 25, 25)
        LicenseBox.PlaceholderText = "KeyAuth connection failed..."
        return
    end
    
    -- Submit Button Logic
    SubmitButton.MouseButton1Click:Connect(function()
        local license = LicenseBox.Text:gsub("%s+", "") -- Remove spaces
        
        if license == "" then
            StatusLabel.Text = "Please enter your license key!"
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
            StatusLabel.Text = "KeyAuth not properly initialized!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        -- Update UI for validation
        StatusLabel.Text = "Validating license with KeyAuth servers..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        SubmitButton.Text = "Validating..."
        SubmitButton.BackgroundColor3 = Color3.fromRGB(40, 30, 20)
        LicenseBox.TextEditable = false
        
        wait(0.8) -- Realistic delay
        
        local success, message = validateLicense(license, sessionid)
        
        if success then
            StatusLabel.Text = message
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            SubmitButton.Text = "Loading Phantom.exe..."
            SubmitButton.BackgroundColor3 = Color3.fromRGB(20, 40, 30)
            
            wait(2)
            ScreenGui:Destroy()
            
            print("🎉 KeyAuth license validation successful! Loading Phantom.exe...")
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "License validation failed: " .. message
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            SubmitButton.Text = "Activate License"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(35, 20, 30)
            LicenseBox.TextEditable = true
            LicenseBox.Text = ""
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
