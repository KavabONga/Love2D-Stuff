-- Made by: Dmitry Shabat

-- Resource Lua files return list of drawing functions related to the shape

Vector = require 'vector'
-- width, height

function love.load()
	time = 0
	width, height = love.graphics.getWidth(), love.graphics.getHeight()
end

function vecPoint(a)
	love.graphics.points(a.x, a.y)
end

function vecLine(a, b)
	love.graphics.line(a.x, a.y, b.x, b.y)
end

-- function recursiveDraw(pos, side, )

local fractals = {
	require 'fractals.triangle', 
	require 'fractals.tree',
	require 'fractals.ang'
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