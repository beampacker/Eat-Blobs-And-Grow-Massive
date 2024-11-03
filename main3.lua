local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
 
local player = Players.LocalPlayer
local playernameString = Players.LocalPlayer.Name
local humanoidRootPart = game.Workspace.Players:FindFirstChild(playernameString):FindFirstChild("HumanoidRootPart")
local humanoid = game.Workspace.Players:FindFirstChild(playernameString):FindFirstChildOfClass("Humanoid")
 
local movingDirection = Vector3.new(0, 0, 0)
local isCtrlPressed = false
local isMoving = false
 
local function createTween(targetPosition)
    if not humanoidRootPart or not humanoid then
        return error("i cant find the character")
    end
 
    local distance = (targetPosition - humanoidRootPart.Position).Magnitude
    local time = distance / humanoid.WalkSpeed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Quad)
    local targetCFrame = CFrame.new(targetPosition)
 
    local tween, err = pcall(function()
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, { CFrame = targetCFrame })
        tween:Play()
        tween.Completed:Wait() -- halt til teh tween is done
    end)
 
    if not tween then
        return err
    end
end
 
local function moveCharacter(direction)
    if humanoidRootPart then
        local targetPosition = humanoidRootPart.Position + direction
        createTween(targetPosition)
    end
end
 
local function updateMovement()
    while isMoving do
        moveCharacter(movingDirection)
        --wait(0.1) -- speed limit (remove if in an autobahn)
    end
end
 
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
 
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.LeftControl then
            isCtrlPressed = true
            if movingDirection.Magnitude > 0 then
                -- if a direction is specified, just start
                isMoving = true
                updateMovement()
            end
        elseif isCtrlPressed then
            if input.KeyCode == Enum.KeyCode.W then
                movingDirection = Vector3.new(0, 0, -3) -- forward
                isMoving = true
                updateMovement()
            elseif input.KeyCode == Enum.KeyCode.A then
                movingDirection = Vector3.new(-3, 0, 0) -- left
                isMoving = true
                updateMovement()
            elseif input.KeyCode == Enum.KeyCode.S then
                movingDirection = Vector3.new(0, 0, 3) -- backward
                isMoving = true
                updateMovement()
            elseif input.KeyCode == Enum.KeyCode.D then
                movingDirection = Vector3.new(3, 0, 0) -- right
                isMoving = true
                updateMovement()
            end
        end
    end
end)
 
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
 
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.LeftControl then
            isCtrlPressed = false
            isMoving = false -- stop moving when ctrl is lifted
            movingDirection = Vector3.new(0, 0, 0) -- reset direction
        elseif input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or
               input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
            -- stop moving when any direction key is lifted
            if movingDirection.Magnitude > 0 then
                isMoving = false
                movingDirection = Vector3.new(0, 0, 0)
            end
        end
    end
end)
