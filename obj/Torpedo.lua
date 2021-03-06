Torpedo = Movable:new()

function Torpedo:new(x, y, drawer, dir, speed, proximity)
    o = Movable:new(x, y, drawer)
    o.dir = dir or 0
    o.speed = speed or 0
    o.proximity = proximity or 300
    o.duration = 5
    self.__index = self
    setmetatable(o, self)
    return o
end

function Torpedo:draw()
    if self.shooter ~= myShip then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(1, 1, 1)
    end
    love.graphics.circle('fill', self:windowPositionX(), self:windowPositionY(), 10 * (gamestate.scale * .5));
    love.graphics.setLineWidth(2);
    for i=1,5 do
        if self.shooter ~= myShip then
            love.graphics.setColor(1, math.random(), math.random())
        else
            love.graphics.setColor(math.random(), math.random(), math.random())
        end
        local dir = math.floor(math.random() * 360)
        local distance = (math.floor(math.random() * 20) + 10) * (gamestate.scale * .75)
        local endX = self:windowPositionX() + (math.sin(math.rad(dir)) * distance)
        local endY = self:windowPositionY() - (math.cos(math.rad(dir)) * distance)
        love.graphics.line(self:windowPositionX(), self:windowPositionY(), endX, endY)
    end
end

function Torpedo:checkCollision(o)
    if (o ~= self.shooter) then 
        if getDistance(o.x, o.y, self.x, self.y) < self.proximity then
            local hitDir = normalizeAngle(getDir(o.x, o.y, self.x, self.y))
            local shieldHit = getShieldSide(o.dir, hitDir)
            local hitStrength = math.random(25) + 25
            log("Shield " .. shieldHit .. " HIT from angle " .. hitDir .. " for " .. hitStrength);
            remove(self)
            if (o.shields[shieldHit] <= 0) then
                table.insert(objects, Explosion:new(o.x, o.y))
                remove(o)
                return true
            else
                local littleExplosion = Explosion:new(o.x, o.y)
                littleExplosion.size = 20
                littleExplosion.seconds = .5
                table.insert(objects, littleExplosion)
            end
            o.shields[shieldHit] = o.shields[shieldHit] - hitStrength;
        end
    end
end

function Torpedo:update()
    
    if self.lifespan / gamestate.cycles > self.duration then
        remove(self)
    else
        for k,v in pairs(objects) do
            if string.find(k, 'enemy') and self:checkCollision(v) then
                gamestate.enemies = gamestate.enemies - 1
            end
        end
        if self:checkCollision(myShip) then -- other death stuff
            myShip.shields = {0, 0, 0, 0, 0, 0}
            gamestate.dead = true
        end
    end
end