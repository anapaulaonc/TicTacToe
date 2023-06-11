local socket = require "socket"

local server = socket.bind("*", 3124) -- * ouve tudo so nessa porta

-- so vai funcionar se os dois tiverem conectados, espera ate que alguem conecte
local playerX = server:accept()
local playerO = server:accept()

local turn = 1 -- 1 = "x", 2 = "o"

local grid = {}
for c = 1, 3 do
    grid[c] = {}
    for r = 1, 3 do
       grid[c][r] = 0
       -- dependendo se botar 0, 1 ou 2 fica nada, x ou o respectivamente
    end 
end  

while true do -- loop infinito
    local message = nil

    if turn == 1 then
        message = playerX:receive(3) -- uma linha
    elseif turn == 2 then
        message = playerO:receive(3)
    end

    -- message = x,y
    local x = message:sub(1,1) -- message[1]
    local y = message:sub(3,3) -- message[3]
    x = tonumber(x)
    y = tonumber(y)
    print(x, y)

    grid[x][y] = turn

    --checkWin()

    message = ""
    for i = 1, 3 do
        for j = 1, 3 do
            message = message .. grid[i][j]
        end
    end

    playerX:send(message)
    playerO:send(message)

    if turn == 1 then
        turn = 2
    else
        turn = 1
    end 
end