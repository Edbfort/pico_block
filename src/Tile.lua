--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Tile = Class{}

function Tile:init(x, y, id)
    self.x = x
    self.y = y

    self.width = TILE_SIZE
    self.height = TILE_SIZE

    self.id = id
end

--[[
    Checks to see whether this ID is whitelisted as collidable in a global constants table.
]]
function Tile:collidable(target)
    for k, v in pairs(COLLIDABLE_TILES) do
        if v == self.id then
            return true
        end
    end

    return false
end

function Tile:render()
    if self.id ~= 0 then
        love.graphics.draw(gTextures['blocksPico'], gFrames['blocksPico'][self.id],
        (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE)
    end
end