function normalizeAngle(a)
    repeat
        if a < 0 then
            a = a + 360
        end
    until a >= 0
    return math.floor(a)
end

function cycle() 
    for k,v in pairs(objects) do
        if (v.move) then
            v:move(dt)
        end
    end
    cycling = cycling - 1
    if myShip.speed ~= myShip.targetSpeed then
        if myShip.speed < myShip.targetSpeed then
            myShip.speed = math.min(myShip.targetSpeed, myShip.speed + 500/gamestate.cycles)
        else
            myShip.speed = math.max(myShip.targetSpeed, myShip.speed - 500/gamestate.cycles)
        end
    end

    currDir = normalizeAngle(myShip.dir)
    targetDir = normalizeAngle(myShip.targetDir)

    diff = targetDir - currDir
    diff = (diff + 180) % 360 - 180

    if myShip.dir ~= myShip.targetDir then
        if diff > 0 then
            log('mydir is less than target')
            myShip.dir = myShip.dir + math.min(diff, 20/gamestate.cycles)
        else
            log('mydir is more than target')
            myShip.dir = myShip.dir - math.min(math.abs(diff), 20/gamestate.cycles)
        end
    end

end