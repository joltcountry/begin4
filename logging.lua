logs = {}
trackers = {}

function log(s)
	table.insert(logs, s)
end

function track(k, s)
	trackers[k] = s 
end

function drawLogs()

	love.graphics.setColor(.3, .3, .9);
	local pos = 0
	for k,v in pairs(trackers) do
		love.graphics.print(k .. ': ' .. v, viewport.size + 10, pos * 20)
		pos = pos + 1
	end
	for i,v in ipairs(logs) do
		love.graphics.print(v, viewport.size + 10, pos * 20)
		pos = pos + 1
	end

end

