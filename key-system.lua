-- Phantom Key System - Clean Edition with Ghost Loading Effect
-- Fixed all HttpPost errors and optimized for reliability

local PhantomKeySystem = {}

-- Configuration
local CONFIG = {
    API_URLS = {
        "https://stormy-thankful-otter.glitch.me",
    },
    
    APP_NAME = "Phantom Executor",
    VERSION = "2.1",
    DISCORD_INVITE = "https://discord.gg/yourserver", -- UPDATE THIS
    
    MAX_RETRIES = 3,
    RETRY_DELAY = 1,
    REQUEST_TIMEOUT = 15
}

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local playerHWID = nil
local isValidated = false
local keySystemGUI = nil
local workingURL = nil

-- Enhanced HWID Generation
local function generateHWID()
    local components = {}
    
    table.insert(components, tostring(LocalPlayer.UserId))
    
    if game.PlaceId then
        table.insert(components, tostring(game.PlaceId):sub(1, 6))
    end
    
    local success, result = pcall(function()
        return tostring(game.GameId or game.PlaceId or 0):sub(1, 8)
    end)
    
    if success and result then
        table.insert(components, result)
    end
    
    local hwid = table.concat(components, "_")
    
    if #hwid < 12 then
        hwid = hwid .. "_" .. string.format("%08x", tick() % 0xFFFFFFFF)
    end
    
    return hwid
end

