import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd = playdate
local gfx = pd.graphics

-- player example of the axis: x = 400/ y = 240 (bottom left corner)
local playerStartX = 40
local playerStartY = 120
local playerSpeed = 3
local playerImage = gfx.image.new("img/sprite")
local playerSprite = gfx.sprite.new(playerImage)
playerSprite:setCollideRect(0, 0, 32, 32) --x, y relative to sprite, size of sprite in px
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

-- game state
local gameState = "stopped"

function pd.update()
    -- 30 FPS
    gfx.sprite.update()
    if gameState == "stopped" then
        gfx.drawTextAligned("press A to start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = "active"
            playerSprite:moveTo(playerStartX, playerStartY)
        end
    elseif gameState == "active" then
        local crankPosition = pd.getCrankPosition()
        if crankPosition <= 90 or crankPosition >= 270 then
            playerSprite:moveBy(0, -playerSpeed)
        else
            playerSprite:moveBy(0, playerSpeed)
        end 
        if playerSprite.y > 270 or playerSprite.y < -30 then
            gameState = "stopped"
        end
    end
end