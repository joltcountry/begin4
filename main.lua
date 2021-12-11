require 'objects'

logs = {}
trackers = {}
function log(s)
	table.insert(logs, s)
end

function track(k, s)
	trackers[k] = s 
end

function drawLogs()

	love.graphics.setColor(.5, .5, 1);
	local pos = 0
	for k,v in pairs(trackers) do
		love.graphics.print(k .. ': ' .. v, gamestate.windowWidth - 300, pos * 20)
		pos = pos + 1
	end
	for i,v in ipairs(logs) do
		love.graphics.print(v, gamestate.windowWidth - 300, i * 20)
		pos = pos + 1
	end

end

function love.load()
log('loading')
	love.window.setMode(1500,1200)
	love.window.setTitle('Fuck Tom Nelson!  No, sorry, that was mean.')
	gamestate = { scale = 1, range = 30000, ringSpacing = 5000 }
	objects = {}

	gamestate.windowWidth = love.graphics.getWidth()
	gamestate.windowHeight = love.graphics.getHeight()
	gamestate.windowOriginX = -(gamestate.windowWidth / 2)
	gamestate.windowOriginY = -(gamestate.windowHeight / 2)

	image = love.graphics.newImage( "ship.png" )
	objects.myShip = Movable:new(0, 0, image, 90, 1000)
	myShip = objects.myShip -- convenience

	love.graphics.setBackgroundColor(.3,.3,.5);

end

function love.draw()

	local maxDimension = math.max(gamestate.windowWidth, gamestate.windowHeight)

	-- draw range rings
	love.graphics.setColor(.9, .7, .8)

	for ringDistance = gamestate.ringSpacing, gamestate.range, gamestate.ringSpacing do
		local radius = ringDistance * maxDimension / gamestate.range / 2
		love.graphics.print(ringDistance, myShip:windowPositionX() - 20, myShip:windowPositionY() - radius - 20)
		love.graphics.circle('line', myShip:windowPositionX(), myShip:windowPositionY(), radius)
	end

	if love.mouse.isDown(1) then
		love.graphics.setLineWidth(3)
		x, y = love.mouse.getPosition()
		love.graphics.setColor(.9, .2, .2)
		love.graphics.line(x, y, myShip:windowPositionX(), myShip:windowPositionY())
		love.graphics.circle('fill', x, y, 10);
		love.graphics.setLineWidth(1)
	end

	love.graphics.setColor(1,1,1);
	for k,v in pairs(objects) do
		v:draw()
	end

	love.graphics.print("Range: " .. gamestate.range, 1400, 1180)

	drawLogs()

end

function love.update( dt )

	track("Ship speed", myShip.speed .. " km/s")
	if love.mouse.isDown(1) then
		x, y = love.mouse.getPosition()
		myShip:setDirection(math.deg(math.atan2(myShip:windowPositionY() - y, myShip:windowPositionX() - x)) - 90)
		local dx = myShip:windowPositionX() - x
		local dy = myShip:windowPositionY() - y
		myShip:setSpeed(math.sqrt ( dx * dx + dy * dy ) * gamestate.range/1000)
	end
	
	for k,v in pairs(objects) do
		if (v.move) then
			v:move(dt)
		end
	end
end

function love.mousepressed(x, y, i)
	if (i == 2) then
		logs = {}
	end
end

function love.wheelmoved(x, y)
	log("Wheel moved: " .. y)
	if (y > 0 and gamestate.range > 1000) or (y < 0 and gamestate.range < 100000) then
		gamestate.range = gamestate.range - (y * 1000)
	end
end

