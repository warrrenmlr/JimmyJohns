--=====This file only really exists for me to transfer code blocks from mac to windows easily. Some beta features might be added here, so feel free to try them out=====--

--===Fisch V2 or smth like that ig. None of ts works at all, but hopefully it's gonna.===--
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

--// Regions n shit
local General = CreateTab("General", 139650104834071) --change to a better icon
local Char = CreateTab("Character", "rbxassetid://18854794412")
local Settings = CreateTab("Settings", "rbxassetid://4483345998")
local Discord = CreateTab("Discord", "rbxassetid://84828491431270")

local FishingSection = CreateRegion(General, "Fishing")
local VisSection = CreateRegion(General, "Configs???")
local AutoSection = CreateRegion(Char, "Character")
local CharSection = CreateRegion(Char, "Teleports??")
local DiscordSection = CreateRegion(Discord, "Discord")
local SettingsSection = CreateRegion(Settings, "Settings")

--//Defining
local RunService = game:GetService("RunService")
local GuiService = cloneref(game:GetService('GuiService'))
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
local vim = game:GetService('VirtualInputManager')

--//WindowSettings
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

--//Helper Funcs 
FindChild = function(parent, child)
    return parent:FindFirstChild(child)
end
FindChildOfClass = function(parent, classname) --Issue was *probably* this not being defined. pmo
    return parent:FindFirstChildOfClass(classname)
end
FindRod = function()
    if FindChildOfClass(getchar(), 'Tool') and FindChild(FindChildOfClass(getchar(), 'Tool'), 'values') then
        return FindChildOfClass(getchar(), 'Tool')
    else
        return nil
    end
end
getchar = function() --and this
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
gethrp = function()
    return getchar():WaitForChild('HumanoidRootPart')
end

