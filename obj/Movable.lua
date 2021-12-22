Movable = ObjectInSpace:new()

function Movable:new(x, y, drawer, dir, speed)
    o = ObjectInSpace:new(x, y, drawer)
    o.dir = dir or 0
    o.speed = speed or 0
    o.lifespan = 0
    self.__index = self
    setmetatable(o, self)
    return o
end

function Movable:draw()
    if (type(self.drawer) == 'userdata') then
        love.graphics.setColor(1,1,1);
        love.graphics.draw(self.drawer, self:windowPositionX(), self:windowPositionY(), math.rad(self.dir), gamestate.scale, gamestate.scale, self.drawer:getWidth() / 2, self.drawer:getHeight() / 2);
    else
        self.drawer()
    end
end

function Movable:setDirection(d)
    self.dir = d
end

function Movable:setSpeed(s)
    self.speed = s
end

function Movable:move(dt)
    self.x = self.x + (math.sin(math.rad(self.dir)) * self.speed * perCycle(1))
    self.y = self.y - (math.cos(math.rad(self.dir)) * self.speed * perCycle(1))
    self.lifespan = self.lifespan + 1
end

function Movable:xVel()
    return math.sin(math.rad(self.dir)) * self.speed
end

function Movable:yVel()
    return -math.cos(math.rad(self.dir)) * self.speed
end