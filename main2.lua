local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local function consumeFood(part)
    -- Example consumption logic
    local player = Players.LocalPlayer
    local playerStats = player:FindFirstChild("Leaderstats") -- Assuming Leaderstats holds the player's stats

    if playerStats and playerStats:FindFirstChild("Food") then
        playerStats.Food.Value += 1 -- Increment food count (adjust as needed)
    end

    part:Destroy() -- Remove the food part after consumption
end

local function movePartToPlayer(part, humanoidRootPart)
    local targetPosition = humanoidRootPart.Position
    local distance = (part.Position - targetPosition).Magnitude
    local time = distance / 10 -- Speed at which the part moves (adjust as needed)
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Quad)

    local tween = TweenService:Create(part, tweenInfo, { Position = targetPosition })
    tween:Play()

    -- Connect to the completed event to consume the food
    tween.Completed:Connect(function()
        if (part.Position - targetPosition).Magnitude < 1 then -- Check if it's close enough
            consumeFood(part)
        end
    end)

    return tween
end

local function getNearestFoodPart(playerHumanoidRootPart)
    local nearestPart = nil
    local nearestDistance = math.huge

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

local function bringNearestFoodPartToPlayer()
    local player = Players.LocalPlayer
    local playerCharacter = player.Character or player.CharacterAdded:Wait()
    local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")

    while true do
        local nearestPart = getNearestFoodPart(playerHumanoidRootPart)
        if nearestPart then
            local tween = movePartToPlayer(nearestPart, playerHumanoidRootPart)
            if tween then
                tween.Completed:Wait() -- Wait for the tween to finish
            end
        end
        wait(0.1) -- Short wait before checking for the nearest part again
    end
end

-- Start the process of bringing the nearest food part to the player
bringNearestFoodPartToPlayer()
