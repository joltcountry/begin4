function normalizeAngle(a)
    repeat
        if a < 0 then
            a = a + 360
        elseif a > 360 then
            a = a - 360
        end
    until a >= 0 and a <= 360
    return math.floor(a)
end

function printTable(t)
    for k,v in pairs(t) do
        print(k)
    end
end
    
function getRad(d)
    return math.rad(d - 90)
end

function getDir(sourceX, sourceY, targetX, targetY)
	return math.deg(math.atan2(sourceY - targetY, sourceX - targetX)) - 90
end

function getDistance(sourceX, sourceY, targetX, targetY)
    local dx = sourceX - targetX
    local dy = sourceY - targetY
    return math.sqrt ( dx * dx + dy * dy )
end

function remove(o)
    for k,v in pairs(objects) do
        if v == o then
            objects[k] = nil
        end
    end
end

function getShieldSide(dir, d)
    d = normalizeAngle(d - dir)
    shieldStarts = { 330, 30, 90, 150, 210, 270 }
    for i,v in ipairs(shieldStarts) do
        if d >= v and d < v + 60 then
            return i
        end
    end
    return 1 -- Betweeen 0 and 29...
end

function drawArc(centerX, centerY, radius, startAngle, endAngle) 
    track('radius', radius)
    local startX, startY, endX, endY
    for a=startAngle,endAngle do
        startX = centerX + math.sin(math.rad(a)) * radius
        startY = centerY - math.cos(math.rad(a)) * radius
        endX = centerX + math.sin(math.rad(a+1)) * radius
        endY = centerY - math.cos(math.rad(a+1)) * radius
        love.graphics.line(startX, startY, endX, endY)
        startX = endX
        endY = endY
    end
end

function getXVel(dir, speed)
    return math.sin(math.rad(dir)) * speed
end

function getYVel(dir, speed)
    return -math.cos(math.rad(dir)) * speed
end

function getVector(xVel, yVel)
    local speed = getDistance(0, 0, xVel, yVel)
    local dir = getDir(0, 0, xVel, yVel)
    return { dir, speed }    
end

function drawShields(o)
    for shield, strength in ipairs(o.shields) do
        local arcStart = o.dir + ((shield-1) * 60) - 25;
        local arcEnd = o.dir + ((shield-1) * 60) + 25;
        if (strength > 0) then
            love.graphics.setColor(1 - strength/100,strength/150 , 0)
            drawArc(o:windowPositionX(), o:windowPositionY(), (30 * gamestate.scale) + (strength/100 * 15 * gamestate.scale), arcStart, arcEnd)
        end
    end
end

function perCycle(n)
    return n / gamestate.cycles
end

function getAngleDiff(currDir, targetDir)
    local diff = targetDir - currDir
    diff = (diff + 180) % 360 - 180
    return diff
end

function setWindow(w, h)
    oldWidth = love.graphics.getWidth()
    oldHeight = love.graphics.getHeight()
    love.window.setMode(w, h)
    for k,v in pairs(panes) do
        v:init()
    end
    windowsInitialized = true
end

function resetPanes()
    for k,v in pairs(panes) do
        v:init()
    end
end

function getTopPane(x, y)
    local topPane
    for k, v in pairs(panes) do
        if v:within(x, y) then
            if not topPane or v.z > topPane.z then
                topPane = v
                track('Top pane', k)
            end
        end
    end
    return topPane
end

function getTopZ()
    local topZ
    for k, v in pairs(panes) do
        if not topZ or v.z > topZ then topZ = v.z end
    end
    return topZ
end