import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd = playdate
local gfx = pd.graphics

local fishyCountdownSprite = gfx.sprite.new()
fishyCountdownSprite:setSize(200, 20)
function fishyCountdownSprite:draw()
    gfx.fillRect(0, 0, 200, 40)
end

fishyCountdownSprite:moveTo(200, 50)
fishyCountdownSprite:add()

-- fix later