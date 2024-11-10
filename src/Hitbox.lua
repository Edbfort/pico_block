Hitbox = Class{}

function Hitbox:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Hitbox:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Hitbox:render()
    love.graphics.setColor(100/255, 100/255, 100/255, 200/255)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end