function love.mousemoved(x, y, dx, dy, istouch )
    if (love.mouse.isDown(3)) then
        viewport.centerX = viewport.centerX - dx * (gamestate.range / 1000)
        viewport.centerY = viewport.centerY - dy * (gamestate.range / 1000)
	elseif (love.mouse.isDown(1)) then
		for k,v in pairs(panes) do
			if v.movable and v.dragging then
				v.dragging = true
				v.startX = v.startX + dx
				v.startY = v.startY + dy
				v.endX = v.startX + v.xWidth
				v.endY = v.startY + v.yWidth
				-- legacy
				v.x = v.startX
				v.y = v.startY

			end
		end
    end
end

function love.mousepressed(x, y, i)

	if (i == 1) then
		if (viewport:isTopPane(x, y)) then
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
		else
			for k, v in pairs(panes) do
				if v.movable and x > v.startX and x < v.endX and y > v.startY and y < v.startY + barHeight then
					v.dragging = true
				end
			end
		end
    end
	:: done ::
	
end

function love.mousereleased( x, y, button, istouch, presses )
	for k,v in pairs(panes) do
		v.dragging = false
	end
	
	if button == 2 and viewport:within(x,y) then
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
		love.event.quit()
	elseif key == '=' then
		setWindow(love.graphics.getWidth() * 1.2, love.graphics.getHeight() * 1.2)
	elseif key == '-' then
		setWindow(love.graphics.getWidth() * .8, love.graphics.getHeight() * .8)
    elseif key == "f" then
		if love.window.getFullscreen() then
			love.window.setFullscreen(false);
			setWindow(gamestate.previousWindowWidth, gamestate.previousWindowHeight)
		else
			gamestate.previousWindowWidth = love.graphics.getWidth()
			gamestate.previousWindowHeight = love.graphics.getHeight()
			love.window.setFullscreen(true)
		end
		resetPanes()
	end
end

function love.wheelmoved(x, y)
	if (y > 0 and gamestate.range > 1000) or (y < 0 and gamestate.range < 100000) then
		gamestate.range = gamestate.range - (y * 1000 * gamestate.range / 10000)
		gamestate.scale = gamestate.scale + (y * (gamestate.scale * .02))
	end
end