-- Create Phantom Ghost Loading Effect
local function createPhantomGhost()
    -- Create ghost ScreenGui
    local ghostGui = Instance.new("ScreenGui")
    ghostGui.Name = "PhantomGhostLoader"
    ghostGui.ResetOnSpawn = false
    ghostGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ghostGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- No background overlay - just the ghost floating
    
    -- Ghost container frame
    local ghostFrame = Instance.new("Frame")
    ghostFrame.Name = "GhostFrame"
    ghostFrame.Parent = ghostGui
    ghostFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ghostFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    ghostFrame.Size = UDim2.new(0, 120, 0, 140)
    ghostFrame.BackgroundTransparency = 1
    ghostFrame.ZIndex = 1000
    
    -- Ghost body
    local ghostBody = Instance.new("Frame")
    ghostBody.Name = "GhostBody"
    ghostBody.Parent = ghostFrame
    ghostBody.Position = UDim2.new(0, 20, 0, 20)
    ghostBody.Size = UDim2.new(0, 80, 0, 100)
    ghostBody.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ghostBody.BackgroundTransparency = 0.1
    ghostBody.BorderSizePixel = 0
    
    -- Ghost body rounded top
    local bodyCorner = Instance.new("UICorner")
    bodyCorner.CornerRadius = UDim.new(0, 30)
    bodyCorner.Parent = ghostBody
    
    -- Ghost glow effect
    local bodyStroke = Instance.new("UIStroke")
    bodyStroke.Color = Color3.fromRGB(138, 43, 226)
    bodyStroke.Thickness = 2
    bodyStroke.Transparency = 0.2
    bodyStroke.Parent = ghostBody
    
    -- Ghost bottom wavy part
    local ghostBottom = Instance.new("Frame")
    ghostBottom.Name = "GhostBottom"
    ghostBottom.Parent = ghostBody
    ghostBottom.Position = UDim2.new(0, 0, 1, -20)
    ghostBottom.Size = UDim2.new(1, 0, 0, 20)
    ghostBottom.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ghostBottom.BackgroundTransparency = 0.1
    ghostBottom.BorderSizePixel = 0
    
    -- Create ghost waves
    local waves = {}
    for i = 1, 4 do
        local wave = Instance.new("Frame")
        wave.Name = "Wave" .. i
        wave.Parent = ghostBottom
        wave.Position = UDim2.new(0, 8 + (i-1) * 16, 0, 4)
        wave.Size = UDim2.new(0, 16, 0, 16)
        wave.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        wave.BackgroundTransparency = 0.1
        wave.BorderSizePixel = 0
        
        local waveCorner = Instance.new("UICorner")
        waveCorner.CornerRadius = UDim.new(0, 8)
        waveCorner.Parent = wave
        
        table.insert(waves, wave)
    end
    
    -- Ghost eyes
    local leftEye = Instance.new("Frame")
    leftEye.Name = "LeftEye"
    leftEye.Parent = ghostBody
    leftEye.Position = UDim2.new(0, 20, 0, 25)
    leftEye.Size = UDim2.new(0, 12, 0, 16)
    leftEye.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    leftEye.BorderSizePixel = 0
    
    local leftEyeCorner = Instance.new("UICorner")
    leftEyeCorner.CornerRadius = UDim.new(0, 6)
    leftEyeCorner.Parent = leftEye
    
    local rightEye = Instance.new("Frame")
    rightEye.Name = "RightEye"
    rightEye.Parent = ghostBody
    rightEye.Position = UDim2.new(0, 48, 0, 25)
    rightEye.Size = UDim2.new(0, 12, 0, 16)
    rightEye.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    rightEye.BorderSizePixel = 0
    
    local rightEyeCorner = Instance.new("UICorner")
    rightEyeCorner.CornerRadius = UDim.new(0, 6)
    rightEyeCorner.Parent = rightEye
    
    -- Ghost mouth
    local mouth = Instance.new("Frame")
    mouth.Name = "Mouth"
    mouth.Parent = ghostBody
    mouth.Position = UDim2.new(0, 37, 0, 55)
    mouth.Size = UDim2.new(0, 6, 0, 6)
    mouth.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    mouth.BorderSizePixel = 0
    
    local mouthCorner = Instance.new("UICorner")
    mouthCorner.CornerRadius = UDim.new(0, 3)
    mouthCorner.Parent = mouth
    
    -- Status text
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Parent = ghostFrame
    statusText.Position = UDim2.new(0.5, 0, 0, -35)
    statusText.AnchorPoint = Vector2.new(0.5, 0.5)
    statusText.Size = UDim2.new(0, 200, 0, 25)
    statusText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    statusText.BackgroundTransparency = 0.2
    statusText.Text = "👻 Phantom Loading..."
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.GothamBold
    statusText.TextXAlignment = Enum.TextXAlignment.Center
    statusText.BorderSizePixel = 0
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = statusText
    
    -- Particle system
    local particles = {}
    
    local function createParticle()
        local particle = Instance.new("Frame")
        particle.Name = "Particle"
        particle.Parent = ghostFrame
        particle.Size = UDim2.new(0, 3, 0, 3)
        particle.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        particle.BorderSizePixel = 0
        
        local particleCorner = Instance.new("UICorner")
        particleCorner.CornerRadius = UDim.new(0, 2)
        particleCorner.Parent = particle
        
        -- Random position around ghost
        local offsetX = math.random(-50, 50)
        local offsetY = math.random(-50, 50)
        particle.Position = UDim2.new(0, 60 + offsetX, 0, 70 + offsetY)
        
        -- Animate particle floating upward and fading
        local floatTween = TweenService:Create(particle, TweenInfo.new(3, Enum.EasingStyle.Linear), {
            Position = UDim2.new(0, 60 + offsetX + 20, 0, 70 + offsetY - 100),
            BackgroundTransparency = 1
        })
        
        floatTween:Play()
        floatTween.Completed:Connect(function()
            particle:Destroy()
        end)
        
        table.insert(particles, particle)
    end
    
    -- Start animations
    local animations = {}
    
    -- Ghost floating animation
    local floatTween = TweenService:Create(ghostFrame, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Position = UDim2.new(0.5, 0, 0.5, -8)
    })
    floatTween:Play()
    table.insert(animations, floatTween)
    
    -- Ghost glow animation
    local glowTween = TweenService:Create(bodyStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = 0.8,
        Thickness = 4
    })
    glowTween:Play()
    table.insert(animations, glowTween)
    
    -- Wave animations
    for i, wave in pairs(waves) do
        local waveTween = TweenService:Create(wave, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Position = UDim2.new(0, 8 + (i-1) * 16, 0, -4)
        })
        waveTween:Play()
        -- Delay each wave slightly
        wait(0.2)
        table.insert(animations, waveTween)
    end
    
    -- Eye blinking animation
    local blinkTween = TweenService:Create(leftEye, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 12, 0, 2)
    })
    local blinkTween2 = TweenService:Create(rightEye, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 12, 0, 2)
    })
    
    local function blink()
        blinkTween:Play()
        blinkTween2:Play()
        blinkTween.Completed:Connect(function()
            TweenService:Create(leftEye, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                Size = UDim2.new(0, 12, 0, 16)
            }):Play()
            TweenService:Create(rightEye, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                Size = UDim2.new(0, 12, 0, 16)
            }):Play()
        end)
    end
    
    -- Status text fade animation
    local textTween = TweenService:Create(statusText, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        TextTransparency = 0.3
    })
    textTween:Play()
    table.insert(animations, textTween)
    
    -- Start particle spawning
    local particleConnection = task.spawn(function()
        while ghostGui.Parent do
            createParticle()
            wait(0.8)
        end
    end)
    
    -- Start blinking
    local blinkConnection = task.spawn(function()
        while ghostGui.Parent do
            wait(3)
            blink()
        end
    end)
    
    -- Entrance animation (no overlay)
    ghostFrame.Size = UDim2.new(0, 0, 0, 0)
    
    local entranceTween = TweenService:Create(ghostFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 120, 0, 140)
    })
    
    entranceTween:Play()
    
    -- Auto-destroy after 2 seconds with exit animation
    task.spawn(function()
        wait(2)
        
        -- Stop all animations
        for _, animation in pairs(animations) do
            animation:Cancel()
        end
        
        -- Exit animation (no overlay)
        local exitTween = TweenService:Create(ghostFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, -20)
        })
        
        exitTween:Play()
        
        exitTween.Completed:Connect(function()
            ghostGui:Destroy()
        end)
    end)
    
    return ghostGui
