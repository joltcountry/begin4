function love.mousemoved(x, y, dx, dy, istouch )
    if (love.mouse.isDown(3)) then
        viewport.centerX = viewport.centerX - dx * (gamestate.range / 1000)
        viewport.centerY = viewport.centerY - dy * (gamestate.range / 1000)
    end
end

function love.mousepressed(x, y, i)

	if (i == 1) then
		if (x < viewport.size and y < viewport.size) then
			local spread = 10
			local volley = 3
			local direction = getDir(myShip:windowPositionX(), myShip:windowPositionY(), x, y)
			local spacing = 0
			local xVel = getXVel(direction, 7000) + myShip:xVel();
			local yVel = getYVel(direction, 7000) + myShip:yVel();
			local vector = getVector(xVel, yVel);
			local start = direction
			if (volley > 1) then
				spacing = spread / (volley - 1)
				start = start - (spread / 2)
			end
			for i=0,volley-1 do
				local torpedo = Torpedo:new(myShip.x, myShip.y, nil, start + i * spacing, vector[2])
				torpedo.shooter = myShip
				table.insert(objects, torpedo)
			end
		end
    end
	:: done ::
	
end

function love.mousereleased( x, y, button, istouch, presses )
	if button == 2 and x < viewport.size and y < viewport.size then
		myShip.targetDir = getDir(myShip:windowPositionX(), myShip:windowPositionY(), x, y)
		myShip.targetSpeed = getDistance(myShip:windowPositionX(), myShip:windowPositionY(), x, y) * 2
		lastClickedX = x
		lastClickedY = y
		lastRadius = getDistance(myShip:windowPositionX(), myShip:windowPositionY(), x, y)
	end
end

function love.keypressed(key)
	log(key)
	if key == '`' then
		logs = {}
	elseif key == 'q' then
		os.exit()
	end
end

function love.wheelmoved(x, y)
	if (y > 0 and gamestate.range > 1000) or (y < 0 and gamestate.range < 100000) then
		gamestate.range = gamestate.range - (y * 1000 * gamestate.range / 10000)
		gamestate.scale = gamestate.scale + (y * (gamestate.scale * .02))
	end
end