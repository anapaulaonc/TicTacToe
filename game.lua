local game = {
    ox, oy = 0, 0,
    grid = {},
    width = 3,
    height = 3,
    tilesize = 99,
    players = {
        [1] = nil,
        [2] = nil
    },
    pawns = {
        [1] = nil,
        [2] = nil
    },

}

function game:reset()
    self.grid = {}
    love.math.setRandomSeed(love.timer.getTime())
    local n = love.math.random(1, 2)

    if n == 1 then
        self.players[1] = self.pawns[1]
        self.players[2] = self.pawns[2]
    else    
        self.players[1] = self.pawns[2]
        self.players[2] = self.pawns[1]
    end

    for c = 1, self.height do
        self.grid[c] = {}
        for r = 1, self.width do
           self.grid[c][r] = 0
           -- dependendo se botar 0, 1 ou 2 fica nada, x ou o respectivamente
        end 
    end   
end     


function game:load()
    self.ox = SCREENWIDTH / 2 - (self.width * self.tilesize) / 2
    self.oy = SCREENHEIGHT / 2 - (self.height * self.tilesize) / 2
    self.pawns[1] = love.graphics.newImage("sprites/x.png")
    self.pawns[2] = love.graphics.newImage("sprites/o.png")

    game:reset()
end

function game:update(dt)
end

function game:draw()

    local dx, dy = self.ox, self.oy
    for c = 1, self.height do
        dx = self.ox
        for r = 1, self.width do
            love.graphics.rectangle('line', dx, dy, self.tilesize, self.tilesize)
            if self.grid[r][c] ~= 0 then
                love.graphics.draw(self.players[self.grid[c][r]], dx, dy)
            end
            dx = dx + self.tilesize
            
        end 
        dx = self.ox
        dy = dy + self.tilesize
    end
    
end

function game:mousepressed(x,y, button)
    if button == 1 then
        local x = math.floor((x - 10) / 20)
        local y = math.floor((y - 50) / 20)
        if self.board[x][y] == " " then
            self.board[x][y] = self.player
            self.player = self.player == "X" and "O" or "X"
        end
    end
end




return game
