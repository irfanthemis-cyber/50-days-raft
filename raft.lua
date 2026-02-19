-- ======================================================
-- 50 DAYS ON A RAFT - AFK AUTO COLLECT (STABLE)
-- ======================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- ===== SETTINGS =====
local SEARCH_RADIUS = 40
local LOOP_DELAY = 0.4
local PICKUP_HOLD = 0.25

-- ===== STATE =====
local AutoCollect = false
local AFKPosition = nil

-- ===== GUI =====
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,55,0,55)
toggleBtn.Position = UDim2.new(0,10,0.5,-27)
toggleBtn.Text = "⚓"
toggleBtn.TextSize = 26
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BorderSizePixel = 0
toggleBtn.Active = true
toggleBtn.Draggable = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,240,0,150)
frame.Position = UDim2.new(0,80,0.5,-75)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "50 Days on a Raft"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)

local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(1,-20,0,45)
autoBtn.Position = UDim2.new(0,10,0,55)
autoBtn.Text = "Auto Collect : OFF"
autoBtn.Font = Enum.Font.Gotham
autoBtn.TextSize = 14
autoBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.BorderSizePixel = 0
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

-- ===== FIND NEAREST PROMPT =====
local function getNearestPrompt()
    local best, dist = nil, SEARCH_RADIUS
    for _,p in pairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Enabled then
            local part =
                p.Parent:IsA("BasePart") and p.Parent
                or p.Parent:FindFirstChildWhichIsA("BasePart")
                or (p.Parent.Parent and p.Parent.Parent:FindFirstChildWhichIsA("BasePart"))

            if part then
                local d = (part.Position - AFKPosition.Position).Magnitude
                if d < dist then
                    dist = d
                    best = {prompt = p, part = part}
                end
            end
        end
    end
    return best
end

-- ===== LOOP =====
task.spawn(function()
    while task.wait(LOOP_DELAY) do
        if AutoCollect and AFKPosition then
            local t = getNearestPrompt()
            if t then
                pcall(function()
                    hrp.CFrame = t.part.CFrame + Vector3.new(0,2,0)
                    task.wait(PICKUP_HOLD)
                    fireproximityprompt(t.prompt)
                    task.wait(0.05)
                    hrp.CFrame = AFKPosition
                end)
            end
        end
    end
end)

print("✅ AFK Auto Collect loaded")
