if arg[2] == "debug" then
    require("lldebugger").start()
end

local Player = require("src.player")
local Bullet = require("src.bullet")
local Enemy = require("src.enemy")
local World = require("src.world")

local map
local player
local bullets = {}
local enemies = {}



function love.load()
    love.window.setMode(1600, 900)
    player = Player.new(500, 200)
    map = World.new(love.graphics.getWidth() / 16)
    table.insert(enemies, Enemy.new(300, 300))
    table.insert(enemies, Enemy.new(500, 300))
    table.insert(enemies, Enemy.new(123, 300))
    table.insert(enemies, Enemy.new(300, 32))
    table.insert(enemies, Enemy.new(1000, 700))
    Height = love.graphics.getHeight()
    Width = love.graphics.getWidth()
end

function love.update(dt)
    player:update(dt, map)

    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet:update(dt)

        if bullet.x > Width or bullet.x < 0
            or bullet.y > Height or bullet.y < 0 then
            table.remove(bullets, i)
        elseif (map:colides(bullet.x, bullet.y, bullet.radius, bullet.radius))then
            table.remove(bullets, i)
        else
            for j = #enemies, 1, -1 do
                local enemy = enemies[j]
                if CheckCollisions(bullet, enemy) then
                    enemy.health = enemy.health - player.damage
                    table.remove(bullets, i)
                    if enemy.health <= 0 then
                        table.remove(enemies, j)
                    end
                    break
                end
            end
        end
    end
    player.fireTimer = player.fireTimer - dt
    if love.mouse.isDown(1) then
        Shoot()
    end
end

function love.draw()
    map:draw()
    player:draw()
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end
    for _, bullet in ipairs(bullets) do
        bullet:draw()
    end
end

function Shoot()
    if player.fireTimer <= 0 then
        local bullet = Bullet.new(player.x, player.y, player.angle)
        table.insert(bullets, bullet)
        player.fireTimer = 1 / player.fireRate
    end
end

function CheckCollisions(bullet, enemy)
    local dx = bullet.x - enemy.x
    local dy = bullet.y - enemy.y

    local distane = math.sqrt(dx * dx + dy * dy)

    return distane < bullet.radius + enemy.radius
end

local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
