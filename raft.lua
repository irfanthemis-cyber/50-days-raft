-- ======================================================
-- 50 DAYS ON A RAFT - AFK ITEM COLLECT & DROP TO PLAYER
-- ======================================================

-- =====================
-- BASIC SETUP
-- =====================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- =====================
-- SETTINGS (EDIT INI)
-- =====================
local SEARCH_RADIUS = 40
local LOOP_DELAY = 0.35
local TELEPORT_DELAY = 0.06

-- =====================
-- STATE
-- =====================
local AutoCollect = false
local AFKPosition = nil

-- =====================
-- GUI
-- =====================
local gui = Instance.new("ScreenGui")
gui.Name = "RaftAFKDropUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

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
        AFKPosition = hrp.CFrame
    end
end)

-- =====================
-- FIND NEAREST ITEM
-- =====================
local function getNearestItem()
    local nearest, shortest = nil, SEARCH_RADIUS

    for _,prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
            local c = prompt.Parent
            local part =
                (c:IsA("BasePart") and c)
                or c:FindFirstChildWhichIsA("BasePart")
                or (c.Parent and c.Parent:FindFirstChildWhichIsA("BasePart"))

            if part then
                local dist = (part.Position - AFKPosition.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = {prompt = prompt, part = part}
                end
            end
        end
    end

    return nearest
end

-- =====================
-- AUTO COLLECT & DROP
-- =====================
task.spawn(function()
    while task.wait(LOOP_DELAY) do
        if AutoCollect and AFKPosition then
            local target = getNearestItem()
            if target then
                pcall(function()
                    -- teleport ke item
                    hrp.CFrame = target.part.CFrame + Vector3.new(0,2,0)
                    task.wait(TELEPORT_DELAY)

                    -- trigger pickup / detach
                    fireproximityprompt(target.prompt)
                    task.wait(0.05)

                    -- paksa item ke AFK spot
                    if target.part and target.part.Parent then
                        target.part.CFrame = AFKPosition + Vector3.new(0, 2, 0)
                    end

                    -- balik ke AFK spot
                    hrp.CFrame = AFKPosition
                end)
            end
        end
    end
end)

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Loaded",
        Text = "AFK Collect & Drop aktif",
        Duration = 5
    })
end)

print("✅ AFK Collect & Drop loaded")
