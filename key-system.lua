-- Phantom Key System for Roblox
-- Replace your Keyauth system with this

local PhantomKeySystem = {}

-- Configuration
local CONFIG = {
    API_URL = "https://2d7e5e66-d814-4c12-9524-99dc13ca819e-00-1hy2gw53vhuk4.picard.replit.dev", -- Replace with your Replit URL
    APP_NAME = "Phantom Executor",
    VERSION = "1.0",
    DISCORD_INVITE = "https://discord.gg/DZcZXe8TNa" -- Your actual Discord invite 
}

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local playerHWID = nil
local isValidated = false
local keySystemGUI = nil

-- HWID Generation (unique per user)
local function generateHWID()
    local hwid = LocalPlayer.UserId .. "_" .. game.JobId:sub(1, 8)
    -- Add more unique identifiers for better security
    if game.PlaceId then
        hwid = hwid .. "_" .. tostring(game.PlaceId):sub(1, 6)
    end
    return hwid
end

-- HTTP Request function with error handling
local function makeRequest(endpoint, method, data)
    method = method or "GET"
    
    local success, response = pcall(function()
        if method == "GET" then
            return HttpService:GetAsync(CONFIG.API_URL .. endpoint)
        elseif method == "POST" then
            return HttpService:PostAsync(
                CONFIG.API_URL .. endpoint,
                HttpService:JSONEncode(data or {}),
                Enum.HttpContentType.ApplicationJson
            )
        end
    end)
    
    if success then
        local jsonSuccess, jsonData = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        
        if jsonSuccess then
            return true, jsonData
        else
            return false, "Invalid JSON response"
        end
    else
        return false, response
    end
end

-- Key validation function
local function validateKey(key, hwid)
    local endpoint = "/api/validate/" .. key .. "/" .. hwid
    local success, response = makeRequest(endpoint)
    
    if success then
        return response.valid, response.reason, response.timeLeft
    else
        return false, "Connection error: " .. tostring(response), 0
    end
end

