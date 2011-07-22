require "physics"
require "class"
servidor = require "server"

function readScoi(scoi, id)
    -- Função para a leitura das scoi's
    -- Cunfiguração da scoi:
    -- UpSide..Key1..Key2.....Keyn..
    if (string.sub(scoi,1,1) == 'w') then
        stg.character[id]:jump()
    end
    if (string.sub(scoi,2,2) == '>') then
        stg.character[id]:moveRight()
    elseif(string.sub(scoi,2,2) == '<') then
        stg.character[id]:moveLeft()
    elseif(string.sub(scoi,2,2) == '_') then
        stg.character[id]:stop()
    end
    -- A partir do terceiro caracter começam os comandos que são separados por '..'
    local _, i = string.find(scoi, '..', 1, true) -- Acha a primeira
    if i then i = i + 1 end
    local j, _ = string.find(scoi, '..', i, true) -- Começo e fim do primeiro comando
    if j then j = j - 1 end
    if (stg.character[id].spells ~= nil) then       
        if (i ~= nil and j~= nil) then --Tem que ter começo e fim
            while true do
                local command = string.sub(scoi, i, j)
                stg.character[id].spells[command]:run(stg.character[id], stg, dt, love.mouse.getX() - stg.x, love.mouse.getY() - stg.y)
                i = j + 3 -- Pula os 2 '..'
                j, _ = string.find(scoi, '..', i, true)
                if j then 
                    j = j - 1
                else
                    break
                end
            end
        end
    end
end

function love.load()
    stg = Stage()
    stg:loadStage('teste')
    stg.character[1] = Character(800/2-stg.x-50, 600/2-stg.y-50, 100, 100, 'energyBall', 'teleport')
    id = servidor:connect()
    if not id then
        servidor:bind()
        id = 1
    end
    print(id)
end


function love.update(dt)

    local scoi = {}
    
    ------------ INPUT - Cria uma string scoi (String Com Os Inputs lol) que contem... os inputs ----------------------
    --Teclas de movimento
    if(love.keyboard.isDown("w"))then
        scoi[id] = (scoi[id] == nil and 'w') or (scoi[id] .. 'w')
    else
        scoi[id] = (scoi[id] == nil and '_') or (scoi[id] .. '_')
    end
    if(love.keyboard.isDown("d"))then
        scoi[id] = scoi[id] .. '>'
    elseif(love.keyboard.isDown("a"))then
        scoi[id] = scoi[id] .. '<'
    else
        scoi[id] = (scoi[id] == nil and '_') or (scoi[id] .. '_')
    end
    
    --Teclas de ação
    if (stg.character[id].spells ~= nil) then
        scoi[id] = scoi[id] .. '..'
    end
    for i, v in pairs(stg.character[id].spells) do
        v.cooldown = v.cooldown - dt
        if(string.sub(i, 1, 1) == 'm') then
            if(love.mouse.isDown(string.sub(i, 2))) then
                scoi[id] = scoi[id] .. i .. '..'
            end
        elseif(string.sub(i, 1, 1) == 'k') then
            if(love.keyboard.isDown(string.sub(i, 2))) then        
                scoi[id] = scoi[id] .. i .. '..'
            end
        end
    end
    
    
----------------------- SERVIDOR --------------------------------------------------------------------------------------
    -- Cliente ------------ NumeroScoi;NumeroScoi...
    if (id ~= 1) then
        _, line = coroutine.resume(servidor.run, servidor, scoi[id])
        if line then
            local i = string.find(line, ';', 1, true) -- Acha a primeira
            if i then i = i + 1 end
            local j = string.find(line, ';', i, true) -- Começo e fim do primeiro comando
            if j then j = j - 1 end
            if (i ~= nil and j~= nil and j>i) then --Tem que ter começo e fim
                while j do
                    local command = string.sub(line, i, j)
                    local indice = tonumber(string.sub(command, 1, 1))
                        if(string.sub(command, 2, 4) ~= 'nil' and indice ~= id) then
                            scoi[indice] = string.sub(command, 2)
                        end
                    i = j + 2 -- Pula o ';'
                    j = string.find(scoi, ';', i, true)
                    if j then j = j - 1 end
                end
            end
        end
    else
        --- Servidor
        readScoi(scoi[id], id)
        local _, numero, tableCois, d, f = coroutine.resume(servidor.run, servidor, scoi[id])
    --        print(numero, tableCois, d, f)
        if (numero == 'n') then
            --new character
            stg.character[tableCois] = Character(200, 400, 100, 100)
            coroutine.resume(servidor.run, servidor, scoi[id], stg)
        else
            for i, v in pairs(tableCois) do
                if (i ~= id) then
                    scoi[i] = v
                end
            end
        end
    end
    for i, v in pairs(scoi) do
        if (v~=nil and v~='') then
            readScoi(v, i)
        end
    end
---------------- LOGICA -----------------------------------------------------------------------------------------------
    
    --Movimento do Personagem
    for i in pairs(stg.character) do
        local mx, my
        mx, my = move(stg.character[i], stg.character[i].velx * dt, stg.character[i].vely * dt, stg.objs)
        for j in pairs(stg.effects) do
            if(collision(stg.effects[j], stg.character[i], mx, my)) then
--                stg.effects[i]:onHit(stg.character[i])
            end
        end
        stg.character[i]:move(stg, mx, my)
        stg.character[i].vely = my/dt
        stg.character[i].vely = stg.character[i].vely + stg.g*dt
    end

    -- Mover os efeitos
    for i in pairs(stg.effects) do
        stg.effects[i]:update(dt)
    end
    
    -- Cicla pelos Buffs, deletando os que retornarem false
    for i, v in pairs(stg.character[1].buffs) do
        if(v:run(dt) == false)then
            stg.character[1].buffs[i] = nil
        end
    end
end

function love.draw()
    for i in pairs(stg.character) do 
        stg.character[i]:draw(stg)
    end
    for i = 1, #stg.objs do
        stg.objs[i]:draw(stg)
    end
    for i in pairs(stg.effects) do
        stg.effects[i]:draw(stg)
    end
end
