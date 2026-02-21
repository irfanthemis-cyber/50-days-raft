-- =====================================
-- CHICKEN EGG SPAWNER (SERVER SIDE)
-- =====================================

local ServerStorage = game:GetService("ServerStorage")

-- MODEL AYAM & TELUR
local Chicken = workspace:WaitForChild("Chicken")
local EggTemplate = ServerStorage:WaitForChild("Egg")

-- SETTINGS
local SPAWN_INTERVAL = 20      -- waktu ayam bertelur (detik)
local MAX_EGGS = 10            -- batas telur di sekitar ayam
local SPAWN_OFFSET = Vector3.new(0, 1.2, 0)

-- pastikan ada PrimaryPart
if not Chicken.PrimaryPart then
    error("Chicken harus punya PrimaryPart")
end

-- hitung telur di sekitar ayam
local function countNearbyEggs()
    local count = 0
    for _,v in pairs(workspace:GetChildren()) do
        if v.Name == "Egg" and v:IsA("Model") then
            if v.PrimaryPart then
                local dist = (v.PrimaryPart.Position - Chicken.PrimaryPart.Position).Magnitude
                if dist < 10 then
                    count += 1
                end
            end
        end
    end
    return count
end

-- LOOP BERTELUR
while true do
    task.wait(SPAWN_INTERVAL)

    -- batasi jumlah telur
    if countNearbyEggs() >= MAX_EGGS then
        continue
    end

    -- clone telur
    local egg = EggTemplate:Clone()
    egg.Name = "Egg"
    egg.Parent = workspace

    -- posisikan telur
    if egg:IsA("Model") then
        if not egg.PrimaryPart then
            warn("Egg tidak punya PrimaryPart")
            egg:Destroy()
            continue
        end
        egg:SetPrimaryPartCFrame(
            Chicken.PrimaryPart.CFrame + SPAWN_OFFSET
        )
    else
        egg.Position = Chicken.PrimaryPart.Position + SPAWN_OFFSET
    end
end
