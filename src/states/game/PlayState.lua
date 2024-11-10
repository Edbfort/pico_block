--[[
    GD50
    Super Mario Bros. Remake

    -- PlayState Class --
]]

PlayState = Class{__includes = BaseState}

function PlayState:addPlayer(params)
    local player
    player = Player({
        x = ((params.x - 1) * TILE_SIZE + (params.number - 1)), y = ((params.y - 2) * TILE_SIZE),
        width = 16, height = 16,
        texture = 'player',
        direction = 'right',
        playerColor = params.color,
        playerNumber = params.number,
        keyUp = params.up,
        keyDown = params.down,
        keyLeft = params.left,
        keyRight = params.right,
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(player) end,
            ['walking'] = function() return PlayerWalkingState(player) end,
            ['jump'] = function() return PlayerJumpState(player, params.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(player, params.gravityAmount) end,
            ['gameOver'] = function() return PlayerGameOverState(player, params.gravityAmount) end,
        },
        map = params.map,
        level = params.level,
        players = {}
    })

    return player
end

function PlayState:enter(params)
    self.camX = 0
    self.camY = 0
    self.maxX = 0
    self.minX = 0
    self.level = LevelMaker.generate(#params.players)
    self.tileMap = self.level.tileMap
    self.background = params.background or math.random(3)
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6

    self.playersArray = params.players
    self.players = {}
    for key, player in pairs(params.players) do
        player.gravityAmount = self.gravityAmount
        player.map = self.tileMap
        player.level = self.level
        table.insert(self.players, self:addPlayer(player))
    end

    for key, player in pairs(self.players) do
        player.players = self.players
    end

    self:spawnEnemies()

    for key, player in pairs(self.players) do
        player:changeState('falling')
    end
end

function PlayState:update(dt)
    Timer.update(dt)

    -- remove any nils from pickups, etc.
    self.level:clear()
    
    for key, player in pairs(self.players) do
        player:update(dt)
        if player.enteredDoor then
            table.remove(self.players, key)
        end
    end

    -- update player and level
    
    self.level:update(dt)

    if self.level.gameOver then
        gStateMachine:change('gameOver', {
            camX = self.camX,
            camY = self.camY,
            level = self.level,
            background = self.background,
            backgroundX = self.backgroundX,
            playersArray = self.playersArray,
            players = self.players
        })
    end

    if #self.players > 0 then
        self.maxX = self.players[1].x
        self.minX = self.players[1].x
        for key, player in pairs(self.players) do
            self.maxX = math.max(player.x, self.maxX)
            self.minX = math.min(player.x, self.minX)
        end
        self.middleX = (self.minX + (self.maxX - self.minX) / 2)
    else
        gStateMachine:change('clear', {
            camX = self.camX,
            camY = self.camY,
            level = self.level,
            background = self.background,
            backgroundX = self.backgroundX,
            playersArray = self.playersArray,
            players = self.players
        })
    end


    -- constrain player X no matter which state
    for key, player in pairs(self.players) do
        if player.x <= 0 then
            player.x = 0
        elseif player.x > TILE_SIZE * self.tileMap.width - player.width then
            player.x = TILE_SIZE * self.tileMap.width - player.width
        elseif player.x < self.camX then
            player.x = self.camX
        elseif player.x + player.width > self.camX + VIRTUAL_WIDTH then
            player.x = self.camX + VIRTUAL_WIDTH - player.width
        end
    end

    if (self.maxX - self.minX) + 15 < (VIRTUAL_WIDTH) then
        self:updateCamera()
    end
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    
    self.level:render()

    for key, player in pairs(self.players) do
        player:render()
    end
    
    love.graphics.pop()
    
    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(''), 4, 4)
end

function PlayState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.middleX - (VIRTUAL_WIDTH / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end

--[[
    Adds a series of enemies to the level randomly.
]]
function PlayState:spawnEnemies()
    local x = 17
    local y = 15

    -- local boss1
    -- boss1 = Boss1 {
    --     texture = 'boss1',
    --     x = (x - 1) * TILE_SIZE,
    --     y = (y - 2) * TILE_SIZE - 2,
    --     width = 64,
    --     height = 35,
    --     stateMachine = StateMachine {
    --         ['dashing'] = function() return Boss1DashState(boss1, {maxDashAmount = 3, dashDistance = (9 - 1) * TILE_SIZE}) end,
    --         -- ['moving'] = function() return SnailMovingState(self.tileMap, self.player, boss1) end,
    --         -- ['chasing'] = function() return SnailChasingState(self.tileMap, self.player, boss1) end

    --         ['idle'] = function() return Boss1IdleState(boss1) end,
    --     },
    --     map = self.tileMap,
    --     level = self.level,
    -- }
    -- boss1:changeState('dashing')

    -- table.insert(self.level.entities, boss1)
end