PlayerJumpState = Class{__includes = BaseState}

function PlayerJumpState:init(player, gravity)
    self.player = player
    self.player.texture = 'playerJump'
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

function PlayerJumpState:enter(params)
    gSounds['jump']:play()
    self.player.dy = self.player.dy + PLAYER_JUMP_VELOCITY
end

function PlayerJumpState:update(dt)
    if (self.player.direction == 'right') then
        self.animation.frames = {1 + self.player.playerColor - 1}
    else
        self.animation.frames = {5 + self.player.playerColor - 1}
    end

    self.player.currentAnimation:update(dt)
    self.player.dy = self.player.dy + self.gravity
    self.player.y = self.player.y + (self.player.dy * dt)

    if self.player.dy >= 0 then
        self.player:changeState('falling')
    end

    self.player.y = self.player.y + (self.player.dy * dt)

    self.collidedPlayer = false
    for key, otherPlayer in pairs(self.player.players) do
        if (not(self.player.playerNumber == otherPlayer.playerNumber) and (self.player:checkPlayerCollisions(self.player.x, self.player.y + 1, otherPlayer) or self.player:checkPlayerCollisions(self.player.x + self.player.width, self.player.y + 1, otherPlayer))) then
            self.collidedPlayer = true
        end
    end

    local tileLeft = self.player.map:pointToTile(self.player.x, self.player.y + 1)
    local tileRight = self.player.map:pointToTile(self.player.x + self.player.width, self.player.y + 1)

    if ((tileLeft and tileRight) and (tileLeft:collidable() or tileRight:collidable()) or self.collidedPlayer) then
        self.player.dy = 0
        self.player.y = self.player.y - ((self.player.dy * dt) * 3)
        self.player:changeState('falling')
    elseif love.keyboard.isDown(self.player.keyLeft) then
        self.player.direction = 'left'
        self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
        self.player:checkLeftCollisions(dt)
    elseif love.keyboard.isDown(self.player.keyRight) then
        self.player.direction = 'right'
        self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
        self.player:checkRightCollisions(dt)
    end



    for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) then
            if object.solid then
                object.onCollide(object)
                self.player.y = object.y + object.height
                self.player.dy = 0
                self.player:changeState('falling')
            elseif object.consumable then
                object.onConsume(self.player)
                table.remove(self.player.level.objects, k)
            end
        end
    end

    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['death']:play()
            self.player.level.gameOver = true
        end
    end
end