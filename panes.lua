panes = {}

viewport = Pane:new(3, 10, 75, 90)
table.insert(panes, viewport)

-- legacy
viewport.centerX = 0
viewport.centerY = 0

function viewport:background()
    love.graphics.setColor(.2, .2, .4)
	love.graphics.draw(background, -1500 - (viewport.centerX/200), -1000 - (viewport.centerY/200));
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

    love.graphics.setColor(1, .8, 0);
    love.graphics.rectangle('line', self.startX, self.startY, self.xWidth - love.graphics.getLineWidth(), self.yWidth - love.graphics.getLineWidth());

end

logPane = Pane:new(70, 5, 95, 40, 100)

table.insert(panes, logPane);