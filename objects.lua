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

function ObjectInSpace:turn()
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

function Movable:new(x, y, drawer, dir, speed)
    o = ObjectInSpace:new(x, y, drawer)
    o.dir = dir or 0
    o.speed = speed or 0
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
    self.x = self.x + (math.sin(math.rad(self.dir)) * self.speed * (1 / gamestate.cycles))
    self.y = self.y - (math.cos(math.rad(self.dir)) * self.speed * (1 / gamestate.cycles))
end

Torpedo = Movable:new()

function Torpedo:turn()
    track("torpedo turns", self.turns)
    if not self.turns then
        self.turns = 1
    else
        self.turns = self.turns + 1
        if self.turns == 10 then
            remove(self)
        end
    end
end

function Torpedo:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', self:windowPositionX(), self:windowPositionY(), 10 * (gamestate.scale * .5));
    love.graphics.setLineWidth(2);
    for i=1,5 do
        love.graphics.setColor(math.random(), math.random(), math.random())
        local dir = math.floor(math.random() * 360)
        local distance = (math.floor(math.random() * 20) + 10) * (gamestate.scale * .75)
        local endX = self:windowPositionX() + (math.sin(math.rad(dir)) * distance)
        local endY = self:windowPositionY() - (math.cos(math.rad(dir)) * distance)
        love.graphics.line(self:windowPositionX(), self:windowPositionY(), endX, endY)
    end
end

function Torpedo:update()
    local hitbox = 200
    for k,v in pairs(objects) do
        if string.find(k, 'enemy') then
            if math.abs(v.x - self.x) < hitbox and math.abs(v.y - self.y) < hitbox then
                table.insert(objects, Explosion:new(v.x, v.y))
                remove(v)
                remove(self)
                gamestate.enemies = gamestate.enemies - 1
            end
        end
    end
end

Explosion = ObjectInSpace:new()

function Explosion:draw()
    love.graphics.setColor(math.random(), math.random(), math.random())
    love.graphics.circle('fill', self:windowPositionX(), self:windowPositionY(), math.random() * 100 + 50);
end

function Explosion:update(dt)
    if not self.timer then
        self.timer = 0
    else
        self.timer = self.timer + dt
        if self.timer > 1 then
            remove(self)
        end
    end
end