-- ====== LOADED INFO ======
print("🔥 50 Days on a Raft script loaded 🔥")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- ====== GUI ROOT ======
local gui = Instance.new("ScreenGui")
gui.Name = "RaftScriptUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- ====== TOGGLE BUTTON (LOGO) ======
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.Text = "⚓"
toggleBtn.TextSize = 24
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = gui
toggleBtn.Active = true
toggleBtn.Draggable = true

-- ====== MAIN FRAME ======
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0, 70, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.Parent = gui

-- ====== TITLE ======
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "50 Days on a Raft"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 16
title.Parent = frame

-- ====== SAMPLE BUTTON ======
local testBtn = Instance.new("TextButton")
testBtn.Size = UDim2.new(1,-20,0,40)
testBtn.Position = UDim2.new(0,10,0,50)
testBtn.Text = "Auto Farm (Soon)"
testBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
testBtn.TextColor3 = Color3.fromRGB(255,255,255)
testBtn.Parent = frame

-- ====== TOGGLE FUNCTION ======
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- ====== NOTIFICATION ======
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Loaded",
        Text = "Tap ⚓ untuk buka/tutup UI",
        Duration = 5
    })
end)

