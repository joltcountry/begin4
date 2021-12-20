Pane = {}

barHeight = 30

function Pane:new(movable, x1Percent, y1Percent, x2Percent, y2Percent, z)
    o = {}
    o.movable = movable
    o.x1Percent = x1Percent or 0
    o.y1Percent = y1Percent or 0
    o.x2Percent = x2Percent or 100
    o.y2Percent = y2Percent or 100
    o.z = z or 0
    setmetatable(o, self)
    self.__index = self
    o:init()
    return o
end

function Pane:init()
    local windowWidth = love.graphics.getWidth()
	local windowHeight = love.graphics.getHeight()
    self.startX = self.x1Percent / 100 * windowWidth
    self.startY = self.y1Percent / 100 * windowHeight
    self.endX = self.x2Percent / 100 * windowWidth - 1
    self.endY = self.y2Percent / 100 * windowHeight - 1
    self.xWidth = self.endX - self.startX
    self.yWidth = self.endY - self.startY
    -- legacy
    self.x = self.startX
    self.y = self.startY
    self.size = math.max(self.xWidth, self.yWidth)
end

function Pane:setTitle(t)
    self.title = t
end

function Pane:scissor()
    love.graphics.setScissor(self.startX, self.startY, self.xWidth, self.yWidth)
end

function Pane:background() -- default
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', self.x, self.y, self.xWidth, self.yWidth)
end

function Pane:draw()
end

function Pane:print(s, x, y)
    self:scissor()
    if self.movable then
        love.graphics.print(s, self.startX + x, self.startY + barHeight + y)
    else
        love.graphics.print(s, self.startX + x, self.startY + y)
    end
    love.graphics.setScissor()
end

function Pane:render()
    self:scissor()
    self:background()
    self:draw()

    if (self.movable) then
        love.graphics.setColor(.4, .4, .5)
        love.graphics.rectangle('fill', self.startX, self.startY, self.xWidth, barHeight);
        love.graphics.setColor(1,1,1);
        love.graphics.setFont(titleFont)
        love.graphics.printf(self.title, self.startX, self.startY + 4, self.xWidth, 'center')
    end

    love.graphics.setScissor()
	love.graphics.setColor(1,1,1);
end

function Pane:within(x, y)
    -- if (self.movable) then
    --     return x >= self.startX and x <= self.endX and y >= self.startY + barHeight and y <= self.endY
    -- else
        return x >= self.startX and x <= self.endX and y >= self.startY and y <= self.endY
--    end
end

function Pane:isTopPane(x, y)
    return self == getTopPane(x, y)
end

function Pane:update()
end
