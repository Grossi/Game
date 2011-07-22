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
    local lineOut, serverScoi
    local stage, stageOut
    while true do
        local lineIn = {}
        self.socket:settimeout(0.01)
        local err
        self.clients[#self.clients + 1], err = self.socket:accept()    --Ve se mais um client se connecta
        if not err then
            self.socket:settimeout(0.06)
            -- Se connecta, yield com um valor especifico para a main passar a posição de todos os characters, e criar um novo para o novo character
            _, serverScoi, stage = coroutine.yield('n', (#self.clients + 1))
            stageOut = 'C::'
            for i, v in pairs(stage.character) do
                stageOut = stageOut .. i .. ',' .. v.x .. ',' .. v.y .. ',' .. v:w .. ',' .. v:h .. ','
                for k, j in pairs(v.spells) do
                    stageOut = stageOut .. k .. ',' .. j.name .. ','
                end
                stageOut = stageOut .. ';'
            end
            stageOut = stageOut .. 'E::'
            for i, v in pairs(stage.effect) do
                
            self.clients[#self.clients]:send(#self.clients + 1 .. '\n')                             --Se connectar, manda o ID...
            -- Manda a posição de todos os personagens, todos os eventos da tela
        end
        for i, v in pairs(self.clients) do
            self.socket:settimeout(0.01)
            lineIn[i+1] = v:receive('*l')
        end
        if scoiServer then lineOut = '1' .. scoiServer .. ';' end
        for i, v in pairs(self.clients) do
            if (lineIn[i+1] == nil or lineIn[i+1] == '') then
                --v:send((j+1) .. 'nil' .. '\n')
            else
                lineOut = lineOut .. (i+1) .. lineIn[i+1] .. ';'
            end
        end
        for i, v in pairs(self.clients) do
            v:send(lineOut .. '\n')
        end                                               -- Manda para todos os clientes uma string com todas as scoi's separadas por ';'
        
        
        _, lineOut = coroutine.yield(#self.clients, lineIn)             -- lineOut é a scoi do servidor. LineIn é uma table com as scoi's dos clients.
    end
end

servidor.clients = {}


return servidor
