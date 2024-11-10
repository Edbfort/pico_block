PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player

    self.player.texture = 'player'

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

function PlayerIdleState:update(dt)
    if (self.player.direction == 'right') then
        self.animation.frames = {1 + self.player.playerColor - 1}
    else
        self.animation.frames = {5 + self.player.playerColor - 1}
    end

    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

    self.player.y = self.player.y + 1

    local collidedObjects = self.player:checkObjectCollisions()

    self.player.y = self.player.y - 1

    self.collidedPlayer = false
    for key, otherPlayer in pairs(self.player.players) do
        if (not(self.player.playerNumber == otherPlayer.playerNumber) and (self.player:checkPlayerCollisions(self.player.x, self.player.y + self.player.height, otherPlayer) or self.player:checkPlayerCollisions(self.player.x + self.player.width, self.player.y + self.player.height, otherPlayer))) then
            self.collidedPlayer = true
        end
    end

    if (#collidedObjects == 0 and self.collidedPlayer == false) and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
        self.player.dy = 0
        self.player:changeState('falling')
    end

    if love.keyboard.isDown(self.player.keyLeft) or love.keyboard.isDown(self.player.keyRight) then
        self.player:changeState('walking')
    end

    if love.keyboard.wasPressed(self.player.keyUp) then
        self.player:changeState('jump')
    end

    -- check if we've collided with any entities and die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['death']:play()
            self.player.level.gameOver = true
        end
    end
end