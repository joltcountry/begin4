Enemy = Movable:new()

function Enemy:new(x, y, drawer, dir, speed, proximity)
    o = Movable:new(x, y, drawer, dir, speed)
    self.__index = self
    setmetatable(o, self)
    return o
end

function Enemy:ai()

    -- fire?
    if (math.random(50) == 1) then
        local dir = getDir(self.x, self.y, myShip.x, myShip.y)
        local torpedo = Torpedo:new(self.x, self.y, nil, dir, 7000)
        torpedo.shooter = self
        table.insert(objects, torpedo)
    end

    -- Some basic AI
    if not self.targetDir or self.dir == self.targetDir then
        self.targetDir = math.random(360)
        self.targetSpeed = math.random(1500) + 500
    else
        if self.speed ~= self.targetSpeed then
            if self.speed < self.targetSpeed then
                self.speed = math.min(self.targetSpeed, self.speed + perCycle(500))
            else
                self.speed = math.max(self.targetSpeed, self.speed - perCycle(500))
    
        self.targetDir = math.random(360)
        self.targetSpeed = math.random(1500) + 500		end
        end
    
        currDir = normalizeAngle(self.dir)
        targetDir = normalizeAngle(self.targetDir)
    
        diff = targetDir - currDir
        diff = (diff + 180) % 360 - 180
    
        if (math.abs(diff) < perCycle(20)) then
            self.dir = self.targetDir
        else
            if diff > 0 then
                self.dir = self.dir + math.min(diff, perCycle(20))
            else
                self.dir = self.dir - math.min(math.abs(diff), perCycle(20))
            end
        end
    end

end

