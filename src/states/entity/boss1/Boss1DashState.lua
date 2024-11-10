Boss1DashState = Class{__includes = BaseState}

function Boss1DashState:init(boss1, def)
    self.boss1 = boss1

    self.animation = Animation {
        frames = {1, 3},
        interval = 0.7
    }

    if (self.boss1.direction == 'left') then
        self.animation.frames = {1, 3}
    else
        self.animation.frames = {2, 4}
    end

    self.boss1.currentAnimation = self.animation
    self.boss1.currentAnimation.timesPlayed = 0

    self.dashAmount = 0
    self.maxDashAmount = def.maxDashAmount
    self.currentDashDistance = 0
    self.dashDistance = def.dashDistance
    self.canDash = false
    self.dashSpeed = 200
    self.speed = self.dashSpeed
end

function Boss1DashState:update(dt)
    self.boss1.currentAnimation:update(dt)

    if self.boss1.currentAnimation.timesPlayed > 0 then
        if self.maxDashAmount >= self.dashAmount then
            if (self.boss1.direction == 'left') then
                self.animation.frames = {5}
                self.speed = -self.dashSpeed
            else
                self.animation.frames = {6}
                self.speed = self.dashSpeed
            end

            local tileBottomLeft = self.boss1.map:pointToTile(self.boss1.x + 1, self.boss1.y + self.boss1.height)
            local tileBottomRight = self.boss1.map:pointToTile(self.boss1.x + self.boss1.width - 1, self.boss1.y + self.boss1.height)

            self.boss1.y = self.boss1.y + 1

            local collidedObjects = self.boss1:checkObjectCollisions()

            self.boss1.y = self.boss1.y - 1

            -- check to see whether there are any tiles beneath us
            if #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
                self.boss1.dx = 0
            elseif self.boss1.direction == 'left' then
                self.boss1.x = self.boss1.x + (self.speed * dt)
                self.boss1:checkLeftCollisions(dt)
            else
                self.boss1.x = self.boss1.x + (self.speed * dt)
                self.boss1:checkRightCollisions(dt)
            end
            
            self.currentDashDistance = self.currentDashDistance + (self.speed * dt)
            if self.currentDashDistance >= self.dashDistance then
                if (self.boss1.direction == 'left') then
                    self.boss1.direction = 'right'
                else
                    self.boss1.direction = 'left'
                end
                self.currentDashDistance = 0
                self.dashAmount = self.dashAmount + 1
            end
        end
    end
end