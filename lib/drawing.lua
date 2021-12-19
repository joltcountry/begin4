function drawRangeRings()

    local maxDimension = viewport.size

    love.graphics.setLineWidth(2)

	for ringDistance = gamestate.ringSpacing, 100000, gamestate.ringSpacing do
		local radius = ringDistance * maxDimension / gamestate.range / 2
		love.graphics.setColor(.3, .3, .4)
		love.graphics.print(ringDistance, myShip:windowPositionX() - 20, myShip:windowPositionY() - radius - 20)
		love.graphics.setColor(.1, .1, .2)
		love.graphics.circle('line', myShip:windowPositionX(), myShip:windowPositionY(), radius)
	end

end

function drawNewNavigation(x, y)

    love.graphics.setLineWidth(3)
    love.graphics.setColor(.5, .3, .2)
    local radius = getDistance(myShip:windowPositionX(), myShip:windowPositionY(), x, y)
    local startAngle = myShip.dir
    gamestate.originalAngle = startAngle
    local endDir = getDir(myShip:windowPositionX(), myShip:windowPositionY(), x, y)
    local endAngle = startAngle + getAngleDiff(startAngle, endDir)

    love.graphics.setLineWidth(2)
    love.graphics.arc('line', myShip:windowPositionX(), myShip:windowPositionY(), radius, getRad(startAngle), getRad(endAngle))
    love.graphics.setColor(.2, .9, .4)
    love.graphics.line(myShip:windowPositionX(), myShip:windowPositionY(), x, y)
    love.graphics.circle('fill', x, y, 10)
    if x < myShip:windowPositionX() then
        love.graphics.print("Heading: " .. math.floor(endAngle), x-120, y - 10)
        love.graphics.print("Speed: " .. math.floor(getDistance(myShip:windowPositionX(), myShip:windowPositionY(), x, y) * 2) .. ' km/s', x-120, y + 10)
    else
        love.graphics.print("Heading: " .. math.floor(endAngle), x+20, y - 10)
        love.graphics.print("Speed: " .. math.floor(getDistance(myShip:windowPositionX(), myShip:windowPositionY(), x, y) * 2) .. ' km/s', x+20, y + 10)
    end

end

function drawOldNavigation()

    local radius = lastRadius
    local startAngle = myShip.dir
    local endAngle = gamestate.originalAngle + getAngleDiff(gamestate.originalAngle, myShip.targetDir)

    local newX = myShip:windowPositionX() + math.sin(math.rad(endAngle)) * radius;
    local newY = myShip:windowPositionY() - math.cos(math.rad(endAngle)) * radius;

    love.graphics.setLineWidth(2)
    love.graphics.setColor(.2, .1, .0)
    love.graphics.arc('line', myShip:windowPositionX(), myShip:windowPositionY(), radius, getRad(startAngle), getRad(endAngle))
    love.graphics.setColor(.05, .2, .1)
    love.graphics.line(myShip:windowPositionX(), myShip:windowPositionY(), newX, newY)
    love.graphics.circle('fill', newX, newY, 10)

end