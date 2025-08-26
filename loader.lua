local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local Window = ReGui:TabsWindow({
    Title = "No.",
    Size = UDim2.fromOffset(300, 250)
})

local tabs = {}
local Names = {"Bodycam", "Fisch"}

for _, Name in next, Names do
    tabs[Name] = Window:CreateTab({ Name = Name })
end

tabs["Bodycam"]:Button({
    Text = "Release",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/warrrenmlr/JimmyJohns/main/Bodycam.lua"))()
    end
})
tabs["Bodycam"]:Button({
    Text = "Beta",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/warrrenmlr/JimmyJohns/main/Development.lua"))()
    end
})
tabs["Fisch"]:Button({
    Text = "Release",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/warrrenmlr/JimmyJohns/main/Fisch.lua"))()
    end
})