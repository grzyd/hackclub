if arg[2] == "debug" then
    require("lldebugger").start()
end

local Player = require("src.player")
local Bullet = require("src.bullet")

local player
local bullets = {}

local height = love.graphics.getHeight()
local width = love.graphics.getWidth()
function love.load()
    love.window.setMode(800, 400)
    player = Player.new(400, 200)
end

function love.update(dt)
    player:update(dt)

    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet:update(dt)
        if(bullet.x > width or bullet.x < 0 or bullet.y > height or bullet.y < 0) then
            table.remove(bullets, i)
        end
    end
end

function love.draw()
    player:draw()
    for i, bullet in ipairs(bullets) do
        bullet:draw()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local bullet = Bullet.new(player.x, player.y, player.angle)
        table.insert(bullets, bullet)
        
    end
end






local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end