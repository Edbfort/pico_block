PlayerGameOverState = Class{__includes = BaseState}

function PlayerGameOverState:init(player, gravity)
    self.player = player
    self.player.texture = 'playerDeath'
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

function PlayerGameOverState:enter(params)
    self.player.dy = self.player.dy + PLAYER_JUMP_VELOCITY
end

function PlayerGameOverState:update(dt)
    if (self.player.direction == 'right') then
        self.animation.frames = {1 + self.player.playerColor - 1}
    else
        self.animation.frames = {5 + self.player.playerColor - 1}
    end

    self.player.currentAnimation:update(dt)
    self.player.dy = self.player.dy + self.gravity
    self.player.y = self.player.y + (self.player.dy * dt)

    self.player.y = self.player.y + (self.player.dy * dt)
end