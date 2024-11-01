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

local function getNearestFoodPart(playerHumanoidRootPart)
    local nearestPart = nil
    local nearestDistance = math.huge -- Start with a very large distance

    for _, part in ipairs(game.Workspace.Food:GetChildren()) do
        if part:IsA("BasePart") then
            local distance = (part.Position - playerHumanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPart = part
            end
        end
    end

    return nearestPart
end

local function teleportToNearestFoodPart()
    local player = Players.LocalPlayer
    local playerCharacter = player.Character or player.CharacterAdded:Wait()
    local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")

    while true do
        local nearestPart = getNearestFoodPart(playerHumanoidRootPart)
        if nearestPart then
            local tween = createTween(nearestPart.Position, playerHumanoidRootPart)
            if tween then
                tween:Play()
                tween.Completed:Wait() -- Wait for the tween to finish
            end
        end
        wait(0.1) -- Short wait before checking for the nearest part again
    end
end

-- Start the teleporting process
teleportToNearestFoodPart()
