-- Phantom Key System with HTTP Bypass
-- Works even when HttpService is disabled

local PhantomKeySystem = {}

-- Configuration
local CONFIG = {
    API_URL = "https://2d7e5e66-d814-4c12-9524-99dc13ca819e-00-1hy2gw53vhuk4.picard.replit.dev:3000",
    APP_NAME = "Phantom Executor",
    VERSION = "1.0",
    DISCORD_INVITE = "https://discord.gg/yourserver"
}

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local playerHWID = nil
local isValidated = false
local keySystemGUI = nil

-- HWID Generation
local function generateHWID()
    local hwid = LocalPlayer.UserId .. "_" .. game.JobId:sub(1, 8)
    if game.PlaceId then
        hwid = hwid .. "_" .. tostring(game.PlaceId):sub(1, 6)
    end
    return hwid
end

-- HTTP Request with multiple bypass methods
local function makeRequest(endpoint, method, data)
    method = method or "GET"
    local url = CONFIG.API_URL .. endpoint
    
    -- Method 1: Try standard HttpService
    local function tryStandardHttp()
        local success, response = pcall(function()
            if method == "GET" then
                return HttpService:GetAsync(url)
            elseif method == "POST" then
                return HttpService:PostAsync(url, HttpService:JSONEncode(data or {}), Enum.HttpContentType.ApplicationJson)
            end
        end)
        
        if success then
            local jsonSuccess, jsonData = pcall(function()
                return HttpService:JSONDecode(response)
            end)
            return jsonSuccess, jsonData
        end
        return false, nil
    end
    
    -- Method 2: Try using game:HttpGet (some executors support this)
    local function tryGameHttpGet()
        if not game.HttpGet then return false, nil end
        
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success then
            local jsonSuccess, jsonData = pcall(function()
                return HttpService:JSONDecode(response)
            end)
            return jsonSuccess, jsonData
        end
        return false, nil
    end
    
    -- Method 3: Try syn.request (Synapse X)
    local function trySynRequest()
        if not syn or not syn.request then return false, nil end
        
        local success, response = pcall(function()
            return syn.request({
                Url = url,
                Method = method,
                Headers = method == "POST" and {["Content-Type"] = "application/json"} or {},
                Body = method == "POST" and HttpService:JSONEncode(data or {}) or nil
            })
        end)
        
        if success and response.Success then
            local jsonSuccess, jsonData = pcall(function()
                return HttpService:JSONDecode(response.Body)
            end)
            return jsonSuccess, jsonData
        end
        return false, nil
    end
    
    -- Method 4: Try http_request (universal)
    local function tryHttpRequest()
        if not http_request then return false, nil end
        
        local success, response = pcall(function()
            return http_request({
                Url = url,
                Method = method,
                Headers = method == "POST" and {["Content-Type"] = "application/json"} or {},
                Body = method == "POST" and HttpService:JSONEncode(data or {}) or nil
            })
        end)
        
        if success and response.Success then
            local jsonSuccess, jsonData = pcall(function()
                return HttpService:JSONDecode(response.Body)
            end)
            return jsonSuccess, jsonData
        end
        return false, nil
    end
    
    -- Method 5: Try request (KRNL/other executors)
    local function tryRequest()
        if not request then return false, nil end
        
        local success, response = pcall(function()
            return request({
                Url = url,
                Method = method,
                Headers = method == "POST" and {["Content-Type"] = "application/json"} or {},
                Body = method == "POST" and HttpService:JSONEncode(data or {}) or nil
            })
        end)
        
        if success and response.Success then
            local jsonSuccess, jsonData = pcall(function()
                return HttpService:JSONDecode(response.Body)
            end)
            return jsonSuccess, jsonData
        end
        return false, nil
    end
    
    -- Try all methods in order
    local methods = {
        tryStandardHttp,
        tryGameHttpGet,
        trySynRequest,
        tryHttpRequest,
        tryRequest
    }
    
    for i, method_func in ipairs(methods) do
        local success, response = method_func()
        if success and response then
            return true, response
        end
    end
    
    return false, "All HTTP methods failed"
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

