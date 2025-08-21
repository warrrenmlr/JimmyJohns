local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local Window = ReGui:TabsWindow({
    Title = "Tarnished is my goat <3",
    Size = UDim2.fromOffset(300, 250)
})

local tabs = {}
local Names = {"Main", "Char", "TP", "Dev"}

for _, Name in next, Names do
    tabs[Name] = Window:CreateTab({ Name = Name })
end

local Players = game:GetService("Players")
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local RunService = game:GetService("RunService")
local GuiService = cloneref(game:GetService('GuiService'))
local LocalPlayer = Players.LocalPlayer

local flags = {}
local characterposition
local lp = Players.LocalPlayer
local fishabundancevisible = false
local deathcon
local tooltipmessag

local shakeConnection
local shakeActive = false
local reelConnection
local reelActive = false
local castConnection
local castActive = false
local afkConnection

FindChild = function(parent, child)
    return parent:FindFirstChild(child)
end
FindChildOfClass = function(parent, classname)
    return parent:FindFirstChildOfClass(classname)
end
FindRod = function()
    if FindChildOfClass(getchar(), 'Tool') and FindChild(FindChildOfClass(getchar(), 'Tool'), 'values') then
        return FindChildOfClass(getchar(), 'Tool')
    else
        return nil
    end
end
getchar = function()
    return lp.Character or lp.CharacterAdded:Wait()
end
gethrp = function()
    return getchar():WaitForChild('HumanoidRootPart')
end


--FreezeChar Main (WIP)
local function enableFreezeChar()
    if freezeActive then return end
    freezeActive = true

    freezeConnection = RunService.Heartbeat:Connect(function()
        if flags['freezechar'] then
            if freezeMode == 'Toggled' then
                if characterposition == nil then
                    characterposition = gethrp().CFrame
                else
                    gethrp().CFrame = characterposition
                end
            elseif freezeMode == 'Rod Equipped' then
                local rod = FindRod()
                if rod then
                    if characterposition == nil then
                        characterposition = gethrp().CFrame
                    else
                        gethrp().CFrame = characterposition
                    end
                else
                    characterposition = nil
                end
            end
        end
    end)
end
local function disableFreezeChar()
    if not freezeActive then return end
    freezeActive = false

    if freezeConnection then
        freezeConnection:Disconnect()
        freezeConnection = nil
        characterposition = nil
    end
end
tabs["Char"]:Checkbox({
    Value = false,
    Label = "Freeze Character",
    Callback = function(self, Value: boolean)
        print("Freeze Character Ticked", Value)
        if Value then
            flags['freezechar'] = true
            if freezeMode then
                enableFreezeChar()
            end
        else
            flags['freezechar'] = false
            disableFreezeChar()
        end
    end
})
tabs["Char"]:Combo({
    Label = "Freeze Mode",
    Items = {"Toggled", "Rod Equipped"},
    Selected = "Rod Equipped",
    Callback = function(self, Mode)
        freezeMode = Mode
        print("Freeze Mode set to", Mode)
        if flags['freezechar'] then
            disableFreezeChar()
            enableFreezeChar()
        end
    end
})

--Auto Cast Main
local function enableCastUI()
    if castActive then return end
    castActive = true

    castConnection = RunService.Heartbeat:Connect(function()
        local rod = FindRod()
        if rod then
            local lureValue = rod['values']['lure'].Value

            if lureValue <= .001 then
                rod.events.cast:FireServer(100, 1)
            end
        end
    end)
end
local function disableCastUI()
    if not castActive then return end
    castActive = false

    if castConnection then
        castConnection:Disconnect()
        castConnection = nil
    end
end
tabs["Main"]:Checkbox({
    Value = false,
    Label = "Auto Cast",
    Callback = function(self, Value: boolean)
        print("Ticked", Value)
        if Value then
            enableCastUI()
        else
            disableCastUI()
        end
    end
})

