local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Food categories (ClassNames) to check in the Workspace
local foodCategories = {
    "Uncommon", "Common", "Basic", "Rare", "Epic", "Legendary", "Divine", "Mythical"
}

-- Function to check if a part belongs to any of the food categories based on its ClassName
local function isPartInFood(part)
    -- Loop through all food categories (ClassNames)
    for _, foodCategory in ipairs(foodCategories) do
        if part.ClassName == foodCategory then
            print(part.Name .. " is in the " .. foodCategory .. " category.")
            return true  -- Part found in one of the food categories
        end
    end
    return false  -- Part not found in any food category
end

-- Function to create smooth CFrame movement (using TweenService)
local function createCFrameMovementTween(targetPosition, character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- Create tween goal to move humanoidRootPart to target position
    local goal = {Position = targetPosition}
    
    -- Define the tween's properties (smooth movement)
    local tweenInfo = TweenInfo.new(
        1,  -- Duration of the tween (adjustable)
        Enum.EasingStyle.Linear,  -- Easing style (smooth)
        Enum.EasingDirection.Out,  -- Easing direction
        0,  -- No repeat count
        false,  -- Do not reverse the tween
        0  -- No delay
    )
    
    -- Create the tween
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    
    -- Play the tween
    tween:Play()

    -- Return a function to check if the tween is completed
    return function()
        return tween.Playing == false
    end
end

-- Function to get the nearest food part based on distance
local function getNearestFoodPart(playerHumanoidRootPart)
    local nearestPart = nil
    local nearestDistance = math.huge  -- Start with a very large distance

    -- Loop through all parts in the workspace and check if their ClassName matches any food category
    for _, part in pairs(workspace:GetChildren()) do
        if part:IsA("BasePart") then  -- Check only parts
            -- Check if the part's ClassName matches any of the food categories
            local distance = (part.Position - playerHumanoidRootPart.Position).Magnitude
            if isPartInFood(part) and distance < nearestDistance then
                nearestDistance = distance
                nearestPart = part
            end
        end
    end

    return nearestPart
end

-- Function to simulate the touch event for collecting the food part
local function simulateTouch(part, character)
    -- Ensure the part has a valid TouchInterest
    if part and part:FindFirstChild("TouchInterest") then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Fire the touch event by manually invoking the Touched event
            print("Simulating touch for part: " .. part.Name)
            part.TouchInterest:Fire(humanoidRootPart)
        end
    else
        print("Error: No TouchInterest found on part " .. part.Name)
    end
end

-- Function to teleport the player to the nearest food part and collect it
local function teleportToNearestFoodPart()
    local player = Players.LocalPlayer
    local playerCharacter = player.Character or player.CharacterAdded:Wait()
    local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")

    while true do
        -- Using pcall to catch any errors that might occur
        local success, nearestPart = pcall(function()
            return getNearestFoodPart(playerHumanoidRootPart)
        end)

        if not success then
            print("Error while finding the nearest food part: " .. nearestPart) -- `nearestPart` will contain the error message
            break  -- Exit the loop on error
        end

        if nearestPart then
            print("Found nearest food part: " .. nearestPart.Name)
            local moveCharacter = createCFrameMovementTween(nearestPart.Position, playerCharacter)

            -- Move the character toward the food part
            while not moveCharacter() do
                wait(0.1)  -- Move character every frame, adjust as needed
            end

            -- Once the character reaches the food part, simulate the touch
            simulateTouch(nearestPart, playerCharacter)

            -- Check if the part is in any of the food categories (based on ClassName)
            local isInFood = isPartInFood(nearestPart)
            if isInFood then
                print(nearestPart.Name .. " is in the Food category and has been collected!")
            else
                print(nearestPart.Name .. " is not in the Food category!")
            end
        else
            print("No food part found!")
        end

        -- Wait 2 seconds before checking for the nearest food part again
        wait(2)  -- This delay reduces the frequency of checks, improving performance
    end
end

-- Start the teleporting process
teleportToNearestFoodPart()
