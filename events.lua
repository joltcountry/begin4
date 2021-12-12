function love.mousemoved(x, y, dx, dy, istouch )
    if (love.mouse.isDown(3)) then
        viewport.centerX = viewport.centerX - dx * 10
        viewport.centerY = viewport.centerY - dy * 10
    end
end

function love.mousepressed(x, y, i)

	if cycling == 0 then
		if (i == 1) then
			for k, v in pairs(buttons) do
				if x > v.x and x < v.x + v.width and y > v.y and y < v.y + 30 then
					takeTurn()
					goto done
				end
			end
			if (x < viewport.size and y < viewport.size) then
				local spread = 10
				local volley = 1
				local direction = getDir(myShip:windowPositionX(), myShip:windowPositionY(), x, y)
				local start = direction
				local spacing = 0
				if (volley > 1) then
					spacing = spread / (volley - 1)
					start = start - (spread / 2)
				end
				for i=0,volley-1 do
					log(spacing)
					local torpedo = Torpedo:new(myShip.x, myShip.y, nil, start + i * spacing, 8000)
					table.insert(objects, torpedo)
				end
				takeTurn()
			end
		end
	end
	:: done ::
end

function love.mousereleased( x, y, button, istouch, presses )
    if cycling == 0 then
        if button == 2 and x < viewport.size and y < viewport.size then
            myShip.targetDir = getDir(myShip:windowPositionX(), myShip:windowPositionY(), x, y)
            myShip.targetSpeed = getDistance(myShip:windowPositionX(), myShip:windowPositionY(), x, y) * 2
            lastClickedX = x
            lastClickedY = y
            lastRadius = getDistance(myShip:windowPositionX(), myShip:windowPositionY(), x, y)
        end
    end
end

function love.keypressed(key)
	if key == '`' then
		logs = {}
	elseif key == 'q' then
		os.exit()
	elseif key == 'space' then
		takeTurn()
	end
end

function love.wheelmoved(x, y)
	log("Wheel moved: " .. y)
	if (y > 0 and gamestate.range > 1000) or (y < 0 and gamestate.range < 100000) then
		gamestate.range = gamestate.range - (y * 1000)
		gamestate.scale = gamestate.scale + (y * (gamestate.scale * .02))
	end
end