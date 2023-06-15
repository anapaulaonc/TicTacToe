local client = require "client"

local game = {
    ox, oy = 0, 0,
    grid = {},
    width = 3,
    height = 3,
    tilesize = 100,
    players = {
        [1] = nil,
        [2] = nil
    },
    player = 0,
    pawns = {
        [1] = nil,
        [2] = nil,
        scale = .7,
        mouseScale = .5,
    },
    --reset = false,
    --userVictory = 0,

}

function game:reset()
    self.grid = {}
    --self.reset = false
    --self.userVictory = 0

    
    love.math.setRandomSeed(love.timer.getTime())
    local n = love.math.random(1, 2)

    if n == 1 then
        self.players[1] = self.pawns[1]
        self.players[2] = self.pawns[2]
    else    
        self.players[1] = self.pawns[2]
        self.players[2] = self.pawns[1]
    end

    self.player = love.math.random(1, 2)  

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
    --self.winning[1] = love.graphics.newImage("sprites/win1.png")
    --self.winning[2] = love.graphics.newImage("sprites/win2.png")

    client:connect()
    game:reset()
end

function game:update(dt)
    local data = client:receive()
    
    if data ~= nil then
        local win = data:sub(10,10)
        for i = 1, 3 do
            for j = 1, 3 do
                local index = (i - 1) * 3 + j
                -- como se fosse data[index]
                self.grid[j][i] = tonumber(data:sub(index, index))

            end
        end
        
        if win ~= "o" then
            GAME = require"winner"
            GAME:load(win)

        elseif win == "o" and string.find(data, "0") == nil then
            win = "d"
            print("entrei no empate")
            GAME = require"winner"
            GAME:load(win)
        end    
    

        
        
           
    end
end

function game:draw()

    for posY = 1, self.height do
        
        
        for posX = 1, self.width do
            local value = self.grid[posY][posX]
            if value == 1 then
                love.graphics.draw(self.pawns[1], ((posX- 1)*self.tilesize)+ self.ox, ((posY- 1)*self.tilesize)+ self.oy)
            end
            if value == 2 then
                love.graphics.draw(self.pawns[2], ((posX-1)*self.tilesize)+ self.ox, ((posY- 1)*self.tilesize)+ self.oy)
            end

        

        end

    end     



    -- local dx, dy = self.ox, self.oy
    -- for c = 1, self.height do
    --     dx = self.ox
    --     for r = 1, self.width do
    --         love.graphics.rectangle('line', dx + 3 , dy + 3, self.tilesize - 6, self.tilesize -6, 4)
    --         if self.grid[r][c] ~= 0 then
    --             love.graphics.draw(self.players[self.grid[c][r]], 
    --                 dx + self.tilesize/2,
    --                 dy + self.tilesize/2,
    --                 0, self.pawns.scale, self.pawns.scale,
    --                 (self.players[self.grid[c][r]]:getWidth()/2)* (self.pawns.scale/2), 
    --                 (self.players[self.grid[c][r]]:getHeight()/2)* (self.pawns.scale/2))
    --         end
    --         dx = dx + self.tilesize
            
    --     end 

    --     dy = dy + self.tilesize
    --end

    -- love.graphics.draw(self.players[self.player], 
    --     love.mouse.getX(),
    --     love.mouse.getY(),
    --     0, self.pawns.mouseScale, self.pawns.mouseScale,
    --     (self.players[self.player]:getWidth()/2)* (self.pawns.mouseScale/2), 
    --     (self.players[self.player]:getHeight()/2)* (self.pawns.mouseScale/2))
    
end

function game:mousepressed(x,y, button)

    local posX = math.floor((x - (self.tilesize/2))/self.tilesize) - 1
    local posY = math.floor((y - (self.tilesize/2))/self.tilesize) 
--[[ 
    if self.grid[posY][posX] == 0 then
        self.grid[posY][posX] = self.player

    end

    if self.player == 1 then
        self.player = 2
    else
        self.player = 1
    end ]]

    client:send(posX, posY)
end




return game 
