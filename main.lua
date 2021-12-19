require 'objects'
require 'events'
require 'cycle'
require 'lib.utils'
require 'lib.logging'
require 'lib.drawing'
require 'panes'

function love.load()

	local shipImage = love.graphics.newImage( "img/ship.png" )
	local enemyImage = love.graphics.newImage( "img/enemy.png" )
	background = love.graphics.newImage('img/stars.jpg')

	math.randomseed(os.time())

	setWindow(1920,1080)
	love.window.setTitle('Begin 4')
	gamestate = { scale = 1, range = 30000, ringSpacing = 10000, cycles = 50, enemies = 3 }
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

	table.sort(panes, function(a,b) return a.z < b.z end)

	for k,v in pairs(panes) do
		v:render()
	end

	drawLogs()

	if gamestate.enemies == 0 then
		log("You won the game!  Yay?")
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