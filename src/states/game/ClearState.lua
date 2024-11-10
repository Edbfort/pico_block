--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ClearState = Class{__includes = BaseState}

function ClearState:init()
    self.map = LevelMaker.generate(2)
    self.background = math.random(3)
    self.players = {}
    self.xOffset = 17
    self.textX = 0
end

function ClearState:enter(def)
    self.camX = def.camX
    self.camY = def.camY
    self.level = def.level
    self.tileMap = self.level.tileMap
    self.background = def.background
    self.backgroundX = def.backgroundX
    self.timer = 1

    self.playersArray = def.playersArray
    self.players = def.players
end

function ClearState:update(dt)
    self.textX = self.textX + 70 * dt
    if self.textX > VIRTUAL_WIDTH * 2 then
        gStateMachine:change('start')
    end
end

function ClearState:render()
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
    
    love.graphics.setFont(gFonts['large'])
    -- love.graphics.setColor(0, 0, 0, 255)
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.printf('LEVEL CLEAR', -VIRTUAL_WIDTH / 2 + self.textX, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('LEVEL CLEAR', -VIRTUAL_WIDTH / 2 + self.textX, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')

    love.graphics.pop()
end