--Auto Shake Main
local function enableShakeUI()
    if shakeActive then return end
    shakeActive = true

    shakeConnection = RunService.Heartbeat:Connect(function()
        if FindChild(lp.PlayerGui, 'shakeui') and FindChild(lp.PlayerGui['shakeui'], 'safezone') and FindChild(lp.PlayerGui['shakeui']['safezone'], 'button') then
            GuiService.SelectedObject = lp.PlayerGui['shakeui']['safezone']['button']
            if GuiService.SelectedObject == lp.PlayerGui['shakeui']['safezone']['button'] then
                game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end
    end)
end
local function disableShakeUI()
    if not shakeActive then return end
    shakeActive = false

    if shakeConnection then
        shakeConnection:Disconnect()
        shakeConnection = nil
    end
end
tabs["Main"]:Checkbox({
    Value = false,
    Label = "Auto Shake",
    Callback = function(self, Value: boolean)
        print("Ticked", Value)
        if Value then
            enableShakeUI()
        else
            disableShakeUI()
        end
    end
})

--Auto Reel Main
local function enableReelUI()
    if reelActive then return end
    reelActive = true
    reelConnection = RunService.Heartbeat:Connect(function()
        local rod = FindRod()
        if rod then
            local lureValue = rod['values']['lure'].Value

            if lureValue >= 100 then
                ReplicatedStorage.events.reelfinished:FireServer(100, true)
            end
        end
    end)
end
local function enablereelUI2()
    if reelActive then return end
    reelActive = true
    reelConnection = RunService.Heartbeat:Connect(function()
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

    end)
end
local function testReel()
    if reelActive then return end
    reelActive = true
    reelConnection = RunService.Heartbeat:Connect(function()
        local ReelUI = LocalPlayer.PlayerGui:FindFirstChild("reel")
        if not ReelUI then return end

        local Bar = ReelUI:FindFirstChild("bar")
        if not Bar then return end

        local PlayerBar = Bar:FindFirstChild("playerbar")
        local TargetBar = Bar:FindFirstChild("fish")
        if not PlayerBar or not TargetBar then return end

        local args = {
            100,
            true
        }
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("reelfinished "):FireServer(unpack(args))
        

    end)
end
local function disableReelUI()
    if not reelActive then return end
    reelActive = false

    if reelConnection then
        reelConnection:Disconnect()
        reelConnection = nil
    end
end
tabs["Main"]:Checkbox({
    Value = false,
    Label = "Auto Reel",
    Callback = function(self, Value: boolean)
        print("Ticked", Value)
        if Value then
            if reelMode == "Legit" then
                enablereelUI2()
            elseif reelMode == "Blatant" then
                enableReelUI()
            elseif reelMode == "Bypass" then
                testReel()            
            end
        else
            disableReelUI()
        end
    end
})
tabs["Main"]:Combo({
    Label = "Reel Config",
    Items = {"Blatant", "Bypass", "Legit"},
    Selected = "Legit",
    Callback = function(self, Mode)
        reelMode = Mode

    end
})

