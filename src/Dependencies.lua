--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    -- Dependencies --

    A file to organize all of the global dependencies for our project, as
    well as the assets for our game, rather than pollute our main.lua file.
]]

--
-- libraries
--
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

--
-- our own code
--

-- utility
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

-- game states
require 'src/states/BaseState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/GameOverState'
require 'src/states/game/ClearState'

-- entity states
require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerJumpState'
require 'src/states/entity/PlayerWalkingState'
require 'src/states/entity/PlayerSlashState'
require 'src/states/entity/PlayerGameOverState'

require 'src/states/entity/snail/SnailChasingState'
require 'src/states/entity/snail/SnailIdleState'
require 'src/states/entity/snail/SnailMovingState'

require 'src/states/entity/boss1/Boss1IdleState'
require 'src/states/entity/boss1/Boss1DashState'

-- general
require 'src/Animation'
require 'src/Entity'
require 'src/GameObject'
require 'src/Hitbox'
require 'src/GameLevel'
require 'src/LevelMaker'
require 'src/Player'
require 'src/Snail'
require 'src/Tile'
require 'src/TileMap'
require 'src/Boss1'

gSounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
    ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
    ['music'] = love.audio.newSource('sounds/music3.mp3', 'static'),
    ['powerup-reveal'] = love.audio.newSource('sounds/powerup-reveal.wav', 'static'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav', 'static'),
    ['empty-block'] = love.audio.newSource('sounds/empty-block.wav', 'static'),
    ['kill'] = love.audio.newSource('sounds/kill.wav', 'static'),
    ['kill2'] = love.audio.newSource('sounds/kill2.wav', 'static')
}

gTextures = {
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
    ['creatures'] = love.graphics.newImage('graphics/creatures.png'),
    ['keys'] = love.graphics.newImage('graphics/keys_and_locks.png'),
    ['playerJump'] = love.graphics.newImage('graphics/playerJump.png'),
    ['playerMove'] = love.graphics.newImage('graphics/playerMove.png'),
    ['playerDeath'] = love.graphics.newImage('graphics/playerDeath.png'),
    ['rainLevelProps'] = love.graphics.newImage('graphics/rainLevelProps.png'),
    ['props'] = love.graphics.newImage('graphics/props.png'),
    ['button'] = love.graphics.newImage('graphics/props.png'),
    ['player'] = love.graphics.newImage('graphics/player.png'),
    ['blocksPico'] = love.graphics.newImage('graphics/blocksPico.png')
}

gFrames = {
    ['backgrounds'] = GenerateQuads(gTextures['backgrounds'], 256, 128),
    ['creatures'] = GenerateQuads(gTextures['creatures'], 16, 16),
    ['keys'] = GenerateQuads(gTextures['keys'], 16, 16),
    ['playerJump'] = GenerateQuads(gTextures['playerJump'], 16, 16),
    ['playerMove'] = GenerateQuads(gTextures['playerMove'], 16, 16),
    ['playerDeath'] = GenerateQuads(gTextures['playerDeath'], 16, 16),
    ['rainLevelProps'] = GenerateQuads(gTextures['rainLevelProps'], 8, 8),
    ['props'] = GenerateQuads(gTextures['props'], 16, 16),
    ['button'] = GenerateQuads(gTextures['button'], 16, 8),
    ['player'] = GenerateQuads(gTextures['player'], 16, 16),
    ['blocksPico'] = GenerateQuads(gTextures['blocksPico'], TILE_SIZE, TILE_SIZE)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}