-- ==================================================================================
-- GUI CODE STARTS HERE - REPLACE THIS SECTION FOR FUTURE GUI UPDATES
-- ==================================================================================
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
    
    -- Main Frame (REMOVED: dragging functionality)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = keySystemGUI
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 480, 0, 350)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BorderSizePixel = 0
    -- REMOVED: mainFrame.Active = true (no dragging)
    -- REMOVED: mainFrame.Draggable = true (no dragging)
    
    -- Main frame gradient
    local mainGradient = Instance.new("UIGradient")
    mainGradient.Parent = mainFrame
    mainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
    }
    mainGradient.Rotation = 45
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainFrame
    
    -- Outer glow effect
    local glowFrame = Instance.new("Frame")
    glowFrame.Name = "GlowFrame"
    glowFrame.Parent = keySystemGUI
    glowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    glowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    glowFrame.Size = UDim2.new(0, 500, 0, 370)
    glowFrame.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    glowFrame.BackgroundTransparency = 0.8
    glowFrame.ZIndex = mainFrame.ZIndex - 1
    glowFrame.BorderSizePixel = 0
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 25)
    glowCorner.Parent = glowFrame
    
    -- Purple accent border
    local accentBorder = Instance.new("Frame")
    accentBorder.Name = "AccentBorder"
    accentBorder.Parent = keySystemGUI
    accentBorder.AnchorPoint = Vector2.new(0.5, 0.5)
    accentBorder.Position = UDim2.new(0.5, 0, 0.5, 0)
    accentBorder.Size = UDim2.new(0, 484, 0, 354)
    accentBorder.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    accentBorder.BackgroundTransparency = 0.3
    accentBorder.ZIndex = mainFrame.ZIndex - 1
    accentBorder.BorderSizePixel = 0
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 22)
    accentCorner.Parent = accentBorder
    
    -- Header Section (Centered Layout)
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "Header"
    headerFrame.Parent = mainFrame
    headerFrame.Size = UDim2.new(1, 0, 0, 80)
    headerFrame.BackgroundTransparency = 1
    
    -- Ghost Logo (centered at top, black background)
    local logoFrame = Instance.new("Frame")
    logoFrame.Name = "Logo"
    logoFrame.Parent = headerFrame
    logoFrame.AnchorPoint = Vector2.new(0.5, 0)
    logoFrame.Position = UDim2.new(0.5, 0, 0, 10)
    logoFrame.Size = UDim2.new(0, 45, 0, 45)
    logoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    logoFrame.BorderSizePixel = 0
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 12)
    logoCorner.Parent = logoFrame
    
    -- Optional: Add subtle border to black background
    local logoStroke = Instance.new("UIStroke")
    logoStroke.Color = Color3.fromRGB(138, 43, 226)
    logoStroke.Thickness = 1
    logoStroke.Transparency = 0.5
    logoStroke.Parent = logoFrame
    
    -- Ghost emoji as placeholder (you can replace this)
    local logoText = Instance.new("TextLabel")
    logoText.Name = "LogoText"
    logoText.Parent = logoFrame
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "👻"  -- Ghost emoji - you can change this
    logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoText.TextScaled = true
    logoText.Font = Enum.Font.GothamBold
    
    -- Title (centered, moved down)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = headerFrame
    titleLabel.AnchorPoint = Vector2.new(0.5, 0)
    titleLabel.Position = UDim2.new(0.5, 0, 0, 50)
    titleLabel.Size = UDim2.new(0, 400, 0, 25)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Phantom.exe"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 22
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Subtitle (centered, moved down)
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "Subtitle"
    subtitleLabel.Parent = headerFrame
    subtitleLabel.AnchorPoint = Vector2.new(0.5, 0)
    subtitleLabel.Position = UDim2.new(0.5, 0, 0, 75)
    subtitleLabel.Size = UDim2.new(0, 400, 0, 15)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = "Advanced Key Authentication System"
    subtitleLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
    subtitleLabel.TextSize = 13
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Close button (top right, transparent background)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = headerFrame
    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.Position = UDim2.new(1, -15, 0, 15)
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Parent = mainFrame
    contentFrame.Position = UDim2.new(0, 0, 0, 80)
    contentFrame.Size = UDim2.new(1, 0, 1, -80)
    contentFrame.BackgroundTransparency = 1
    
    -- Status label (centered)
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Parent = contentFrame
    statusLabel.AnchorPoint = Vector2.new(0.5, 0)
    statusLabel.Position = UDim2.new(0.5, 0, 0, 15)
    statusLabel.Size = UDim2.new(1, -60, 0, 25)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Enter your authentication key to continue"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    statusLabel.TextSize = 15
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Key input container
    local inputContainer = Instance.new("Frame")
    inputContainer.Name = "InputContainer"
    inputContainer.Parent = contentFrame
    inputContainer.Position = UDim2.new(0, 30, 0, 45)
    inputContainer.Size = UDim2.new(1, -60, 0, 45)
    inputContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    inputContainer.BorderSizePixel = 0
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 12)
    inputCorner.Parent = inputContainer
    
    -- Input border gradient
    local inputBorder = Instance.new("Frame")
    inputBorder.Name = "InputBorder"
    inputBorder.Parent = contentFrame
    inputBorder.Position = UDim2.new(0, 28, 0, 43)
    inputBorder.Size = UDim2.new(1, -56, 0, 49)
    inputBorder.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    inputBorder.BackgroundTransparency = 0.7
    inputBorder.ZIndex = inputContainer.ZIndex - 1
    inputBorder.BorderSizePixel = 0
    
    local inputBorderCorner = Instance.new("UICorner")
    inputBorderCorner.CornerRadius = UDim.new(0, 14)
    inputBorderCorner.Parent = inputBorder
    
    -- Key input
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Parent = inputContainer
    keyInput.Position = UDim2.new(0, 15, 0, 0)
    keyInput.Size = UDim2.new(1, -30, 1, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.Text = ""
    keyInput.PlaceholderText = "XXXX-XXXX-XXXX-XXXX"
    keyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.TextSize = 15
    keyInput.Font = Enum.Font.GothamMedium
    keyInput.ClearTextOnFocus = false
    keyInput.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Validate button
    local validateButton = Instance.new("TextButton")
    validateButton.Name = "ValidateButton"
    validateButton.Parent = contentFrame
    validateButton.Position = UDim2.new(0, 30, 0, 105)
    validateButton.Size = UDim2.new(1, -60, 0, 45)
    validateButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    validateButton.Text = "Authenticate Key"
    validateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    validateButton.TextSize = 16
    validateButton.Font = Enum.Font.GothamBold
    validateButton.BorderSizePixel = 0
    
    local validateCorner = Instance.new("UICorner")
    validateCorner.CornerRadius = UDim.new(0, 12)
    validateCorner.Parent = validateButton
    
    local validateGradient = Instance.new("UIGradient")
    validateGradient.Parent = validateButton
    validateGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 85, 211)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
    }
    validateGradient.Rotation = 45
    
    -- Button container for Get Key and Discord
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Parent = contentFrame
    buttonContainer.Position = UDim2.new(0, 30, 0, 165)
    buttonContainer.Size = UDim2.new(1, -60, 0, 35)
    buttonContainer.BackgroundTransparency = 1
    
    -- Get key button
    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Name = "GetKeyButton"
    getKeyButton.Parent = buttonContainer
    getKeyButton.Position = UDim2.new(0, 0, 0, 0)
    getKeyButton.Size = UDim2.new(0.48, 0, 1, 0)
    getKeyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    getKeyButton.Text = "🔑 Get Key"
    getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyButton.TextSize = 13
    getKeyButton.Font = Enum.Font.Gotham
    getKeyButton.BorderSizePixel = 0
    
    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 8)
    getKeyCorner.Parent = getKeyButton
    
    -- Discord button
    local discordButton = Instance.new("TextButton")
    discordButton.Name = "DiscordButton"
    discordButton.Parent = buttonContainer
    discordButton.Position = UDim2.new(0.52, 0, 0, 0)
    discordButton.Size = UDim2.new(0.48, 0, 1, 0)
    discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordButton.Text = "💬 Discord"
    discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordButton.TextSize = 13
    discordButton.Font = Enum.Font.Gotham
    discordButton.BorderSizePixel = 0
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 8)
    discordCorner.Parent = discordButton
    
    -- Info section at bottom (fixed positioning)
    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Parent = contentFrame
    infoFrame.Position = UDim2.new(0, 30, 0, 210)
    infoFrame.Size = UDim2.new(1, -60, 0, 50)
    infoFrame.BackgroundTransparency = 1
    
    -- Bypass method label
    local bypassLabel = Instance.new("TextLabel")
    bypassLabel.Name = "BypassLabel"
    bypassLabel.Parent = infoFrame
    bypassLabel.Position = UDim2.new(0, 0, 0, 0)
    bypassLabel.Size = UDim2.new(1, 0, 0, 12)
    bypassLabel.BackgroundTransparency = 1
    bypassLabel.Text = "HTTP Bypass: Checking methods..."
    bypassLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
    bypassLabel.TextSize = 9
    bypassLabel.Font = Enum.Font.Gotham
    bypassLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- HWID Label
    local hwidLabel = Instance.new("TextLabel")
    hwidLabel.Name = "HWIDLabel"
    hwidLabel.Parent = infoFrame
    hwidLabel.Position = UDim2.new(0, 0, 0, 14)
    hwidLabel.Size = UDim2.new(1, 0, 0, 12)
    hwidLabel.BackgroundTransparency = 1
    hwidLabel.Text = "HWID: " .. playerHWID
    hwidLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
    hwidLabel.TextSize = 9
    hwidLabel.Font = Enum.Font.Gotham
    hwidLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Version label
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Name = "VersionLabel"
    versionLabel.Parent = infoFrame
    versionLabel.Position = UDim2.new(0, 0, 0, 28)
    versionLabel.Size = UDim2.new(1, 0, 0, 12)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "Version " .. CONFIG.VERSION .. " • Secure Authentication"
    versionLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
    versionLabel.TextSize = 8
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Check available HTTP methods
    local function checkHttpMethods()
        local methods = {}
        
        if HttpService then table.insert(methods, "HttpService") end
        if game.HttpGet then table.insert(methods, "game:HttpGet") end
        if syn and syn.request then table.insert(methods, "syn.request") end
        if http_request then table.insert(methods, "http_request") end
        if request then table.insert(methods, "request") end
        
        if #methods > 0 then
            bypassLabel.Text = "HTTP Methods: " .. table.concat(methods, ", ")
            bypassLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
        else
            bypassLabel.Text = "HTTP Methods: None available"
            bypassLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
        end
    end
    
    checkHttpMethods()
    
    -- Hover effects for buttons
    local function addHoverEffect(button, hoverColor, normalColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
        end)
    end
    
    addHoverEffect(validateButton, Color3.fromRGB(186, 85, 211), Color3.fromRGB(138, 43, 226))
    addHoverEffect(getKeyButton, Color3.fromRGB(60, 60, 75), Color3.fromRGB(40, 40, 55))
    addHoverEffect(discordButton, Color3.fromRGB(108, 121, 255), Color3.fromRGB(88, 101, 242))
    
    -- Special hover effect for close button (no background color change)
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    
    -- Focus effect for input
    keyInput.Focused:Connect(function()
        TweenService:Create(inputBorder, TweenInfo.new(0.3), {BackgroundTransparency = 0.3}):Play()
    end)
    
    keyInput.FocusLost:Connect(function(enterPressed)
        TweenService:Create(inputBorder, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
        
        if enterPressed then
            validateButton.MouseButton1Click:Fire()
        end
    end)
    
    -- Event handlers
    closeButton.MouseButton1Click:Connect(function()
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        wait(0.3)
        keySystemGUI:Destroy()
    end)
    
    getKeyButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(CONFIG.DISCORD_INVITE)
            statusLabel.Text = "✅ Discord invite copied to clipboard!"
            statusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
        else
            statusLabel.Text = "🔗 Discord: " .. CONFIG.DISCORD_INVITE
            statusLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
        end
    end)
    
    discordButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(CONFIG.DISCORD_INVITE)
            statusLabel.Text = "✅ Discord invite copied to clipboard!"
            statusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
        else
            statusLabel.Text = "🔗 Discord: " .. CONFIG.DISCORD_INVITE
            statusLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
        end
    end)
    
    validateButton.MouseButton1Click:Connect(function()
        local key = keyInput.Text:gsub("%s+", "") -- Remove spaces
        
        if key == "" then
            statusLabel.Text = "❌ Please enter a valid key!"
            statusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
            
            -- Shake animation for empty input
            local originalPos = inputContainer.Position
            TweenService:Create(inputContainer, TweenInfo.new(0.1), {Position = originalPos + UDim2.new(0, 5, 0, 0)}):Play()
            wait(0.1)
            TweenService:Create(inputContainer, TweenInfo.new(0.1), {Position = originalPos - UDim2.new(0, 5, 0, 0)}):Play()
            wait(0.1)
            TweenService:Create(inputContainer, TweenInfo.new(0.1), {Position = originalPos}):Play()
            return
        end
        
        -- Show loading state
        validateButton.Text = "🔄 Authenticating..."
        validateButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
        
        statusLabel.Text = "🔍 Validating key with secure servers..."
        statusLabel.TextColor3 = Color3.fromRGB(251, 191, 36)
        
        -- Validate key with bypass
        spawn(function()
            local isValid, reason, timeLeft = validateKey(key, playerHWID)
            
            if isValid then
                statusLabel.Text = "✅ Authentication successful! Loading script..."
                statusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
                
                validateButton.Text = "✅ Authenticated"
                validateButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
                
                -- Show time left if available
                if timeLeft and timeLeft > 0 then
                    local days = math.floor(timeLeft / (24 * 60 * 60 * 1000))
                    local hours = math.floor((timeLeft % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000))
                    
                    if days > 0 then
                        statusLabel.Text = statusLabel.Text .. " (Valid for " .. days .. "d " .. hours .. "h)"
                    else
                        statusLabel.Text = statusLabel.Text .. " (Valid for " .. hours .. "h)"
                    end
                end
                
                isValidated = true
                
                -- Success animation
                TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                }):Play()
                
                wait(2)
                keySystemGUI:Destroy()
                
            else
                statusLabel.Text = "❌ " .. reason
                statusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
                
                validateButton.Text = "Authenticate Key"
                validateButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
                
                -- Error shake animation
                local originalPos = mainFrame.Position
                TweenService:Create(mainFrame, TweenInfo.new(0.1), {Position = originalPos + UDim2.new(0, 10, 0, 0)}):Play()
                wait(0.1)
                TweenService:Create(mainFrame, TweenInfo.new(0.1), {Position = originalPos - UDim2.new(0, 10, 0, 0)}):Play()
                wait(0.1)
                TweenService:Create(mainFrame, TweenInfo.new(0.1), {Position = originalPos}):Play()
            end
        end)
    end)
    
    -- REMOVED: All draggable functionality has been completely removed
    -- No more drag code - GUI stays fixed in place
    
    -- Animate GUI entrance
    mainFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 480, 0, 350)
    }):Play()
    
    -- Animate glow and accent border
    TweenService:Create(glowFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 500, 0, 370)
    }):Play()
    
    TweenService:Create(accentBorder, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 484, 0, 354)
    }):Play()
    
    -- Parent to PlayerGui
    keySystemGUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    return keySystemGUI
end
-- ==================================================================================
-- GUI CODE ENDS HERE - REPLACE UNTIL THIS LINE FOR FUTURE GUI UPDATES
-- ==================================================================================

-- Main initialization function
function PhantomKeySystem.init()
    -- Generate HWID
    playerHWID = generateHWID()
    
    print("🔑 Phantom Key System Initialized (HTTP Bypass)")
    print("HWID: " .. playerHWID)
    
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
