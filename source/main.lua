import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd = playdate
local gfx = pd.graphics

local splashscreen = gfx.image.new("img/splashscreen2")
-- player example of the axis: x = 400/ y = 240 (bottom left corner)
local playerStartX = 40
local playerStartY = 230
local playerSpeed = 2
local playerImage = gfx.image.new("img/paw")
local playerSprite = gfx.sprite.new(playerImage)

playerSprite:setCollideRect(0, 0, 20, 50) --x, y relative to sprite, size of sprite in px
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

-- game state
local gameState = "stopped"
local score = 0

-- obstacle
local obstacleSpeed = 0
local obstacleImage = gfx.image.new("img/fish")
local obstacleSprite = gfx.sprite.new(obstacleImage)
obstacleSprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap
obstacleSprite:setCollideRect(0, 0, 57, 57)
obstacleSprite:moveTo(200, 20)
obstacleSprite:add()

local lastCrankPosition = 0

function pd.update()
    -- 30 FPS

    gfx.sprite:update()
    if gameState == "stopped" then
        splashscreen:draw(0, 0)
        --gfx.drawTextAligned("press A to start", 200, 40, kTextAlignment.center)

        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = "active"
            score = 0
            obstacleSpeed = 0
            playerSprite:moveTo(playerStartX, playerStartY)
            obstacleSprite:moveTo(math.random(20, 200), 0)
        end
    elseif gameState == "active" then
        -- crank will control up and down , aka how close you can get to the fishy
        local crankPosition = pd.getCrankPosition()

        -- this if statement will move very time this thing updateds.
        if lastCrankPosition ~= crankPosition then
            lastCrankPosition = crankPosition
            if crankPosition <= 90 or crankPosition >= 270 then
                playerSprite:moveBy(0, -playerSpeed)
            elseif crankPosition > 90 or crankPosition < 270 then
                playerSprite:moveBy(0, playerSpeed)
            else    
                playerSprite:moveBy(0,0)
            end 
        end

        if pd.buttonJustPressed(pd.kButtonLeft) then
            playerSprite:moveBy(-playerSpeed + 5, 0)
        elseif pd.buttonJustPressed(pd.kButtonRight) then
            playerSprite:moveBy(playerSpeed + 5, 0)
        end

        local actualX, actualY, collisions, length = obstacleSprite:moveWithCollisions(obstacleSprite.x - obstacleSpeed, obstacleSprite.y)
        -- complex games will need to check more than just length > 0 
        -- if obstacleSprite.x < -20 then
        --     obstacleSprite:moveTo(20, math.random(40, 200))
        --     score += 1
        -- end
        if length > 0 then
            score += 1
            -- gameState = "stopped"
            obstacleSprite:moveTo(20, math.random(40, 200))
        end
        if playerSprite.y > 270 or playerSprite.y < -30  then
            gameState = "stopped"
        end
    end

    gfx.drawTextAligned("Score: " .. score, 390, 10, kTextAlignment.right)
end