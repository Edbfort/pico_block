--[[
    GD50
    Super Mario Bros. Remake

    -- PlayerFallingState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerFallingState = Class{__includes = BaseState}

function PlayerFallingState:init(player, gravity)
    self.player = player
    self.gravity = gravity
    self.animation = Animation {
        frames = {1},
        interval = 1
    }

    if (self.player.direction == 'right') then
        self.animation.frames = {1 + self.player.playerColor - 1}
    else
        self.animation.frames = {5 + self.player.playerColor - 1}
    end

    self.player.currentAnimation = self.animation
end

function PlayerFallingState:update(dt)
    if (self.player.direction == 'right') then
        self.animation.frames = {1 + self.player.playerColor - 1}
    else
        self.animation.frames = {5 + self.player.playerColor - 1}
    end

    self.player.currentAnimation:update(dt)
    self.player.dy = self.player.dy + self.gravity
    self.player.y = self.player.y + (self.player.dy * dt)

    self.collidedPlayer = false
    for key, otherPlayer in pairs(self.player.players) do
        if (not(self.player.playerNumber == otherPlayer.playerNumber) and (self.player:checkPlayerCollisions(self.player.x, self.player.y + self.player.height - 1, otherPlayer) or self.player:checkPlayerCollisions(self.player.x + self.player.width, self.player.y + self.player.height - 1, otherPlayer))) then
            self.collidedPlayer = true
        end
    end

    -- look at two tiles below our feet and check for collisions
    local tileBottomLeft = self.player.map:pointToTile(self.player.x, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

    -- if we get a collision beneath us, go into either walking or idle
    if ((tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) or self.collidedPlayer) then
        self.player.dy = 0
        
        -- set the player to be walking or idle on landing depending on input
        if love.keyboard.isDown(self.player.keyLeft) or love.keyboard.isDown(self.player.keyRight) then
            self.player:changeState('walking')
        else
            self.player:changeState('idle')
        end

        self.player.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.player.height
    
    -- go back to start if we fall below the map boundary
    elseif self.player.y > VIRTUAL_HEIGHT then
        gSounds['death']:play()
        self.player.level.gameOver = true
    
    -- check side collisions and reset position
    elseif love.keyboard.isDown(self.player.keyLeft) then
        self.player.direction = 'left'
        self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
        self.player:checkLeftCollisions(dt)
    elseif love.keyboard.isDown(self.player.keyRight) then
        self.player.direction = 'right'
        self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
        self.player:checkRightCollisions(dt)
    end

    -- check if we've collided with any collidable game objects
    for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) then
            if object.solid then
                self.player.dy = 0
                self.player.y = object.y - self.player.height

                if love.keyboard.isDown(self.player.keyLeft) or love.keyboard.isDown(self.player.keyRight) then
                    self.player:changeState('walking')
                else
                    self.player:changeState('idle')
                end
            elseif object.consumable then
                object.onConsume(self.player)
                table.remove(self.player.level.objects, k)
            end
        end
    end

    -- check if we've collided with any entities and kill them if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['kill']:play()
            gSounds['kill2']:play()
            self.player.score = self.player.score + 100
            table.remove(self.player.level.entities, k)
        end
    end
end