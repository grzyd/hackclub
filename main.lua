local Player = require("src.player")
local Bullet = require("src.bullet")
local Enemy = require("src.enemy")
local World = require("src.world")

local map
local player
local bullets = {}
local enemies = {}
local enemyBullets = {}

CurrentLevel = 1

local gameState = "menu"

function love.load()
    love.window.setMode(1600, 900)
    LoadLevel(CurrentLevel)








    Height = love.graphics.getHeight()
    Width = love.graphics.getWidth()
end

function love.update(dt)
    if gameState ~= "playing" then
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
    if #enemies == 0 and gameState == "playing" then
        NextLevel()
    end
end

function love.draw()
    if gameState == "menu" then
        DrawMenu()
    else
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

        if gameState == "won" then
            love.graphics.setColor(0, 0, 0, 0.8)

            love.graphics.rectangle(
                "fill",
                0, 0,
                love.graphics.getWidth(),
                love.graphics.getHeight()
            )

            love.graphics.setColor(0.2, 1, 0.2)

            love.graphics.printf(
                "YOU WON!",
                0,
                350,
                love.graphics.getWidth(),
                "center"
            )

            love.graphics.setColor(1, 1, 1)

            love.graphics.setColor(1, 1, 1)

            love.graphics.printf(
                "Press R to start again \n press M to open menu",
                0,
                420,
                love.graphics.getWidth(),
                "center"
            )

        end

        player:drawHealtBar()
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
    if key == "r" and gameState == "won" then
        RestartGame()
        LoadLevel(1)
        CurrentLevel = 1
    end
    if key == "m" and gameState == "won" then
        gameState = "menu"
    end
end

function RestartGame()
    player = Player.new(0, 5, map)

    bullets = {}
    enemyBullets = {}

    enemies = {}

    local spawns = map:getEnemySpawns()

    for _, spawn in ipairs(spawns) do
        table.insert(enemies, Enemy.new(spawn.x, spawn.y))
    end

    gameState = "playing"
end

function LoadLevel(levelNumber)
    local levelLayout = require("src.levels.level" .. levelNumber)

    map = World.new(love.graphics.getWidth() / 16, levelLayout)

    map:load()

    player = Player.new(0, 5, map)

    bullets = {}
    enemyBullets = {}
    enemies = {}

    local spawns = map:getEnemySpawns()

    for _, spawn in ipairs(spawns) do
        table.insert(enemies, Enemy.new(spawn.x, spawn.y))
    end
end

function NextLevel()
    CurrentLevel = CurrentLevel + 1

    if CurrentLevel > 5 then
        gameState = "won"
        return
    end

    LoadLevel(CurrentLevel)
end

local buttons = {
    play = {
        width = 200,
        height = 60
    },

    quit = {
        width = 200,
        height = 60
    }
}

function love.mousepressed(x, y, button)
    if button ~= 1 then return end

    if gameState == "menu" then
        local play = buttons.play

        if x >= play.x and x <= play.x + play.width
            and y >= play.y and y <= play.y + play.height then
            LoadLevel(1)
            gameState = "playing"
        end

        local quit = buttons.quit

        if x >= quit.x and x <= quit.x + quit.width
            and y >= quit.y and y <= quit.y + quit.height then
            love.event.quit()
        end
    end
end

function DrawMenu()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()


    buttons.play.x = screenWidth / 2 - buttons.play.width / 2
    buttons.play.y = screenHeight / 2 - 40

    buttons.quit.x = screenWidth / 2 - buttons.quit.width / 2
    buttons.quit.y = screenHeight / 2 + 40


    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)


    love.graphics.setColor(0.6, 0.6, 0.4)
    love.graphics.printf(
        "SOLOCREW",
        0, screenHeight / 2 - 180,
        screenWidth,
        "center"
    )
    love.graphics.setColor(1, 1, 1)

    love.graphics.rectangle(
        "fill",
        buttons.play.x,
        buttons.play.y,
        buttons.play.width,
        buttons.play.height
    )

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(
        "PLAY",
        buttons.play.x,
        buttons.play.y + 20,
        buttons.play.width,
        "center"
    )


    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle(
        "fill",
        buttons.quit.x,
        buttons.quit.y,
        buttons.quit.width,
        buttons.quit.height
    )

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(
        "QUIT",
        buttons.quit.x,
        buttons.quit.y + 20,
        buttons.quit.width,
        "center"
    )

    love.graphics.setColor(1, 1, 1)
end

