Vector = require 'vector'

local time
width, height = love.graphics.getWidth(), love.graphics.getHeight()

function love.load()
	time = 0
	-- width, height = love.graphics.getWidth(), love.graphics.getHeight()
end

function vecPoint(a)
	love.graphics.points(a.x, a.y)
end

function vecLine(a, b)
	love.graphics.line(a.x, a.y, b.x, b.y)
end

function recursiveTriFractal(pos, side)
	if pos.x > width or pos.y > height then
		return
	end
	if side < 1 then
		vecPoint(pos)
	else
		recursiveTriFractal(pos + Vector(side / 4, side * math.sqrt(3) / 4), side / 2)
		recursiveTriFractal(pos + Vector(side / 2, 0), side / 2)
		recursiveTriFractal(pos, side / 2)
	end
end

function drawTriFractal()
	recursiveTriFractal(Vector(width / 4, height / 4), width * math.pow(1.5, time) / 2)
end

function recursiveTreeFractal(pos, side, angle, rotation)
	rotation = rotation or 0
	if side < 1 then
		return
	else 
		local left, right = pos + Vector(-math.sin(angle) * side, -math.cos(angle) * side):rotated(rotation), pos + Vector(math.sin(angle) * side, -math.cos(angle) * side):rotated(rotation)
		vecLine(pos, left)
		vecLine(pos, right)
		recursiveTreeFractal(left, side * 3 / 5, angle, rotation - angle)
		recursiveTreeFractal(right, side * 3 / 5, angle, rotation + angle)
	end
end
function drawTreeFractal()
	recursiveTreeFractal(Vector(width / 2, height), height * 2 / 5, math.sin(time / 3) * math.pi / 2)
end

function recursiveAngFractal(pos, side, rotation)
	if pos.x > width + side * 3 or pos.y > height + side * 3 then
		return
	end
	rotation = rotation or 0
	local next1 = pos + Vector(side, 0):rotated(rotation)
	local next2 = pos + Vector(side * 3 / 2, -side * math.sqrt(3) / 2):rotated(rotation)
	local next3 = pos + Vector(side * 2, 0):rotated(rotation)
	local next4 = pos + Vector(side * 3, 0):rotated(rotation)
	if side >= 2 then
		recursiveAngFractal(pos, side / 3, rotation)
		recursiveAngFractal(next1, side / 3, rotation - math.pi / 3)
		recursiveAngFractal(next2, side / 3, rotation + math.pi / 3)
		recursiveAngFractal(next3, side / 3, rotation)
	else
		vecLine(pos, next1)
		vecLine(next1, next2)
		vecLine(next2, next3)
		vecLine(next3, next4)
	end
end

function drawAngFractal() 
	recursiveAngFractal(Vector(0, height * 2 / 3), width / 2 * math.pow(1.5, time), 0)
end

function recursiveAnimateAng(pos, side, k, rotation)
	rotation = rotation or 0
	local next1 = pos + Vector(side, 0):rotated(rotation)
	local next2 = pos + Vector(side * 3 / 2, -side * math.sqrt(3) / 2):rotated(rotation)
	local next3 = pos + Vector(side * 2, 0):rotated(rotation)
	local next4 = pos + Vector(side * 3, 0):rotated(rotation)
	if k < 1 then
		vecLine(pos, next1)
		vecLine(next3, next4)
		if k < 0.5 then
			vecLine(next1, next1 + (next2 - next1) * k * 2)
		else
			vecLine(next1, next2)
			vecLine(next2, next2 + (next3 - next2) * (2 * k - 1))
		end
		vecLine(next1 + (next3 - next1) * k, next3)
	else
		recursiveAnimateAng(pos, side / 3, k - 1, rotation)
		recursiveAnimateAng(next1, side / 3, k - 1, rotation - math.pi / 3)
		recursiveAnimateAng(next2, side / 3, k - 1, rotation + math.pi / 3)
		recursiveAnimateAng(next3, side / 3, k - 1, rotation)
	end
end

function animateAng()
	recursiveAnimateAng(Vector(0, height * 2 / 3), width / 3, math.abs((time + 7) % 15 - 7))
end

function recursiveAnimateTri(pos, side, k)
	local a1, a2, a3 = pos + Vector(side / 4, -side * math.sqrt(3) / 4), pos + Vector(side * 3 / 4, -side * math.sqrt(3) / 4), pos + Vector(side / 2, 0)
	if k > 1 then
		vecLine(a1, a2)
		vecLine(a2, a3)
		vecLine(a3, a1)
		recursiveAnimateTri(pos, side / 2, k - 1)
		recursiveAnimateTri(a1, side / 2, k - 1)
		recursiveAnimateTri(a3, side / 2, k - 1)
	else
		vecLine(a1, a1 + (a2 - a1) * k)
		vecLine(a2, a2 + (a3 - a2) * k)
		vecLine(a3, a3 + (a1 - a3) * k)
	end
end

function animateTri()
	recursiveAnimateTri(Vector(width / 8, height * 7 / 8), width * 3 / 4, math.abs((time + 8) % 17 - 8))
end

local fractals = {
	{drawTriFractal, animateTri}, 
	{drawTreeFractal}, 
	{drawAngFractal, animateAng}
}

local fractalIndex, fractalSubIndex = 1, 1

function love.keypressed(key)
	if key == 'down' then
		fractalIndex = fractalIndex % #fractals + 1
		fractalSubIndex = 1
		time = 0
	end
	if key == 'up' then
		fractalIndex = (fractalIndex - 2) % #fractals + 1
		fractalSubIndex = 1
		time = 0
	end
	if key == 'left' then
		fractalSubIndex = (fractalSubIndex - 2) % #fractals[fractalIndex] + 1
		time = 0
	end
	if key == 'right' then
		fractalSubIndex = fractalSubIndex % #fractals[fractalIndex] + 1
		time = 0
	end
	if key == 'escape' then
		love.event.quit()
	end
end

function love.load()
	time = 0
end

function love.update(dt)
	time = time + dt
end

function love.wheelmoved(x, y)
	time = time + y / 10
end

function love.draw()
	love.graphics.setColor(0.98, 0.2, 0.114, 1)
	love.graphics.print(time, 0, 0)
	love.graphics.setColor(1, 1, 1, 1)
	fractals[fractalIndex][fractalSubIndex]()
	local rowy = height - 10
	for row = #fractals, 1, -1 do
		colx = 10
		for col = 1, #fractals[row] do
			if row == fractalIndex and col == fractalSubIndex then
				love.graphics.setColor(0, 1, 0, 1)
			else
				love.graphics.setColor(0, 0, 1, 1)
			end
			love.graphics.rectangle('fill', colx, rowy - 10, 10, 10)
			love.graphics.setColor(1, 1, 1, 1)
			colx = colx + 15
		end
		rowy = rowy - 15
	end
end