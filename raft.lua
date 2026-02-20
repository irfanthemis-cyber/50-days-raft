local plr = game.Players.LocalPlayer
local hrp = plr.Character or plr.CharacterAdded:Wait()
hrp = hrp:WaitForChild("HumanoidRootPart")

local startPos = hrp.CFrame

-- pindah sekali
hrp.CFrame = hrp.CFrame * CFrame.new(0,0,-10)
wait(1)

-- balik
hrp.CFrame = startPos

print("TEST SELESAI")
