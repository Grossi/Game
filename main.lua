require "physics"
require "class"
require "animation"
require "character"
require "scoi"
    
function love.load()
    showmx, showmy = 0, 0
    charAnim = love.graphics.newImage( 'img/charAnimation.jpg' )
    charAnimation = newAnimation(charAnim, 25.5, 38, 0.1, 0)
    stg = Stage()
    stg:loadStage('teste')
    local obja = Obj( 10, 0, 20, 10, 20, 40, 10, 50, 0, 40, 0, 10 )
    stg.character[1] = CharacterObj(obja, 350, 250, 'energyBall', 'teleport')
    stg.character[2] = Character(500, 500, 50, 50)
end

function love.update(dt)

    charAnimation:update(dt)
    
    local scoi = getInput(dt)
    
    readScoi(scoi, dt)
    
    ------------ LOGICA -------------
    
    --Movimento do Personagem
    for i = 1, #stg.character do
        local onGround
        local mx, my, onGround = move(stg.character[i], stg.character[i].velx * dt, stg.character[i].vely * dt, stg.objs)
        
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
            stg.character[i].vely = math.floor(my/dt)
            stg.character[i].vely = stg.character[i].vely + stg.g
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
    love.graphics.print( onGrounds ..  " - ".. stg.character[1].x .. " - " .. stg.character[1].y .. "   mx, my ->" .. math.floor(showmx) .. ", " .. math.floor(showmy) , 10, 10)
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
