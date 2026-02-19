-- ======================================
-- 50 DAYS ON A RAFT - AUTO COLLECT FIXED + RETURN
-- ======================================

-- ===== BASIC =====
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- ===== STATE =====
local AutoCollect = false
local StartCFrame = nil   -- 🔑 POSISI AWAL

-- ======================================
-- GUI ROOT
-- ======================================
local gui = Instance.new("ScreenGui")
gui.Name = "RaftAutoUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ======================================
-- TOGGLE BUTTON
-- ======================================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -27)
toggleBtn.Text = "⚓"
toggleBtn.TextSize = 26
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = gui
toggleBtn.Active = true
toggleBtn.Draggable = true

-- ======================================
-- MENU
-- ======================================
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 160)
frame.Position = UDim2.new(0, 80, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "50 Days on a Raft"
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

-- AUTO COLLECT BUTTON
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(1,-20,0,45)
autoBtn.Position = UDim2.new(0,10,0,55)
autoBtn.Text = "Auto Collect : OFF"
autoBtn.TextSize = 14
autoBtn.Font = Enum.Font.Gotham
autoBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoBtn.BorderSizePixel = 0
autoBtn.Parent = frame
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0,8)

-- TOGGLES
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

autoBtn.MouseButton1Click:Connect(function()
    AutoCollect = not AutoCollect
    autoBtn.Text = AutoCollect and "Auto Collect : ON" or "Auto Collect : OFF"

    if AutoCollect then
        -- 🔑 SIMPAN POSISI AWAL SAAT ON
        StartCFrame = hrp.CFrame
    end
end)

-- ======================================
-- AUTO COLLECT + BALIK KE AWAL
-- ======================================
task.spawn(function()
    while task.wait(0.6) do
        if AutoCollect and StartCFrame then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and v.Enabled then
                    local container = v.Parent
                    local part =
                        (container:IsA("BasePart") and container)
                        or container:FindFirstChildWhichIsA("BasePart")
                        or (container.Parent and container.Parent:FindFirstChildWhichIsA("BasePart"))

                    if part then
                        pcall(function()
                            -- teleport ke item
                            hrp.CFrame = part.CFrame + Vector3.new(0,2,0)
                            task.wait(0.12)

                            -- ambil item
                            fireproximityprompt(v)
                            task.wait(0.12)

                            -- 🔑 BALIK KE POSISI AWAL
                            hrp.CFrame = StartCFrame
                        end)
                    end
                end
            end
        end
    end
end)

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Loaded",
        Text = "Tap ⚓ → Auto Collect ON",
        Duration = 5
    })
end)
