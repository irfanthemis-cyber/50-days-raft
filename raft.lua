-- ======================================
-- 50 DAYS ON A RAFT - AUTO COLLECT STABLE
-- ======================================

-- ===== BASIC =====
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getChar()
    local c = player.Character or player.CharacterAdded:Wait()
    return c, c:WaitForChild("HumanoidRootPart")
end

local char, hrp = getChar()
player.CharacterAdded:Connect(function()
    char, hrp = getChar()
end)

-- ===== STATE =====
local AutoCollect = false
local StartCFrame = nil
local Busy = false -- 🔑 lock proses

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

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "50 Days on a Raft"
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

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

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

autoBtn.MouseButton1Click:Connect(function()
    AutoCollect = not AutoCollect
    autoBtn.Text = AutoCollect and "Auto Collect : ON" or "Auto Collect : OFF"

    if AutoCollect then
        StartCFrame = hrp.CFrame -- simpan SEKALI
    else
        Busy = false -- reset biar bisa dipakai ulang
    end
end)

-- ======================================
-- AUTO COLLECT (1 ITEM / LOOP)
-- ======================================
task.spawn(function()
    while task.wait(0.5) do
        if AutoCollect and StartCFrame and not Busy then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and v.Enabled then
                    local container = v.Parent
                    local part =
                        (container:IsA("BasePart") and container)
                        or container:FindFirstChildWhichIsA("BasePart")
                        or (container.Parent and container.Parent:FindFirstChildWhichIsA("BasePart"))

                    if part then
                        Busy = true
                        pcall(function()
                            -- ke item
                            hrp.CFrame = part.CFrame + Vector3.new(0,2,0)
                            task.wait(0.2)

                            -- HOLD prompt (WAJIB)
                            fireproximityprompt(v, v.HoldDuration or 0.2)
                            task.wait(0.3)

                            -- balik ke awal
                            hrp.CFrame = StartCFrame
                        end)
                        Busy = false
                        break -- 🔑 1 item saja
                    end
                end
            end
        end
    end
end)

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Loaded",
        Text = "Auto Collect siap dipakai ulang",
        Duration = 5
    })
end)
