--=====This file only really exists for me to transfer code blocks from mac to windows easily. Some beta features might be added here, so feel free to try them out=====--

--===Aimbot with more customizable options (add into the regular code)===--
local AimFOV = 125
local AimColor = Color3.fromRGB(255, 255, 255)
tabs["Main"]:Checkbox({
    Value = false,
    Label = "Aimbot",
    Callback = function(self, Value: boolean)
        if Value then
            local LOCK_DISTANCE = 300 -- studs

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

            RunService.RenderStepped:Connect(function()
                circle.Size = UDim2.new(0, AimFOV * 2, 0, AimFOV * 2)
                outline.Color = AimColor
            end)

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

tabs["Main"]:SliderColor3({
    Value = Color3.fromRGB(255,255,255),
    Label = "Color",
    Callback = function(self, Value: Color3)
        AimColor = Value
    end

})

--===Testing out a new GUI overhaul, will come with better working features as well===--
local RunService = game:GetService("RunService")

local ReGui = require(game.ReplicatedStorage.ReGui)
ReGui:Init()
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
	Title = "Modal Example",
	AutoSize = "Y"
})
ModalWindow:Label({
	Text = [[Hello, this is a modal. 
Thank you for using Depso's ReGui 😁]],
	TextWrapped = true
})
ModalWindow:Separator()
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
local Settings = CreateTab("Settings", ReGui.Icons.Settings)

--// General Tab
local AimbotSection = CreateRegion(General, "Aimbot")
local ESPSection = CreateRegion(General, "ESP")

--//Define Variables
local function Defining()
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
end
Defining()

--//Aimbot Section
local AimFOV = 125
local AimColor = Color3.fromRGB(255,255,255)
AimbotSection:Checkbox({
    Value = false,
    Label = "Aimbot",
    Callback = function(self, Value: boolean)
        if Value then
            local LOCK_DISTANCE = 300 -- studs

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

            RunService.RenderStepped:Connect(function()
                circle.Size = UDim2.new(0, AimFOV * 2, 0, AimFOV * 2)
                outline.Color = AimColor
            end)

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
AimbotSection:SliderInt({
    Label = "FOV",
    Value = 125,
    Minimum = 50,
    Maximum = 500,
    Callback = function(self, Value)
        AimFOV = Value
    end
})
AimbotSection:SliderColor3({
    Value = Color3.fromRGB(255,255,255),
    Label = "Color",
    Callback = function(self, Value: Color3)
        AimColor = Value
    end

})
