local socket = require "socket"

local client = {}

function client:connect()
    self.connection = socket.connect("localhost", 3124)
    self.connection:settimeout(0.1)
end

function client:send(x, y)
    self.connection:send(x .. "," .. y)
end

function client:receive()
    return self.connection:receive(10)
end

return client