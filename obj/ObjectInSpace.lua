ObjectInSpace = {}

function ObjectInSpace:new(x, y, drawer)
    o = {}
    o.x = x or 0
    o.y = y or 0
    o.drawer = drawer
    setmetatable(o, self)
    self.__index = self
    return o
end

function ObjectInSpace:draw()
    if (type(self.drawer) == 'userdata') then
        love.graphics.setColor(1,1,1);
        love.graphics.draw(self.drawer, self:windowPositionX(), self:windowPositionY(), 0, gamestate.scale, gamestate.scale, self.drawer:getWidth() / 2, self.drawer:getHeight() / 2);
    else
        self.drawer()
    end
end

function ObjectInSpace:update()
end

function ObjectInSpace:windowPositionX()
    local unit = viewport.size / gamestate.range
    local xOffset = self.x - viewport.centerX

    return viewport.x + viewport.xWidth/2 + (xOffset * unit)
end

function ObjectInSpace:windowPositionY()
    local unit = viewport.size / gamestate.range
    local yOffset = self.y - viewport.centerY

    return viewport.y + viewport.yWidth/2 + (yOffset * unit)
end