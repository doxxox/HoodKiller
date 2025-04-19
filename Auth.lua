-- Auth.lua - Key + HWID Lock without storing HWIDs

-- Authorized keys for validation (replace with your actual keys)
local authorized_keys = {
    "key12345",  -- Example key (replace with actual keys)
    "key67890"
}

local hwid_lock = {}  -- Temporarily stores HWID lock for session use
local blacklisted_hwids = {}  -- Blacklisted HWIDs (not stored permanently)
local admin_hwid = "admin_hwid_example"  -- Admin's HWID or a specific key

-- Admin Panel - Aimlock, Visuals, Misc
local admin_panel = {
    aimlock_enabled = false,  -- Aimlock toggle
    skeleton_enabled = false,  -- Skeleton toggle
    box_enabled = false,  -- Box toggle
    fly_enabled = false,  -- Fly toggle
    orbit_enabled = false,  -- Orbit toggle
    speed_enabled = false,  -- Speed toggle
    credits = "Credits: Created by You!",
    anti_lock_enabled = false -- Anti-Lock toggle
}

-- Function to authenticate user by key
function authenticate(key, hwid)
    for _, valid_key in ipairs(authorized_keys) do
        if key == valid_key then
            print("Key authenticated successfully.")

            -- Lock HWID for this session (does not store permanently)
            if not hwid_lock[key] then
                hwid_lock[key] = hwid
                print("HWID " .. hwid .. " locked to this key.")
            else
                if hwid_lock[key] ~= hwid then
                    print("HWID mismatch! Re-authentication required.")
                    return false
                end
            end
            return true
        end
    end
    print("Invalid key.")
    return false
end

-- Create License Key Input GUI
local function createLicenseKeyScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer.PlayerGui

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
    title.TextAlign = Enum.TextXAlignment.Center

    local inputBox = Instance.new("TextBox")
    inputBox.Parent = frame
    inputBox.Size = UDim2.new(0.8, 0, 0.2, 0)
    inputBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    inputBox.Text = ""
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.PlaceholderText = "Enter License Key"
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
        local hwid = "some_hwid"  -- This should be replaced with the actual HWID retrieval method
        
        if authenticate(key, hwid) then
            -- If valid, go to admin panel
            print("License Key Validated. Proceeding to Admin Panel.")
            screenGui:Destroy()  -- Remove the key input screen
            showAdminPanel()     -- Show the admin panel
        else
            print("Invalid License Key.")
            -- Optionally display an error message to the user
        end
    end)
end

-- Admin Panel - Display the features once the license key is valid
local function showAdminPanel()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer.PlayerGui

    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0.5, 0, 0.5, 0)
    frame.Position = UDim2.new(0.25, 0, 0.25, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.Text = "Admin Panel"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.TextAlign = Enum.TextXAlignment.Center

    local creditsLabel = Instance.new("TextLabel")
    creditsLabel.Parent = frame
    creditsLabel.Size = UDim2.new(1, 0, 0.2, 0)
    creditsLabel.Position = UDim2.new(0, 0, 0.2, 0)
    creditsLabel.Text = admin_panel.credits
    creditsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    creditsLabel.TextSize = 18
    creditsLabel.TextAlign = Enum.TextXAlignment.Center

    -- Admin Panel Features (like Aimlock, Visuals, etc.)
    -- Display toggles or buttons for different admin features

    local aimlockButton = Instance.new("TextButton")
    aimlockButton.Parent = frame
    aimlockButton.Size = UDim2.new(0.8, 0, 0.1, 0)
    aimlockButton.Position = UDim2.new(0.1, 0, 0.4, 0)
    aimlockButton.Text = "Toggle Aimlock"
    aimlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimlockButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
    aimlockButton.MouseButton1Click:Connect(function()
        admin_panel.aimlock_enabled = not admin_panel.aimlock_enabled
        print("Aimlock: " .. (admin_panel.aimlock_enabled and "Enabled" or "Disabled"))
    end)
    
    -- You can add more buttons for other features like fly, speed, etc.

    -- Add any other features to the admin panel as needed
end

-- Call the function to show the License Key screen when the script runs
createLicenseKeyScreen()
