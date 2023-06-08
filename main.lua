GAME = require "game"

local background = nil
function love.load()

    SCREENWIDTH = love.graphics.getWidth()  
    SCREENHEIGHT = love.graphics.getHeight()

    background = love.graphics.newImage("sprites/tab.png")


    GAME:load()
end

function love.update(dt)
    GAME:update(dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.setColor(0,0,0,.1)
    love.graphics.rectangle('fill', 0, 0, SCREENWIDTH, SCREENHEIGHT)
    love.graphics.setColor(1,1,1,1)
    GAME:draw()
end

function love.mousepressed(x,y, button)
    GAME:mousepressed(x,y, button)
end