local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local Window = ReGui:TabsWindow({
    Title = "Fuck Ye",
    Size = UDim2.fromOffset(300, 250)
})

local tabs = {}
local Names = {"Main", "Char", "Gun Mods", "Dev", "In Testing"}

for _, Name in next, Names do
    tabs[Name] = Window:CreateTab({ Name = Name })
end

local Lighting = game:GetService("Lighting")
local suspectsFolder = workspace.GAME:FindFirstChild("Suspects")
local evidenceFolder = workspace.GAME.Suspects:FindFirstChild("Evidence")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or player.CharacterAdded:Wait()
local Camera = Workspace.CurrentCamera
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

tabs["Main"]:Checkbox({
    Value = false,
    Label = "Aimbot",
    Callback = function(self, Value: boolean)
        if Value then
            local LOCK_DISTANCE = 100 -- studs
            local AIM_THRESHOLD = 50 -- pixels

            local gui = Instance.new("ScreenGui")
            gui.Name = "AimThresholdCircle"
            gui.ResetOnSpawn = false
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, AIM_THRESHOLD * 2, 0, AIM_THRESHOLD * 2)
            circle.Position = UDim2.new(0.5, 0, 0.475, 0)
            circle.AnchorPoint = Vector2.new(0.5, 0.5)
            circle.BackgroundTransparency = 1

            local uiCorner = Instance.new("UICorner")
            uiCorner.CornerRadius = UDim.new(1, 0)
            uiCorner.Parent = circle

            local outline = Instance.new("UIStroke")
            outline.Thickness = 1
            outline.Color = Color3.fromRGB(255, 255, 255)
            outline.Parent = circle

            -- Add plus sign in center
            local plusHorizontal = Instance.new("Frame")
            plusHorizontal.Size = UDim2.new(0, 10, 0, 2)
            plusHorizontal.Position = UDim2.new(0.5, 0, 0.5, 0)
            plusHorizontal.AnchorPoint = Vector2.new(0.5, 0.5)
            plusHorizontal.BackgroundColor3 = Color3.new(1, 1, 1)
            plusHorizontal.BorderSizePixel = 0
            plusHorizontal.Parent = circle

            local plusVertical = Instance.new("Frame")
            plusVertical.Size = UDim2.new(0, 2, 0, 10)
            plusVertical.Position = UDim2.new(0.5, 0, 0.5, 0)
            plusVertical.AnchorPoint = Vector2.new(0.5, 0.5)
            plusVertical.BackgroundColor3 = Color3.new(1, 1, 1)
            plusVertical.BorderSizePixel = 0
            plusVertical.Parent = circle

            circle.Parent = gui

            -- Function to check if NPC is alive
            local function isAlive(npc)
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                return humanoid and humanoid.Health > 0
            end

            -- Function to check if head is visible
            local function isHeadVisible(head)
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                rayParams.FilterDescendantsInstances = {LocalPlayer.Character}

                local rayDirection = (head.Position - Camera.CFrame.Position)
                local rayResult = Workspace:Raycast(Camera.CFrame.Position, rayDirection, rayParams)

                if rayResult then
                    return rayResult.Instance:IsDescendantOf(head.Parent)
                end
                return false
            end

            -- Find closest valid head
            local function getClosestHead()
                local mousePos = Camera.ViewportSize / 2
                local closestNPC, closestDist = nil, math.huge

                for _, npc in ipairs(suspectsFolder:GetChildren()) do
                    if (npc.Name == "Suspect_Regular" or npc.Name == "Suspect_Heavey" or npc.Name == "Suspect_LawranceAccomplice" or npc.Name == "Suspect_LawranceFairfax")
                    and npc:FindFirstChild("Head")
                    and isAlive(npc) then

                        local head = npc.Head
                        local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)

                        if onScreen then
                            local screenPos = Vector2.new(headPos.X, headPos.Y)
                            local dist = (screenPos - mousePos).Magnitude
                            local camDist = (Camera.CFrame.Position - head.Position).Magnitude

                            if camDist <= LOCK_DISTANCE and dist < closestDist and isHeadVisible(head) then
                                closestNPC = npc
                                closestDist = dist
                            end
                        end
                    end
                end
                if closestNPC and closestDist <= AIM_THRESHOLD then
                    return closestNPC.Head
                end
                return nil
            end

            -- Main loop
            RunService.RenderStepped:Connect(function()
                local targetHead = getClosestHead()
                if targetHead then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                end
            end)
        end
    end
})
tabs["Main"]:Checkbox({
    Value = false,
    Label = "ESP",
    Callback = function(self, Value: boolean)
        if Value then
            if suspectsFolder then
                for _, npc in ipairs(suspectsFolder:GetChildren()) do
                    if (npc.Name == "Suspect_Regular" or npc.Name == "Suspect_Heavey" or npc.Name == "Suspect_LawranceAccomplice" or npc.Name == "Suspect_LawranceFairfax") then
                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = npc
                        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red fill
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = npc
                    else 
                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = npc
                        highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Red fill
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = npc
                    end
                end
                if evidenceFolder then
                    for _, evidence in ipairs(evidenceFolder:GetChildren()) do
                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = evidence
                        highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Red fill
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = game.CoreGui
                    end
                end
            end
        end
    end
})
tabs["Main"]:Checkbox({
    Value = false,
    Label = "Fullbright",
    Callback = function(self, Value: boolean)
        if Value then
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.ClockTime = 14 -- Midday
            Lighting.FogEnd = 100000 -- No fog

            -- Remove dark ambient colors
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)

            -- Prevent time from changing
            Lighting.Changed:Connect(function()
                Lighting.Brightness = 2
                Lighting.GlobalShadows = false
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            end)
        end
    end
})
tabs["Main"]:Checkbox({
    Value = false,
    Label = "Enable Jumping",
    Callback = function(self, Value: boolean)
        if Value then
            local JUMP_FORCE = 50 -- Adjust this to make jump higher/lower

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
                    -- Force upward movement even if jump is disabled
                    rootPart.Velocity = Vector3.new(rootPart.Velocity.X, JUMP_FORCE, rootPart.Velocity.Z)
                end
            end)
        end
    end
})
local walkspeed = 23
tabs["Main"]:Button({
    Text = "Walkspeed",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
    end
})
tabs["Main"]:SliderInt({
    Label = "Walkspeed Set",
    Value = 23,
    Minimum = 1,
    Maximum = 30,
})