--//Fishing Section
--checks or smth.
CheckRS = RunService.Heartbeat:Connect(function()
    local ReelUI = LocalPlayer.PlayerGui:FindFirstChild("reel")
    if ReelUI then local Bar = ReelUI and ReelUI:FindFirstChild("bar")
        if Bar then local PlayerBar, TargetBar = Bar and Bar:FindFirstChild("playerbar"), Bar and Bar:FindFirstChild("fish") end
    end
    local ShakeUI = LocalPlayer.PlayerGui:FindFirstChild("shakeui")
    if ShakeUI then local ShakeSafezone = LocalPlayer.PlayerGui:FindFirstChild('shakeui'):FindFirstChild('safezone') 
        if ShakeSafezone then local ShakeButton = LocalPlayer.PlayerGui['shakeui']['safezone']:FindFirstChild('button') end
    end
end)
--Casting 
AutoCastActive =false
AutoCastMode = "Normal"
FishingSection:Checkbox({
    Value = false,
    Label = "Auto Cast",
    Callback = function(self, Value: boolean)
        if Value then
            AutoCastActive = true
            AutoCastCombo = FishingSection:Combo({
                Label = "Cast Config",
                Items = {"Hidden - Fast", "Hidden - Delayed", "Normal"},
                Selected = AutoCastMode,
                Callback = function(self, ComboValue: string)
                    AutoCastMode = ComboValue
                end
            })
        else
            AutoCastActive = false
            if AutoCastCombo then
                AutoCastCombo:Destroy()
                AutoCastCombo = nil
            end
        end
    end
})
AutoCastRS = RunService.Heartbeat:Connect(function()
    if AutoCastActive then
        local rod = FindRod()
        if AutoCastMode == "Hidden - Fast" then --***fuckass vim dont work*** (mby) 
            if rod then
                vim:SendMouseButtonEvent(0, 0, Enum.UserInputType.MouseButton1, true, game, 0) -- change coords to wherever
                task.wait(0.01)
                vim:SendMouseButtonEvent(0, 0, Enum.UserInputType.MouseButton1, false, game, 0)
            end
        elseif AutoCastMode == "Hidden - Delayed" then --***fuckass vim dont work*** (mby)
            if rod then
                game:GetService('VirtualInputManager'):SendMouseButtonEvent(0, 0, Enum.UserInputType.MouseButton1, true, game, 0) 
                task.wait(0.5)
                game:GetService('VirtualInputManager'):SendMouseButtonEvent(0, 0, Enum.UserInputType.MouseButton1, false, game, 0)
                
            end
        elseif AutoCastMode == "Normal" then --This should work for now
            if rod then
                local lureValue = rod['values']['lure'].Value

                if lureValue <= .001 then
                    rod.events.cast:FireServer(100, 1)
                end
            end
        end
    end
end)
--Should be the basics for casting, build upon them if instant casting isn't detected. ie; Blatant Cast.
--Shaking
AutoShakeActive = false
FishingSection:Checkbox({
    Value = false,
    Label = "Auto Shake",
    Callback = function(self, Value: boolean)
        if Value then
            AutoShakeActive = true
        else
            AutoShakeActive = false
        end
    end
})
AutoShakeRS = RunService.Heartbeat:Connect(function()
    if AutoShakeActive then
        if ShakeUI and ShakeSafezone and ShakeButton then
            GuiService.SelectedObject = LocalPlayer.PlayerGui['shakeui']['safezone']['button']
            if GuiService.SelectedObject == LocalPlayer.PlayerGui['shakeui']['safezone']['button'] then
                game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end
    end
end)
--This is really shit, figure out how to change pos of the buttons and autoclick for more better. If unable, you can also click by finding pos and using vim to click at pos (mby)
--Reeling
AutoReelActive = false
AutoReelMode = "Clamp"
FishingSection:Checkbox({
    Value = false,
    Label = "Auto Reel",
    Callback = function(self, Value: boolean)
        if Value then
            AutoReelActive = true
            AutoReelCombo = FishingSection:Combo({
                Label = "Reel Config",
                Items = {"Clamp", "Instant"},
                Selected = AutoReelMode,
                Callback = function(self, ComboValue: string)
                    AutoReelMode = ComboValue
                end
            })
            AutoReelText = FishingSection:Label({
                Text = "Warning! Instant may be detected soon!"
            })
        else
            AutoReelActive = false
            if AutoReelCombo and AutoReelText then
                AutoReelCombo:Destroy()
                AutoReelCombo = nil
                AutoReelText:Destroy()
                AutoReelText = nil
            end
        end
    end
})
AutoReelRS = RunService.Heartbeat:Connect(function()
    if AutoReelActive then
        if AutoReelMode == "Clamp" then
            local ReelUI = LocalPlayer.PlayerGui:FindFirstChild("reel")
            if not ReelUI then return end
    
            local Bar = ReelUI:FindFirstChild("bar")
            if not Bar then return end
    
            local PlayerBar = Bar:FindFirstChild("playerbar")
            local TargetBar = Bar:FindFirstChild("fish")
            if not PlayerBar or not TargetBar then return end
    
            
            local unfiltered = PlayerBar.Position:Lerp(TargetBar.Position, 0.7)
            local clampedX = math.clamp(unfiltered.X.Scale, 0.15, 0.85)
            local newPos = UDim2.new(clampedX, 0, unfiltered.Y.Scale, 0)
    
            PlayerBar.Position = newPos
        elseif AutoReelMode == "Instant" then
            local ReelUI = LocalPlayer.PlayerGui:FindFirstChild("reel") --should be able to remove all the definitions. mby. 
            if not ReelUI then return end

            local Bar = ReelUI:FindFirstChild("bar")
            if not Bar then return end

            local PlayerBar = Bar:FindFirstChild("playerbar")
            local TargetBar = Bar:FindFirstChild("fish")
            if not PlayerBar or not TargetBar then return end

            local args = {100, true}
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("reelfinished "):FireServer(unpack(args))
        end
    end
end)

--Use the helper funcs, idk why it aint working without. And figure out a way to fix configs if possible.
