local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local function createTween(targetPosition, humanoidRootPart)
    local humanoid = humanoidRootPart.Parent:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local distance = (targetPosition - humanoidRootPart.Position).Magnitude
    local time = distance / humanoid.WalkSpeed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Quad)
    local targetCFrame = CFrame.new(targetPosition)

    local tween = TweenService:Create(humanoidRootPart, tweenInfo, { CFrame = targetCFrame })
    tween:Play()
    return tween
end

local function teleportToFoodParts()
    local player = Players.LocalPlayer
    local playerCharacter = player.Character or player.CharacterAdded:Wait()
    local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")

    while true do
        for _, part in ipairs(game.Workspace.Food:GetChildren()) do
            if part:IsA("BasePart") then
                local tween = createTween(part.Position, playerHumanoidRootPart)
                if tween then
                    tween.Completed:Wait() -- wait for the tween to finish
                    wait(0.5) -- wait before the next teleport
                end
            end
        end
        wait(1) -- wait before starting over
    end
end

-- Start the teleporting process
teleportToFoodParts()
