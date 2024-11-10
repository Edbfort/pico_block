PlayerWalkingState = Class{__includes = BaseState}

function PlayerWalkingState:init(player)
    self.player = player
    self.player.texture = 'playerMove'
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

function PlayerWalkingState:update(dt)
    if (self.player.direction == 'right') then
        self.animation.frames = {1 + self.player.playerColor - 1}
    else
        self.animation.frames = {5 + self.player.playerColor - 1}
    end

    self.player.currentAnimation:update(dt)

    
    self.collidedPlayer = false
    for key, otherPlayer in pairs(self.player.players) do
        if (not(self.player.playerNumber == otherPlayer.playerNumber) and (self.player:checkPlayerCollisions(self.player.x, self.player.y + self.player.height, otherPlayer) or self.player:checkPlayerCollisions(self.player.x + self.player.width, self.player.y + self.player.height, otherPlayer))) then
            self.collidedPlayer = true
        end
    end

    for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) then
            if object.solid then
                object.onCollide(object)
            end
        end
    end
    
    local tileBottomLeft = self.player.map:pointToTile(self.player.x - 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width + 1, self.player.y + self.player.height)

    self.player.y = self.player.y + 1

    local collidedObjects = self.player:checkObjectCollisions()

    self.player.y = self.player.y - 1

    if (#collidedObjects == 0 and self.collidedPlayer == false) and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
        self.player.dy = 0
        self.player:changeState('falling')
    elseif love.keyboard.isDown(self.player.keyLeft) then
        self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
        self.player.direction = 'left'
        self.player:checkLeftCollisions(dt)
    elseif love.keyboard.isDown(self.player.keyRight) then
        self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
        self.player.direction = 'right'
        self.player:checkRightCollisions(dt)
    elseif not love.keyboard.isDown(self.player.keyLeft) and not love.keyboard.isDown(self.player.keyRight) then
        self.player:changeState('idle')
    end

    -- -- check if we've collided with any entities and die if so
    -- for k, entity in pairs(self.player.level.entities) do
    --     if entity:collides(self.player) then
    --         gSounds['death']:play()
    --         gStateMachine:change('gameOver')
    --     end
    -- end

    if love.keyboard.wasPressed(self.player.keyUp) then
        self.player:changeState('jump')
    end
end