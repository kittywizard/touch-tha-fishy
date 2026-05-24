local pd = playdate
local gfx = pd.graphics

class('Player') extends(gfx.sprite)

function Player:init(x, y)
  -- player example of the axis: x = 400/ y = 240 (bottom left corner)
    local playerStartX = 40
    local playerStartY = 230
    local playerSpeed = 2
    local playerImage = gfx.image.new("img/paw")
    local playerSprite = gfx.sprite.new(playerImage) 
end