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


-- =========================
-- UI BUTTON (NO IMAGE)
-- =========================
local AutoCollect = false

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 60, 0, 60)
button.Position = UDim2.new(0, 10, 0.5, -30)
button.Text = "⚙"
button.TextSize = 28
button.BackgroundColor3 = Color3.fromRGB(30,30,30)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Parent = gui
button.Active = true
button.Draggable = true

button.MouseButton1Click:Connect(function()
    AutoCollect = not AutoCollect
    button.Text = AutoCollect and "ON" or "OFF"
end)

-- =========================
-- AUTO COLLECT ALL ITEMS
-- =========================
task.spawn(function()
    while task.wait(0.5) do
        if AutoCollect then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    local part = v.Parent
                    if part and part:IsA("BasePart") then
                        hrp.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.1)
                        fireproximityprompt(v)
                    end
                end
            end
        end
    end
end)