tabs["Gun Mods"]:Button({
    Text = "m4 inf ammo",
    Callback = function()
        game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Two, false, game)
        game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Two, false, game)
        wait(1)
        local gunSettingsModule = LocalPlayer.Backpack["M4 Carbine "]:FindFirstChild("ACS_Settings")

        if gunSettingsModule and gunSettingsModule:IsA("ModuleScript") then
            local ACS_Settings = require(gunSettingsModule)

            ACS_Settings.Ammo = 10000
            ACS_Settings.AmmoInGun = 10000
            --ACS_Settings.ShootRate = 12000
            --ACS_Settings.ShootType = 3
            ACS_Settings.camRecoil = {
                ["camRecoilUp"] = v1 and { 0, 0 } or { 0, 0 },
                ["camRecoilTilt"] = v1 and { 0, 0 } or { 0, 0 },
                ["camRecoilLeft"] = v1 and { 0, 0 } or { 0, 0 },
                ["camRecoilRight"] = v1 and { 0, 0 } or { 0, 0 }
            }
            ACS_Settings.MinSpread = 0
            ACS_Settings.MaxSpread = 0
            ACS_Settings.BulletDrop = 0
            ACS_Settings.MuzzleVelocity = 6000
        end
        wait(1)
        game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.One, false, game)
        game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.One, false, game)
    end
})
tabs["Dev"]:Button({
    Text = "Infinite Yeild",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})
