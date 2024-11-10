--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StartState = Class{__includes = BaseState}

function StartState:init()
    self.map = LevelMaker.generate(0)
    self.tileMap = self.map.tileMap
    self.background = 1
    self.playersArray = {}
    self.players = {}
    self.testing = false
    self.createdPlayer = {nil, nil, nil, nil}
    self.xOffset = 0
    self.gravityAmount = 6
end

function StartState:update(dt)
    if (love.keyboard.wasPressed('e') or self.testing) and (self.createdPlayer[1] == nil) then
        local player
        player = {
            x = 2 + self.xOffset,
            y = 4,
            color = 1,
            number = 1,
            up = 'e',
            down = 'r',
            left = 'q',
            right = 'w'
        }
        table.insert(self.playersArray, player)
        player.gravityAmount = self.gravityAmount
        player.map = self.tileMap
        player.level = self.map
        table.insert(self.players, self:addPlayer(player))
        self.players[#self.players].players = self.players
        
        self.createdPlayer[1] = true
    end
    if (love.keyboard.wasPressed('o') or self.testing) and (self.createdPlayer[2] == nil) then
        local player
        player = {
            x = 3 + self.xOffset,
            y = 4,
            color = 2,
            number = 2,
            up = 'o',
            down = 'p',
            left = 'u',
            right = 'i'
        }
        table.insert(self.playersArray, player)
        player.gravityAmount = self.gravityAmount
        player.map = self.tileMap
        player.level = self.map
        table.insert(self.players, self:addPlayer(player))
        self.players[#self.players].players = self.players

        self.createdPlayer[2] = true
    end
    if (love.keyboard.wasPressed('c') or self.testing) and (self.createdPlayer[3] == nil) then
        local player
        player = {
            x = 4 + self.xOffset,
            y = 4,
            color = 3,
            number = 3,
            up = 'c',
            down = 'v',
            left = 'z',
            right = 'x'
        }
        table.insert(self.playersArray, player)
        player.gravityAmount = self.gravityAmount
        player.map = self.tileMap
        player.level = self.map
        table.insert(self.players, self:addPlayer(player))
        self.players[#self.players].players = self.players

        self.createdPlayer[3] = true
    end
    if (love.keyboard.wasPressed('up') or self.testing) and (self.createdPlayer[4] == nil) then
        local player
        player = {
            x = 5 + self.xOffset,
            y = 4,
            color = 4,
            number = 4,
            up = 'up',
            down = 'down',
            left = 'left',
            right = 'right'
        }
        table.insert(self.playersArray, player)
        player.gravityAmount = self.gravityAmount
        player.map = self.tileMap
        player.level = self.map
        table.insert(self.players, self:addPlayer(player))
        self.players[#self.players].players = self.players

        self.createdPlayer[4] = true
    end

    for key, player in pairs(self.players) do
        player:update(dt)
    end

    if #self.playersArray > 1 and (love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')) then
        gStateMachine:change('play', {
            players = self.playersArray
        })
    end
end

function StartState:render()
    -- love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0, 0)
    -- love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0,
    --     gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    

    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(0), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(0),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(0 + 256), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(0 + 256),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(0), -math.floor(0))
    
    self.map:render()

    for key, player in pairs(self.players) do
        player:render()
    end

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf(#self.players .. ' / 2', 1, VIRTUAL_HEIGHT / 2 - 5, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf(#self.players .. ' / 2', 0, VIRTUAL_HEIGHT / 2 - 5, VIRTUAL_WIDTH, 'center')
    
    love.graphics.pop()

    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Pico Block', 1, VIRTUAL_HEIGHT / 2 - 40 + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Pico Block', 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.printf('Press Enter', 1, VIRTUAL_HEIGHT / 2 + 17, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
end

function StartState:addPlayer(params)
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

    player:changeState('idle')

    return player
end