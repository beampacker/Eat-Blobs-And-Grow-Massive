local Rayfield = require(game.ReplicatedStorage:WaitForChild("Rayfield")) -- Adjust the path as needed
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Create the GUI
local Window = Rayfield:CreateWindow({
    Title = "Character Movement",
    Center = true,
    AutoSize = true,
})

local isMoving = false
local movingDirection = Vector3.new(0, 0, 0)
local isCtrlPressed = false
local humanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

local function createTween(targetPosition)
    if not humanoidRootPart or not humanoid then
        return error("I can't find the character")
    end

    local distance = (targetPosition - humanoidRootPart.Position).Magnitude
    local time = distance / humanoid.WalkSpeed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Quad)
    local targetCFrame = CFrame.new(targetPosition)

    local tween = TweenService:Create(humanoidRootPart, tweenInfo, { CFrame = targetCFrame })
    tween:Play()
    tween.Completed:Wait() -- halt until the tween is done
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
        wait(0.1)
    end
end

-- GUI buttons
local StartButton = Window:CreateButton({
    Name = "Start Moving",
    Callback = function()
        if not isMoving then
            isMoving = true
            updateMovement()
        end
    end,
})

local StopButton = Window:CreateButton({
    Name = "Stop Moving",
    Callback = function()
        isMoving = false
        movingDirection = Vector3.new(0, 0, 0) -- reset direction
    end,
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.LeftControl then
            isCtrlPressed = true
            if movingDirection.Magnitude > 0 then
                isMoving = true
                updateMovement()
            end
        elseif isCtrlPressed then
            if input.KeyCode == Enum.KeyCode.W then
                movingDirection = Vector3.new(0, 0, -5) -- forward
                isMoving = true
                updateMovement()
            elseif input.KeyCode == Enum.KeyCode.A then
                movingDirection = Vector3.new(-5, 0, 0) -- left
                isMoving = true
                updateMovement()
            elseif input.KeyCode == Enum.KeyCode.S then
                movingDirection = Vector3.new(0, 0, 5) -- backward
                isMoving = true
                updateMovement()
            elseif input.KeyCode == Enum.KeyCode.D then
                movingDirection = Vector3.new(5, 0, 0) -- right
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
            isMoving = false
            movingDirection = Vector3.new(0, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or
               input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
            if movingDirection.Magnitude > 0 then
                isMoving = false
                movingDirection = Vector3.new(0, 0, 0)
            end
        end
    end
end)
