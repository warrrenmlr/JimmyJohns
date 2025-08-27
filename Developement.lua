--=====This file only really exists for me to transfer code blocks from mac to windows easily. Some beta features might be added here, so feel free to try them out=====--

--===Gui Overhaul (adding full features little by little, having issues with execs rn so might be a bit)===--
local RunService = game:GetService("RunService")
local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
ReGui:DefineTheme("Cherry", {
	TitleAlign = Enum.TextXAlignment.Center,
	TextDisabled = Color3.fromRGB(120, 100, 120),
	Text = Color3.fromRGB(200, 180, 200),
	
	FrameBg = Color3.fromRGB(25, 20, 25),
	FrameBgTransparency = 0.4,
	FrameBgActive = Color3.fromRGB(120, 100, 120),
	FrameBgTransparencyActive = 0.4,
	
	CheckMark = Color3.fromRGB(150, 100, 150),
	SliderGrab = Color3.fromRGB(150, 100, 150),
	ButtonsBg = Color3.fromRGB(150, 100, 150),
	CollapsingHeaderBg = Color3.fromRGB(150, 100, 150),
	CollapsingHeaderText = Color3.fromRGB(200, 180, 200),
	RadioButtonHoveredBg = Color3.fromRGB(150, 100, 150),
	
	WindowBg = Color3.fromRGB(35, 30, 35),
	TitleBarBg = Color3.fromRGB(35, 30, 35),
	TitleBarBgActive = Color3.fromRGB(50, 45, 50),
	
	Border = Color3.fromRGB(50, 45, 50),
	ResizeGrab = Color3.fromRGB(50, 45, 50),
	RegionBgTransparency = 1,
})
--// Tabs
local Window = ReGui:Window({
	Title = "Cherry",
	Theme = "Cherry",
	NoClose = true,
	Size = UDim2.new(0, 600, 0, 400),
}):Center()
local ModalWindow = Window:PopupModal({
	Title = "I REAAAALLLY like cats",
	AutoSize = "Y"
})
ModalWindow:Label({
	Text = [[Hey! This script is slowly developing, but we need more testers! If you are at all interested in getting early versions of this script, please join the discord linked below!]],
	TextWrapped = true
})
ModalWindow:Separator()
ModalWindow:Button({
    Text = "Discord",
    Callback = function()
        local textToCopy = "discord.gg/NVsvWfxv3K"
        setclipboard(textToCopy)
    end
})
ModalWindow:Button({
	Text = "Okay",
	Callback = function()
		ModalWindow:ClosePopup()
	end,
})
local Group = Window:List({
	UiPadding = 2,
	HorizontalFlex = Enum.UIFlexAlignment.Fill,
})
local TabsBar = Group:List({
	Border = true,
	UiPadding = 5,
	BorderColor = Window:GetThemeKey("Border"),
	BorderThickness = 1,
	HorizontalFlex = Enum.UIFlexAlignment.Fill,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	AutomaticSize = Enum.AutomaticSize.None,
	FlexMode = Enum.UIFlexMode.None,
	Size = UDim2.new(0, 40, 1, 0),
	CornerRadius = UDim.new(0, 5)
})
local TabSelector = Group:TabSelector({
	NoTabsBar = true,
	Size = UDim2.fromScale(0.5, 1)
})
local function CreateTab(Name: string, Icon)
	local Tab = TabSelector:CreateTab({
		Name = Name
	})

	local List = Tab:List({
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		UiPadding = 1,
		Spacing = 10
	})

	local Button = TabsBar:Image({
		Image = Icon,
		Ratio = 1,
		RatioAxis = Enum.DominantAxis.Width,
		Size = UDim2.fromScale(1, 1),
		Callback = function(self)
			TabSelector:SetActiveTab(Tab)
		end,
	})

	ReGui:SetItemTooltip(Button, function(Canvas)
		Canvas:Label({
			Text = Name
		})
	end)

	return List
end
local function CreateRegion(Parent, Title)
	local Region = Parent:Region({
		Border = true,
		BorderColor = Window:GetThemeKey("Border"),
		BorderThickness = 1,
		CornerRadius = UDim.new(0, 5)
	})

	Region:Label({
		Text = Title
	})

	return Region
end

local General = CreateTab("General", 139650104834071)
local Char = CreateTab("Character", "rbxassetid://18854794412")
local Discord = CreateTab("Discord", "rbxassetid://84828491431270")


--// General Tab
local AimbotSection = CreateRegion(General, "Aimbot")
local ESPSection = CreateRegion(General, "ESP")
local AutoSection = CreateRegion(Char, "Auto")
local CharSection = CreateRegion(Char, "Character")

