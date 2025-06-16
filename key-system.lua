-- Phantom Key System - Luarmor Integration
-- Keep your beautiful GUI, use Luarmor for validation

local PhantomKeySystem = {}

-- Configuration - UPDATE THESE WITH YOUR LUARMOR DETAILS
local CONFIG = {
    -- Luarmor Configuration
    LUARMOR_PROJECT_ID = "a167a492fe4ecaf4793689a3b3d58f74", -- Your actual Project ID
    LUARMOR_API_KEY = "d0b0c5e6962fca6e760152ea5cc4a44ef28e295fb3993931b8e2", -- Your actual API Key
    LUARMOR_BASE_URL = "https://api.luarmor.net/v3",
    
    -- Your App Configuration
    APP_NAME = "Phantom Executor",
    VERSION = "2.1",
    DISCORD_INVITE = "https://discord.gg/yourserver", -- UPDATE THIS
    
    MAX_RETRIES = 3,
    RETRY_DELAY = 1,
    REQUEST_TIMEOUT = 15
}

-- Services (keep same)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables (keep same)
local LocalPlayer = Players.LocalPlayer
local playerHWID = nil
local isValidated = false
local keySystemGUI = nil

-- Enhanced HWID Generation (keep same)
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

-- Keep your ghost loading effect (unchanged)
local function createPhantomGhost()
    -- [Keep your existing createPhantomGhost function exactly as is]
    -- I'll include it abbreviated here for space:
    
    local ghostGui = Instance.new("ScreenGui")
    ghostGui.Name = "PhantomGhostLoader"
    ghostGui.ResetOnSpawn = false
    ghostGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ghostGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- [Rest of your ghost creation code stays the same]
    -- Just copy your existing createPhantomGhost function here
    
    return ghostGui
end