-- Create modern GUI
local function createKeySystemGUI()
    -- Destroy existing GUI if it exists
    if keySystemGUI then
        keySystemGUI:Destroy()
    end
    
    -- Create ScreenGui
    keySystemGUI = Instance.new("ScreenGui")
    keySystemGUI.Name = "PhantomKeySystem"
    keySystemGUI.ResetOnSpawn = false
    keySystemGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = keySystemGUI
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 450, 0, 320)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Drop shadow effect
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Parent = keySystemGUI
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
    shadow.Size = UDim2.new(0, 460, 0, 330)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = mainFrame.ZIndex - 1
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow
    
    -- Header
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "Header"
    headerFrame.Parent = mainFrame
    headerFrame.Size = UDim2.new(1, 0, 0, 60)
    headerFrame.BackgroundColor3 = Color3.fromRGB(102, 126, 234)
    headerFrame.BorderSizePixel = 0
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = headerFrame
    
    -- Fix header corners (bottom should be square)
    local headerBottomFix = Instance.new("Frame")
    headerBottomFix.Parent = headerFrame
    headerBottomFix.Position = UDim2.new(0, 0, 0.7, 0)
    headerBottomFix.Size = UDim2.new(1, 0, 0.3, 0)
    headerBottomFix.BackgroundColor3 = Color3.fromRGB(102, 126, 234)
    headerBottomFix.BorderSizePixel = 0
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = headerFrame
    titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    titleLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    titleLabel.Size = UDim2.new(0.8, 0, 0.8, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔑 " .. CONFIG.APP_NAME .. " Key System"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = headerFrame
    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.Position = UDim2.new(1, -10, 0, 10)
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 59, 59)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Parent = mainFrame
    contentFrame.Position = UDim2.new(0, 0, 0, 60)
    contentFrame.Size = UDim2.new(1, 0, 1, -60)
    contentFrame.BackgroundTransparency = 1
    
    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Parent = contentFrame
    statusLabel.Position = UDim2.new(0, 20, 0, 20)
    statusLabel.Size = UDim2.new(1, -40, 0, 30)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Enter your key to continue:"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 16
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Key input
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Parent = contentFrame
    keyInput.Position = UDim2.new(0, 20, 0, 60)
    keyInput.Size = UDim2.new(1, -40, 0, 40)
    keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    keyInput.BorderSizePixel = 0
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your key here (e.g., ABCD-1234-EFGH-5678)"
    keyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.Gotham
    keyInput.ClearTextOnFocus = false
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = keyInput
    
    -- Validate button
    local validateButton = Instance.new("TextButton")
    validateButton.Name = "ValidateButton"
    validateButton.Parent = contentFrame
    validateButton.Position = UDim2.new(0, 20, 0, 120)
    validateButton.Size = UDim2.new(1, -40, 0, 40)
    validateButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    validateButton.Text = "Validate Key"
    validateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    validateButton.TextSize = 16
    validateButton.Font = Enum.Font.GothamBold
    validateButton.BorderSizePixel = 0
    
    local validateCorner = Instance.new("UICorner")
    validateCorner.CornerRadius = UDim.new(0, 6)
    validateCorner.Parent = validateButton
    
    -- Get key button
    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Name = "GetKeyButton"
    getKeyButton.Parent = contentFrame
    getKeyButton.Position = UDim2.new(0, 20, 0, 170)
    getKeyButton.Size = UDim2.new(0.48, -10, 0, 35)
    getKeyButton.BackgroundColor3 = Color3.fromRGB(102, 126, 234)
    getKeyButton.Text = "Get Key"
    getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyButton.TextSize = 14
    getKeyButton.Font = Enum.Font.Gotham
    getKeyButton.BorderSizePixel = 0
    
    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 6)
    getKeyCorner.Parent = getKeyButton
    
    -- Discord button
    local discordButton = Instance.new("TextButton")
    discordButton.Name = "DiscordButton"
    discordButton.Parent = contentFrame
    discordButton.Position = UDim2.new(0.52, 10, 0, 170)
    discordButton.Size = UDim2.new(0.48, -10, 0, 35)
    discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordButton.Text = "Discord"
    discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordButton.TextSize = 14
    discordButton.Font = Enum.Font.Gotham
    discordButton.BorderSizePixel = 0
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 6)
    discordCorner.Parent = discordButton
    
    -- HWID Label
    local hwidLabel = Instance.new("TextLabel")
    hwidLabel.Name = "HWIDLabel"
    hwidLabel.Parent = contentFrame
    hwidLabel.Position = UDim2.new(0, 20, 1, -30)
    hwidLabel.Size = UDim2.new(1, -40, 0, 20)
    hwidLabel.BackgroundTransparency = 1
    hwidLabel.Text = "HWID: " .. playerHWID
    hwidLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    hwidLabel.TextSize = 10
    hwidLabel.Font = Enum.Font.Gotham
    hwidLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Event handlers
    closeButton.MouseButton1Click:Connect(function()
        keySystemGUI:Destroy()
    end)
    
    getKeyButton.MouseButton1Click:Connect(function()
        setclipboard(CONFIG.DISCORD_INVITE)
        statusLabel.Text = "Discord invite copied to clipboard!"
        statusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
    end)
    
    discordButton.MouseButton1Click:Connect(function()
        setclipboard(CONFIG.DISCORD_INVITE)
        statusLabel.Text = "Discord invite copied to clipboard!"
        statusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
    end)
    
    validateButton.MouseButton1Click:Connect(function()
        local key = keyInput.Text:gsub("%s+", "") -- Remove spaces
        
        if key == "" then
            statusLabel.Text = "Please enter a key!"
            statusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
            return
        end
        
        -- Show loading state
        validateButton.Text = "Validating..."
        validateButton.BackgroundColor3 = Color3.fromRGB(156, 163, 175)
        
        statusLabel.Text = "Validating key..."
        statusLabel.TextColor3 = Color3.fromRGB(251, 191, 36)
        
        -- Validate key
        local isValid, reason, timeLeft = validateKey(key, playerHWID)
        
        if isValid then
            statusLabel.Text = "✅ Key validated successfully!"
            statusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
            
            validateButton.Text = "Success!"
            validateButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
            
            -- Show time left if available
            if timeLeft and timeLeft > 0 then
                local days = math.floor(timeLeft / (24 * 60 * 60 * 1000))
                local hours = math.floor((timeLeft % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000))
                
                if days > 0 then
                    statusLabel.Text = statusLabel.Text .. " (Expires in " .. days .. "d " .. hours .. "h)"
                else
                    statusLabel.Text = statusLabel.Text .. " (Expires in " .. hours .. "h)"
                end
            end
            
            isValidated = true
            
            -- Close GUI after 2 seconds
            wait(2)
            keySystemGUI:Destroy()
            
        else
            statusLabel.Text = "❌ " .. reason
            statusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
            
            validateButton.Text = "Validate Key"
            validateButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        end
    end)
    
    -- Enter key to validate
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            validateButton.MouseButton1Click:Fire()
        end
    end)
    
    -- Make draggable
    local dragToggle = nil
    local dragSpeed = 0.25
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(mainFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
    end
    
    headerFrame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input)
            end
        end
    end)
    
    -- Animate GUI entrance
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, -100)
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 450, 0, 320)
    }):Play()
    
    -- Parent to PlayerGui
    keySystemGUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    return keySystemGUI
end

-- Main initialization function
function PhantomKeySystem.init()
    -- Generate HWID
    playerHWID = generateHWID()
    
    print("🔑 Phantom Key System Initialized")
    print("HWID: " .. playerHWID)
    
    -- Check if already validated (optional: save to file)
    -- For now, always show key system
    
    -- Create and show GUI
    createKeySystemGUI()
    
    -- Wait for validation
    local attempts = 0
    local maxAttempts = 300 -- 5 minutes timeout
    
    while not isValidated and attempts < maxAttempts do
        wait(1)
        attempts = attempts + 1
    end
    
    if isValidated then
        print("✅ Key validation successful!")
        return true
    else
        print("❌ Key validation timeout")
        return false
    end
end

-- Function to check if user is validated
function PhantomKeySystem.isValidated()
    return isValidated
end

-- Function to get player HWID
function PhantomKeySystem.getHWID()
    return playerHWID
end

return PhantomKeySystem