--//Define Variables
local Lighting = game:GetService("Lighting")
local suspectsFolder = workspace.GAME:FindFirstChild("Suspects")
local evidenceFolder = workspace.GAME.Suspects:FindFirstChild("Evidence")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Camera = Workspace.CurrentCamera
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

--//Aimbot Section
local AimFOV = 125
local AimColor = Color3.fromRGB(255,255,255)
local AimSpeed = "instant"
AimbotSection:Checkbox({
    Value = false,
    Label = "Enabled",
    Callback = function(self, Value: boolean)
        if Value then
            local LOCK_DISTANCE = 300

            local gui = Instance.new("ScreenGui")
            gui.Name = "AimThresholdCircle"
            gui.ResetOnSpawn = false
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, AimFOV * 2, 0, AimFOV * 2)
            circle.Position = UDim2.new(0.5, 0, 0.475, 0)
            circle.AnchorPoint = Vector2.new(0.5, 0.5)
            circle.BackgroundTransparency = 1
            circle.Parent = gui

            local uiCorner = Instance.new("UICorner")
            uiCorner.CornerRadius = UDim.new(1, 0)
            uiCorner.Parent = circle

            local outline = Instance.new("UIStroke")
            outline.Thickness = 1
            outline.Color = AimColor
            outline.Parent = circle

            local plusHorizontal = Instance.new("Frame")
            plusHorizontal.Size = UDim2.new(0, 10, 0, 2)
            plusHorizontal.Position = UDim2.new(0.5, 0, 0.5, 0)
            plusHorizontal.AnchorPoint = Vector2.new(0.5, 0.5)
            plusHorizontal.BackgroundColor3 = AimColor
            plusHorizontal.BorderSizePixel = 0
            plusHorizontal.Parent = circle

            local plusVertical = Instance.new("Frame")
            plusVertical.Size = UDim2.new(0, 2, 0, 10)
            plusVertical.Position = UDim2.new(0.5, 0, 0.5, 0)
            plusVertical.AnchorPoint = Vector2.new(0.5, 0.5)
            plusVertical.BackgroundColor3 = AimColor
            plusVertical.BorderSizePixel = 0
            plusVertical.Parent = circle

            RunService.RenderStepped:Connect(function()
                circle.Size = UDim2.new(0, AimFOV * 2, 0, AimFOV * 2)
                outline.Color = AimColor
                plusHorizontal.BackgroundColor3 = AimColor
                plusVertical.BackgroundColor3 = AimColor
            end)

            local function isAlive(npc)
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                return humanoid and humanoid.Health > 0
            end

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

            local function getClosestHead()
                local mousePos = Camera.ViewportSize / 2
                local closestNPC, closestDist = nil, math.huge

                for _, npc in ipairs(suspectsFolder:GetChildren()) do
                    if (npc.Name == "Suspect_Regular" or npc.Name == "Suspect_Heavy" or npc.Name == "Suspect_LawranceAccomplice" or npc.Name == "Suspect_LawranceFairfax")
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
                if closestNPC and closestDist <= AimFOV then
                    return closestNPC.Head
                end
                return nil
            end

            RunService.RenderStepped:Connect(function()
                local targetHead = getClosestHead()
                if targetHead then
                    if AimSpeed == "instant" then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                    else 
                        local target = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                        Camera.CFrame = Camera.CFrame:Lerp(target, AimSpeed)
                    end
                end
            end)
        elseif not Value then
            if LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("AimThresholdCircle") then
                LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("AimThresholdCircle"):Destroy()
            end
        end
    end
})
AimbotSection:SliderInt({
    Label = "FOV",
    Value = 125,
    Minimum = 50,
    Maximum = 500,
    Callback = function(self, Value)
        AimFOV = Value
    end
})
AimbotSection:SliderInt({
    Label = "Speed",
    Value = 100,
    Minimum = 1,
    Maximum = 100,
    Callback = function(self, Value)
        if Value < 100 then
            AimSpeed = Value/1000
        else
            AimSpeed = "instant"
        end
    end
})
AimbotSection:SliderColor3({
    Value = Color3.fromRGB(255,255,255),
    Label = "Color",
    Callback = function(self, Value: Color3)
        AimColor = Value
    end

})
ESPSection:Checkbox({
    Value = false,
    Label = "ESP",
    Callback = function(self, Value: boolean)
        if Value then
            if suspectsFolder then
                for _, npc in ipairs(suspectsFolder:GetChildren()) do
                    if (npc.Name == "Suspect_Regular" or npc.Name == "Suspect_Heavy" or npc.Name == "Suspect_LawranceAccomplice" or npc.Name == "Suspect_LawranceFairfax") then
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
ESPSection:Checkbox({
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
local walkspeed = 16
local walkspeedToggle = false
CharSection:Checkbox({
    Value = false,
    Label = "Walkspeed Toggle",
    Callback = function(self, Value)
        walkspeedToggle = Value
    end
})
CharSection:SliderInt({
    Label = "Walkspeed Set",
    Value = 16,
    Minimum = 1,
    Maximum = 30,
    Callback = function(self, Value)
        walkspeed = Value
        
    end
})
RunService.RenderStepped:Connect(function()
    if walkspeedToggle then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

CharSection:Button({
    Text = "m4 inf ammo",
    Callback = function()
        game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Two, false, game)
        game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Two, false, game)
        wait(0.4)
        local gunSettingsModule = LocalPlayer.Backpack["M4 Carbine "]:FindFirstChild("ACS_Settings")

        if gunSettingsModule and gunSettingsModule:IsA("ModuleScript") then
            local ACS_Settings = require(gunSettingsModule)

            ACS_Settings.Ammo = 1000
            ACS_Settings.AmmoInGun = 1000
            --ACS_Settings.ShootRate = 12000
            --ACS_Settings.ShootType = 3
            ACS_Settings.camRecoil = {
                ["camRecoilUp"] = v1 and { 0, 0 } or { 0, 0 },
                ["camRecoilTilt"] = v1 and { 0, 0 } or { 0, 0 },
                ["camRecoilLeft"] = v1 and { 0, 0 } or { 0, 0 },
                ["camRecoilRight"] = v1 and { 0, 0 } or { 0, 0 }
            }
            ACS_Settings.gunRecoil = {
                ["gunRecoilUp"] = { 0, 0 },
                ["gunRecoilTilt"] = { 0, 0 },
                ["gunRecoilLeft"] = { 0, 0 },
                ["gunRecoilRight"] = { 0, 0 }
            }
            ACS_Settings.MinSpread = 0
            ACS_Settings.MaxSpread = 0
            ACS_Settings.BulletDrop = 0
            ACS_Settings.MuzzleVelocity = 10000
            ACS_Settings.AimInaccuracyStepAmount = 0
            ACS_Settings.AimInaccuracyDecrease = 0
            ACS_Settings.AimRecoilReduction = 0
            ACS_Settings.AimSpreadReduction = 0
            ACS_Settings.MinRecoilPower = 0
            ACS_Settings.MaxRecoilPower = 0
            ACS_Settings.RecoilPowerStepAmount = 0
        end
        wait(0.1)
        game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.One, false, game)
        game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.One, false, game)
    end
})

local AutoEvidence
AutoSection:Checkbox({
    Value = false,
    Label = "Auto Collect Evidence",
    Callback = function(self, Value: boolean)
        AutoEvidence = Value
    end
})
local AutoReport
AutoSection:Checkbox({
    Value = false,
    Label = "Auto Report Suspects",
    Callback = function(self, Value: boolean)
        AutoReport = Value
    end
})
local AutoDoor
AutoSection:Checkbox({
    Value = false,
    Label = "Auto Breach Doors",
    Callback = function(self, Value: boolean)
        AutoDoor = Value
    end
})
local AutoArrest
AutoSection:Checkbox({
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
    "HardDrive",
    "Radio",
    "Radio",
    "Cargo"
}
local prompts = {}
local function collectPrompts()
    prompts = {} -- reset each time to reflect current map state
    local evidenceFolder = workspace.GAME.Suspects.Evidence
    for _, evidence in ipairs(evidenceFolder:GetChildren()) do
        if table.find(evidenceNames, evidence.Name) and evidence:FindFirstChild("EvidenceBag") then
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
        if suspect.Name == "Suspect_Regular" or suspect.Name == "Suspect_Heavy" 
        or suspect.Name == "Suspect_LawranceAccomplice" or suspect.Name == "Suspect_LawranceFairfax" then
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
RunService.RenderStepped:Connect(function()
    if AutoReport then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local prompts2 = getAllSuspectPrompts() -- refresh every frame

        for i = #prompts2, 1, -1 do
            local prompt = prompts2[i]
            if prompt and prompt.Parent and prompt.Parent:IsA("BasePart") then
                local suspectModel = prompt.Parent.Parent
                local humanoid = suspectModel and suspectModel:FindFirstChildOfClass("Humanoid")
                
                if humanoid and humanoid.Health <= 0 then
                    local promptPosition = prompt.Parent.Position
                    local distance = (root.Position - promptPosition).Magnitude
                    if distance <= prompt.MaxActivationDistance then
                        fireproximityprompt(prompt)
                    end
                end
            end
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
        if suspect.Name == "Civilian_LadyFairfax" or suspect.Name == "Civilian_HostageMMB" or suspect.Name == "Civilian_Madame" or suspect.Name == "Civilian_Melinda" or suspect.Name == "Civilian_Worker" then
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
