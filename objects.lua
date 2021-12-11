ObjectInSpace = {}

function ObjectInSpace:new(x, y, imageFile)
    o = {}
    o.x = x or 0
    o.y = y or 0
    o.imageFile = imageFile
    setmetatable(o, self)
    self.__index = self
    return o
end

function ObjectInSpace:draw()
    love.graphics.draw(self.imageFile, self:windowPositionX(), self:windowPositionY(), 0, gamestate.scale, gamestate.scale, self.imageFile:getWidth() / 2, self.imageFile:getHeight() / 2);
end

function ObjectInSpace:windowPositionX()
    local unit = viewport.size / gamestate.range
    local xOffset = self.x - viewport.centerX

    return viewport.x + viewport.size/2 + (xOffset * unit)
end

function ObjectInSpace:windowPositionY()
    local unit = viewport.size / gamestate.range
    local yOffset = self.y - viewport.centerY

    return viewport.y + viewport.size/2 + (yOffset * unit)
end

Movable = ObjectInSpace:new()

function Movable:new(x, y, imageFile, dir, speed)
    o = ObjectInSpace:new(x, y, imageFile)
    o.dir = dir or 0
    o.speed = speed or 0
    self.__index = self
    setmetatable(o, self)
    return o
end

function Movable:draw()
    love.graphics.draw(self.imageFile, self:windowPositionX(), self:windowPositionY(), math.rad(self.dir), gamestate.scale, gamestate.scale, self.imageFile:getWidth() / 2, self.imageFile:getHeight() / 2);
end

function Movable:setDirection(d)
    self.dir = d
end

function Movable:setSpeed(s)
    self.speed = s
end

function Movable:move(dt)
    self.x = self.x + (math.sin(math.rad(self.dir)) * self.speed * (1 / gamestate.cycles))
    self.y = self.y - (math.cos(math.rad(self.dir)) * self.speed * (1 / gamestate.cycles))
end