local AutoEvidence
tabs["In Testing"]:Checkbox({
    Value = false,
    Label = "Auto Collect Evidence",
    Callback = function(self, Value: boolean)
        AutoEvidence = Value
    end
})
local AutoReport
tabs["In Testing"]:Checkbox({
    Value = false,
    Label = "Auto Report Suspects",
    Callback = function(self, Value: boolean)
        AutoReport = Value
    end
})
local AutoDoor
tabs["In Testing"]:Checkbox({
    Value = false,
    Label = "Auto Breach Doors",
    Callback = function(self, Value: boolean)
        AutoDoor = Value
    end
})
local AutoArrest
tabs["In Testing"]:Checkbox({
    Value = false, 
    Label = "Auto Arrest Civilians",
    Callback = function(self, Value: boolean)
        AutoArrest = Value
    end
})

local evidenceNames = {
    "Suitcase",
    "Pile of guns",
    "Laptop",
    "Pile of money",
    "MoneyStack",
    "GunCarton",
    "HardDrive"
}
local prompts = {}
local function collectPrompts()
    prompts = {}  -- reset each time to reflect current map state
    local evidenceFolder = workspace.GAME.Suspects.Evidence
    for _, name in ipairs(evidenceNames) do
        local evidence = evidenceFolder:FindFirstChild(name)
        if evidence and evidence:FindFirstChild("EvidenceBag") then
            local attachment = evidence.EvidenceBag:FindFirstChild("Attachment")
            if attachment then
                local prompt = attachment:FindFirstChild("ProximityPrompt")
                if prompt then
                    table.insert(prompts, prompt)
                end
            end
        end
    end
end
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local EvidenceConnection
EvidenceConnection = RunService.RenderStepped:Connect(function()
    if AutoEvidence then
        collectPrompts()  -- refresh prompts list every frame or you can call less often if you want

        for i = #prompts, 1, -1 do
            local prompt = prompts[i]
            if prompt and prompt.Parent and prompt.Parent:IsA("Attachment") then
                local promptPosition = prompt.Parent.WorldPosition
                local distance = (root.Position - promptPosition).Magnitude
                if distance <= prompt.MaxActivationDistance then
                    fireproximityprompt(prompt)
                    table.remove(prompts, i)
                end
            else
                table.remove(prompts, i)
            end
        end

        if #prompts == 0 then
            EvidenceConnection:Disconnect()
        end
    end
end)


local function getAllSuspectPrompts()
    local suspectsFolder = workspace:WaitForChild("GAME"):WaitForChild("Suspects")
    local prompts = {}

    for _, suspect in ipairs(suspectsFolder:GetChildren()) do
        if suspect.Name == "Suspect_Regular" or suspect.Name == "Suspect_Heavey" or suspect.Name == "Suspect_LawranceAccomplice" or suspect.Name == "Suspect_LawranceFairfax" then
            local torso = suspect:FindFirstChild("Torso")
            if torso then
                local prompt = torso:FindFirstChild("ProximityPromptReportDead")
                if prompt then
                    table.insert(prompts, prompt)
                end
            end
        end
    end

    return prompts
end
local prompts2 = getAllSuspectPrompts()
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local ReportConnection
ReportConnection = RunService.RenderStepped:Connect(function()
    if AutoReport then
        for i = #prompts2, 1, -1 do  -- backwards to safely remove items
            local prompt = prompts2[i]
            if prompt and prompt.Parent and prompt.Parent:IsA("BasePart") then
                local suspectModel = prompt.Parent.Parent
                local humanoid = suspectModel and suspectModel:FindFirstChildOfClass("Humanoid")
                local isDead = humanoid and humanoid.Health <= 0

                if isDead then
                    local promptPosition = prompt.Parent.Position
                    local distance = (root.Position - promptPosition).Magnitude
                    if distance <= prompt.MaxActivationDistance then
                        fireproximityprompt(prompt)
                        table.remove(prompts2, i)
                    end
                end
            else
                table.remove(prompts2, i)
            end
        end

        if #prompts2 == 0 then
            ReportConnection:Disconnect()
        end
    end
end)

