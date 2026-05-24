import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "./imports/AnimatedSprite"

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

-- obstacle (aka the fishy)
local obstacleSpeed = 0
local obstacleImage = gfx.image.new("img/fishy2")
local obstacleSprite = gfx.sprite.new(obstacleImage)
obstacleSprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap
obstacleSprite:setCollideRect(0, 0, 57, 57)
obstacleSprite:moveTo(200, 20)
obstacleSprite:add()

-- the mean human stopping you from touching the fishy!
local humanEnemyImage = gfx.image.new('img/human')
local humanEnemy = gfx.sprite.new(humanEnemyImage)
humanEnemy.setZIndex(humanEnemy, 100)

local health = 3

-- countdown display TBD
    -- don't want numbers displayed, but some sort of indicator that the human will appear
local fishyCountdown = 10000


local function callHuman()
    print('timer ran')
    humanEnemy:moveTo(30,50)
    humanEnemy:add()
end
-- timer setup

-- create new timer with default amount of time. as the game progresses, lower this timer variable
-- in each game loop, run timer and user will move towards fishy but the the 'human' will appear randomly to stop them
-- after three failed attempts (being caught) game will end
-- will need method to randomly insert human appearance 


local lastCrankPosition = 0

function pd.update()
    -- 30 FPS

    gfx.sprite:update()
    pd.timer.updateTimers()

    if gameState == "stopped" then
        splashscreen:draw(0, 0)
        --gfx.drawTextAligned("press A to start", 200, 40, kTextAlignment.center)

        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = "active"
            score = 0
            obstacleSpeed = 0
            playerSprite:moveTo(playerStartX, playerStartY)
            obstacleSprite:moveTo(math.random(20, 200), 10)
            pd.timer.new(fishyCountdown, callHuman)

        end
    elseif gameState == "active" then
        -- crank will control up and down , aka how close you can get to the fishy
        local crankPosition = pd.getCrankPosition()

        -- checking to make sure crank isn't constantly moving
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

        -- left and right movement
        if pd.buttonJustPressed(pd.kButtonLeft) then
            if playerSprite.x> 0 then     
                playerSprite:moveBy(-playerSpeed - 8, 0)
            end
        elseif pd.buttonJustPressed(pd.kButtonRight) then
            if playerSprite.x < 400 then
                playerSprite:moveBy(playerSpeed + 8, 0)
            end
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
        -- just prevent character from going out of bounds?
        if playerSprite.y > 270 or playerSprite.y < -30  then
            -- gameState = "stopped"
            print('just testing..')
        end
    end

    gfx.drawTextAligned("Score: " .. score, 350, 10, kTextAlignment.left)
    gfx.drawTextAligned("Lives:" .. health, 350, 40, kTextAlignment.left) 
end