--Teleport Prep + Functions
local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
local islandSelect = "None"
local rodSelect = "None"
local totemSelect = "None"
--Teleport Main
tabs["TP"]:Button({
    Text = "Island Teleport",
    Callback = function()
        if islandSelect == "None" then end
        if islandSelect == "Moosewood" then
            hrp.CFrame = CFrame.new(379, 135, 233)
        elseif islandSelect == "Roslit" then
            hrp.CFrame = CFrame.new(-1472, 133, 707)
        elseif islandSelect == "Forsaken" then
            hrp.CFrame = CFrame.new(-2491, 134, 1561)
        elseif islandSelect == "Sunstone" then
            hrp.CFrame = CFrame.new(-913, 139, -1133)
        elseif islandSelect == "Statue of Sovereignty" then
            hrp.CFrame = CFrame.new(21, 160, -1039)
        elseif islandSelect == "Terrapin" then
            hrp.CFrame = CFrame.new(-193, 136, 1951)
        elseif islandSelect == "Grand Reef" then
            hrp.CFrame = CFrame.new(-3575, 151, 524)
        elseif islandSelect == "Depths" then
            hrp.CFrame = CFrame.new(925, -723, 1260)
        elseif islandSelect == "Enchant" then
            hrp.CFrame = CFrame.new(1313, -805, -99)
        elseif islandSelect == "Vents" then
            hrp.CFrame = CFrame.new(-3181, -2040, 4037)
        elseif islandSelect == "Another Damn Test" then
            hrp.CFrame = CFrame.new(19925, 1138, 5359)
        elseif islandSelect == "Veil of the Forsaken" then
            hrp.CFrame = CFrame.new(-2513, -11224, 6917)
        elseif islandSelect == "Calm Zone" then
            hrp.CFrame = CFrame.new(-4322, -11183, 3680)
        elseif islandSelect == "Kraken Pool" then
            hrp.CFrame = CFrame.new(-4261, -1001, 2020)
        elseif islandSelect == "Ancient Isles" then
            hrp.CFrame = CFrame.new(6010, 190, 331)
        end
    end
})
tabs["TP"]:Combo({
    Label = "Islands",
    Items = {"None", "Moosewood", "Roslit", "Forsaken", "Sunstone", "Statue of Sovereignty", "Terrapin", "Grand Reef", "Depths", "Enchant", "Vents", "Veil of the Forsaken", "Calm Zone", "Kraken Pool", "Ancient Isles", "Another Damn Test"},
    Selected = "None",
    Callback = function(self, Mode)
        islandSelect = Mode
    end
})
tabs["TP"]:Button({
    Text = "Rod Teleport",
    Callback = function()
        if rodSelect == "None" then end
        if rodSelect == "Arctic" then
            hrp.CFrame = CFrame.new(19579, 133, 5303)
        elseif rodSelect == "Trident" then
            hrp.CFrame = CFrame.new(-1484, -226, -2205)
        elseif rodSelect == "Depthseeker" then
            hrp.CFrame = CFrame.new(-4462, -606, 1869)
        elseif rodSelect == "Champions" then
            hrp.CFrame = CFrame.new(-4270, -604, 1838)
        elseif rodSelect == "Abyssal Specter" then
            hrp.CFrame = CFrame.new(-3804, -567, 1863)
        elseif rodSelect == "Tempest" then
            hrp.CFrame = CFrame.new(-4932, -596, 1851)
        elseif rodSelect == "Zues" then
            hrp.CFrame = CFrame.new(-4278, -628, 2664)
        elseif rodSelect == "Heavens" then
            hrp.CFrame = CFrame.new(20026, -468, 7113)
        elseif rodSelect == "Steady" then
            hrp.CFrame = CFrame.new(-1511, 142, 764)
        elseif rodSelect == "Rapid" then
            hrp.CFrame = CFrame.new(-1509, 142, 764)
        elseif rodSelect == "EPR" then
            hrp.CFrame = CFrame.new(-4360, -11171, 3715)
        elseif rodSelect == "Kraken" then
            hrp.CFrame = CFrame.new(-4408, -997, 2053)
        end 
    end
})
tabs["TP"]:Combo({
    Label = "Rods",
    Items = {"None", "Steady", "Long", "Arctic", "Depthseeker", "Champions", "Abyssal Specter", "Tempest", "Zues", "Trident", "Heavens", "EPR", "Kraken"},
    Selected = "None",
    Callback = function(self, Mode)
        rodSelect = Mode
    end
})
tabs["TP"]:Button({
    Text = "Totem Teleport",
    Callback = function()
        if totemSelect == "None" then end
        if totemSelect == "Aurora" then
            hrp.CFrame = CFrame.new(-1810, -135, -3280)
        end
    end
})
tabs["TP"]:Combo({
    Label = "Totems",
    Items = {"None", "Aurora"},
    Selected = "None",
    Callback = function(self, Mode)
        totemSelect = Mode
    end
})
tabs["TP"]:Button({
    Text = "Merlin",
    Callback = function()
        hrp.CFrame = CFrame.new(-931, 223, -988)
    end
})

--Anti-AFK (WIP)
tabs["Char"]:Checkbox({
    Value = false,
    Label = "Anti-AFK",
    Callback = function(self, Value: boolean)
        print("Ticked", Value)
        if Value then
            afkConnection = RunService.Heartbeat:Connect(function()
                wait(5)
                local args = {
                    false
                }
                game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("afk"):FireServer(unpack(args))
                
            end)
        end
    end
})

--Development tools
tabs["Dev"]:Button({
    Text = "Infinite Yeild",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})
