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
local enemyBullets = {}


local gameState = "playing"

function love.load()
    love.window.setMode(1600, 900)
    
    map = World.new(love.graphics.getWidth() / 16)
    player = Player.new(5, 5, map)
    map:load()
    local spawns = map:getEnemySpawns()

    for _, spawn in ipairs(spawns) do
        table.insert(enemies, Enemy.new(spawn.x, spawn.y))
    end




    Height = love.graphics.getHeight()
    Width = love.graphics.getWidth()
end

function love.update(dt)
    if gameState == "lost" then
        return
    end
    player:update(dt, map)

    for _, enemy in ipairs(enemies) do
        enemy:update(dt, player, map)
        enemy:shoot(player, enemyBullets, map)
    end
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet:update(dt)

        if bullet.x > Width or bullet.x < 0
            or bullet.y > Height or bullet.y < 0 then
            table.remove(bullets, i)
        elseif (map:colides(bullet.x, bullet.y, bullet.radius, bullet.radius)) then
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
    for i = #enemyBullets, 1, -1 do
        local bullet = enemyBullets[i]
        bullet:update(dt)

        if bullet.x > Width or bullet.x < 0
            or bullet.y > Height or bullet.y < 0 then
            table.remove(enemyBullets, i)
        elseif CheckCollisions(bullet, player) then
            player.health = player.health - bullet.damage
            table.remove(enemyBullets, i)
            print(player.health)
        elseif (map:colides(bullet.x, bullet.y, bullet.radius, bullet.radius)) then
            table.remove(enemyBullets, i)
        end
    end

    player.fireTimer = player.fireTimer - dt
    if love.mouse.isDown(1) then
        Shoot()
    end

    if gameState == "playing" then
        if player.health <= 0 then
            gameState = "lost"
        end
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
    for _, bullet in ipairs(enemyBullets) do
        bullet:draw()
    end
    if gameState == "lost" then
        love.graphics.setColor(0, 0, 0, 0.8)

        love.graphics.rectangle(
            "fill",
            0, 0,
            love.graphics.getWidth(),
            love.graphics.getHeight()
        )

        love.graphics.setColor(1, 0.2, 0.2)

        love.graphics.printf(
            "YOU LOST!",
            0,
            350,
            love.graphics.getWidth(),
            "center"
        )

        love.graphics.setColor(1, 1, 1)

        love.graphics.setColor(1, 1, 1)

        love.graphics.printf(
            "Press R to restart",
            0,
            420,
            love.graphics.getWidth(),
            "center"
        )
    end
end

function Shoot()
    if player.fireTimer <= 0 then
        local bullet = Bullet.new(player.x, player.y, player.angle, player.damage)
        table.insert(bullets, bullet)
        player.fireTimer = 1 / player.fireRate
    end
end

function CheckCollisions(bullet, enemy)
    local dx = bullet.x - enemy.x
    local dy = bullet.y - enemy.y

    local distane = math.sqrt(dx * dx + dy * dy)

    if enemy.radius then
        return distane < bullet.radius + enemy.radius
    else
        return distane < bullet.radius + enemy.width
    end
end

function love.keypressed(key)
    if key == "r" and gameState == "lost" then
        RestartGame()
    end
end

function RestartGame()
    player = Player.new(5, 5, map)

    bullets = {}
    enemyBullets = {}

    enemies = {}

    local spawns = map:getEnemySpawns()

    for _, spawn in ipairs(spawns) do
        table.insert(enemies, Enemy.new(spawn.x, spawn.y))
    end

    gameState = "playing"
end

local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
