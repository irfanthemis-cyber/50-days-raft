-- ===== LOAD INFO =====
print("🔥 50 Days on a Raft script loaded 🔥")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "RaftUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== LOGO BUTTON (NO IMAGE, NO UPLOAD) =====
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 52, 0, 52)
toggleBtn.Position = UDim2.new(0, 12, 0.5, -26)
toggleBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
toggleBtn.Text = "⚓"
toggleBtn.TextSize = 26
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = gui
toggleBtn.Active = true
toggleBtn.Draggable = true

-- ===== MAIN UI =====
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0, 80, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0,8)

-- ===== TITLE =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "50 Days on a Raft"
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

-- ===== TOGGLE =====
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- ===== NOTIFICATION =====
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Loaded",
        Text = "Tap ⚓ untuk buka / tutup UI",
        Duration = 5
    })
end)
