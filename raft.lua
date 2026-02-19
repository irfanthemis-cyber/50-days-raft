-- ======================================================
-- 50 DAYS ON A RAFT - AFK AUTO COLLECT (TELEPORT & RETURN)
-- ======================================================

-- =====================
-- BASIC SETUP
-- =====================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- =====================
-- SETTINGS (BOLEH EDIT)
-- =====================
local SEARCH_RADIUS = 40      -- jarak max cari item (studs)
local TELEPORT_DELAY = 0.15   -- jeda teleport
local LOOP_DELAY = 1          -- kecepatan scan

-- =====================
-- STATE
-- =====================
local AutoCollect = false
local AFKPosition = nil

-- =====================
-- GUI ROOT
-- =====================
local gui = Instance.new("ScreenGui")
gui.Name = "RaftAFKUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- =====================
-- TOGGLE BUTTON (LOGO)
-- =====================
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

-- =====================
-- MENU FRAME
-- =====================
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

-- =====================
-- UI TOGGLES
-- =====================
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

autoBtn.MouseButton1Click:Connect(function()
    AutoCollect = not AutoCollect
    autoBtn.Text = AutoCollect and "Auto Collect : ON" or "Auto Collect : OFF"

    -- simpan posisi AFK saat dinyalakan
    if AutoCollect then
        AFKPosition = hrp.CFrame
    end
end)

-- =====================
-- FIND NEAREST ITEM
-- =====================
local function getNearestPrompt()
    local nearest = nil
    local shortest = SEARCH_RADIUS

    for _,prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
            local container = prompt.Parent
            local part =
                (container:IsA("BasePart") and container)
                or container:FindFirstChildWhichIsA("BasePart")
                or (container.Parent and container.Parent:FindFirstChildWhichIsA("BasePart"))

            if part then
                local dist = (part.Position - AFKPosition.Position).Magnitude
                if dist <= shortest then
                    shortest = dist
                    nearest = {prompt = prompt, part = part}
                end
            end
        end
    end

    return nearest
end

-- =====================
-- AUTO COLLECT LOOP
-- =====================
task.spawn(function()
    while task.wait(LOOP_DELAY) do
        if AutoCollect and AFKPosition then
            local target = getNearestPrompt()
            if target then
                pcall(function()
                    -- teleport ke item
                    hrp.CFrame = target.part.CFrame + Vector3.new(0,2,0)
                    task.wait(TELEPORT_DELAY)

                    -- ambil item
                    fireproximityprompt(target.prompt)
                    task.wait(TELEPORT_DELAY)

                    -- balik ke posisi awal
                    hrp.CFrame = AFKPosition
                end)
            end
        end
    end
end)

-- =====================
-- NOTIFICATION
-- =====================
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Loaded",
        Text = "Tap ⚓ → Auto Collect AFK",
        Duration = 5
    })
end)

print("✅ AFK Auto Collect loaded")
