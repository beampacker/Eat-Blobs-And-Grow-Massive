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
    return tween
end

local function teleportToFoodParts()
    local player = Players.LocalPlayer
    local playerCharacter = player.Character or player.CharacterAdded:Wait()
    local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")

    local foodParts = game.Workspace.Food:GetChildren()
    
    local function teleportToNextPart(index)
        if index > #foodParts then
            index = 1 -- Reset to the first part
        end

        local part = foodParts[index]
        if part:IsA("BasePart") then
            local tween = createTween(part.Position, playerHumanoidRootPart)
            if tween then
                tween:Play()
                tween.Completed:Wait() -- Wait for the tween to finish
                teleportToNextPart(index + 1) -- Move to the next part
            end
        end
    end

    teleportToNextPart(1) -- Start teleporting
end

-- Start the teleporting process
teleportToFoodParts()
