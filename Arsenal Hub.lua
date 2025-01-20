local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Tab Example", 4483362458) -- Title, Image

local Players = game:GetService("Players")
local highlightEnabled = false -- State to track if highlighting is enabled
local highlights = {} -- Table to store created SelectionBoxes

-- Function to enable highlight
local function enableHighlight()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and not highlights[part] then
                    -- Create and store the highlight
                    local selectionBox = Instance.new("SelectionBox")
                    selectionBox.Adornee = part
                    selectionBox.Color3 = Color3.new(0, 1, 0) -- Green color
                    selectionBox.LineThickness = 0.05
                    selectionBox.SurfaceTransparency = 0.5
                    selectionBox.Parent = part
                    highlights[part] = selectionBox
                end
            end
        end
    end
end

-- Function to disable highlight
local function disableHighlight()
    for part, selectionBox in pairs(highlights) do
        if selectionBox and selectionBox.Parent then
            selectionBox:Destroy()
        end
    end
    highlights = {} -- Clear the highlights table
end

-- Toggle button
local Toggle = Tab:CreateToggle({
    Name = "Toggle Highlight",
    Default = false, -- Initial state of the toggle
    Callback = function(state)
        highlightEnabled = state -- Update the highlight state
        if highlightEnabled then
            enableHighlight() -- Enable highlighting
        else
            disableHighlight() -- Disable highlighting
        end
    end,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local highlightEnabled = false -- Tracks if the aimbot is toggled on
local isRightMouseDown = false -- Tracks if the right mouse button is pressed

-- Function to get the closest player's head
local function getClosestPlayerHead()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local distance = (LocalPlayer.Character.Head.Position - head.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = head
            end
        end
    end

    return closestPlayer
end

-- Aimbot function
local function aimbot()
    if not highlightEnabled or not isRightMouseDown then return end

    local targetHead = getClosestPlayerHead()
    if targetHead then
        local camera = workspace.CurrentCamera
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position)
    end
end

-- Right mouse button input detection
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Ignore inputs handled by the game

    if input.UserInputType == Enum.UserInputType.MouseButton2 then -- Right mouse button
        isRightMouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then -- Right mouse button
        isRightMouseDown = false
    end
end)

-- Toggle button
local Toggle = Tab:CreateToggle({
    Name = "Aimbot Toggle",
    Default = false, -- Initial state of the toggle
    Callback = function(state)
        highlightEnabled = state -- Update the toggle state

        if highlightEnabled then
            -- Connect the aimbot logic to RenderStepped
            RunService.RenderStepped:Connect(aimbot)
        else
            -- Disconnect RenderStepped logic to stop aimbot
            RunService:UnbindFromRenderStep("Aimbot")
            isRightMouseDown = false -- Reset right mouse down state
        end
    end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Function to set the player's walk speed
local function setWalkSpeed(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end

-- Create the slider for walk speed
local Slider = Tab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100}, -- Minimum 16 (default walk speed) to maximum 100
    Increment = 1, -- Adjust in steps of 1
    Suffix = " Speed", -- Adds "Speed" after the number
    CurrentValue = 16, -- Default walk speed
    Flag = "WalkSpeedSlider", -- Unique identifier for the slider
    Callback = function(Value)
        setWalkSpeed(Value) -- Update the walk speed whenever the slider changes
    end,
})