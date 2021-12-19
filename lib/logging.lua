logs = {}
trackers = {}

function log(s)
	table.insert(logs, s)
end

function track(k, s)
	trackers[k] = s 
end

function drawLogs()

	love.graphics.setFont(logFont)
	love.graphics.setColor(.7, .7, .9);
	local pos = 0
	for k,v in pairs(trackers) do
		logPane:print(k .. ': ' .. tostring(v), 5, 5 + pos * 20)
		pos = pos + 1
	end
	for i,v in ipairs(logs) do
		logPane:print(v, 5, 5 + pos * 20)
		pos = pos + 1
	end

end

