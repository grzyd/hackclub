local Bullet = {}
Bullet.__index = Bullet

function Bullet.new(x, y, angle)
    local self = {
        x = x,
        y = y,
        speed = 600,
        angle = angle,
        radius = 5
        
    }    
    setmetatable(self, Bullet)
    return self
end


function Bullet:update(dt)
    self.x = self.x + math.cos(self.angle) * self.speed * dt
    self.y = self.y + math.sin(self.angle) * self.speed * dt


end

function Bullet:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end




return Bullet