tabs["Dev"]:Button({
    Text = "Coords",
    Callback = function()
        -- LocalScript inside PlayerGui

        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI setup
        local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
        gui.Name = "CoordGui"
        gui.IgnoreGuiInset = true  -- optional: removes Roblox’s top bar margin :contentReference[oaicite:1]{index=1}


        local frame = Instance.new("Frame", gui)
        frame.Size = UDim2.new(0, 180, 0, 100)
        frame.Position = UDim2.new(0, 20, 0, 50)
        frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
        frame.BorderSizePixel = 0

        local function newLabel(name, yOffset)
            local lbl = Instance.new("TextLabel")
            lbl.Name = name
            lbl.Size = UDim2.new(1, -20, 0, 20)
            lbl.Position = UDim2.new(0, 10, 0, yOffset)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.new(1,1,1)
            lbl.TextSize = 14
            lbl.Text = name .. ": 0.00"
            lbl.Parent = frame
            return lbl
        end

        local xLabel = newLabel("X", 10)
        local yLabel = newLabel("Y", 35)
        local zLabel = newLabel("Z", 60)

        local button = Instance.new("TextButton", frame)
        button.Name = "ShowCoords"
        button.Size = UDim2.new(0, 150, 0, 25)
        button.Position = UDim2.new(0, 10, 1, 5)  -- moved down and within frame
        button.AnchorPoint = Vector2.new(0, 1)       -- bottom-left anchor
        button.Text = "Show Coordinates"
        button.TextSize = 14
        button.BackgroundColor3 = Color3.fromRGB(60,60,60)
        button.TextColor3 = Color3.new(1,1,1)
        button.ZIndex = 2  -- ensures it's on top :contentReference[oaicite:2]{index=2}

        button.MouseButton1Click:Connect(function()
            local pos = hrp.Position
            xLabel.Text = string.format("X: %.2f", pos.X)
            yLabel.Text = string.format("Y: %.2f", pos.Y)
            zLabel.Text = string.format("Z: %.2f", pos.Z)
        end)
    end
})


--Sell all
tabs["Main"]:Button({
    Text = "Sell All",
    Callback = function()
        savedCFrame = hrp.CFrame
        hrp.CFrame = CFrame.new(379, 135, 233)
        local args = {
            {
                voice = 12,
                idle = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("description"):WaitForChild("idle"),
                npc = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant")
            }
        }
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("SellAll"):InvokeServer(unpack(args))
        hrp.CFrame = savedCFrame
    end
})


--Character settings for temp/oxygen
tabs["Char"]:Checkbox({
    Value = false,
    Label = "Inf Oxygen Water",
    Callback = function(self, Value: boolean)
        print("Ticked", Value)
        if Value then
            game.Players.LocalPlayer.Character.Resources.oxygen.Disabled = true
            game.Players.LocalPlayer.Character.Resources.oxygen.ui.Disabled = true
        else
            game.Players.LocalPlayer.Character.Resources.oxygen.Enabled = true
        end
    end
})
tabs["Char"]:Checkbox({
    Value = false,
    Label = "Inf Oxygen Mountains",
    Callback = function(self, Value: boolean)
        if Value then
            game.Players.LocalPlayer.Character.Resources["oxygen(peaks)"].Disabled = true
        else
            game.Players.LocalPlayer.Character.Resources["oxygen(peaks)"].Enabled = true
        end
    end
})
tabs["Char"]:Checkbox({
    Value = false,
    Label = "Temp Bypass V2",
    Callback = function(self, Value: boolean)
        if Value then
            local char = getchar()
            char:SetAttribute("Glimmerfin_Suit", 3)
        else 
            local char = getchar()
            char:SetAttribute("Glimmerfin_Suit", nil)
        end
    end
})


