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
