-- Fixed Auth.gg System for Phantom.exe
print("🚀 Starting Phantom.exe Auth.gg system...")

local function createKeySystem()
    print("📝 Creating GUI...")
    
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local APP_ID = "34033"
    local APP_SECRET = "BDzsD5aoli0c70lFcSDm1YgfmVqfaqWa573"
    local AUTH_KEY = "GENJMYJCFPJP" -- Your Authorization Key from Auth.gg
    
    print("✅ HWID:", hwid)
    print("✅ App ID:", APP_ID)
    print("✅ Auth Key:", AUTH_KEY)
    
    -- Correct Auth.gg validation function
    local function validateLicense(licenseKey)
        print("🔍 Attempting to validate license:", licenseKey)
        
        local success, result = pcall(function()
            -- Correct Auth.gg API format based on your settings
            local url = "https://api.auth.gg/v1/"
            
            -- Since HWID Check is disabled, we don't need to send HWID
            local postData = "type=login&aid=" .. APP_ID .. "&apikey=" .. AUTH_KEY .. "&secret=" .. APP_SECRET .. "&username=" .. licenseKey .. "&password=" .. licenseKey
            
            print("📡 Making request to:", url)
            print("📤 POST data:", postData)
            
            local response = game:HttpGet(url .. "?" .. postData, true)
            print("📥 Raw response:", response)
            
            if response and response ~= "" then
                local data = game:GetService("HttpService"):JSONDecode(response)
                print("📊 Parsed data:", data)
                
                -- Check various success indicators
                if data.result == "success" or data.status == "success" or data.success == true then
                    return true
                elseif data.message then
                    print("❌ Auth.gg message:", data.message)
                end
            end
            
            return false
        end)
        
        if success then
            print("✅ Validation result:", result)
            return result
        else
            print("❌ Validation error:", result)
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
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "PhantomAuthGG"
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 400, 0, 300)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = Frame
    
    -- Title
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Position = UDim2.new(0, 0, 0, 0)
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
        
        -- Special debug bypass
        if licenseKey == "test" then
            print("🧪 Using debug bypass")
            StatusLabel.Text = "🧪 Debug mode - Loading script..."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
            ScreenGui:Destroy()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
            return
        end
        
        StatusLabel.Text = "🔄 Validating license with Auth.gg..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
        SubmitButton.Text = "Validating..."
        SubmitButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        wait(1) -- Small delay for UX
        
        if validateLicense(licenseKey) then
            StatusLabel.Text = "✅ License valid! Loading Phantom.exe..."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            SubmitButton.Text = "Loading Script..."
            
            wait(1)
            ScreenGui:Destroy()
            
            -- Load your main script
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "❌ Invalid license! Check console (F9) for details."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            SubmitButton.Text = "🚀 Validate License"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            TextBox.Text = ""
        end
    end)
    
    -- Auto-focus textbox
    TextBox:CaptureFocus()
    
    print("✅ GUI created successfully!")
end

-- Wrap in pcall to catch any errors
local success, error = pcall(createKeySystem)

if success then
    print("✅ Auth.gg key system loaded successfully!")
else
    print("❌ Error loading key system:", error)
end
