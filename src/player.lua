local player = {
    x = 400,
    y = 300,
    speed = 200,
    angle = 0,
    radius = 15

}



function love.load()
    love.window.setMode(800, 400)
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    local dx = 0
    local dy = 0

    if love.keyboard.isDown("w") then dy = dy - 1 end
    if love.keyboard.isDown("s") then dy = dy + 1 end
    if love.keyboard.isDown("a") then dx = dx - 1 end
    if love.keyboard.isDown("d") then dx = dx + 1 end


    player.x = player.x + dx
    player.y = player.y + dy
end

function love.draw()
    love.graphics.push()

    love.graphics.translate(player.x, player.y)
    love.graphics.rectangle("fill", 200, 100, 40, 40)
    love.graphics.pop()
end


return player