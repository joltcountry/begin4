Explosion = ObjectInSpace:new()

function Explosion:draw()
    local size = self.size or 50
    love.graphics.setColor(math.random(), math.random(), math.random())
    love.graphics.circle('fill', self:windowPositionX(), self:windowPositionY(), math.random() * size * 2 + size);
end

function Explosion:update(dt)
    local seconds = self.seconds or 1
    if not self.timer then
        self.timer = 0
    else
        self.timer = self.timer + dt
        if self.timer > seconds then
            remove(self)
        end
    end
end