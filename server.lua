local socket = require "socket"

local server = socket.bind("*", 3124) -- * ouve tudo so nessa porta

-- so vai funcionar se os dois tiverem conectados, espera ate que alguem conecte
local playerX = server:accept()
local playerO = server:accept()

local turn = 1 -- 1 = "x", 2 = "o"
local endgame = 0
local winner = 0

local grid = {}
for c = 1, 3 do
    grid[c] = {}
    for r = 1, 3 do
       grid[c][r] = 0
       -- dependendo se botar 0, 1 ou 2 fica nada, x ou o respectivamente
    end
end

function checkWin(grid)
    if (grid[2][1] ~= 0 and grid[2][1] == grid[2][2] and grid[2][2] == grid[2][3])
    or (grid[1][2] ~= 0 and grid[1][2] == grid[2][2] and grid[2][2] == grid[3][2])
    or (grid[1][1] ~= 0 and grid[1][1] == grid[2][2] and grid[2][2] == grid[3][3])
    or (grid[1][3] ~= 0 and grid[1][3] == grid[2][2] and grid[2][2] == grid[3][1]) then
        endgame = 1
        winner = grid[2][2]
        print("entrou check 1")

    elseif (grid[1][1] ~= 0 and grid[1][1] == grid[1][2] and grid[1][2] == grid[1][3])
    or (grid[1][1] ~= 0 and grid[1][1] == grid[2][1] and grid[2][1] == grid[3][1]) then
        endgame = 1
        winner = grid[1][1]
        print("entrou check 2")
    elseif (grid[3][1] ~= 0 and grid[3][1] == grid[3][2] and grid[3][2] == grid[3][3])
    or (grid[1][3] ~= 0 and grid[1][3] == grid[2][3] and grid[2][3] == grid[3][3]) then
        endgame = 1
        winner = grid[3][3]
        print("entrou check 3")
    end
    return endgame, winner
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

    if grid[x][y] == 0 then

        grid[x][y] = turn

        endgame, winner = checkWin(grid)

        message = ""
        for i = 1, 3 do
            for j = 1, 3 do
                message = message .. grid[i][j]
            end
        end

        if winner == 1 then
            local message1 = message .. "w"
            local message2 = message .. "l"
            print(message1)
            print(message2)
            playerX:send(message1)
            playerO:send(message2)

            
        elseif winner == 2 then
            local message1 = message .. "l"
            local message2 = message .. "w"
            print(message1)
            print(message2)
            playerX:send(message1)
            playerO:send(message2)
        else
            message = message .. "o"
            print(message)
            playerX:send(message)
            playerO:send(message)
        end

        if endgame == 0 then
            if turn == 1 then
                turn = 2
            else
                turn = 1
            end
        else
            print(winner)
            break
        end
    else
        print("Jogue novamente")
    end
end

while true do
    a = 0
end