-- Correct Auth.gg AIO License System for Phantom.exe
print("🚀 Starting Phantom.exe Auth.gg AIO system...")

local function createKeySystem()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    
    -- Your Auth.gg credentials
    local APP_ID = "34033"
    local APP_SECRET = "BDzsD5aoli0c70lFcSDm1YgfmVqfaqWa573"
    local AUTH_KEY = "GENJMYJCFPJP"
    
    print("✅ App ID:", APP_ID)
    print("✅ HWID:", hwid)
    
    -- Auth.gg AIO (All-In-One) License Validation
    local function validateLicense(licenseKey)
        print("🔍 Validating license with Auth.gg AIO:", licenseKey)
        
        local success, result = pcall(function()
            local url = "https://api.auth.gg/v1/"
            
            -- Method 1: AIO License Check (recommended by Auth.gg)
            local postData = "type=license&aid=" .. APP_ID .. "&secret=" .. APP_SECRET .. "&license=" .. licenseKey .. "&hwid=" .. hwid
            
            print("📡 AIO Request URL:", url)
            print("📤 AIO POST data:", postData)
            
            local response = game:HttpGet(url .. "?" .. postData, true)
            print("📥 AIO Raw response:", response)
            
            if response and response ~= "" then
                local data = game:GetService("HttpService"):JSONDecode(response)
                print("📊 AIO Parsed data:", data)
                
                -- Check for success indicators
                if data.result == "success" or data.status == "success" then
                    print("✅ AIO License validation successful!")
                    return true
                elseif data.message then
                    print("❌ Auth.gg AIO message:", data.message)
                    
                    -- Try alternative method if AIO fails
                    print("🔄 Trying alternative registration method...")
                    
                    local regData = "type=register&aid=" .. APP_ID .. "&secret=" .. APP_SECRET .. "&username=" .. licenseKey .. "&password=" .. licenseKey .. "&email=user@example.com&license=" .. licenseKey .. "&hwid=" .. hwid
                    print("📤 Registration data:", regData)
                    
                    local regResponse = game:HttpGet(url .. "?" .. regData, true)
                    print("📥 Registration response:", regResponse)
                    
                    if regResponse and regResponse ~= "" then
                        local regResult = game:GetService("HttpService"):JSONDecode(regResponse)
                        print("📊 Registration result:", regResult)
                        
                        if regResult.result == "success" then
                            print("✅ Registration successful!")
                            return true
                        end
                    end
                end
            end
            
            return false
        end)
        
        if success then
            return result
        else
            print("❌ License validation error:", result)
            return false
        end
    end
    
    -- Create GUI
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
    local SubmitButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    local StatusLabel = Instance.new("TextLabel")
    local InfoLabel = Instance.new("TextLabel")
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "PhantomAuthGGAIO"
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 420, 0, 350)
    Frame.Position = UDim2.new(0.5, -210, 0.5, -175)
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
    Title.Text = "🔐 Phantom.exe Auth.gg License"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    
    -- Info Label
    InfoLabel.Parent = Frame
    InfoLabel.Size = UDim2.new(0.9, 0, 0, 40)
    InfoLabel.Position = UDim2.new(0.05, 0, 0.18, 0)
    InfoLabel.Text = "Protected by Auth.gg with HWID locking & expiration"
    InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextSize = 12
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextWrapped = true
    
    -- License Input
    TextBox.Parent = Frame
    TextBox.Size = UDim2.new(0.85, 0, 0, 45)
    TextBox.Position = UDim2.new(0.075, 0, 0.35, 0)
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
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 60)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.73, 0)
    StatusLabel.Text = "Ready to validate license with Auth.gg..."
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    
    -- HWID Display
    local HWIDLabel = Instance.new("TextLabel")
    HWIDLabel.Parent = Frame
    HWIDLabel.Size = UDim2.new(0.9, 0, 0, 25)
    HWIDLabel.Position = UDim2.new(0.05, 0, 0.92, 0)
    HWIDLabel.Text = "HWID: " .. hwid:sub(1, 25) .. "..."
    HWIDLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    HWIDLabel.BackgroundTransparency = 1
    HWIDLabel.TextSize = 10
    HWIDLabel.Font = Enum.Font.Gotham
    
    -- Button Logic
    SubmitButton.MouseButton1Click:Connect(function()
        local licenseKey = TextBox.Text
        
        if licenseKey == "" then
            StatusLabel.Text = "❌ Please enter a license key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        StatusLabel.Text = "🔄 Validating license with Auth.gg AIO method..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        SubmitButton.Text = "Validating..."
        SubmitButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        wait(1)
        
        if validateLicense(licenseKey) then
            StatusLabel.Text = "✅ License valid! HWID locked. Loading Phantom.exe..."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            SubmitButton.Text = "Loading Script..."
            
            wait(1)
            ScreenGui:Destroy()
            
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "❌ Invalid license, expired, or HWID mismatch! Check console (F9)."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            SubmitButton.Text = "🚀 Validate License"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            TextBox.Text = ""
        end
    end)
    
    TextBox:CaptureFocus()
    print("✅ Auth.gg AIO system loaded!")
end

local success, error = pcall(createKeySystem)
if not success then
    print("❌ Error:", error)
end
