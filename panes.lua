panes = {}

viewport = Pane:new()
table.insert(panes, viewport)
viewport.scale = true
viewport.z = -1
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

logPane = Pane:new(true, 70, 5, 95, 40, false)
function logPane:background()
	love.graphics.setColor(.2,.2,.3)
	love.graphics.rectangle('fill', self.x, self.y, self.xWidth, self.yWidth)
end
function logPane:draw()
	drawLogs()
end
logPane:setTitle("Debugging Logs")
table.insert(panes, logPane)

shieldPane = Pane:new(true, 0, 40, 7, 57, true)
shieldPane:setTitle("Shields")
table.insert(panes, shieldPane)
function shieldPane:background()
	love.graphics.setColor(.1, .05, .15)
	love.graphics.rectangle('fill', self.startX, self.startY, self.xWidth, self.yWidth)
end

function shieldPane:draw()
	love.graphics.setFont(logFont)
	love.graphics.setColor(1,1,1)
	for i=1,6 do
		self:print('Shield ' .. i .. ': ' .. myShip.shields[i] .. '%', 5, i * 20)
	end
end