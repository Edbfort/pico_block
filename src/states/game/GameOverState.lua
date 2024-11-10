--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.map = LevelMaker.generate(2)
    self.background = math.random(3)
    self.players = {}
    self.xOffset = 17
end

function GameOverState:enter(def)
    self.camX = def.camX
    self.camY = def.camY
    self.level = def.level
    self.tileMap = self.level.tileMap
    self.background = def.background
    self.backgroundX = def.backgroundX
    self.timer = 2

    self.playersArray = def.playersArray
    self.players = def.players

    for key, player in pairs(self.players) do
        player:changeState('gameOver')
    end
end

function GameOverState:update(dt)
    if self.timer < 0 then
        gStateMachine:change('play', {
            players = self.playersArray
        })
    end
    self.timer = self.timer - dt

    for key, player in pairs(self.players) do
        player:update(dt)
    end
end

function GameOverState:render()
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