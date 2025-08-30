--=====This file only really exists for me to transfer code blocks from mac to windows easily. Some beta features might be added here, so feel free to try them out=====--

--===adding disabling features for ESP/Fullbright/Aimbot, added FOV changer for Playercam, added Gui Togglability===--
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
local Settings = CreateTab("Settings", "rbxassetid://4483345998")
local Discord = CreateTab("Discord", "rbxassetid://84828491431270")

--// General Tab
local AimbotSection = CreateRegion(General, "Aimbot")
local VisSection = CreateRegion(General, "Visual")
local AutoSection = CreateRegion(Char, "Auto")
local CharSection = CreateRegion(Char, "Character")
local DiscordSection = CreateRegion(Discord, "Discord")
local SettingsSection = CreateRegion(Settings, "Settings")

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

local GuiToggleKey = Enum.KeyCode.Quote
local guiVisible = true
local GuiRoot = Window.Parent
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == GuiToggleKey then
        guiVisible = not guiVisible
        GuiRoot.Enabled = guiVisible
    end
end)

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
--//ESP Section
VisSection:Checkbox({
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
        else 
            for _, npc in ipairs(suspectsFolder:GetChildren()) do
                if npc:FindFirstChildOfClass("Highlight") then
                    npc:FindFirstChildOfClass("Highlight"):Destroy()
                end
            end
            if evidenceFolder then
                for _, evidence in ipairs(evidenceFolder:GetChildren()) do
                    if evidence:FindFirstChildOfClass("Highlight") then
                        evidence:FindFirstChildOfClass("Highlight"):Destroy()
                    end
                end
            end
        end
    end
})
VisSection:Checkbox({
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
        else 
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        end
    end
})
VisSection:SliderInt({
    Label = "FOV",
    Value = 70,
    Minimum = 70,
    Maximum = 120,
    Callback = function(self, Value)
        Camera.FieldOfView = Value
    end 

})
--//WalkSpeed
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
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 10
    end
end)
--//Gun Mods
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
--// Auto Section
local Toggles = {
    AutoEvidence = false,
    AutoReport   = false,
    AutoDoor     = false,
    AutoArrest   = false
}
local EvidenceNames = {
    "Suitcase", "Pile of guns", "Laptop",
    "Pile of money", "MoneyStack", "GunCarton",
    "HardDrive", "Radio", "Cargo"
}
--functions
local function isInRange(prompt)
    local promptPos = prompt.Parent:IsA("Attachment") 
        and prompt.Parent.WorldPosition 
        or prompt.Parent.Position
    return (rootPart.Position - promptPos).Magnitude <= prompt.MaxActivationDistance
end
local function collectPrompts(container, filterFunc, promptLocator)
    local prompts = {}
    for _, obj in ipairs(container:GetChildren()) do
        if filterFunc(obj) then
            local prompt = promptLocator(obj)
            if prompt then
                table.insert(prompts, prompt)
            end
        end
    end
    return prompts
end
--specific collections
local function getEvidencePrompts()
    local evidenceFolder = workspace.GAME.Suspects.Evidence
    return collectPrompts(
        evidenceFolder,
        function(obj) return table.find(EvidenceNames, obj.Name) and obj:FindFirstChild("EvidenceBag") end,
        function(evidence)
            local attachment = evidence.EvidenceBag:FindFirstChild("Attachment")
            return attachment and attachment:FindFirstChild("ProximityPrompt")
        end
    )
end
local function getSuspectReportPrompts()
    local suspects = workspace.GAME.Suspects
    return collectPrompts(
        suspects,
        function(suspect)
            return table.find({
                "Suspect_Regular", "Suspect_Heavy",
                "Suspect_LawranceAccomplice", "Suspect_LawranceFairfax"
            }, suspect.Name)
        end,
        function(suspect)
            return suspect:FindFirstChild("Torso") and suspect.Torso:FindFirstChild("ProximityPromptReportDead")
        end
    )
