--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.downable = def.downable
    self.onDown = def.onDown
    self.hit = def.hit
    self.dx = def.dx or 0
    self.dy = def.dy or 0
    self.xTo = def.xTo or self.x
    self.yTo = def.yTo or self.y
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(dt)
    self.x = self.x + self.dx * dt
    if self.dx ~= 0 and math.abs(self.x - self.xTo) < 1 then
        self.dx = math.abs(self.dx) - 1
    end

    if self.x > self.xTo then
        self.dx = -math.abs(self.dx)
    elseif self.x < self.xTo then
        self.dx = math.abs(self.dx)
    else
        self.x = self.xTo
        self.dx = 0
    end
    
    self.y = self.y + self.dy * dt
    if self.dy ~= 0 and math.abs(self.y - self.yTo) < 1 then
        self.dy = math.abs(self.dy) - 1
    end

    if self.y > self.yTo then
        self.dy = -math.abs(self.dy)
    elseif self.y < self.yTo then
        self.dy = math.abs(self.dy)
    else
        self.y = self.yTo
        self.dy = 0
    end
end

function GameObject:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
end