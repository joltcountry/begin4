Pane = {}

function Pane:new(x1Percent, y1Percent, x2Percent, y2Percent, z)
    o = {}
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

function Pane:scissor()
    love.graphics.setScissor(self.startX, self.startY, self.xWidth, self.yWidth)
end

function Pane:background() -- default
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', self.x, self.y, self.xWidth, self.yWidth)
end

function Pane:draw() -- default, should be overridden
    love.graphics.setColor(0, 1, 0);
    love.graphics.rectangle('line', self.startX, self.startY, self.xWidth - love.graphics.getLineWidth(), self.yWidth - love.graphics.getLineWidth());
end

function Pane:render()
    self:scissor()
    self:background()
    self:draw()
    love.graphics.setScissor()
	love.graphics.setColor(1,1,1);
end

function Pane:within(x, y)
    return x >= self.startX and x <= self.endX and y >= self.startX and y <= self.endY
end

function Pane:update()
end
