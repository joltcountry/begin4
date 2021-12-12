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