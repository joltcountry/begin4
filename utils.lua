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
        print(k..'..'..v)
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
    track('startAngle', startAngle)
    track('endAngle', endAngle)
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