end

-- Simplified but robust HTTP request system
local function makeRequest(endpoint, maxRetries)
    maxRetries = maxRetries or CONFIG.MAX_RETRIES
    local lastError = "Connection failed"
    
    local function tryURL(baseUrl)
        local fullUrl = baseUrl .. endpoint
        print("🔗 Trying: " .. fullUrl)
        
        -- Method 1: Standard HttpService
        local function tryHttpService()
            if not HttpService then return false, "HttpService unavailable" end
            
            local success, response = pcall(function()
                return HttpService:GetAsync(fullUrl, true)
            end)
            
            if success and response then
                local jsonSuccess, jsonData = pcall(function()
                    return HttpService:JSONDecode(response)
                end)
                if jsonSuccess and jsonData then
                    return true, jsonData
                end
            end
            return false, "HttpService failed"
        end
        
        -- Method 2: game:HttpGet (safer, no HttpPost)
        local function tryGameHttpGet()
            if not game.HttpGet then return false, "HttpGet unavailable" end
            
            local success, response = pcall(function()
                return game:HttpGet(fullUrl, true)
            end)
            
            if success and response then
                local jsonSuccess, jsonData = pcall(function()
                    return HttpService:JSONDecode(response)
                end)
                if jsonSuccess and jsonData then
                    return true, jsonData
                end
            end
            return false, "HttpGet failed"
        end
        
        -- Method 3: Executor-specific requests
        local function tryExecutorRequests()
            local executors = {
                -- Modern executors
                {name = "http_request", func = http_request},
                {name = "request", func = request},
                {name = "syn.request", func = syn and syn.request},
                
                -- Specific executor functions
                {name = "wave.request", func = getgenv and getgenv().wave and getgenv().wave.request},
                {name = "solara.request", func = getgenv and getgenv().solara and getgenv().solara.request},
                {name = "luna.request", func = getgenv and getgenv().luna and getgenv().luna.request},
                {name = "argon.request", func = getgenv and getgenv().argon and getgenv().argon.request},
                {name = "xeno.request", func = getgenv and getgenv().xeno and getgenv().xeno.request},
                {name = "swift.request", func = getgenv and getgenv().swift and getgenv().swift.request},
                {name = "awp.request", func = getgenv and getgenv().awp and getgenv().awp.request},
                {name = "deltax.request", func = getgenv and getgenv().deltax and getgenv().deltax.request},
                {name = "fluxusx.request", func = getgenv and getgenv().fluxusx and getgenv().fluxusx.request},
                {name = "arceusx.request", func = getgenv and getgenv().arceusx and getgenv().arceusx.request},
                {name = "codex.request", func = getgenv and getgenv().codex and getgenv().codex.request},
                {name = "cryptic.request", func = getgenv and getgenv().cryptic and getgenv().cryptic.request},
                {name = "deltaios.request", func = getgenv and getgenv().deltaios and getgenv().deltaios.request},
                {name = "arceusxios.request", func = getgenv and getgenv().arceusxios and getgenv().arceusxios.request}
            }
            
            for _, executor in pairs(executors) do
                if executor.func then
                    local success, response = pcall(function()
                        if executor.name == "syn.request" then
                            return executor.func({
                                Url = fullUrl,
                                Method = "GET",
                                Timeout = CONFIG.REQUEST_TIMEOUT
                            })
                        else
                            return executor.func({
                                Url = fullUrl,
                                Method = "GET",
                                Timeout = CONFIG.REQUEST_TIMEOUT
                            })
                        end
                    end)
                    
                    if success and response then
                        local body = response.Body or response.body or response.data
                        if body and (response.Success or response.StatusCode == 200) then
                            local jsonSuccess, jsonData = pcall(function()
                                return HttpService:JSONDecode(body)
                            end)
                            if jsonSuccess and jsonData then
                                print("✅ " .. executor.name .. " worked!")
                                return true, jsonData
                            end
                        end
                    end
                end
            end
            return false, "All executor methods failed"
        end
        
        -- Try methods in order
        local methods = {
            {name = "HttpService", func = tryHttpService},
            {name = "HttpGet", func = tryGameHttpGet},
            {name = "Executors", func = tryExecutorRequests}
        }
        
        for _, method in pairs(methods) do
            local success, result = method.func()
            if success and result then
                print("✅ " .. method.name .. " successful")
                return true, result
            else
                print("❌ " .. method.name .. ": " .. tostring(result))
            end
            wait(0.1)
        end
        
        return false, "All methods failed for URL"
    end
    
    -- Try each URL with retries
    for urlIndex, baseUrl in pairs(CONFIG.API_URLS) do
        print("🔄 Testing URL " .. urlIndex .. ": " .. baseUrl)
        
        for attempt = 1, maxRetries do
            print("  → Attempt " .. attempt .. "/" .. maxRetries)
            
            local success, response = tryURL(baseUrl)
            
            if success and response then
                workingURL = baseUrl
                print("✅ Connected to: " .. baseUrl)
                return true, response
            else
                lastError = response or "Unknown error"
                print("❌ Failed: " .. lastError)
                
                if attempt < maxRetries then
                    print("⏳ Retrying in " .. CONFIG.RETRY_DELAY .. "s...")
                    wait(CONFIG.RETRY_DELAY)
                end
            end
        end
        
        if urlIndex < #CONFIG.API_URLS then
            wait(1)
        end
    end
    
    return false, lastError
