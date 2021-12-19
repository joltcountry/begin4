function cycle()

    for k,v in pairs(objects) do
        if (v.move) then
            v:move()
        end
        if (v.ai) then
            v:ai()
        end
    end

    --- Match ship to navigation
    
    if myShip.speed ~= myShip.targetSpeed then
        if myShip.speed < myShip.targetSpeed then
            myShip.speed = math.min(myShip.targetSpeed, myShip.speed + perCycle(500))
        else
            myShip.speed = math.max(myShip.targetSpeed, myShip.speed - perCycle(500))
        end
    end

    local diff = getAngleDiff(myShip.dir, myShip.targetDir)

    if myShip.dir ~= myShip.targetDir then
        if diff > 0 then
            myShip.dir = myShip.dir + math.min(diff, perCycle(20))
        else
            myShip.dir = myShip.dir - math.min(math.abs(diff), perCycle(20))
        end
    end

end