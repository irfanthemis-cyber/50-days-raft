-- ===== BASIC =====
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

print("SCRIPT STARTED")

-- simpan posisi awal
local StartCFrame = hrp.CFrame
print("START POSITION SAVED")

-- loop sederhana
task.spawn(function()
    while task.wait(1) do
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Enabled then
                local parent = v.Parent
                local part = parent:IsA("BasePart") and parent
                    or parent:FindFirstChildWhichIsA("BasePart")
                    or (parent.Parent and parent.Parent:FindFirstChildWhichIsA("BasePart"))

                if part then
                    print("FOUND PROMPT:", v:GetFullName())

                    -- teleport ke item
                    hrp.CFrame = part.CFrame + Vector3.new(0,2,0)
                    task.wait(0.2)

                    -- pickup (PALING AMAN)
                    fireproximityprompt(v)
                    print("PROMPT FIRED")

                    task.wait(0.3)

                    -- balik
                    hrp.CFrame = StartCFrame
                    print("RETURNED")

                    task.wait(1)
                end
            end
        end
    end
end)
