require "physics"
require "class"
require "animation"

function readScoi(scoi, dt, mx, my)
    -- Função para a leitura das scoi's
    -- Cunfiguração da scoi:
    -- UpSide..Key1..Key2.. (...) KeyN..
    if (string.sub(scoi,1,1) == 'w') then
        stg.character[1]:jump()	
    end
    if (string.sub(scoi,2,2) == '>') then
        stg.character[1]:moveRight()
    elseif(string.sub(scoi,2,2) == '<') then
        stg.character[1]:moveLeft()
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
    
function love.load()
    showmx, showmy = 0, 0
    charAnim = love.graphics.newImage( 'img/charAnimation.jpg' )
    charAnimation = newAnimation(charAnim, 25.5, 38, 0.1, 0)
    stg = Stage()
    stg:loadStage('teste')
    stg.character[1] = Character(350, 250, 100, 100, 'energyBall', 'teleport')
    stg.character[2] = Character(500, 500, 50, 50)
end

function love.update(dt)

    charAnimation:update(dt)
    
    local scoi = getInput(dt)
    
    readScoi(scoi, dt)
    
    ------------ LOGICA -------------
    
    --Movimento do Personagem
    for i in pairs(stg.character) do
        local onGround
        local mx, my, onGround = move(stg.character[i], stg.character[i].velx * dt, stg.character[i].vely * dt, stg.objs)
        
        if (onGround == true) then
            print("CHAO")
            stg.character[i].onGround = true
        elseif (onGround == nil ) then
            print("AIR")
        elseif( onGround == false) then
            print("wAT")
        end
-- showmx and showmy are variables that are draw on the screen for testing (so it shows the last value that is not 0)
        if (mx ~= 0 or my ~= 0) then
            showmx, showmy = mx, my
        end
        for j in pairs(stg.effects) do
            if(collision(stg.effects[j], stg.character[i], mx, my)) then
--                stg.effects[i]:onHit(stg.character[i])
            end
        end
        stg.character[i]:move(stg, mx, my)
        if (stg.character[i].onGround == false ) then 
            stg.character[i].vely = my/dt
            stg.character[i].vely = stg.character[i].vely + stg.g*dt
        else
            stg.character[i].vely = 0
        end
    end

    -- Mover os efeitos
    for i in pairs(stg.effects) do
        stg.effects[i]:update(dt)
        if( stg.effects[i].lifeTime < 0 ) then
            stg.effects[i] = nil
        end
    end
    
    -- Cicla pelos Buffs, deletando os que retornarem false
    for i, v in pairs(stg.character[1].buffs) do
        if(v:run(dt) == false)then
            stg.character[1].buffs[i] = nil
        end
    end

end

function love.draw()
    love.graphics.draw( stg.background, -stg.character[1].x/5, -stg.character[1].y/5)
--    love.graphics.scale(1 / 2, 1 / 2)
--    love.graphics.translate(400, 300)
    local onGrounds = "AIR"
    if (stg.character[1].onGround ) then
        local onGrounds = "GROUND"
    end
    love.graphics.print( onGrounds ..  " - ".. stg.character[1].x .. " - " .. stg.character[1].y .. "   mx, my ->" .. showmx .. ", " .. showmy , 10, 10)
    for i in pairs(stg.character) do 
        stg.character[i]:draw(stg)
        --charAnimation:draw( stg.character[i].vx[1] + stg.x , stg.character[i].vy[3] + stg.y, 0, 1, 1 )
    end
    for i = 1, #stg.objs do
        stg.objs[i]:draw(stg)
    end
    local b = 1
    for i in pairs(stg.effects) do
        b = b + 1
        stg.effects[i]:draw(stg)
        love.graphics.print( stg.effects[i].lifeTime, 10, 50 + 50*b )
    end
end
