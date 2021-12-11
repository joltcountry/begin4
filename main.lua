require 'objects'

logs = {}
trackers = {}

buttons = {
	nextturn = {
		x=1500,y=1300,
		label = "End Turn",
		width = 200
	}
}

function log(s)
	table.insert(logs, s)
end

function track(k, s)
	trackers[k] = s 
end

function drawLogs()

	love.graphics.setColor(.3, .3, .9);
	local pos = 0
	for k,v in pairs(trackers) do
		love.graphics.print(k .. ': ' .. v, viewport.size + 10, pos * 20)
		pos = pos + 1
	end
	for i,v in ipairs(logs) do
		love.graphics.print(v, viewport.size + 10, pos * 20)
		pos = pos + 1
	end

end

cycling = 0

function love.load()
log('loading')
	love.window.setMode(1800,1400)
	love.window.setTitle('Fuck Tom Nelson!  No, sorry, that was mean.')
	gamestate = { scale = 1, range = 30000, ringSpacing = 10000, cycles = 100 }
	viewport = { x = 0, y = 0, size = 1400, centerX = 0, centerY = 0 }
	objects = {}
	
	gamestate.windowWidth = love.graphics.getWidth()
	gamestate.windowHeight = love.graphics.getHeight()
	gamestate.windowOriginX = -(viewport.size / 2)
	gamestate.windowOriginY = -(viewport.size / 2)

	image = love.graphics.newImage( "ship.png" )
	objects.myShip = Movable:new(0, 0, image)
	myShip = objects.myShip -- convenience

	enemyImage = love.graphics.newImage( "enemy.png" )
	objects.enemy = Movable:new(-10000, -5000, enemyImage, 135, 500)

	background = love.graphics.newImage('stars.jpg')

end

function love.draw()

	local maxDimension = viewport.size

	love.graphics.setScissor(viewport.x, viewport.y, viewport.size, viewport.size)
	love.graphics.setColor(.3, .3, .3)
	love.graphics.draw(background, -1500 - (viewport.centerX/200), -1000 - (viewport.centerY/200));
	-- draw range rings
	love.graphics.setColor(.4, .3, .4)

	for ringDistance = gamestate.ringSpacing, gamestate.range * 2, gamestate.ringSpacing do
		local radius = ringDistance * maxDimension / gamestate.range / 2
		love.graphics.print(ringDistance, myShip:windowPositionX() - 20, myShip:windowPositionY() - radius - 20)
		love.graphics.circle('line', myShip:windowPositionX(), myShip:windowPositionY(), radius)
	end

	if love.mouse.isDown(1) then
		x, y = love.mouse.getPosition()
		if x < viewport.size and y < viewport.size then
			love.graphics.setLineWidth(3)
			x, y = love.mouse.getPosition()
			love.graphics.setColor(.9, .2, .2)
			love.graphics.line(x, y, myShip:windowPositionX(), myShip:windowPositionY())
			love.graphics.circle('fill', x, y, 10);
			love.graphics.setLineWidth(1)
		end
	end

	love.graphics.setColor(1,1,1);
	for k,v in pairs(objects) do
		track(k, v.x .. '.' .. v.y)
		v:draw()
	end

	love.graphics.setScissor()

	love.graphics.print("Range: " .. gamestate.range, viewport.size - 100, viewport.size - 20)

	for k, v in pairs(buttons) do
		love.graphics.rectangle('line', v.x, v.y, v.width, 30)
		love.graphics.print(v.label, v.x + 30, v.y + 10)
	end

	if (cycling > 0) then
		love.graphics.print('Processing turn...', 650, 1300)
	end
	drawLogs()

end

function love.update( dt )

	track("Ship speed", myShip.speed .. " km/s")
	if cycling == 0 then
		if love.mouse.isDown(1) then
			x, y = love.mouse.getPosition()
			if x < viewport.size and y < viewport.size then
				myShip:setDirection(math.deg(math.atan2(myShip:windowPositionY() - y, myShip:windowPositionX() - x)) - 90)
				local dx = myShip:windowPositionX() - x
				local dy = myShip:windowPositionY() - y
				myShip:setSpeed(math.sqrt ( dx * dx + dy * dy ))
			end
		end
	else
		for k,v in pairs(objects) do
			if (v.move) then
				v:move(dt)
			end
		end
		cycling = cycling - 1
	end

	objects.enemy:setDirection(math.deg(math.atan2(objects.enemy:windowPositionY() - myShip:windowPositionY(), objects.enemy:windowPositionX() - myShip:windowPositionX())) - 90)

end

function love.mousemoved(x, y, dx, dy, istouch )
    if (love.mouse.isDown(3)) then
        viewport.centerX = viewport.centerX - dx * 10
        viewport.centerY = viewport.centerY - dy * 10
    end
end

function love.mousepressed(x, y, i)

	if (i == 1) then
		for k, v in pairs(buttons) do
			if x > v.x and x < v.x + v.width and y > v.y and y < v.y + 30 then
				log('you pressed ' .. v.label);
				cycling = gamestate.cycles
			end
		end
	end

	if (i == 2) then
		logs = {}
	end
end

function love.wheelmoved(x, y)
	log("Wheel moved: " .. y)
	if (y > 0 and gamestate.range > 1000) or (y < 0 and gamestate.range < 100000) then
		gamestate.range = gamestate.range - (y * 1000)
		gamestate.scale = gamestate.scale + (y * (gamestate.scale * .02))
	end
end

