function readScoi(scoi, dt, mx, my)
    -- Função para a leitura das scoi's
    -- Cunfiguração da scoi:
    -- UpSide..Key1..Key2.. (...) KeyN..
    if (string.sub(scoi,1,1) == 'w') then
        stg.character[1]:jump()	
    end
    if (string.sub(scoi,2,2) == '>') then
        stg.character[1]:moveRight(dt)
    elseif(string.sub(scoi,2,2) == '<') then
        stg.character[1]:moveLeft(dt)
    elseif(string.sub(scoi,2,2) == '_') then
        stg.character[1]:stop(dt)
    end
    -- A partir do terceiro caracter começam os comandos que são separados por '..'
    local _, i = string.find(scoi, '..', 1, true) -- Acha a primeira
    if i then i = i + 1 end
    local j, _ = string.find(scoi, '..', i, true) -- Começo e fim do primeiro comando
    if j then j = j - 1 end
    if (stg.character[1].spells ~= nil) then       
        if (i ~= nil and j~= nil) then --Tem que ter começo e fim
            while true do
                local command = string.sub(scoi, i, j)
                stg.character[1].spells[command]:run(stg.character[1], stg, dt, love.mouse.getX() - stg.x, love.mouse.getY() - stg.y)
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

function getInput(dt)
    local scoi
    ------------ INPUT - Cria uma string scoi (String Com Os Inputs lol) que contem... os inputs --        
    --Teclas de movimento
    if(love.keyboard.isDown("w"))then
        scoi = (scoi == nil and 'w') or (scoi .. 'w')
    else
        scoi = (scoi == nil and '_') or (scoi .. '_')
    end
    if(love.keyboard.isDown("d"))then
        scoi = scoi .. '>'
    elseif(love.keyboard.isDown("a"))then
        scoi = scoi .. '<'
    else
        scoi = (scoi == nil and '_') or (scoi .. '_')
    end
    
    --Teclas de ação
    if (stg.character[1].spells ~= nil) then
        scoi = scoi .. '..'
    end
    for i, v in pairs(stg.character[1].spells) do
        v.cooldown = v.cooldown - dt
        if(string.sub(i, 1, 1) == 'm') then
            if(love.mouse.isDown(string.sub(i, 2))) then
                scoi = scoi .. i .. '..'
            end
        elseif(string.sub(i, 1, 1) == 'k') then
            if(love.keyboard.isDown(string.sub(i, 2))) then        
                scoi = scoi .. i .. '..'
            end
        end
    end
    return scoi
end