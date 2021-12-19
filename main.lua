require 'objects'
require 'events'
require 'cycle'
require 'lib.utils'
require 'lib.logging'
require 'lib.drawing'

function love.load()

	local shipImage = love.graphics.newImage( "img/ship.png" )
	local enemyImage = love.graphics.newImage( "img/enemy.png" )
	background = love.graphics.newImage('img/stars.jpg')

	math.randomseed(os.time())

	love.window.setMode(1800,1400)
	love.window.setTitle('Begin 4')
	gamestate = { scale = 1, range = 30000, ringSpacing = 10000, cycles = 50, enemies = 3 }
	viewport = { x = 0, y = 0, size = 1400, centerX = 0, centerY = 0 }
	objects = {}
	
	gamestate.windowWidth = love.graphics.getWidth()
	gamestate.windowHeight = love.graphics.getHeight()
	gamestate.windowOriginX = -(viewport.size / 2)
	gamestate.windowOriginY = -(viewport.size / 2)

	objects.myShip = Movable:new(0, 0, shipImage)
	myShip = objects.myShip -- convenience
	myShip.targetDir = myShip.dir
	myShip.targetSpeed = myShip.speed

	myShip.shields = { 100, 100, 100, 100, 100, 100 }
	myShip.shieldsRaised = true

	for i=1, gamestate.enemies do
		local enemy = Enemy:new(math.random() * 40000 - 20000, math.random() * 40000 - 20000, enemyImage, math.random(360), math.random(1500) + 500)
		enemy.shields = { 100, 100, 100, 100, 100, 100 }
		enemy.shieldsRaised = true
		objects['enemy' .. i] = enemy
	end

	cycleTimer = 0

end

function love.draw()

	love.graphics.setScissor(viewport.x, viewport.y, viewport.size, viewport.size)
	love.graphics.setColor(.2, .2, .4)
	love.graphics.draw(background, -1500 - (viewport.centerX/200), -1000 - (viewport.centerY/200));

	drawRangeRings()

	-- Draw navigation lines

	if love.mouse.isDown(2) then -- right mouse button
		x, y = love.mouse.getPosition()
		if x < viewport.size and y < viewport.size then
			drawNewNavigation(x, y)
		end
	end

	if normalizeAngle(myShip.targetDir) ~= normalizeAngle(myShip.dir) then
		drawOldNavigation()
	end

	for k,v in pairs(objects) do
		v:draw()
	end

	-- Draw shields

	if (myShip.shieldsRaised) then
		drawShields(myShip)
	end

	for k,v in pairs(objects) do
		if string.find(k, 'enemy') then
			if v.shieldsRaised then
				drawShields(v)
			end
		end
	end

	-- Draw random crap to be removed/replaced

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

		cycleTimer = cycleTimer + dt

		if (love.keyboard.isDown('space') and cycleTimer > perCycle(1)) then
			cycle()
			cycleTimer = 0
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