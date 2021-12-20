panes = {}

viewport = Pane:new()
panes['viewport'] = viewport

-- legacy
viewport.centerX = 0
viewport.centerY = 0

function viewport:background()
    love.graphics.setColor(.2, .2, .4)
	love.graphics.draw(background, -500 - (viewport.centerX/200), -500 - (viewport.centerY/200));
end

function viewport:draw()

	drawRangeRings()

	-- Draw navigation lines

	if love.mouse.isDown(2) then -- right mouse button
		x, y = love.mouse.getPosition()

		if self:within(x, y) then
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

end

function viewport:update()
	if love.mouse.isDown(2) then
		x, y = love.mouse.getPosition()
		if self:within(x, y) then
			myShip.targetDir = myShip.dir
			myShip.targetSpeed = myShip.speed
		end
	end
end

logPane = Pane:new(true, 70, 5, 95, 40, 100)
function logPane:background()
	love.graphics.setColor(.2,.2,.3)
	love.graphics.rectangle('fill', self.x, self.y, self.xWidth, self.yWidth)
end

logPane:setTitle("Debugging Logs")

panes['logPane'] = logPane;