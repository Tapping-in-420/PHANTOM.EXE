-- Simple Key System for Phantom.exe (Works Immediately)
local function createKeySystem()
    -- Your controlled keys (you can change these anytime)
    local validKeys = {
        "PHANTOM_PREMIUM_2024",
        "ELITE_ACCESS_777",
        "VIP_USER_999",
        "BETA_TESTER_123",
        "SPECIAL_EDITION_456"
    }
    
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
    local SubmitButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    local StatusLabel = Instance.new("TextLabel")
    
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "PhantomKeySystem"
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
    Title.Size = UDim2.new(1, 0, 0, 70)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Text = "🔐 Phantom.exe Access Control"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    
    -- Key Input
    TextBox.Parent = Frame
    TextBox.Size = UDim2.new(0.85, 0, 0, 50)
    TextBox.Position = UDim2.new(0.075, 0, 0.35, 0)
    TextBox.PlaceholderText = "Enter your access key..."
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
    SubmitButton.Position = UDim2.new(0.075, 0, 0.6, 0)
    SubmitButton.Text = "🚀 Launch Phantom.exe"
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
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 40)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.8, 0)
    StatusLabel.Text = "Ready to authenticate..."
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    
    -- Button Logic
    SubmitButton.MouseButton1Click:Connect(function()
        local enteredKey = TextBox.Text
        local keyValid = false
        
        -- Check if key matches any valid key
        for _, key in pairs(validKeys) do
            if enteredKey == key then
                keyValid = true
                break
            end
        end
        
        if keyValid then
            StatusLabel.Text = "✅ Access granted! Loading script..."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            SubmitButton.Text = "Loading..."
            SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
            
            wait(1)
            ScreenGui:Destroy()
            
            -- Load your main script
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tapping-in-420/PHANTOM.EXE/refs/heads/main/PHANTOM.EXE'))()
        else
            StatusLabel.Text = "❌ Invalid access key! Contact admin for key."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            TextBox.Text = ""
            TextBox.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
            wait(2)
            TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            StatusLabel.Text = "Ready to authenticate..."
            StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end)
    
    -- Auto-focus textbox
    TextBox:CaptureFocus()
    
    print("🔐 Phantom.exe Key System loaded")
    print("Valid keys for testing:", table.concat(validKeys, ", "))
end

createKeySystem()