end

-- Key validation
local function validateKey(key, hwid)
    print("🔑 Validating: " .. key)
    print("🔒 HWID: " .. hwid)
    
    local endpoints = {
        "/api/validate/" .. key .. "/" .. hwid,
        "/api/validate?key=" .. key .. "&hwid=" .. hwid,
        "/validate/" .. key .. "/" .. hwid
    }
    
    for i, endpoint in pairs(endpoints) do
        print("🔄 Trying endpoint " .. i .. ": " .. endpoint)
        
        local success, response = makeRequest(endpoint)
        
        if success and response then
            print("✅ Endpoint " .. i .. " worked!")
            
            local isValid = response.valid or response.success or false
            local reason = response.reason or response.error or response.message or "Unknown"
            local timeLeft = response.timeLeft or response.timeRemaining or 0
            
            print("📊 Valid: " .. tostring(isValid) .. " | Reason: " .. reason)
            return isValid, reason, timeLeft
        else
            print("❌ Endpoint " .. i .. " failed: " .. tostring(response))
        end
    end
    
    return false, "All endpoints failed", 0
end

-- Detect executor
local function detectExecutor()
    local executorName = "Unknown"
    local methods = {}
    
    -- Add basic methods
    if HttpService then table.insert(methods, "HttpService") end
    if game.HttpGet then table.insert(methods, "HttpGet") end
    
    -- Detect specific executors
    if getgenv then
        if getgenv().wave then 
            executorName = "Wave"
            table.insert(methods, "wave.request")
        elseif getgenv().solara then 
            executorName = "Solara"
            table.insert(methods, "solara.request")
        elseif getgenv().luna then 
            executorName = "Luna"
            table.insert(methods, "luna.request")
        elseif getgenv().argon then 
            executorName = "Argon"
            table.insert(methods, "argon.request")
        elseif getgenv().xeno then 
            executorName = "Xeno"
            table.insert(methods, "xeno.request")
        elseif getgenv().swift then 
            executorName = "Swift"
            table.insert(methods, "swift.request")
        elseif getgenv().awp then 
            executorName = "AWP"
            table.insert(methods, "awp.request")
        elseif getgenv().deltax then 
            executorName = "Delta X"
            table.insert(methods, "deltax.request")
        elseif getgenv().fluxusx then 
            executorName = "Fluxus X"
            table.insert(methods, "fluxusx.request")
        elseif getgenv().arceusx then 
            executorName = "Arceus X"
            table.insert(methods, "arceusx.request")
        elseif getgenv().codex then 
            executorName = "Code X"
            table.insert(methods, "codex.request")
        elseif getgenv().cryptic then 
            executorName = "Cryptic"
            table.insert(methods, "cryptic.request")
        elseif getgenv().deltaios then 
            executorName = "Delta iOS"
            table.insert(methods, "deltaios.request")
        elseif getgenv().arceusxios then 
            executorName = "Arceus X iOS"
            table.insert(methods, "arceusxios.request")
        elseif getgenv().delta then 
            executorName = "Delta"
            table.insert(methods, "delta.request")
        elseif getgenv().krnl or getgenv().KRNL_LOADED then 
            executorName = "KRNL"
        elseif getgenv().fluxus then 
            executorName = "Fluxus"
            table.insert(methods, "fluxus.request")
        end
    end
    
    -- Legacy detection
    if syn and syn.request then 
        executorName = "Synapse X (Legacy)"
        table.insert(methods, "syn.request")
    end
    
    -- Universal methods
    if http_request then table.insert(methods, "http_request") end
    if request then table.insert(methods, "request") end
    
    return executorName, methods
