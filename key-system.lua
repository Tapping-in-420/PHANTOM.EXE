-- Correct Auth.gg Key System for Phantom.exe
local function createKeySystem()
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local APP_ID = "34033"
    local APP_SECRET = "BDzsD5aoli0c70lFcSDm1YgfmVqfaqWa573" -- Your app secret from earlier
    
    local function validateLicense(licenseKey)
        -- Auth.gg license validation endpoint (AIO style)
        local url = "https://api.auth.gg/v1/"
        local postData = "type=license&aid=" .. APP_ID .. "&secret=" .. APP_SECRET .. "&license=" .. licenseKey .. "&hwid=" .. hwid
        
        print("🔍 Debug - Validating license:", licenseKey)
        print("🔍 Debug - HWID:", hwid)
        
        local success, response = pcall(function()
            return game:HttpGet(url .. "?" .. postData, true)
        end)
        
        if success then
            print("🔍 Debug - Raw response:", response)
            
            local parseSuccess, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(response)
            end)
            
            if parseSuccess then
                print("🔍 Debug - Parsed data:", data)
                if data.result then
                    print("🔍 Debug - Result:", data.result)
                    return data.result == "success"
                elseif data.status then
                    print("🔍 Debug - Status:", data.status)
                    return data.status == "success"
                end
            else
                print("🔍 Debug - JSON parse failed:", data)
            end
        else
            print("🔍 Debug - HTTP request failed:", response)
        end
        
        return false
    end
    
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
    Frame.Size = UDim2.new(0, 400, 0, 320)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -160)
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
    Title.Size = UDim2.new(1, 0, 0, 70)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Text = "🔐 Phantom.exe License System"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    
    -- License Input
    TextBox.Parent = Frame
    TextBox.Size = UDim2.new(0.85, 0, 0, 50)
    TextBox.Position = UDim2.new(0.075, 0, 0.3, 0)
    TextBox.PlaceholderText = "Enter your license key..."
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TextBox.BorderSizePixel = 0
    TextBox.TextSize = 16
    TextBox.Font = Enum.Font.Gotham
    
    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 8)
    textboxCorner.Parent = TextBox
    
    -- Submit Button
    SubmitButton.Parent = Frame
    SubmitButton.Size = UDim2.new(0.85, 0, 0, 50)
    SubmitButton.Position = UDim2.new(0.075, 0, 0.5, 0)
    SubmitButton.Text = "🚀 Validate License"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    SubmitButton.BorderSizePixel = 0
    SubmitButton.TextSize = 18
    SubmitButton.Font = Enum.Font.GothamBold
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = SubmitButton
    
    -- Status Label
    StatusLabel.Parent = Frame
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 60)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
    StatusLabel.Text = "Ready to validate license..."
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    
    -- HWID Display (for debugging)
    local HWIDLabel = Instance.new("TextLabel")
    HWIDLabel.Parent = Frame
    HWIDLabel.Size = UDim2.new(0.9, 0, 0, 30)
    HWIDLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
    HWIDLabel.Text = "HWID: " .. hwid:sub(1, 20) .. "..."
    HWIDLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
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
            StatusLabel.Text = "❌ Invalid license or HWID mismatch! Check console for details."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            SubmitButton.Text = "🚀 Validate License"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            TextBox.Text = ""
        end
    end)
    
    -- Auto-focus textbox
    TextBox:CaptureFocus()
    
    print("🔐 Auth.gg License System loaded")
    print("App ID:", APP_ID)
    print("HWID:", hwid)
end

createKeySystem()
