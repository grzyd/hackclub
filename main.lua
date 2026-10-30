if arg[2] == "debug" then
    require("lldebugger").start()
end


-- Load some default values for our rectangle.
function love.load()
    X, Y, w, h = 20, 20, 60, 20
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    
end



-- Draw a coloured rectangle.
function love.draw()
    -- In versions prior to 11.0, color component values are (0, 102, 102)
    X, Y = love.mouse.getPosition()
    love.graphics.setColor(0, 0.4, 0.4)
    love.graphics.rectangle("fill", X, Y, w, h)
end








local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end