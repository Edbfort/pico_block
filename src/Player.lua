--[[
    GD50
    Super Mario Bros. Remake

    -- Player Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.playerColor = def.playerColor
    self.playerNumber = def.playerNumber

    self.keyUp = def.keyUp
    self.keyDown = def.keyDown
    self.keyLeft = def.keyLeft
    self.keyRight = def.keyRight

    self.solid = true
    self.players = def.players
    self.enteredDoor = false
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:render()
    Entity.render(self)
end

function Player:checkLeftCollisions(dt)
    -- check for left two tiles collision
    local tileTopLeft = self.map:pointToTile(self.x - 1, self.y + 1)
    local tileBottomLeft = self.map:pointToTile(self.x - 1, self.y + self.height - 1)

    -- place player outside the X bounds on one of the tiles to reset any overlap
    if (tileTopLeft and tileBottomLeft) and (tileTopLeft:collidable() or tileBottomLeft:collidable()) then
        self.x = (tileTopLeft.x - 1) * TILE_SIZE + tileTopLeft.width
    else
        
        -- allow us to walk atop solid objects even if we collide with them
        self.y = self.y - 1
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y + 1

        -- check if collide with other player
        self.collidedPlayer = false
        for key, otherPlayer in pairs(self.players) do
            if (not(self.playerNumber == otherPlayer.playerNumber) and (self:checkPlayerCollisions(self.x, self.y + 1, otherPlayer) or self:checkPlayerCollisions(self.x, self.y + self.height - 1, otherPlayer))) then
                self.collidedPlayer = true
            end
        end

        -- reset X if new collided object
        if #collidedObjects > 0 or self.collidedPlayer then
            self.x = self.x + PLAYER_WALK_SPEED * dt
        end
    end
end

function Player:checkRightCollisions(dt)
    -- check for right two tiles collision
    local tileTopRight = self.map:pointToTile(self.x + self.width - 1, self.y + 1)
    local tileBottomRight = self.map:pointToTile(self.x + self.width - 1, self.y + self.height - 1)

    -- place player outside the X bounds on one of the tiles to reset any overlap
    if (tileTopRight and tileBottomRight) and (tileTopRight:collidable() or tileBottomRight:collidable()) then
        self.x = (tileTopRight.x - 1) * TILE_SIZE - self.width
    else
        
        -- allow us to walk atop solid objects even if we collide with them
        self.y = self.y - 1
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y + 1

        -- check if collide with other player
        self.collidedPlayer = false
        for key, otherPlayer in pairs(self.players) do
            if (not(self.playerNumber == otherPlayer.playerNumber) and (self:checkPlayerCollisions(self.x + self.width, self.y + 1, otherPlayer) or self:checkPlayerCollisions(self.x + self.width, self.y + self.height - 1, otherPlayer))) then
                self.collidedPlayer = true
            end
        end

        -- reset X if new collided object
        if #collidedObjects > 0 or self.collidedPlayer then
            self.x = self.x - PLAYER_WALK_SPEED * dt
        end
    end
end

function Player:checkObjectCollisions()
    local collidedObjects = {}

    for k, object in pairs(self.level.objects) do
        if object:collides(self) then
            if object.solid then
                table.insert(collidedObjects, object)
            elseif object.consumable then
                object.onConsume(self)
                table.remove(self.level.objects, k)
            elseif object.downable then
                if love.keyboard.isDown(self.keyDown) then
                    object.onDown(self)
                end
            end
        end
    end

    return collidedObjects
end

function Player:checkPlayerCollisions(x, y, entity)
    return not (x > entity.x + entity.width or entity.x > x or
                y > entity.y + entity.height or entity.y > y)
end