-- Updated HTTP request system for Luarmor
local function makeLuarmorRequest(endpoint, method, data)
    method = method or "GET"
    local lastError = "Connection failed"
    
    local fullUrl = CONFIG.LUARMOR_BASE_URL .. endpoint
    print("🔗 Luarmor Request: " .. fullUrl)
    
    -- Create request headers
    local headers = {
        ["Authorization"] = "Bearer " .. CONFIG.LUARMOR_API_KEY,
        ["Content-Type"] = "application/json"
    }
    
    -- Function to try different HTTP methods
    local function tryRequest()
        -- Method 1: Standard HttpService
        local function tryHttpService()
            if not HttpService then return false, "HttpService unavailable" end
            
            local success, response = pcall(function()
                if method == "GET" then
                    return HttpService:GetAsync(fullUrl, true, headers)
                else
                    local jsonData = data and HttpService:JSONEncode(data) or ""
                    return HttpService:PostAsync(fullUrl, jsonData, Enum.HttpContentType.ApplicationJson, false, headers)
                end
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
        
        -- Method 2: Executor-specific requests
        local function tryExecutorRequests()
            local executors = {
                {name = "http_request", func = http_request},
                {name = "request", func = request},
                {name = "syn.request", func = syn and syn.request},
            }
            
            for _, executor in pairs(executors) do
                if executor.func then
                    local requestData = {
                        Url = fullUrl,
                        Method = method,
                        Headers = headers,
                        Timeout = CONFIG.REQUEST_TIMEOUT
                    }
                    
                    if data and method ~= "GET" then
                        requestData.Body = HttpService:JSONEncode(data)
                    end
                    
                    local success, response = pcall(function()
                        return executor.func(requestData)
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
            {name = "Executors", func = tryExecutorRequests}
        }
        
        for _, methodInfo in pairs(methods) do
            local success, result = methodInfo.func()
            if success and result then
                print("✅ " .. methodInfo.name .. " successful")
                return true, result
            else
                print("❌ " .. methodInfo.name .. ": " .. tostring(result))
            end
            wait(0.1)
        end
        
        return false, "All methods failed"
    end
    
    -- Try with retries
    for attempt = 1, CONFIG.MAX_RETRIES do
        print("  → Attempt " .. attempt .. "/" .. CONFIG.MAX_RETRIES)
        
        local success, response = tryRequest()
        
        if success and response then
            print("✅ Luarmor request successful")
            return true, response
        else
            lastError = response or "Unknown error"
            print("❌ Failed: " .. lastError)
            
            if attempt < CONFIG.MAX_RETRIES then
                print("⏳ Retrying in " .. CONFIG.RETRY_DELAY .. "s...")
                wait(CONFIG.RETRY_DELAY)
            end
        end
    end
    
    return false, lastError
end

-- NEW: Luarmor key validation
local function validateKeyWithLuarmor(key, hwid)
    print("🔑 Validating with Luarmor: " .. key)
    print("🔒 HWID: " .. hwid)
    
    -- Luarmor validation endpoint
    local endpoint = "/validate"
    
    local requestData = {
        project_id = CONFIG.LUARMOR_PROJECT_ID,
        license_key = key,
        hwid = hwid,
        -- Optional: add user info
        user_id = tostring(LocalPlayer.UserId),
        username = LocalPlayer.Name
    }
    
    local success, response = makeLuarmorRequest(endpoint, "POST", requestData)
    
    if success and response then
        print("✅ Luarmor response received")
        
        -- Parse Luarmor response
        local isValid = response.valid or response.success or false
        local reason = response.message or response.error or "Unknown"
        local timeLeft = response.expires_in or response.time_left or 0
        
        -- Additional Luarmor data you might want to use
        local userInfo = response.user or {}
        local licenseInfo = response.license || {}
        
        print("📊 Valid: " .. tostring(isValid) .. " | Reason: " .. reason)
        
        if timeLeft > 0 then
            print("⏰ Time remaining: " .. timeLeft .. " seconds")
        end
        
        return isValid, reason, timeLeft, userInfo, licenseInfo
    else
        print("❌ Luarmor validation failed: " .. tostring(response))
        return false, "Connection to Luarmor failed: " .. tostring(response), 0
    end
end

-- Keep your detect executor function (unchanged)
local function detectExecutor()
    -- [Keep your existing detectExecutor function exactly as is]
    local executorName = "Unknown"
    local methods = {}
    
    -- Add basic methods
    if HttpService then table.insert(methods, "HttpService") end
    if game.HttpGet then table.insert(methods, "HttpGet") end
    
    -- [Rest of your existing detection logic]
    
    return executorName, methods
end

-- Keep your GUI creation function (mostly unchanged)
local function createKeySystemGUI()
    if keySystemGUI then
        keySystemGUI:Destroy()
    end
    
    -- [Keep your existing GUI creation code exactly as is]
    -- Just update the validate button click handler:
    
    -- Create ScreenGui
    keySystemGUI = Instance.new("ScreenGui")
    keySystemGUI.Name = "PhantomKeySystem"
    keySystemGUI.ResetOnSpawn = false
    keySystemGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- [All your existing GUI creation code...]
    
    -- UPDATE ONLY THE VALIDATION HANDLER:
    validateButton.MouseButton1Click:Connect(function()
        local key = keyInput.Text:gsub("%s+", "")
        
        if key == "" then
            statusLabel.Text = "❌ Please enter a valid key!"
            statusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
            return
        end
        
        validateButton.Text = "🔄 Authenticating..."
        validateButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
        
        statusLabel.Text = "🔍 " .. executorName .. " | Connecting to Luarmor..."
        statusLabel.TextColor3 = Color3.fromRGB(251, 191, 36)
        
        spawn(function()
            -- USE LUARMOR VALIDATION INSTEAD OF YOUR CUSTOM API
            local isValid, reason, timeLeft, userInfo, licenseInfo = validateKeyWithLuarmor(key, playerHWID)
            
            if isValid then
                statusLabel.Text = "✅ Authentication successful! Loading script..."
                statusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
                
                validateButton.Text = "✅ Authenticated"
                validateButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
                
                if timeLeft > 0 then
                    local days = math.floor(timeLeft / 86400)
                    local hours = math.floor((timeLeft % 86400) / 3600)
                    statusLabel.Text = statusLabel.Text .. string.format(" (%dd %dh remaining)", days, hours)
                end
                
                wait(1)
                
                -- Close key system GUI first
                keySystemGUI:Destroy()
                
                wait(0.5)
                
                -- Show the phantom ghost loading effect
                createPhantomGhost()
                
                -- Wait for ghost to complete
                wait(2.5)
                
                -- Set validated to true
                isValidated = true
                
            else
                local errorDetails = "❌ " .. reason
                
                if string.find(reason:lower(), "expired") then
                    errorDetails = errorDetails .. "\n⏰ License has expired"
                elseif string.find(reason:lower(), "invalid") then
                    errorDetails = errorDetails .. "\n🔑 Invalid license key"
                elseif string.find(reason:lower(), "hwid") then
                    errorDetails = errorDetails .. "\n🔒 Hardware ID mismatch"
                elseif string.find(reason:lower(), "connection") then
                    errorDetails = errorDetails .. "\n🌐 Connection issue"
                end
                
                statusLabel.Text = errorDetails
                statusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
                
                validateButton.Text = "Authenticate Key"
                validateButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            end
        end)
    end)
    
    -- [Rest of your existing GUI code...]
    
    keySystemGUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
    return keySystemGUI
end

-- Main initialization (keep mostly same)
function PhantomKeySystem.init()
    playerHWID = generateHWID()
    
    local executorName, methods = detectExecutor()
    
    print("🔑 Phantom Key System v" .. CONFIG.VERSION .. " (Luarmor Powered)")
    print("🖥️ Executor: " .. executorName)
    print("🌐 HTTP Methods: " .. table.concat(methods, ", "))
    print("🔒 HWID: " .. playerHWID)
    print("🛡️ Using Luarmor for validation...")
    
    createKeySystemGUI()
    
    -- Wait for validation
    local attempts = 0
    local maxAttempts = 300 -- 5 minutes
    
    while not isValidated and attempts < maxAttempts do
        wait(1)
        attempts = attempts + 1
    end
    
    if isValidated then
        print("✅ Luarmor validation successful!")
        print("👻 Phantom ghost loading complete!")
        return true
    else
        print("❌ Key validation timeout")
        return false
    end
end

-- Keep your utility functions (unchanged)
function PhantomKeySystem.isValidated()
    return isValidated
end

function PhantomKeySystem.getHWID()
    return playerHWID
end

-- NEW: Get Luarmor user info (if needed)
function PhantomKeySystem.getUserInfo()
    return userInfo
end

function PhantomKeySystem.testLuarmorConnection()
    print("🧪 Testing Luarmor connectivity...")
    local success, response = makeLuarmorRequest("/status", "GET")
    if success then
        print("✅ Luarmor server reachable")
        return true
    else
        print("❌ Luarmor unreachable: " .. tostring(response))
        return false
    end
end

return PhantomKeySystem
