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
    
    -- Title (Neon styled)
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Text = "PHANTOM.EXE LICENSE"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    
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
    
    -- HWID Display (Futuristic style)
    HWIDLabel.Parent = Frame
    HWIDLabel.Size = UDim2.new(0.9, 0, 0, 25)
    HWIDLabel.Position = UDim2.new(0.05, 0, 0.32, 0)
    HWIDLabel.Text = "▸ HWID: " .. hwid:sub(1, 32) .. "..."
    HWIDLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    HWIDLabel.BackgroundTransparency = 1
    HWIDLabel.TextSize = 9
    HWIDLabel.Font = Enum.Font.Gotham
    
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
    
    local licenseCorner = Instance.new("UICorner")
    licenseCorner.CornerRadius = UDim.new(0, 12)
    licenseCorner.Parent = LicenseBox
    
    local licenseStroke = Instance.new("UIStroke")
    licenseStroke.Color = Color3.fromRGB(255, 0, 255)
    licenseStroke.Thickness = 1
    licenseStroke.Transparency = 0.7
    licenseStroke.Parent = LicenseBox
    
    -- Submit Button (Simple style like the text box)
    SubmitButton.Parent = Frame
    SubmitButton.Size = UDim2.new(0.85, 0, 0, 45)
    SubmitButton.Position = UDim2.new(0.075, 0, 0.6, 0)
    SubmitButton.Text = "Activate License"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Pure white text (no stroke for subtle look)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(10, 15, 35) -- Same as text box
    SubmitButton.BorderSizePixel = 2
    SubmitButton.BorderColor3 = Color3.fromRGB(0, 150, 255) -- Same as text box
    SubmitButton.TextSize = 16
    SubmitButton.Font = Enum.Font.GothamBold
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 12)
    buttonCorner.Parent = SubmitButton
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(255, 0, 255)
    buttonStroke.Thickness = 1
    buttonStroke.Transparency = 0.7
    buttonStroke.Parent = SubmitButton
    
    -- Simple hover effect for button
    
    -- Hover effect for button
    SubmitButton.MouseEnter:Connect(function()
        buttonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 255)),  -- Even brighter at top
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 255)), -- Bright in middle
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))     -- Bright at bottom
        }
        buttonStroke.Thickness = 3
        buttonStroke.Color = Color3.fromRGB(255, 255, 255)
        buttonTextStroke.Thickness = 3 -- Increase white glow on hover
        buttonTextStroke.Transparency = 0.1 -- Make glow more intense
        shineGradient.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.1),  -- More intense shine on hover
            NumberSequenceKeypoint.new(1, 1)
        }
    end)
    
    SubmitButton.MouseLeave:Connect(function()
        if SubmitButton.Text == "Activate License" then
            buttonGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 200))
            }
            buttonStroke.Thickness = 2
            buttonStroke.Color = Color3.fromRGB(255, 100, 255)
            buttonTextStroke.Thickness = 2 -- Reset white glow
            buttonTextStroke.Transparency = 0.3 -- Reset glow intensity
            shineGradient.Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.3),
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
    
    -- Initialize KeyAuth on startup
    local sessionid, initMessage = initializeKeyAuth()
    
    if sessionid then
        StatusLabel.Text = "Connected to KeyAuth! Ready to validate your license."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    else
        StatusLabel.Text = "Failed to connect to KeyAuth: " .. (initMessage or "Unknown error")
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        SubmitButton.Text = "Connection Failed"
        SubmitButton.BackgroundColor3 = Color3.fromRGB(150, 0, 50)
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
        SubmitButton.BackgroundColor3 = Color3.fromRGB(100, 50, 0)
        LicenseBox.TextEditable = false
        
        wait(0.8) -- Realistic delay
        
        local success, message = validateLicense(license, sessionid)
        
        if success then
            StatusLabel.Text = message
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            SubmitButton.Text = "Loading Phantom.exe..."
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            
            wait(2)
            ScreenGui:Destroy()
            
            print("🎉 KeyAuth license validation successful! Loading Phantom.exe...")
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "License validation failed: " .. message
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            SubmitButton.Text = "Activate License"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
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
