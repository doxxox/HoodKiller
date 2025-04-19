-- Auth.lua - Key + HWID Lock with improvements

-- Replace with actual keys or sync with bot
local authorized_keys = {
    "key12345",
    "key67890"
}

local hwid_lock = {}
local blacklisted_hwids = {
    -- Add blacklisted HWIDs here or sync from bot
    -- "example_blacklisted_hwid"
}

local admin_panel = {
    aimlock_enabled = false,
    skeleton_enabled = false,
    box_enabled = false,
    fly_enabled = false,
    orbit_enabled = false,
    speed_enabled = false,
    anti_lock_enabled = false,
    credits = "Credits: Created by You!"
}

-- Authentication
function authenticate(key, hwid)
    -- Blacklist check
    for _, blacklisted in ipairs(blacklisted_hwids) do
        if hwid == blacklisted then
            print("HWID is blacklisted.")
            return false
        end
    end

    for _, valid_key in ipairs(authorized_keys) do
        if key == valid_key then
            print("Key authenticated successfully.")
            if not hwid_lock[key] then
                hwid_lock[key] = hwid
                print("HWID " .. hwid .. " locked to this key.")
            elseif hwid_lock[key] ~= hwid then
                print("HWID mismatch! Re-authentication required.")
                return false
            end
            return true
        end
    end

    print("Invalid key.")
    return false
end

-- UI to input license key
local function createLicenseKeyScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0.5, 0, 0.3, 0)
    frame.Position = UDim2.new(0.25, 0, 0.35, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.Text = "Enter License Key"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24

    local inputBox = Instance.new("TextBox")
    inputBox.Parent = frame
    inputBox.Size = UDim2.new(0.8, 0, 0.2, 0)
    inputBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    inputBox.PlaceholderText = "Enter License Key"
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 20

    local submitButton = Instance.new("TextButton")
    submitButton.Parent = frame
    submitButton.Size = UDim2.new(0.5, 0, 0.2, 0)
    submitButton.Position = UDim2.new(0.25, 0, 0.7, 0)
    submitButton.Text = "Submit"
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)

    submitButton.MouseButton1Click:Connect(function()
        local key = inputBox.Text
        local hwid = tostring(game:GetService("Players").LocalPlayer.UserId)  -- Replace with better HWID if needed

        if authenticate(key, hwid) then
            print("License Key Validated. Proceeding to Admin Panel.")
            screenGui:Destroy()
            showAdminPanel()
        else
            print("Invalid License Key or HWID.")
        end
    end)
end

-- Dynamic toggle button creator
local function createToggleButton(parent, yPos, featureName)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Size = UDim2.new(0.8, 0, 0.1, 0)
    button.Position = UDim2.new(0.1, 0, yPos, 0)
    button.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18

    local field = featureName:lower() .. "_enabled"
    local function updateButton()
        local state = admin_panel[field] and "ON ✅" or "OFF ❌"
        button.Text = featureName .. ": " .. state
    end

    button.MouseButton1Click:Connect(function()
        admin_panel[field] = not admin_panel[field]
        print(featureName .. ": " .. (admin_panel[field] and "Enabled" or "Disabled"))
        updateButton()
    end)

    updateButton()
end

-- Admin Panel GUI
function showAdminPanel()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0.5, 0, 0.6, 0)
    frame.Position = UDim2.new(0.25, 0, 0.2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.Text = "Admin Panel"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24

    local credits = Instance.new("TextLabel")
    credits.Parent = frame
    credits.Size = UDim2.new(1, 0, 0.1, 0)
    credits.Position = UDim2.new(0, 0, 0.1, 0)
    credits.Text = admin_panel.credits
    credits.TextColor3 = Color3.fromRGB(255, 255, 255)
    credits.TextSize = 18

    -- Add buttons for features
    local features = {
        "Aimlock",
        "Skeleton",
        "Box",
        "Fly",
        "Orbit",
        "Speed",
        "Anti_Lock"
    }

    for i, feature in ipairs(features) do
        createToggleButton(frame, 0.2 + (i * 0.1), feature)
    end
end

-- Init
createLicenseKeyScreen()
