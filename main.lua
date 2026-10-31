if arg[2] == "debug" then
    require("lldebugger").start()
end

local Player = require("src.player")
local player

-- Load some default values for our rectangle.
function love.load()
    player = Player
    
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    
end



-- Draw a coloured rectangle.
function love.draw()

end








local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end