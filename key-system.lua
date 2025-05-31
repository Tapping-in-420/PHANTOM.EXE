-- Phantom Key System - Bulletproof Edition
-- Works with ALL executors and network conditions

local PhantomKeySystem = {}

-- Configuration with multiple backup URLs
local CONFIG = {
    -- PRIMARY URLS (UPDATED WITH YOUR ACTUAL URL!)
    API_URLS = {
        "https://2d7e5e66-d814-4c12-9524-99dc13ca819e-00-1hy2gw53vhuk4.picard.replit.dev",  -- Your Replit URL (fixed - no :3000)
        -- Add backup URLs here if you have them
    },
    
    APP_NAME = "Phantom Executor",
    VERSION = "2.0",
    DISCORD_INVITE = "https://discord.gg/yourserver",  -- UPDATE THIS WITH YOUR ACTUAL DISCORD INVITE
    
    -- Retry settings
    MAX_RETRIES = 3,
    RETRY_DELAY = 2,
    REQUEST_TIMEOUT = 10
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

-- Enhanced HWID Generation (more consistent across sessions)
local function generateHWID()
    local components = {}
    
    -- Base component (always available)
    table.insert(components, tostring(LocalPlayer.UserId))
    
    -- Game-specific component
    if game.PlaceId then
        table.insert(components, tostring(game.PlaceId):sub(1, 6))
    end
    
    -- Try to get more stable identifiers
    local success, result = pcall(function()
        -- Try to use more stable game identifiers
        local gameId = game.GameId or game.PlaceId or 0
        return tostring(gameId):sub(1, 8)
    end)
    
    if success and result then
        table.insert(components, result)
    end
    
    -- Create consistent HWID
    local hwid = table.concat(components, "_")
    
    -- Ensure minimum length and add checksum
    if #hwid < 12 then
        hwid = hwid .. "_" .. string.format("%08x", tick() % 0xFFFFFFFF)
    end
    
    return hwid
end

-- Advanced HTTP Request with comprehensive fallbacks
local function makeRequest(endpoint, method, data, maxRetries)
    method = method or "GET"
    maxRetries = maxRetries or CONFIG.MAX_RETRIES
    
    local lastError = "Unknown error"
    
    -- Function to try a single URL with a specific HTTP method
    local function tryRequestWithMethod(url, httpMethod, requestData)
        local fullUrl = url .. endpoint
        
        -- Method 1: Standard HttpService
        local function tryStandardHttp()
            if not HttpService then return false, "HttpService not available" end
            
            local success, response = pcall(function()
                if httpMethod == "GET" then
                    return HttpService:GetAsync(fullUrl, true) -- Sync request
                elseif httpMethod == "POST" then
                    return HttpService:PostAsync(fullUrl, HttpService:JSONEncode(requestData or {}), Enum.HttpContentType.ApplicationJson, true)
                end
            end)
            
            if success then
                local jsonSuccess, jsonData = pcall(function()
                    return HttpService:JSONDecode(response)
                end)
                if jsonSuccess then
                    return true, jsonData
                end
            end
            return false, "Standard HTTP failed"
        end
        
        -- Method 2: game:HttpGet/HttpPost (Fixed)
        local function tryGameHttp()
            local success, response = pcall(function()
                if httpMethod == "GET" and game.HttpGet then
                    return game:HttpGet(fullUrl, true)
                elseif httpMethod == "POST" and game.HttpPost then
                    -- Some games don't have HttpPost, so we'll skip this
                    return nil
                end
                return nil
            end)
            
            if success and response then
                local jsonSuccess, jsonData = pcall(function()
                    return HttpService:JSONDecode(response)
                end)
                if jsonSuccess then
                    return true, jsonData
                end
            end
            return false, "Game HTTP failed"
        end
        
        -- Method 3: Modern Executor Requests (2024+)
        local function tryModernExecutors()
            local executorFunctions = {
                -- Wave
                {name = "Wave", check = function() return getgenv and getgenv().wave and getgenv().wave.request end,
                 func = function() return getgenv().wave.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- AWP
                {name = "AWP", check = function() return getgenv and getgenv().awp and getgenv().awp.request end,
                 func = function() return getgenv().awp.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Swift
                {name = "Swift", check = function() return getgenv and getgenv().swift and getgenv().swift.request end,
                 func = function() return getgenv().swift.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Xeno
                {name = "Xeno", check = function() return getgenv and getgenv().xeno and getgenv().xeno.request end,
                 func = function() return getgenv().xeno.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Argon
                {name = "Argon", check = function() return getgenv and getgenv().argon and getgenv().argon.request end,
                 func = function() return getgenv().argon.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Solara
                {name = "Solara", check = function() return getgenv and getgenv().solara and getgenv().solara.request end,
                 func = function() return getgenv().solara.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Luna
                {name = "Luna", check = function() return getgenv and getgenv().luna and getgenv().luna.request end,
                 func = function() return getgenv().luna.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Delta X
                {name = "Delta X", check = function() return getgenv and getgenv().deltax and getgenv().deltax.request end,
                 func = function() return getgenv().deltax.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Fluxus X
                {name = "Fluxus X", check = function() return getgenv and getgenv().fluxusx and getgenv().fluxusx.request end,
                 func = function() return getgenv().fluxusx.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Arceus X (PC)
                {name = "Arceus X", check = function() return getgenv and getgenv().arceusx and getgenv().arceusx.request end,
                 func = function() return getgenv().arceusx.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Code X
                {name = "Code X", check = function() return getgenv and getgenv().codex and getgenv().codex.request end,
                 func = function() return getgenv().codex.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Cryptic
                {name = "Cryptic", check = function() return getgenv and getgenv().cryptic and getgenv().cryptic.request end,
                 func = function() return getgenv().cryptic.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Delta iOS
                {name = "Delta iOS", check = function() return getgenv and getgenv().deltaios and getgenv().deltaios.request end,
                 func = function() return getgenv().deltaios.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end},
                
                -- Arceus X iOS
                {name = "Arceus X iOS", check = function() return getgenv and getgenv().arceusxios and getgenv().arceusxios.request end,
                 func = function() return getgenv().arceusxios.request({
                    Url = fullUrl, Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                }) end}
            }
            
            for _, executor in ipairs(executorFunctions) do
                if executor.check() then
                    local success, response = pcall(executor.func)
                    if success and response and (response.Success or response.StatusCode == 200) then
                        local jsonSuccess, jsonData = pcall(function()
                            return HttpService:JSONDecode(response.Body or response.body or response.data)
                        end)
                        if jsonSuccess then
                            print("✅ " .. executor.name .. " request successful")
                            return true, jsonData
                        end
                    end
                end
            end
            
            return false, "All modern executor methods failed"
        end
        
        -- Method 4: Legacy Synapse (if still exists)
        local function tryLegacySynapse()
            if not syn or not syn.request then return false, "Legacy Synapse not available" end
            
            local success, response = pcall(function()
                return syn.request({
                    Url = fullUrl,
                    Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                })
            end)
            
            if success and response and response.Success and response.StatusCode == 200 then
                local jsonSuccess, jsonData = pcall(function()
                    return HttpService:JSONDecode(response.Body)
                end)
                if jsonSuccess then
                    return true, jsonData
                end
            end
            return false, "Legacy Synapse request failed"
        end
        
        -- Method 4: http_request (Universal)
        local function tryHttpRequest()
            if not http_request then return false, "http_request not available" end
            
            local success, response = pcall(function()
                return http_request({
                    Url = fullUrl,
                    Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                })
            end)
            
            if success and response and response.Success and response.StatusCode == 200 then
                local jsonSuccess, jsonData = pcall(function()
                    return HttpService:JSONDecode(response.Body)
                end)
                if jsonSuccess then
                    return true, jsonData
                end
            end
            return false, "http_request failed"
        end
        
        -- Method 5: request (KRNL/Others)
        local function tryRequest()
            if not request then return false, "request not available" end
            
            local success, response = pcall(function()
                return request({
                    Url = fullUrl,
                    Method = httpMethod,
                    Headers = httpMethod == "POST" and {["Content-Type"] = "application/json"} or {},
                    Body = httpMethod == "POST" and HttpService:JSONEncode(requestData or {}) or nil,
                    Timeout = CONFIG.REQUEST_TIMEOUT
                })
            end)
            
            if success and response and response.Success and response.StatusCode == 200 then
                local jsonSuccess, jsonData = pcall(function()
                    return HttpService:JSONDecode(response.Body)
                end)
                if jsonSuccess then
                    return true, jsonData
                end
            end
            return false, "request failed"
        end
        
        -- Method 6: WebSocket fallback (for some executors)
        local function tryWebSocketFallback()
            -- This is a placeholder for WebSocket-based communication
            -- Some executors support WebSocket when HTTP is blocked
            return false, "WebSocket not implemented"
        end
        
        -- Try all HTTP methods in order of reliability
        local httpMethods = {
            {name = "Standard HTTP", func = tryStandardHttp},
            {name = "Game HTTP", func = tryGameHttp},
            {name = "Modern Executors", func = tryModernExecutors},
            {name = "Legacy Synapse", func = tryLegacySynapse},
            {name = "HTTP Request", func = tryHttpRequest},
            {name = "Request", func = tryRequest},
            {name = "WebSocket", func = tryWebSocketFallback}
        }
        
        for _, methodInfo in ipairs(httpMethods) do
            local success, response = methodInfo.func()
            if success and response then
                print("✅ " .. methodInfo.name .. " worked for " .. url)
                return true, response
            else
                print("❌ " .. methodInfo.name .. " failed: " .. tostring(response))
            end
            
            -- Small delay between methods
            wait(0.1)
        end
        
        return false, "All HTTP methods failed for " .. url
    end
    
    -- Try each URL with retries
    for urlIndex, baseUrl in ipairs(CONFIG.API_URLS) do
        print("🔄 Trying URL " .. urlIndex .. ": " .. baseUrl)
        
        for attempt = 1, maxRetries do
            print("  Attempt " .. attempt .. "/" .. maxRetries)
            
            local success, response = tryRequestWithMethod(baseUrl, method, data)
            
            if success and response then
                workingURL = baseUrl
                print("✅ Success with " .. baseUrl)
                return true, response
            else
                lastError = response or "Unknown error"
                print("❌ Attempt " .. attempt .. " failed: " .. lastError)
                
                if attempt < maxRetries then
                    print("⏳ Waiting " .. CONFIG.RETRY_DELAY .. " seconds before retry...")
                    wait(CONFIG.RETRY_DELAY)
                end
            end
        end
        
        print("💀 All attempts failed for " .. baseUrl)
        
        -- Wait before trying next URL
        if urlIndex < #CONFIG.API_URLS then
            wait(1)
        end
    end
    
    return false, "All URLs and methods failed. Last error: " .. lastError
end

-- Enhanced key validation with better error handling
local function validateKey(key, hwid)
    print("🔑 Validating key: " .. key)
    print("🔒 HWID: " .. hwid)
    
    -- Try different endpoint formats for compatibility
    local endpoints = {
        "/api/validate/" .. key .. "/" .. hwid,  -- Your current format
        "/api/validate?key=" .. key .. "&hwid=" .. hwid,  -- Query parameter format
        "/validate/" .. key .. "/" .. hwid,  -- Alternative path
    }
    
    for i, endpoint in ipairs(endpoints) do
        print("🔄 Trying endpoint format " .. i .. ": " .. endpoint)
        
        local success, response = makeRequest(endpoint, "GET")
        
        if success and response then
            print("✅ Endpoint " .. i .. " worked!")
            
            -- Handle different response formats
            local isValid = response.valid or response.success or false
            local reason = response.reason or response.error or response.message or "Unknown status"
            local timeLeft = response.timeLeft or response.timeRemaining or 0
            
            print("📊 Response - Valid: " .. tostring(isValid) .. ", Reason: " .. reason)
            
            return isValid, reason, timeLeft
        else
            print("❌ Endpoint " .. i .. " failed: " .. tostring(response))
        end
    end
    
    return false, "All endpoint formats failed", 0
end

-- Detect available HTTP methods and executor
local function detectEnvironment()
    local methods = {}
    local executor = "Unknown"
    local executorInfo = {
        name = "Unknown",
        version = "Unknown",
        platform = "PC"
    }
    
    -- Detect HTTP methods
    if HttpService then table.insert(methods, "HttpService") end
    if game.HttpGet then table.insert(methods, "game:HttpGet") end
    -- Removed game.HttpPost as it's not available in all games
    
    -- Modern Executor Detection (2024+)
    
    -- Wave Executor
    if getgenv and getgenv().wave then
        executor = "Wave"
        executorInfo = {name = "Wave", version = getgenv().wave.version or "Unknown", platform = "PC"}
        if getgenv().wave.request then table.insert(methods, "wave.request") end
    
    -- AWP (Advanced Whitelist Protection)
    elseif getgenv and getgenv().awp then
        executor = "AWP"
        executorInfo = {name = "AWP", version = getgenv().awp.version or "Unknown", platform = "PC"}
        if getgenv().awp.request then table.insert(methods, "awp.request") end
    
    -- Swift Executor
    elseif getgenv and getgenv().swift then
        executor = "Swift"
        executorInfo = {name = "Swift", version = getgenv().swift.version or "Unknown", platform = "PC"}
        if getgenv().swift.request then table.insert(methods, "swift.request") end
    
    -- Xeno Executor
    elseif getgenv and getgenv().xeno then
        executor = "Xeno"
        executorInfo = {name = "Xeno", version = getgenv().xeno.version or "Unknown", platform = "PC"}
        if getgenv().xeno.request then table.insert(methods, "xeno.request") end
    
    -- Argon Executor
    elseif getgenv and getgenv().argon then
        executor = "Argon"
        executorInfo = {name = "Argon", version = getgenv().argon.version or "Unknown", platform = "PC"}
        if getgenv().argon.request then table.insert(methods, "argon.request") end
    
    -- Solara Executor
    elseif getgenv and getgenv().solara then
        executor = "Solara"
        executorInfo = {name = "Solara", version = getgenv().solara.version or "Unknown", platform = "PC"}
        if getgenv().solara.request then table.insert(methods, "solara.request") end
    
    -- Luna Executor
    elseif getgenv and getgenv().luna then
        executor = "Luna"
        executorInfo = {name = "Luna", version = getgenv().luna.version or "Unknown", platform = "PC"}
        if getgenv().luna.request then table.insert(methods, "luna.request") end
    
    -- KRNL (Updated detection)
    elseif getgenv and (getgenv().KRNL_LOADED or getgenv().krnl) then
        executor = "KRNL"
        executorInfo = {name = "KRNL", version = getgenv().krnl and getgenv().krnl.version or "Unknown", platform = "PC"}
        if request then table.insert(methods, "request") end
    
    -- Delta Executor
    elseif getgenv and getgenv().delta then
        executor = "Delta"
        executorInfo = {name = "Delta", version = getgenv().delta.version or "Unknown", platform = "PC"}
        if getgenv().delta.request then table.insert(methods, "delta.request") end
    
    -- Delta X
    elseif getgenv and getgenv().deltax then
        executor = "Delta X"
        executorInfo = {name = "Delta X", version = getgenv().deltax.version or "Unknown", platform = "PC"}
        if getgenv().deltax.request then table.insert(methods, "deltax.request") end
    
    -- Fluxus X
    elseif getgenv and getgenv().fluxusx then
        executor = "Fluxus X"
        executorInfo = {name = "Fluxus X", version = getgenv().fluxusx.version or "Unknown", platform = "PC"}
        if getgenv().fluxusx.request then table.insert(methods, "fluxusx.request") end
    
    -- Arceus X (PC)
    elseif getgenv and getgenv().arceusx then
        executor = "Arceus X"
        executorInfo = {name = "Arceus X", version = getgenv().arceusx.version or "Unknown", platform = "PC"}
        if getgenv().arceusx.request then table.insert(methods, "arceusx.request") end
    
    -- Code X
    elseif getgenv and getgenv().codex then
        executor = "Code X"
        executorInfo = {name = "Code X", version = getgenv().codex.version or "Unknown", platform = "PC"}
        if getgenv().codex.request then table.insert(methods, "codex.request") end
    
    -- Cryptic Executor
    elseif getgenv and getgenv().cryptic then
        executor = "Cryptic"
        executorInfo = {name = "Cryptic", version = getgenv().cryptic.version or "Unknown", platform = "PC"}
        if getgenv().cryptic.request then table.insert(methods, "cryptic.request") end
    
    -- iOS Executors Detection
    
    -- Delta iOS
    elseif getgenv and getgenv().deltaios then
        executor = "Delta iOS"
        executorInfo = {name = "Delta iOS", version = getgenv().deltaios.version or "Unknown", platform = "iOS"}
        if getgenv().deltaios.request then table.insert(methods, "deltaios.request") end
    
    -- Arceus X iOS
    elseif getgenv and getgenv().arceusxios then
        executor = "Arceus X iOS"
        executorInfo = {name = "Arceus X iOS", version = getgenv().arceusxios.version or "Unknown", platform = "iOS"}
        if getgenv().arceusxios.request then table.insert(methods, "arceusxios.request") end
    
    -- Legacy/Fallback Detection
    
    -- Old Synapse Detection (if someone still has it)
    elseif syn and syn.request then
        executor = "Synapse X (Legacy)"
        executorInfo = {name = "Synapse X", version = "Legacy", platform = "PC"}
        table.insert(methods, "syn.request")
    
    -- Script-Ware
    elseif getgenv and getgenv().SCRIPT_WARE_LOADED then
        executor = "Script-Ware"
        executorInfo = {name = "Script-Ware", version = "Unknown", platform = "PC"}
        if getgenv().SCRIPT_WARE and getgenv().SCRIPT_WARE.request then
            table.insert(methods, "scriptware.request")
        end
    
    -- Fluxus (Original)
    elseif getgenv and getgenv().fluxus then
        executor = "Fluxus"
        executorInfo = {name = "Fluxus", version = getgenv().fluxus.version or "Unknown", platform = "PC"}
        if getgenv().fluxus.request then table.insert(methods, "fluxus.request") end
    
    -- Sentinel
    elseif getgenv and getgenv().SENTINEL_LOADED then
        executor = "Sentinel"
        executorInfo = {name = "Sentinel", version = "Unknown", platform = "PC"}
    
    -- SirHurt
    elseif is_sirhurt_closure then
        executor = "SirHurt"
        executorInfo = {name = "SirHurt", version = "Unknown", platform = "PC"}
    
    -- Comet
    elseif getgenv and getgenv().COMET_LOADED then
        executor = "Comet"
        executorInfo = {name = "Comet", version = "Unknown", platform = "PC"}
    
    -- JJSploit
    elseif getgenv and getgenv().JJSPLOIT_LOADED then
        executor = "JJSploit"
        executorInfo = {name = "JJSploit", version = "Unknown", platform = "PC"}
    end
    
    -- Check for universal HTTP functions
    if http_request then 
        table.insert(methods, "http_request")
        if executor == "Unknown" then executor = "Universal HTTP" end
    end
    if request then 
        table.insert(methods, "request")
        if executor == "Unknown" then executor = "Generic Request" end
    end
    
    -- Platform detection for iOS
    if game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled then
        if executorInfo.platform == "PC" then
            executorInfo.platform = "Mobile/iOS"
        end
    end
    
    return methods, executor, executorInfo
end

-- Enhanced GUI with better error reporting
local function createKeySystemGUI()
    -- [Keep your existing GUI code but add these enhancements to the status updates]
    
    -- Destroy existing GUI if it exists
    if keySystemGUI then
        keySystemGUI:Destroy()
    end
    
    -- [Your existing GUI creation code here...]
    -- I'll just show the key validation part with enhanced error handling:
    
    validateButton.MouseButton1Click:Connect(function()
        local key = keyInput.Text:gsub("%s+", "") -- Remove spaces
        
        if key == "" then
            statusLabel.Text = "❌ Please enter a valid key!"
            statusLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
            return
        end
        
        -- Show loading state with enhanced environment info
        local methods, executor, executorInfo = detectEnvironment()
        
        validateButton.Text = "🔄 Authenticating..."
        validateButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
        
        local platformEmoji = executorInfo.platform == "iOS" and "📱" or "💻"
        statusLabel.Text = platformEmoji .. " " .. executorInfo.name .. " v" .. executorInfo.version .. " | " .. #methods .. " methods"
        statusLabel.TextColor3 = Color3.fromRGB(251, 191, 36)
        
        wait(0.5)
        statusLabel.Text = "🌐 Testing " .. #CONFIG.API_URLS .. " server URLs..."
        
        -- Validate key with enhanced error reporting
        spawn(function()
            local isValid, reason, timeLeft = validateKey(key, playerHWID)
            
            if isValid then
                statusLabel.Text = "✅ Authentication successful! Loading script..."
                statusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
                
                validateButton.Text = "✅ Authenticated"
                validateButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
                
                if workingURL then
                    statusLabel.Text = statusLabel.Text .. " (Server: " .. workingURL .. ")"
                end
                
                if timeLeft and timeLeft > 0 then
                    local days = math.floor(timeLeft / (24 * 60 * 60 * 1000))
                    local hours = math.floor((timeLeft % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000))
                    
                    if days > 0 then
                        statusLabel.Text = statusLabel.Text .. " | Valid: " .. days .. "d " .. hours .. "h"
                    else
                        statusLabel.Text = statusLabel.Text .. " | Valid: " .. hours .. "h"
                    end
                end
                
                isValidated = true
                
                wait(2)
                keySystemGUI:Destroy()
                
            else
                -- Enhanced error reporting
                local errorDetails = "❌ " .. reason
                
                if string.find(reason:lower(), "connection") or string.find(reason:lower(), "failed") then
                    errorDetails = errorDetails .. "\n🔧 Try: Check internet connection or contact support"
                elseif string.find(reason:lower(), "hwid") then
                    errorDetails = errorDetails .. "\n🔒 This key is bound to different hardware"
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
    
    -- [Rest of your existing GUI code...]
end

-- Enhanced initialization
function PhantomKeySystem.init()
    -- Generate consistent HWID
    playerHWID = generateHWID()
    
    -- Detect environment
    local methods, executor, executorInfo = detectEnvironment()
    
    print("🔑 Phantom Key System v" .. CONFIG.VERSION .. " Initialized")
    print("🖥️ Executor: " .. executorInfo.name .. " v" .. executorInfo.version .. " (" .. executorInfo.platform .. ")")
    print("🌐 HTTP Methods: " .. table.concat(methods, ", "))
    print("🔒 HWID: " .. playerHWID)
    print("📡 Testing " .. #CONFIG.API_URLS .. " server URLs...")
    
    -- Test connectivity on startup
    spawn(function()
        local success, response = makeRequest("/api/health", "GET", nil, 1)
        if success then
            print("✅ Server connectivity confirmed: " .. (workingURL or "Unknown"))
        else
            print("⚠️ Server connectivity issues detected")
        end
    end)
    
    -- Create and show GUI
    createKeySystemGUI()
    
    -- Wait for validation with longer timeout
    local attempts = 0
    local maxAttempts = 600 -- 10 minutes timeout
    
    while not isValidated and attempts < maxAttempts do
        wait(1)
        attempts = attempts + 1
    end
    
    if isValidated then
        print("✅ Key validation successful!")
        return true
    else
        print("❌ Key validation timeout after " .. (maxAttempts/60) .. " minutes")
        return false
    end
end

-- Additional utility functions
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
    print("🧪 Testing server connectivity...")
    local success, response = makeRequest("/api/health", "GET", nil, 1)
    if success then
        print("✅ Server reachable: " .. (workingURL or "Unknown"))
        return true
    else
        print("❌ Server unreachable: " .. tostring(response))
        return false
    end
end

return PhantomKeySystem