--Half ts broken </3
local scyllaName = "fish_Scylla"
local autoScyllaCheck = false
local scyllaSavedPos = nil
workspace.ChildAdded:Connect(function(child)
    if child.Name == scyllaName then
        if autoScyllaCheck then
            scyllaSavedPos = hrp.CFrame
            local targetPos = Vector3.new(-2516, -11223, 6924)
            local faceTarget = Vector3.new(-2500, -11223, 6930)  -- e.g., east of the spawn
            hrp.CFrame = CFrame.new(targetPos, faceTarget)
        end
    end
end)
workspace.ChildRemoved:Connect(function(child)
    if child.Name == scyllaName then
        if autoScyllaCheck then
            wait(15)
            hrp.CFrame = scyllaSavedPos
        end
    end
end)
tabs["Dev"]:Checkbox({
    Value = false,
    Label = "Auto Scylla",
    Callback = function(self, Value: boolean)
        autoScyllaCheck = Value
    end
})

local krakenName = "fish_The Kraken"
local autoKrakenCheck = false
local krakenSavedPos = nil
workspace.ChildAdded:Connect(function(child)
    if child.Name == krakenName then
        if autoKrakenCheck then
            krakenSavedPos = hrp.CFrame
            local targetPos = Vector3.new(-2516, -11223, 6924)
            local faceTarget = Vector3.new(-2500, -11223, 6930)  -- e.g., east of the spawn
            hrp.CFrame = CFrame.new(targetPos, faceTarget)
        end
    end
end)
workspace.ChildRemoved:Connect(function(child)
    if child.Name == krakenName then
        if autoKrakenCheck then
            wait(15)
            hrp.CFrame = krakenSavedPos
        end
    end
end)
tabs["Dev"]:Checkbox({
    Value = false,
    Label = "Auto Kraken",
    Callback = function(self, Value: boolean)
        autoKrakenCheck = Value
    end
})

local mossName = "Mosslurker"
local autoMossCheck = true
local mossSavedPos = nil
local mossConnection
local char = lp.Character or lp.CharacterAdded:Wait()
local humanoid = char:FindFirstChildOfClass("Humanoid")
workspace.zones.fishing.ChildAdded:Connect(function(child)
    if child.Name == mossName then
        if autoMossCheck then
            mossSavedPos = hrp.CFrame
            local part = workspace.zones.fishing.Mosslurker
            local pos = part.CFrame.Position
            humanoid.PlatformStand = true
            mossConnection = RunService.Heartbeat:Connect(function()
                hrp.CFrame = CFrame.new(pos)
            end)
        end
    end
end)
workspace.zones.fishing.ChildRemoved:Connect(function(child)
    if child.Name == mossName then
        if autoMossCheck then
            hrp.CFrame = mossSavedPos
            mossSavedPos = nil
            humanoid.PlatformStand = false
            mossConnection:Disconnect()
        end
    end
end)
tabs["Dev"]:Checkbox({
    Value = false,
    Label = "Auto Moss",
    Callback = function(self, Value: boolean)
        autoMossCheck = Value
    end
})

local megName = "Megalodon Default"
local autoMegCheck = true
local megSavedPos = nil
local megConnection
workspace.zones.fishing.ChildAdded:Connect(function(child)
    if child.Name == megName then
        if autoMegCheck then
            megSavedPos = hrp.CFrame
            local part = workspace.zones.fishing["Megalodon Default"]
            local pos = part.CFrame.Position
            humanoid.PlatformStand = true
            megConnection = RunService.Heartbeat:Connect(function()
                hrp.CFrame = CFrame.new(pos)
            end)
        end
    end
end)
workspace.zones.fishing.ChildRemoved:Connect(function(child)
    if child.Name == megName then
        if autoMegCheck then
            hrp.CFrame = megSavedPos
            megSavedPos = nil
            humanoid.PlatformStand = false
            megConnection:Disconnect()
        end
    end
end)
tabs["Dev"]:Checkbox({
    Value = false,
    Label = "Auto Meg",
    Callback = function(self, Value: boolean)
        autoMegCheck = Value
    end
})

local char = lp.Character or lp.CharacterAdded:Wait()
local humanoid = char:FindFirstChildOfClass("Humanoid")
tabs["Dev"]:Checkbox({
    Value = false,
    Label = "Air-Fish",
    Callback = function(self, Value: boolean)
        BBC = Value
        while BBC do
            humanoid.PlatformStand = true
            wait(1)
        end
        if not BBC then
            humanoid.PlatformStand = false
        end
    end
})