end
local function getDoorPrompts()
    local doors = workspace.GAME.Doors
    return collectPrompts(
        doors,
        function(door) return door.Name == "DoorV2.5_Wooden" or door.Name == "DoorV2.5_Metal" end,
        function(door)
            local components = door:FindFirstChild("Components")
            return components and components:FindFirstChild("Interactions1") 
                and components.Interactions1:FindFirstChild("LK1") 
                and components.Interactions1.LK1:FindFirstChild("ProximityPrompt")
        end
    )
end
local function getCivilianPrompts()
    local suspects = workspace.GAME.Suspects
    local prompts = {}
    for _, civilian in ipairs(suspects:GetChildren()) do
        if table.find({
            "Civilian_LadyFairfax", "Civilian_HostageMMB",
            "Civilian_Madame", "Civilian_Melinda", "Civilian_Worker"
        }, civilian.Name) then
            local parts = { civilian:FindFirstChild("Left Arm"), civilian:FindFirstChild("Head"), civilian:FindFirstChild("Torso") }
            for _, part in ipairs(parts) do
                if part then
                    for _, promptName in ipairs({"ProximityPrompt", "ProximityPromptReport", "ProximityPromptReportDead"}) do
                        local prompt = part:FindFirstChild(promptName)
                        if prompt then
                            table.insert(prompts, prompt)
                        end
                    end
                end
            end
        end
    end
    return prompts
end
--Core loop
RunService.RenderStepped:Connect(function()
    if Toggles.AutoEvidence then
        for _, prompt in ipairs(getEvidencePrompts()) do
            if isInRange(prompt) then fireproximityprompt(prompt) end
        end
    end
    if Toggles.AutoReport then
        for _, prompt in ipairs(getSuspectReportPrompts()) do
            local humanoid = prompt.Parent.Parent:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 and isInRange(prompt) then
                fireproximityprompt(prompt)
            end
        end
    end
    if Toggles.AutoDoor then
        for _, prompt in ipairs(getDoorPrompts()) do
            if isInRange(prompt) then fireproximityprompt(prompt) end
        end
    end
    if Toggles.AutoArrest then
        for _, prompt in ipairs(getCivilianPrompts()) do
            local suspect = prompt.Parent.Parent
            local humanoid = suspect:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if prompt.Name == "ProximityPromptReportDead" and humanoid.Health <= 0 and isInRange(prompt) then
                    fireproximityprompt(prompt)
                elseif (prompt.Name == "ProximityPrompt" or prompt.Name == "ProximityPromptReport") 
                    and humanoid.Health > 0 and isInRange(prompt) then
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end)
--Checkboxes
AutoSection:Checkbox({
    Value = false,
    Label = "Auto Collect Evidence",
    Callback = function(_, val) Toggles.AutoEvidence = val end
})
AutoSection:Checkbox({
    Value = false,
    Label = "Auto Report Suspects",
    Callback = function(_, val) Toggles.AutoReport = val end
})
AutoSection:Checkbox({
    Value = false,
    Label = "Auto Breach Doors",
    Callback = function(_, val) Toggles.AutoDoor = val end
})
AutoSection:Checkbox({
    Value = false,
    Label = "Auto Arrest Civilians",
    Callback = function(_, val) Toggles.AutoArrest = val end
})

--//Discord Integration

DiscordSection:Label({
    Text = "Join the Discord for updates, support, and to suggest features!",
    TextWrapped = true
})
DiscordSection:Button({
    Text = "Copy Discord Invite",
    Callback = function()
        local textToCopy = "discord.gg/NVsvWfxv3K"
        setclipboard(textToCopy)
        local DiscordPopup = Discord:PopupModal({
            Title = "Join the Discord!",
            AutoSize = "Y"
        })
        DiscordPopup:Label({
            Text = [[Invite Copied to Clipboard!]],
            TextWrapped = true
        })
        DiscordPopup:Button({
            Text = "Okay",
            Callback = function()
                DiscordPopup:ClosePopup()
            end,
        })
    end,
})
--//Settings
SettingsSection:Button({
    Text = "Unload Script",
    Callback = function()
        ReGui:Unload()
    end
})
SettingsSection:Keybind({
    Label = "Toggle Gui Keybind",
    Value = Enum.KeyCode.Quote,
    OnKeybindSet = function(self, KeyID)
        GuiToggleKey = KeyID
    end
})