local function getAllDoorPrompts()
    local doorsFolder = workspace:WaitForChild("GAME"):WaitForChild("Doors")
    local prompts = {}

    for _, door in ipairs(doorsFolder:GetChildren()) do
        -- Check for expected name or just include all, adjust if needed
        if door.Name == "DoorV2.5_Wooden" or door.Name == "DoorV2.5_Metal" then
            local lk1 = door:FindFirstChild("Components") 
                          and door.Components:FindFirstChild("Interactions1") 
                          and door.Components.Interactions1:FindFirstChild("LK1")
            if lk1 then
                local prompt = lk1:FindFirstChild("ProximityPrompt")
                if prompt then
                    table.insert(prompts, prompt)
                end
            end
        end
    end

    return prompts
end
local prompts3 = getAllDoorPrompts()
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local DoorConnection
DoorConnection = RunService.RenderStepped:Connect(function()
    if AutoDoor then
        for i = #prompts3, 1, -1 do
            local prompt = prompts3[i]
            if prompt and prompt.Parent and prompt.Parent:IsA("Attachment") then
                local promptPosition = prompt.Parent.WorldPosition
                local distance = (root.Position - promptPosition).Magnitude
                if distance <= prompt.MaxActivationDistance then
                    fireproximityprompt(prompt)
                    table.remove(prompts3, i)
                end
            else
                table.remove(prompts3, i)
            end
        end

        if #prompts3 == 0 then
            DoorConnection:Disconnect()
        end
    end
end)
local function getAllPrompts()
    local prompts = {}

    for _, suspect in ipairs(suspectsFolder:GetChildren()) do
        if suspect.Name == "Civilian_LadyFairfax" or suspect.Name == "Civilian_HostageMMB" or suspect.Name == "Civilian_Madame" or suspect.Name == "Civilian_Melinda" then
            local leftArm = suspect:FindFirstChild("Left Arm")
            if leftArm then
                local attachment = leftArm:FindFirstChild("Attachment")
                if attachment then
                    local prompt = attachment:FindFirstChild("ProximityPrompt")
                    if prompt then
                        table.insert(prompts, prompt)
                    end
                end
            end

            -- Attempt to get "Head" prompt
            local head = suspect:FindFirstChild("Head")
            if head then
                local prompt = head:FindFirstChild("ProximityPromptReport")
                if prompt then
                    table.insert(prompts, prompt)
                end
            end
            local torso = suspect:FindFirstChild("Torso")
            if torso then
                local prompt = torso:FindFirstChild("ProximityPromptReportDead")
                if prompt then
                    table.insert(prompts, prompt)
                end
            end
        end
    end
    return prompts
end
local ArrestConnection
ArrestConnection = RunService.RenderStepped:Connect(function()
    if AutoArrest then
        local prompts2 = getAllPrompts()

        for i = #prompts2, 1, -1 do
            local prompt = prompts2[i]
            if prompt and prompt.Parent and (prompt.Parent:IsA("BasePart") or prompt.Parent:IsA("Attachment")) then
                local suspectModel = prompt.Parent.Parent
                local humanoid = suspectModel and suspectModel:FindFirstChildOfClass("Humanoid")
                local isAlive = humanoid and humanoid.Health > 0
                local isDead = humanoid and humanoid.Health <= 0

                local promptName = prompt.Name

                local shouldFire = false
                if promptName == "ProximityPromptReportDead" then
                    -- Only fire if dead
                    shouldFire = isDead
                elseif promptName == "ProximityPrompt" or promptName == "ProximityPromptReport" then
                    -- Only fire if alive
                    shouldFire = isAlive
                end

                if shouldFire then
                    local promptPosition = (prompt.Parent:IsA("Attachment") and prompt.Parent.WorldPosition) or prompt.Parent.Position
                    local distance = (root.Position - promptPosition).Magnitude
                    if distance <= prompt.MaxActivationDistance then
                        fireproximityprompt(prompt)
                        table.remove(prompts2, i)
                    end
                else
                    table.remove(prompts2, i)
                end
            else
                table.remove(prompts2, i)
            end
        end

        if #prompts2 == 0 then
            ArrestConnection:Disconnect()
        end
    end
end)
