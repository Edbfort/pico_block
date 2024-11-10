LevelMaker = Class{}

function LevelMaker.generate(playerTotal)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND

    local blockType = {
        -- 21
        function(playerTotal, tiles, x, y)
            if playerTotal >= 2 then
                table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            else
                table.insert(tiles[y],
                        Tile(x, y, 1))
            end
        end,
        -- 22
        function(playerTotal, tiles, x, y)
            if playerTotal >= 3 then
                table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            else
                table.insert(tiles[y],
                        Tile(x, y, 2))
            end
        end,
        -- 23
        function(playerTotal, tiles, x, y)
            if playerTotal >= 4 then
                table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            elseif playerTotal == 3 then
                table.insert(tiles[y],
                    Tile(x, y, 2))
                table.insert(objects,
                    -- tile block
                    GameObject {
                        texture = 'blocksPico',
                        x = (x - 1) * TILE_SIZE - 8,
                        y = (y - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- edge top left
                        frame = 2,
                        collidable = false,
                        solid = true,
                        onCollide = function(obj)
                            
                        end
                    }
                )
            else
                table.insert(tiles[y],
                        Tile(x, y, 1))
            end
        end,
        -- 24
        function(playerTotal, tiles, x, y)
            if playerTotal <= 2 then
                table.insert(tiles[y],
                        Tile(x, y, 2))
            else
                table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            end
        end,
        -- 25
        function(playerTotal, tiles, x, y)
            if playerTotal <= 3 then
                table.insert(tiles[y],
                        Tile(x, y, 2))
            else
                table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            end
        end,
        -- 26
        function(playerTotal, tiles, x, y)
            if playerTotal <= 4 then
                table.insert(tiles[y],
                        Tile(x, y, 3))
            else
                table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            end
        end,
        -- 27
        function(playerTotal, tiles, x, y)
            table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            table.insert(objects,
                GameObject {
                    texture = 'button',
                    x = (x - 1) * TILE_SIZE,
                    y = (y - 1) * TILE_SIZE + 8,
                    width = 16,
                    height = 8,

                    -- button
                    frame = 6,
                    consumable = true,
                    hit = false,
                    solid = false,

                    onConsume = function(player)
                        table.insert(objects,
                            -- tile block below
                            GameObject {
                                texture = 'blocksPico',
                                x = (x - 1) * TILE_SIZE,
                                y = (y - 1 + 1) * TILE_SIZE,
                                width = 16,
                                height = 16,

                                -- edge top left
                                frame = 7,
                                collidable = false,
                                solid = true,
                                onCollide = function(obj)
                                    
                                end,
                                dx = -20,
                                xTo = (x - 10 - 1) * TILE_SIZE + 8
                            }
                        )
                        for i = 1, 9 do
                            table.insert(objects,
                                -- tile block below
                                GameObject {
                                    texture = 'blocksPico',
                                    x = (x - 1) * TILE_SIZE,
                                    y = (y - 1 + 1) * TILE_SIZE,
                                    width = 16,
                                    height = 16,

                                    -- edge top left
                                    frame = 1,
                                    collidable = false,
                                    solid = true,
                                    onCollide = function(obj)
                                        
                                    end,
                                    dx = -20 + i,
                                    xTo = (x - 10 + i - 1) * TILE_SIZE + 9 - i
                                }
                            )
                        end
                        table.insert(objects,
                            GameObject {
                                texture = 'button',
                                x = (x - 1) * TILE_SIZE,
                                y = (y - 1) * TILE_SIZE + 8,
                                width = 16,
                                height = 8,

                                -- button
                                frame = 7,
                                solid = false,
                            }
                        )
                    end
                }
            )
        end,
        -- 28
        function(playerTotal, tiles, x, y)
            table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            table.insert(objects,
                -- jump block
                GameObject {
                    texture = 'props',
                    x = (x - 1) * TILE_SIZE,
                    y = (y - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,

                    -- door
                    frame = 3,
                    hit = false,
                    solid = false,

                    onCollide = function(obj)

                    end
                }
            )
        end,
        -- 29
        function(playerTotal, tiles, x, y)
            if playerTotal <= 3 then
                table.insert(tiles[y],
                        Tile(x, y, 1))
            else
                table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            end
        end,
        -- 30
        function(playerTotal, tiles, x, y)
            if playerTotal <= 2 then
                table.insert(tiles[y],
                        Tile(x, y, 1))
            elseif playerTotal <= 3 then
                table.insert(tiles[y],
                        Tile(x, y, 3))
            else
                table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            end
        end,
        -- 31
        function(playerTotal, tiles, x, y)
            if playerTotal <= 3 then
                table.insert(tiles[y],
                        Tile(x, y, 1))
            else
                table.insert(tiles[y],
                    Tile(x, y, 2))
            end
        end,
        -- 32
        function(playerTotal, tiles, x, y)
            if playerTotal >= 3 then
                table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            else
                table.insert(tiles[y],
                        Tile(x, y, 1))
            end
        end,
        -- 33
        function(playerTotal, tiles, x, y)
            if playerTotal <= 2 then
                table.insert(tiles[y],
                        Tile(x, y, 3))
            else
                table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            end
        end,
        -- 34
        function(playerTotal, tiles, x, y)
            if playerTotal >= 4 then
                table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            elseif playerTotal == 3 then
                table.insert(tiles[y],
                    Tile(x, y, 2))
                table.insert(objects,
                    -- tile block
                    GameObject {
                        texture = 'blocksPico',
                        x = (x - 1) * TILE_SIZE - 8,
                        y = (y - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- edge top left
                        frame = 2,
                        collidable = false,
                        solid = true,
                        onCollide = function(obj)
                            
                        end
                    }
                )
            else
                table.insert(tiles[y],
                        Tile(x, y, 1))
            end
        end,
        -- 35
        function(playerTotal, tiles, x, y)
            if playerTotal >= 4 then
                table.insert(tiles[y],
                    Tile(x, y, 2))
            elseif playerTotal <= 3 then
                table.insert(tiles[y],
                    Tile(x, y, 1))
            end
        end,
        -- 36
        function(playerTotal, tiles, x, y)
            if playerTotal >= 4 then
                table.insert(tiles[y],
                    Tile(x, y, 3))
            elseif playerTotal <= 3 then
                table.insert(tiles[y],
                    Tile(x, y, 1))
            end
        end,
        -- 37
        function(playerTotal, tiles, x, y)
            table.insert(tiles[y],
                    Tile(x, y, TILE_ID_EMPTY))
            table.insert(objects,
                GameObject {
                    texture = 'keys',
                    x = (x - 1) * TILE_SIZE,
                    y = (y - playerTotal + 2 - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,

                    -- key
                    frame = 2,
                    consumable = true,
                    solid = false,

                    onConsume = function(player)
                        for kObject, object in pairs(player.level.objects) do
                            if object.texture == 'props' and object.frame == 3 then
                                object.frame = 4
                                object.downable = true
                                object.onDown = function(currentPlayer)
                                    currentPlayer.enteredDoor = true
                                end
                            end
                        end
                    end
                }
            )
        end,
    }

    local maps = {
        {},
        {}
    }

    local mapArray = {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 33, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 25, 29, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27, 0, 0, 2, 1, 1, 36, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27, 28, 0, 1},
        {1, 1, 1, 1, 1, 1, 1, 3, 21, 21, 21, 21, 22, 32, 23, 31, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 22, 34, 35, 1, 1, 1, 1}
    }

    -- insert blank tables into tiles for later access
    for x = 1, #mapArray do
        table.insert(tiles, {})
    end

    local map
    -- column by column generation instead of row; sometimes better for platformers
    if playerTotal ~= 0 then
        for x = 1, #mapArray[1] do
            for y = 1, #mapArray do
                if mapArray[y][x] == 0 then
                    table.insert(tiles[y],
                        Tile(x, y, TILE_ID_EMPTY))
                elseif mapArray[y][x] <= 10 then
                    table.insert(tiles[y],
                        Tile(x, y, mapArray[y][x]))
                elseif mapArray[y][x] <= 20 then
                    -- props
                else
                    blockType[mapArray[y][x] - 20](playerTotal, tiles, x, y)
                end
            end
        end

        map = TileMap(#mapArray[1], #mapArray)
    else
        for x = 1, math.floor(VIRTUAL_WIDTH / 16) do
            for y = 1, math.floor(VIRTUAL_HEIGHT / 16) do
                if (x == 1 or x == math.floor(VIRTUAL_WIDTH / 16)) or (y == 1 or y == math.floor(VIRTUAL_HEIGHT / 16)) then
                    table.insert(tiles[y],
                        Tile(x, y, TILE_ID_GROUND))
                else
                    table.insert(tiles[y],
                        Tile(x, y, TILE_ID_EMPTY))
                end
            end
        end

        map = TileMap(math.floor(VIRTUAL_WIDTH / 16), math.floor(VIRTUAL_HEIGHT / 16))
    end
    
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end