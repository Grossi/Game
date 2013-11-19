-- SERVER MODULE --
local socket = require('socket')

local servidor = {}

servidor.connect = function(self)
    self.client = socket.connect("0.0.0.0", "36789")
    if (self.client ~= nil) then
        self.run = coroutine.create(self.runclient)
        self.client:settimeout(10)
        local line, err = self.client:receive()
        if (line == nil) then
            print("Servidor não retornou, erro: " .. err)
            os.exit()
        else
            return tonumber(line)
        end
    else
        return false
    end
end

servidor.bind = function(self)
    self.socket = socket.bind("*", '36789')
    self.run = coroutine.create(self.runserver)
    return self.socket
end

servidor.runclient = function(self)
    --run client routine
    while true do
        self.client:settimeout(0.01)
        local lineIn, err = self.client:receive('*l')
        local lineOut
        if not err then
            -- Se recebe algo, retorna isso
            _, lineOut = coroutine.yield(lineIn)
        else
            _, lineOut = coroutine.yield() -- Se não recebe nada, apenas retorna
        end
        if (lineOut ~= nil) then -- Se recebeu algo do Yield, envia ao servidor
            self.client:send(lineOut .. '\n')
        end
    end
end

servidor.runserver = function(self)
    --run server routine
    local lineOut
    local coisas = {}
    while true do
        local lineIn = {}
        self.socket:settimeout(0.01)
        local err
        self.clients[#self.clients + 1], err = self.socket:accept()    --Ve se mais um client se connecta
        if not err then
            self.socket:settimeout(0.06)
            -- Se connecta, yield com um valor especifico para a main passar a posição de todos os characters, e criar um novo para o novo character
            _, lineOut, coisas = coroutine.yield('n', (#self.clients + 1))
            self.clients[#self.clients]:send(#self.clients + 1 .. '\n')                             --Se connectar, manda o ID... 
        end
        for i, v in pairs(self.clients) do
            self.socket:settimeout(0.01)
            lineIn[i+1] = v:receive('*l')
            if (lineOut ~= nil) then v:send('1' .. lineOut .. '\n') end         -- Se recebeu scoi do servidor, manda para o cliente
        end
        for i, v in pairs(self.clients) do
            for j in pairs(self.clients) do
                if (lineIn[j+1] == nil or lineIn[j] == '') then
                    v:send((j+1) .. 'nil' .. '\n')
                else
                    v:send((j+1) .. lineIn[j+1] .. '\n')
                end
            end
        end                                               -- Manda para todos os clientes "v" a scoi de cada cliente "j"
        _, lineOut = coroutine.yield(#self.clients, lineIn)             -- lineOut é a scoi do servidor. LineIn é uma table com as scoi's dos clients.
    end
end

servidor.clients = {}


return servidor