end

-- Create GUI
local function createKeySystemGUI()
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
    mainFrame.Size = UDim2.new(0, 480, 0, 350)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BorderSizePixel = 0
    
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
    
    -- Header Section
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "Header"
    headerFrame.Parent = mainFrame
    headerFrame.Size = UDim2.new(1, 0, 0, 80)
    headerFrame.BackgroundTransparency = 1
    
    -- Ghost Logo
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
    
    local logoStroke = Instance.new("UIStroke")
    logoStroke.Color = Color3.fromRGB(138, 43, 226)
    logoStroke.Thickness = 1
    logoStroke.Transparency = 0.5
    logoStroke.Parent = logoFrame
    
    local logoText = Instance.new("TextLabel")
    logoText.Name = "LogoText"
    logoText.Parent = logoFrame
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "👻"
    logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoText.TextScaled = true
    logoText.Font = Enum.Font.GothamBold
    
    -- Title
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
    
    -- Close button
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
    
    -- Status label
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
    
    -- Button container
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
    
    -- Info section
    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Parent = contentFrame
    infoFrame.Position = UDim2.new(0, 30, 0, 210)
    infoFrame.Size = UDim2.new(1, -60, 0, 50)
    infoFrame.BackgroundTransparency = 1
    
    -- Executor info
    local executorLabel = Instance.new("TextLabel")
    executorLabel.Name = "ExecutorLabel"
    executorLabel.Parent = infoFrame
    executorLabel.Position = UDim2.new(0, 0, 0, 0)
    executorLabel.Size = UDim2.new(1, 0, 0, 12)
    executorLabel.BackgroundTransparency = 1
    executorLabel.Text = "Executor: Detecting..."
    executorLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
    executorLabel.TextSize = 9
    executorLabel.Font = Enum.Font.Gotham
    executorLabel.TextXAlignment = Enum.TextXAlignment.Left
    
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
    
    -- Detect executor and update display
    local executorName, methods = detectExecutor()
    executorLabel.Text = "Executor: " .. executorName .. " | " .. #methods .. " methods"
    if executorName ~= "Unknown" then
        executorLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
    end
    
    -- Event handlers
    closeButton.MouseButton1Click:Connect(function()
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
        local key = keyInput.Text:gsub("%s+", "")
        
        if key == "" then
            statusLabel.Text = "❌ Please enter a valid key!"
            statusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
            return
        end
        
        validateButton.Text = "🔄 Authenticating..."
        validateButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
        
        statusLabel.Text = "🔍 " .. executorName .. " | Testing connection..."
        statusLabel.TextColor3 = Color3.fromRGB(251, 191, 36)
        
        spawn(function()
            local isValid, reason, timeLeft = validateKey(key, playerHWID)
            
            if isValid then
                statusLabel.Text = "✅ Authentication successful! Loading script..."
                statusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
                
                validateButton.Text = "✅ Authenticated"
                validateButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
                
                if workingURL then
                    statusLabel.Text = statusLabel.Text .. " (Connected)"
                end
                
                wait(1)
                
                -- Close key system GUI first
                keySystemGUI:Destroy()
                
                wait(0.5) -- Small pause
                
                -- Show the phantom ghost loading effect
                createPhantomGhost()
                
                -- Wait for ghost to complete (2+ seconds) BEFORE setting validation
                wait(2.5)
                
                -- NOW set validated to true (this triggers main script)
                isValidated = true
                
            else
                local errorDetails = "❌ " .. reason
                
                if string.find(reason:lower(), "connection") or string.find(reason:lower(), "failed") then
                    errorDetails = errorDetails .. "\n🔧 Check internet or contact support"
                elseif string.find(reason:lower(), "hwid") then
                    errorDetails = errorDetails .. "\n🔒 Key bound to different hardware"
                elseif string.find(reason:lower(), "expired") then
                    errorDetails = errorDetails .. "\n⏰ Key time limit reached"
                elseif string.find(reason:lower(), "not found") then
                    errorDetails = errorDetails .. "\n🔑 Invalid key - check spelling"
                end
                
                statusLabel.Text = errorDetails
                statusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
                
                validateButton.Text = "Authenticate Key"
                validateButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            end
        end)
    end)
    
    -- Animate GUI entrance
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 480, 0, 350)
    }):Play()
    
    -- Parent to PlayerGui
    keySystemGUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    return keySystemGUI
