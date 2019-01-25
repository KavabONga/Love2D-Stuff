Vector = require 'vector'

local time = 0

function vecPoint(a)
	love.graphics.points(a.x, a.y)
end

function vecLine(a, b)
	love.graphics.line(a.x, a.y, b.x, b.y)
end

function recursiveTriFractal(pos, side)
	if pos.x > love.graphics.getWidth() or pos.y > love.graphics.getHeight() then
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
	recursiveTriFractal(Vector(love.graphics.getWidth() / 4, love.graphics.getHeight() / 4), love.graphics.getWidth() * math.pow(1.5, time) / 2)
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
	recursiveTreeFractal(Vector(love.graphics.getWidth() / 2, love.graphics.getHeight()), love.graphics.getHeight() * 2 / 5, math.sin(time / 3) * math.pi / 2)
end

function recursiveAngFractal(pos, side, rotation)
	if pos.x > love.graphics.getWidth() + side * 3 or pos.y > love.graphics.getHeight() + side * 3 then
		return
	end
	rotation = rotation or 0
	local next1 = pos + Vector(side * 2, 0):rotated(rotation)
	local next2 = pos + Vector(side, 0):rotated(rotation)
	local next3 = pos + Vector(side * 3 / 2, -side * math.sqrt(3) / 2):rotated(rotation)
	local next4 = pos + Vector(2 * side, 0):rotated(rotation)
	if side >= 2 then
		recursiveAngFractal(pos, side / 3, rotation)
		recursiveAngFractal(next1, side / 3, rotation)
		recursiveAngFractal(next2, side / 3, rotation - math.pi / 3)
		recursiveAngFractal(next3, side / 3, rotation + math.pi / 3)
	else
		vecLine(pos, next1)
		vecLine(next1, next2)
		vecLine(next2, next3)
		vecLine(next3, next4)
	end
end

function drawAngFractal() 
	recursiveAngFractal(Vector(0, love.graphics.getHeight() * 2 / 3), love.graphics.getWidth() / 2 * math.pow(1.5, time), 0)
end

local fractals = {drawTriFractal, drawTreeFractal, drawAngFractal}

local fractalFunctionIndex = 1

function love.keypressed(key)
	if key == 'space' then
		fractalFunctionIndex = fractalFunctionIndex % #fractals + 1
		time = 0
	end
end

function love.load()
	time = 0
end

function love.update(dt)
	time = time + dt
end

function love.draw()
	fractals[fractalFunctionIndex]()
end