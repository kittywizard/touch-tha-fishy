local pd = playdate
local gfx = pd.graphics

-- player example of the axis: x = 400/ y = 240 (bottom left corner)
local playerX = 40
local playerY = 120
local playerSpeed = 3
local playerImage = gfx.image.new("img/sprite")

function pd.update()
    -- 30 FPS
    gfx.clear()

    local crankPosition = pd.getCrankPosition()
    if crankPosition <= 90 or crankPosition >= 270 then
        playerY -= playerSpeed
    else
        playerY += playerSpeed
    end 

    playerImage:draw(playerX, playerY)
end