require 'objects'
require 'utils'
require 'logging' 
require 'events'
require 'cycle'

buttons = {
	nextturn = {
		x=1500,y=1300,
		label = "End Turn",
		width = 200
	}
}

function takeTurn()
	if cycling == 0 then
		for k,v in pairs(objects) do
			v:turn()
		end
		cycling = gamestate.cycles
		gamestate.turn = gamestate.turn + 1
	end
end

function love.load()

	cycling = 0
	t = 0
	math.randomseed(os.time())

	love.window.setMode(1800,1400)
	love.window.setTitle('Begin 4')
	gamestate = { scale = 1, range = 30000, ringSpacing = 10000, cycles = 20, turn = 1, enemies = 10 }
	viewport = { x = 0, y = 0, size = 1400, centerX = 0, centerY = 0 }
	objects = {}
	
	gamestate.windowWidth = love.graphics.getWidth()
	gamestate.windowHeight = love.graphics.getHeight()
	gamestate.windowOriginX = -(viewport.size / 2)
	gamestate.windowOriginY = -(viewport.size / 2)

	image = love.graphics.newImage( "ship.png" )
	objects.myShip = Movable:new(0, 0, image)
	myShip = objects.myShip -- convenience
	myShip.targetDir = myShip.dir
	myShip.targetSpeed = myShip.speed

	myShip.shields = { 10, 100, 0, 50, 100, 100 }
	myShip.shieldsRaised = true

	enemyImage = love.graphics.newImage( "enemy.png" )
	for i=1, gamestate.enemies do
		objects['enemy' .. i] = Movable:new(math.random() * 100000 - 50000, math.random() * 100000 - 50000, enemyImage, 0, 1000)
		objects['enemy' .. i].shields = { 100, 100, 100, 100, 100, 100 }
		objects['enemy' .. i].shieldsRaised = true
	end

	background = love.graphics.newImage('stars.jpg')

end

function love.draw()

	local maxDimension = viewport.size

	love.graphics.setScissor(viewport.x, viewport.y, viewport.size, viewport.size)
	love.graphics.setColor(.3, .3, .3)
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

	if cycling == 0 and love.mouse.isDown(2) then
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
		for shield, strength in ipairs(myShip.shields) do
			local arcStart = myShip.dir + ((shield-1) * 60) - 25;
			local arcEnd = myShip.dir + ((shield-1) * 60) + 25;
			if (strength > 0) then
				love.graphics.setColor(1 - 1 * strength/100,1 * strength/100 ,0)
				drawArc(myShip:windowPositionX(), myShip:windowPositionY(), 50 * gamestate.scale * .75, arcStart, arcEnd)
			end
		end
	end

	if (love.keyboard.isDown('lalt')) then
		for k,v in pairs(objects) do
			if string.find(k, 'enemy') then
				for shield, strength in ipairs(v.shields) do
					local arcStart = v.dir + ((shield-1) * 60) - 25;
					local arcEnd = v.dir + ((shield-1) * 60) + 25;
					if (strength > 0) then
						love.graphics.setColor(1 - 1 * strength/100,1 * strength/100 ,0)
						drawArc(v:windowPositionX(), v:windowPositionY(), 50 * gamestate.scale * .75, arcStart, arcEnd)
					end
				end
			end
		end
	end

	-----

	love.graphics.setScissor()

	love.graphics.setColor(1,1,1);
	love.graphics.print("Turn " .. gamestate.turn, 690, 10)

	love.graphics.print("Zoom: " .. math.floor(gamestate.range) .. 'km', viewport.size - 100, viewport.size - 20)

	for k, v in pairs(buttons) do
		love.graphics.rectangle('line', v.x, v.y, v.width, 30)
		love.graphics.print(v.label, v.x + 30, v.y + 10)
	end

	if (cycling > 0) then
		love.graphics.print('Processing turn...', 650, 1300)
	end
	drawLogs()

	love.graphics.setColor(.6, .6, .6)
	love.graphics.print("LMB: shoot, RMB: navigate, MMB: drag map, Wheel: zoom, Space: next turn, q: quit, `: reset logs", 20, 1350);
	if (gamestate.enemies == 0) then
		love.graphics.setColor(math.random(), math.random(), math.random())
		love.graphics.print("YOU WON DA GAME!", 650 + math.random() * 100 - 50, 700 + math.random() * 100 - 50);
	end

end

function love.update( dt )

	t = t + dt

	if (cycling > 0 and t > 1 / gamestate.cycles) then
		cycle()
		t = 0
	end

	track("Ship speed", myShip.speed .. " km/s")
	track("Ship heading", myShip.dir)
	track("Enemies", gamestate.enemies)

	if cycling == 0 and love.mouse.isDown(2) then
		myShip.targetDir = myShip.dir
		myShip.targetSpeed = myShip.speed
	end

	for k,v in pairs(objects) do
		v:update(dt)
	end

	for k,v in pairs(objects) do
		if string.find(k, "enemy") then
			v:setDirection(math.deg(math.atan2(v:windowPositionY() - myShip:windowPositionY(), v:windowPositionX() - myShip:windowPositionX())) - 90)
		end
	end

end



