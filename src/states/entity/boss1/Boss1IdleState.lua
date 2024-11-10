Boss1IdleState = Class{__includes = BaseState}

function Boss1IdleState:init(boss1)
    self.boss1 = boss1

    self.animation = Animation {
        frames = {1},
        interval = 1
    }

    if (self.boss1.direction == 'left') then
        self.animation.frames = {1}
    else
        self.animation.frames = {2}
    end

    self.boss1.currentAnimation = self.animation
end

function Boss1IdleState:update(dt)
    -- if love.keyboard.isDown('a') or love.keyboard.isDown('d') then
    --     self.boss1:changeState('walking')
    -- end

    -- if love.keyboard.wasPressed('space') then
    --     self.boss1:changeState('jump')
    -- end

    -- if love.keyboard.wasPressed('k') then
    --     self.boss1:changeState('jump')
    -- end

    -- if love.keyboard.wasPressed('l') then
    --     self.boss1:changeState('slash')
    -- end

    -- -- check if we've collided with any entities and die if so
    -- for k, entity in pairs(self.player.level.entities) do
    --     if entity:collides(self.player) then
    --         gSounds['death']:play()
    --         gStateMachine:change('start')
    --     end
    -- end
end