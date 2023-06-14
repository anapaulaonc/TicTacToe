local winner = {
    image = nil
}

function winner:load(value)
    if value == "w" then
        self.image = love.graphics.newImage("sprites/WIN.png")
    end
    if value == "l" then
        self.image = love.graphics.newImage("sprites/LOSE.png")
    end
    
end

function winner:update()
end

function winner:draw()
    love.graphics.draw(self.image)
    
end

function winner:mousepressed()
end

return winner