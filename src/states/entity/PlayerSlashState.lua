PlayerSlashState = Class{__includes = BaseState}

function PlayerSlashState:init(player, gravity)
    self.player = player
    self.gravity = gravity
    self.animation = Animation {
        frames = {1},
        interval = 0.04
    }
    self.type = 'slash'

    -- look at two tiles below our feet and check for collisions
    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if love.keyboard.isDown('w') then
        self.animation.frames = {17, 18, 19, 20}
        hitboxWidth = 32
        hitboxHeight = 26
        hitboxX = self.player.x - 10
        hitboxY = self.player.y - 8
    elseif love.keyboard.isDown('s') and not((tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable())) then
        self.animation.frames = {13, 14, 15, 16}
        hitboxWidth = 32
        hitboxHeight = 26
        hitboxX = self.player.x - 11
        hitboxY = self.player.y + 1
    elseif (self.player.direction == 'right') then
        self.animation.frames = {5, 6, 7, 8}
        hitboxWidth = 20
        hitboxHeight = 13
        hitboxX = self.player.x + 2
        hitboxY = self.player.y + 3
    elseif self.player.direction == 'left' then
        self.animation.frames = {9, 10, 11, 12}
        hitboxWidth = 20
        hitboxHeight = 13
        hitboxX = self.player.x - 10
        hitboxY = self.player.y + 3
    end

    self.player.currentAnimation = self.animation
    self.player.currentAnimation.timesPlayed = 0
    self.player.currentAnimation.canAttackAgain = 0

    self.hitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
end

function PlayerSlashState:update(dt)
    self.player.currentAnimation:update(dt)
    -- look at two tiles below our feet and check for collisions
    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)
    if not((tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable())) then
        self.player.dy = self.player.dy + self.gravity
    end
    self.player.y = self.player.y + (self.player.dy * dt)

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player:changeState('falling')
    end


    self.player.y = self.player.y + (self.player.dy * dt)

    
    -- look at two tiles below our feet and check for collisions
    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

    -- if we get a collision beneath us, go into either walking or idle
    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) then
        self.player.dy = 0
        if self.player.currentAnimation.timesPlayed > 0 then
            -- set the player to be walking or idle on landing depending on input
            if love.keyboard.isDown('a') or love.keyboard.isDown('d') then
                self.player:changeState('walking')
            else
                self.player:changeState('idle')
            end

            self.player.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.player.height
        end
        
        if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('k') then
            self.player:changeState('jump')
        end

    -- go back to start if we fall below the map boundary
    elseif self.player.y > VIRTUAL_HEIGHT then
        gSounds['death']:play()
        self.player.level.gameOver = true
    end

    -- check side collisions and reset position
    if love.keyboard.isDown('a') then
        self.player.direction = 'left'
        if self.player.dx < 10 and self.player.dx > -10 then
            self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
        self.player:checkLeftCollisions(dt)
        end
    elseif love.keyboard.isDown('d') then
        self.player.direction = 'right'
        if self.player.dx < 10 and self.player.dx > -10 then
            self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
            self.player:checkRightCollisions(dt)
        end
    end

    -- check if we've collided with any collidable game objects
    for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) then
            if object.solid then
                self.player.dy = 0
                self.player.y = object.y - self.player.height

                if love.keyboard.isDown('a') or love.keyboard.isDown('d') then
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

    -- look at two tiles below our feet and check for collisions
    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if love.keyboard.isDown('w') then
        self.animation.frames = {17, 18, 19, 20}
        hitboxWidth = 32
        hitboxHeight = 26
        hitboxX = self.player.x - 10
        hitboxY = self.player.y - 8
    elseif love.keyboard.isDown('s') and not((tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable())) then
        self.animation.frames = {13, 14, 15, 16}
        hitboxWidth = 32
        hitboxHeight = 26
        hitboxX = self.player.x - 11
        hitboxY = self.player.y + 1
    elseif (self.player.direction == 'right') then
        self.animation.frames = {5, 6, 7, 8}
        hitboxWidth = 20
        hitboxHeight = 13
        hitboxX = self.player.x + 2
        hitboxY = self.player.y + 3
    elseif self.player.direction == 'left' then
        self.animation.frames = {9, 10, 11, 12}
        hitboxWidth = 20
        hitboxHeight = 13
        hitboxX = self.player.x - 10
        hitboxY = self.player.y + 3
    end

    self.hitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    -- check if we've collided with any entities and kill them if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.hitbox) then
            gSounds['kill']:play()
            gSounds['kill2']:play()
            self.player.score = self.player.score + 100
            table.remove(self.player.level.entities, k)

            if love.keyboard.isDown('w') and not((tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable())) then
                self.player.dy = self.player.dy + 60
                self.player:changeState('falling')
            elseif love.keyboard.isDown('s') and not((tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()))  then
                self.player.dy = 50
                self.player:changeState('jump')
            elseif (self.player.direction == 'right') then
                self.player.dx = -120
            elseif self.player.direction == 'left' then
                self.player.dx = 120
            end
        end
    end

    if love.keyboard.wasPressed('l') and self.animation.canAttackAgain then
        self.player:changeState('slash')
    end
end

function PlayerSlashState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    --
    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end