function cycle(dt)
    for k,v in pairs(objects) do
        if (v.move) then
            v:move(dt)
        end
    end

    if myShip.speed ~= myShip.targetSpeed then
        if myShip.speed < myShip.targetSpeed then
            myShip.speed = math.min(myShip.targetSpeed, myShip.speed + perCycle(500))
        else
            myShip.speed = math.max(myShip.targetSpeed, myShip.speed - perCycle(500))
        end
    end

    currDir = normalizeAngle(myShip.dir)
    targetDir = normalizeAngle(myShip.targetDir)

    diff = targetDir - currDir
    diff = (diff + 180) % 360 - 180

    if myShip.dir ~= myShip.targetDir then
        if diff > 0 then
            myShip.dir = myShip.dir + math.min(diff, perCycle(20))
        else
            myShip.dir = myShip.dir - math.min(math.abs(diff), perCycle(20))
        end
    end

    for k,v in pairs(objects) do
		if string.find(k, "enemy") then

            -- fire?
            if (math.random(50) == 1) then
                local dir = getDir(v.x, v.y, myShip.x, myShip.y)
                local torpedo = Torpedo:new(v.x, v.y, nil, dir, 5000)
				torpedo.shooter = v
				table.insert(objects, torpedo)
            end

			-- Some basic AI
			if not v.targetDir or v.dir == v.targetDir then
				v.targetDir = math.random(360)
				v.targetSpeed = math.random(1500) + 500
			else
				if v.speed ~= v.targetSpeed then
					if v.speed < v.targetSpeed then
						v.speed = math.min(v.targetSpeed, v.speed + perCycle(500))
					else
						v.speed = math.max(v.targetSpeed, v.speed - perCycle(500))
			
				v.targetDir = math.random(360)
				v.targetSpeed = math.random(1500) + 500		end
				end
			
				currDir = normalizeAngle(v.dir)
				targetDir = normalizeAngle(v.targetDir)
			
				diff = targetDir - currDir
				diff = (diff + 180) % 360 - 180
			
				if (math.abs(diff) < perCycle(20)) then
					v.dir = v.targetDir
				else
					if diff > 0 then
						v.dir = v.dir + math.min(diff, perCycle(20))
					else
						v.dir = v.dir - math.min(math.abs(diff), perCycle(20))
					end
				end
			end
		end
	end


end