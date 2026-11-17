local Enemy = {}
Enemy.__index = Enemy

local Bullet = require("src.bullet")



function Enemy.new(x, y)
    local self = {
        x = x,
        y = y,
        speed = 100,
        angle = 0,
        radius = 20,
        health = 100,
        damage = 10,
        fireRate = 1,
        fireTimer = 0
        
    }    
    setmetatable(self, Enemy)
    return self
end



function Enemy:load()
    
end

function Enemy:update(dt, player, map)
    self.fireTimer = self.fireTimer - dt

    if map:hasLOS(self.x, self.y, player.x, player.y) then
        local dx = player.x - self.x
        local dy = player.y - self.y

        local distance = math.sqrt(dx * dx + dy * dy)

        if distance > 200 then
            dx = dx / distance
            dy = dy / distance

            self.x = self.x + dx * self.speed * dt
            self.y = self.y + dy * self.speed * dt
        end
    end
end


function Enemy:shoot(player, bullets, map)
    if self.fireTimer <= 0 then
        if not map:hasLOS(player.x, player.y, self.x, self.y) then
            return
        end

        local dx = player.x - self.x
        local dy = player.y - self.y

        local angle = math.atan2(dy, dx)

        table.insert(bullets, Bullet.new(self.x, self.y, angle, self.damage))

        self.fireTimer = 1/self.fireRate
    end
    
end

function Enemy:draw()
    love.graphics.setColor(1 - self.health/100, self.health/100, 0)
    love.graphics.circle("fill", self.x, self.y, self.radius)
    love.graphics.setColor(1, 1 ,1)
    
end



return Enemy