end

-- Main initialization
function PhantomKeySystem.init()
    playerHWID = generateHWID()
    
    local executorName, methods = detectExecutor()
    
    print("🔑 Phantom Key System v" .. CONFIG.VERSION .. " Initialized")
    print("🖥️ Executor: " .. executorName)
    print("🌐 HTTP Methods: " .. table.concat(methods, ", "))
    print("🔒 HWID: " .. playerHWID)
    print("📡 Testing connectivity...")
    
    -- Test connectivity
    spawn(function()
        local success, response = makeRequest("/api/health", 1)
        if success then
            print("✅ Server online: " .. (workingURL or "Connected"))
        else
            print("⚠️ Server connectivity issues")
        end
    end)
    
    createKeySystemGUI()
    
    -- Wait for validation
    local attempts = 0
    local maxAttempts = 300 -- 5 minutes
    
    while not isValidated and attempts < maxAttempts do
        wait(1)
        attempts = attempts + 1
    end
    
    if isValidated then
        print("✅ Key validation successful!")
        print("👻 Phantom ghost loading complete!")
        return true
    else
        print("❌ Key validation timeout")
        return false
    end
end

-- Utility functions
function PhantomKeySystem.isValidated()
    return isValidated
end

function PhantomKeySystem.getHWID()
    return playerHWID
end

function PhantomKeySystem.getWorkingURL()
    return workingURL
end

function PhantomKeySystem.testConnectivity()
    print("🧪 Testing connectivity...")
    local success, response = makeRequest("/api/health", 1)
    if success then
        print("✅ Server reachable")
        return true
    else
        print("❌ Server unreachable: " .. tostring(response))
        return false
    end
end

return PhantomKeySystem
