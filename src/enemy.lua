local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y)
    local self = {
        x = x,
        y = y,
        speed = 200,
        angle = 0,
        radius = 20,
        health = 100
        
    }    
    setmetatable(self, Enemy)
    return self
end



function Enemy:load()
    
end

function Enemy:draw()
    love.graphics.setColor(1 - self.health/100, self.health/100, 0)
    love.graphics.circle("fill", self.x, self.y, self.radius)
    
end

return Enemy