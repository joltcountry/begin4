require 'objects'
require 'lib.utils'
require 'lib.logging' 
require 'events'
require 'cycle'

function love.load()

	t = 0
	math.randomseed(os.time())

	love.window.setMode(1800,1400)
	love.window.setTitle('Begin 4')
	gamestate = { scale = 1, range = 30000, ringSpacing = 10000, cycles = 50, turn = 1, enemies = 3 }
	viewport = { x = 0, y = 0, size = 1400, centerX = 0, centerY = 0 }
	objects = {}
	
	gamestate.windowWidth = love.graphics.getWidth()
	gamestate.windowHeight = love.graphics.getHeight()
	gamestate.windowOriginX = -(viewport.size / 2)
	gamestate.windowOriginY = -(viewport.size / 2)

	image = love.graphics.newImage( "img/ship.png" )
	objects.myShip = Movable:new(0, 0, image)
	myShip = objects.myShip -- convenience
	myShip.targetDir = myShip.dir
	myShip.targetSpeed = myShip.speed

	myShip.shields = { 100, 100, 100, 100, 100, 100 }
	myShip.shieldsRaised = true

	enemyImage = love.graphics.newImage( "img/enemy.png" )
	for i=1, gamestate.enemies do
		local enemy = Movable:new(math.random() * 40000 - 20000, math.random() * 40000 - 20000, enemyImage, math.random(360), math.random(1500) + 500)
		enemy.shields = { 100, 100, 100, 100, 100, 100 }
		enemy.shieldsRaised = true
		objects['enemy' .. i] = enemy
	end

	background = love.graphics.newImage('img/stars.jpg')

end

function love.draw()

	local maxDimension = viewport.size

	love.graphics.setScissor(viewport.x, viewport.y, viewport.size, viewport.size)
	love.graphics.setColor(.2, .2, .4)
	love.graphics.draw(background, -1500 - (viewport.centerX/200), -1000 - (viewport.centerY/200));
	-- draw range rings
	love.graphics.setLineWidth(2)

	for ringDistance = gamestate.ringSpacing, 100000, gamestate.ringSpacing do
		local radius = ringDistance * maxDimension / gamestate.range / 2
		love.graphics.setColor(.3, .3, .4)
		love.graphics.print(ringDistance, myShip:windowPositionX() - 20, myShip:windowPositionY() - radius - 20)
		love.graphics.setColor(.1, .1, .2)
		love.graphics.circle('line', myShip:windowPositionX(), myShip:windowPositionY(), radius)
	end

	if love.mouse.isDown(2) then
		x, y = love.mouse.getPosition()
		if x < viewport.size and y < viewport.size then
			love.graphics.setLineWidth(3)
			x, y = love.mouse.getPosition()
			love.graphics.setColor(.5, .3, .2)
			local radius = getDistance(myShip:windowPositionX(), myShip:windowPositionY(), x, y)
			local startAngle = myShip.dir
			local endAngle = getDir(myShip:windowPositionX(), myShip:windowPositionY(), x, y)
			if endAngle < 0 then
				endAngle = endAngle + 360
			end
			if math.abs(startAngle - endAngle) > 180 then
				startAngle = startAngle + 360
			end

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
	end

	if normalizeAngle(myShip.targetDir) ~= normalizeAngle(myShip.dir) then
		local radius = lastRadius
		local startAngle = myShip.dir
		local endAngle = myShip.targetDir
		if endAngle < 0 then
			endAngle = endAngle + 360
		end
		if math.abs(startAngle - endAngle) > 180 then
			startAngle = startAngle + 360
		end

		local newX = myShip:windowPositionX() + math.sin(math.rad(endAngle)) * radius;
		local newY = myShip:windowPositionY() - math.cos(math.rad(endAngle)) * radius;

		love.graphics.setLineWidth(2)
		love.graphics.setColor(.2, .1, .0)
		love.graphics.arc('line', myShip:windowPositionX(), myShip:windowPositionY(), radius, getRad(startAngle), getRad(endAngle))
		love.graphics.setColor(.05, .2, .1)
		love.graphics.line(myShip:windowPositionX(), myShip:windowPositionY(), newX, newY)
		love.graphics.circle('fill', newX, newY, 10)
	end

	love.graphics.setColor(1,1,1);
	
	for k,v in pairs(objects) do
		v:draw()
	end

	-- Draw shields

	if (myShip.shieldsRaised) then
		drawShields(myShip)
	end

--	if (love.keyboard.isDown('lalt')) then
		for k,v in pairs(objects) do
			if string.find(k, 'enemy') then
				if v.shieldsRaised then
					drawShields(v)
				end
			end
		end
--	end

	-----

	love.graphics.setScissor()

	love.graphics.setColor(1,1,1);

	love.graphics.print("Zoom: " .. math.floor(gamestate.range) .. 'km', viewport.size - 100, viewport.size - 20)

	drawLogs()

	love.graphics.setColor(.6, .6, .6)
	love.graphics.print("LMB: shoot, RMB: navigate, MMB: drag map, Wheel: zoom, Space: GO!, q: quit, `: reset logs", 20, 1350);
	if (gamestate.enemies == 0) then
		love.graphics.setColor(math.random(), math.random(), math.random())
		love.graphics.print("YOU WON DA GAME!", 650 + math.random() * 100 - 50, 700 + math.random() * 100 - 50);
	end

end

function love.update( dt )

	if not gamestate.dead then 
		t = t + dt

		if (love.keyboard.isDown('space') and t > 1 / gamestate.cycles) then
			cycle()
			t = 0
		end

		track("Ship speed", myShip.speed .. " km/s")
		track("Ship heading", myShip.dir)
		track("Enemies", gamestate.enemies)

		if love.mouse.isDown(2) then
			myShip.targetDir = myShip.dir
			myShip.targetSpeed = myShip.speed
		end

		for k,v in pairs(objects) do
			v:update(dt)
		end
	end
end



