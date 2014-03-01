--- CONTEM FUNÇÕES DE FISICA (colisões)

function collision(effect, character, mx, my)
    if(effect.style == 'circle')then
        return collisionCircle(character, effect, mx, my)
    elseif(effect.style == 'polygon')then
        return collisionPolygon(character, effect, mx, my)
    end
end

function colisaoAlpha(obja, objb, mx, my)
    -- A função ve a trajetoria [ (xa, ya) -> (xb, yb) ] para cada vertice ( os vertices estão em obj.vx e obj.vy )
    -- Ela compara essa trajetoria para cada lado do objb ( (xc, yc), (xd, yd) formam um lado do objeto )
    -- Se as retas se cruzarem, significa que houve colisão. Logo o movimento do personagem no eixo que colidiu 
    local onGround = false
    local nb = #objb.vx
    local na = #obja.vx
    t = 1
    tl = 1
    abx = 0
    aby = 0
    -- Nesse loop eu vario por todas as retas de movimento (xa, ya), (xb, yb) do objeto A, formado pelas
    --  retas formadas pelos vertices do objA até os vertices do objA + movimento
    for i = 1, na do
        local xa, xb = obja.vx[i], obja.vx[i] + mx
        local ya, yb = obja.vy[i], obja.vy[i] + my

        -- Nesse loop eu vario por todas as retas (xc, yx), (xd, yd) que formam o objeto B
        for j = 1, nb do
            xa, xb = obja.vx[i], obja.vx[i] + mx
            ya, yb = obja.vy[i], obja.vy[i] + my
            local xc, xd = objb.vx[j], objb.vx[(j%nb)+1]
            local yc, yd = objb.vy[j], objb.vy[(j%nb)+1]
            local d = (xb-xa)*(yc-yd)-(yb-ya)*(xc-xd)
            local dt = (xc-xa)*(yc-yd)-(yc-ya)*(xc-xd)
            local dtl = (xb-xa)*(yc-ya)-(yb-ya)*(xc-xa)
            -- xg = xgrande, xp = xpequeno
            -- ordem é xp, yg - xg, yg - xg, yp - xp, yp
            -- j = 1 chao j = 3 teto, j = 4 lado direito j = 2 lado esquerdo
            if ( d ~= 0 ) then
                local temptl = dtl/d
                local tempt = dt/d
                if(not(temptl>1 or temptl<0 or tempt>1 or tempt<0))then --Se colide...
                    if ( j == 1 or j == 3 ) then
                        local m2 = my
                        onGround = true
                        -- Chão/Teto, considerar apenas o y
                        -- error( "MESSAGE ---->> " .. yc .. "  -  " .. yd .. " ---- " .. objb.vy[1] .. " - " .. objb.vy[3] .. " my -> " .. my .. " || 4 -> " .. na )
--                        if ( math.abs(obja.bb.miny - objb.bb.maxy) > math.abs(my) ) then 
--                            error(" CHAO/ TETO Por que colide? " .. xa .. "," .. ya .. ") - (" .. xb .. ", ".. yb .. ") - (" .. xc .. ", " .. yc .. ") - (" .. xd .. ", " .. yd .. ") --> mx, my -> " .. mx .. " - " .. my .. "ya, yc ->" .. ya .. " - " .. yc  )
--                        end
                        my = yc - ya
                        if ( math.abs( my ) < 1 ) then
                            my = 0
                        end
                        if ( my > 0 ) then
                            my = my - 0.5
                        end
                        if ( my < 0 ) then
                            my = my + 0.5
                        end
                        yb = ya + my
                        if ( my * m2 < 0 ) then
                            error(" MUDOU SINAL LOL  " .. my .. ", " .. m2 )
                        end
                    end
                    if ( j == 2 or j == 4 ) then
                        -- Parede, considerar apenas o x
                        if ( math.abs(xa - xc) > ( math.abs(mx) ) ) then 
                            error("PAREDE Por que colide? " .. xa .. "," .. ya .. ") - (" .. xb .. ", ".. yb .. ") - (" .. xc .. ", " .. yc .. ") - (" .. xd .. ", " .. yd .. ") --> mx, my -> " .. mx .. " - " .. my .. "xa, xc ->" .. xa .. " - " .. xc   )
                        end
                        mx = xc - xa
                        if ( math.abs( mx ) < 1 ) then
                            mx = 0
                        end
                        if ( mx > 0 ) then
                            mx = mx - 0.5
                        end
                        if ( mx < 0 ) then
                            mx = mx + 0.5
                        end
                        xb = xa + mx
                    end
                end
            end
         end
    end
    -- Agora tenho que fazer como se os objetos estivessem se movendo,
    --  para pegar os casos de colisao que sao vertices do objeto passando pelo personagem
    for i = 1, nb do
        -- É como se o objeto estivesse se movendo com velocidade negativa a do personagem, e o personagem estivesse parado.
        local xa, xb = objb.vx[i], objb.vx[i] - mx
        local ya, yb = objb.vy[i], objb.vy[i] - my
        for j = 1, na do
            xa, xb = objb.vx[i], objb.vx[i] - mx
            ya, yb = objb.vy[i], objb.vy[i] - my
            local xc, xd = obja.vx[j], obja.vx[(j%nb)+1]
            local yc, yd = obja.vy[j], obja.vy[(j%nb)+1]
            local d = (xb-xa)*(yc-yd)-(yb-ya)*(xc-xd)
            local dt = (xc-xa)*(yc-yd)-(yc-ya)*(xc-xd)
            local dtl = (xb-xa)*(yc-ya)-(yb-ya)*(xc-xa)
            if ( d ~= 0 ) then
                local temptl = dtl/d
                local tempt = dt/d
                if(not(temptl>1 or temptl<0 or tempt>1 or tempt<0))then --Se colide...
                    if ( j == 1 or j == 3 ) then
                        -- Chão/Teto, considerar apenas o y
                        my = ya - yc
                        if ( math.abs( my ) < 1 ) then
                            my = 0
                        end
                        if ( my > 0 ) then
                            my = my - 0.5
                        end
                        if ( my < 0 ) then
                            my = my + 0.5
                        end
                        yb = ya - my
                    end
                    if ( j == 2 or j == 4 ) then
                        -- Parede, considerar apenas o x
                        mx = xa - xc
                        if ( xc ~= xd ) then
                            error( "Personagem wtf -> (" .. xc .. ", " .. yc .. "), (" .. xd .. ", " .. yd .. ")" .. j )
                        end
                        if ( math.abs( mx ) < 1 ) then
                            mx = 0
                        end
                        if ( mx > 0 ) then
                            mx = mx - 0.5
                        end
                        if ( mx < 0 ) then
                            mx = mx + 0.5
                        end
                        xb = xa - mx
                    end
                end
            end
         end
    end
    return mx, my, onGround
end

function collisionPolygon(obja, objb, mx, my)
    t = 1
    tl = 1
    for i = 1, #obja.vx do
        xa, xb, ya, yb = obja.vx[i], obja.vx[i] + mx, obja.vy[i], obja.vy[i] + my
        for j = 1, #objb.vx do
            xc, yc, xd, yd = objb.vx[j], objb.vy[j], objb.vx[((((j+1)%#objb.vx)>=1 and ((j+1)%#objb.vx)) or #objb.vx)], objb.vy[((((j+1)%#objb.vx)>=1 and ((j+1)%#objb.vx)) or #objb.vx)]
            d = (xb-xa)*(yc-yd)-(yb-ya)*(xc-xd)
            dt = (xc-xa)*(yc-yd)-(yc-ya)*(xc-xd)
            dtl = (xb-xa)*(yc-ya)-(yb-ya)*(xc-xa)
            if(d ~= 0)then
                temptl = dtl/d
                tempt = dt/d
                if(not(temptl>1 or temptl<0 or tempt>1 or tempt<0))then --Se colide...
                    return true
                end
            end
        end
    end
    return false
end


function collisionRetangle( obja, objb, mx, my)

    local AX1, AX2 = obja.vx[1], obja.vx[3]
    if (obja.vx[1] < obja.vx[3]) then
        AX1, AX2 = obja.vx[3], obja.vx[1]
    end

    local AY1, AY2 = obja.vy[1], obja.vy[3]
    if (obja.vy[1] < obja.vy[3]) then
        AY1, AY2 = obja.vy[3], obja.vy[1]
    end

    local BX1, BX2 = objb.vx[1], objb.vx[3]
    if (objb.vx[1] < objb.vx[3]) then
        BX1, BX2 = objb.vx[3], objb.vx[1]
    end

    local BY1, BY2 = objb.vy[1], objb.vy[3]
    if (objb.vy[1] < objb.vy[3]) then
        BY1, BY2 = objb.vy[3], objb.vy[1]
    end

    local insideX = (AX1 > BX1 and AX1 < BX2) or (AX2 > BX1 and AX2 < BX2)

    if insideX then
        local insideY = (AY1 > BY1 and AY1 < BY2) or (AY2 > BY1 and AY2 < BY2)
        return true
    end

    return false
    
end


function collisionCircle(obja, circ, mx, my)
    for i = 1, #obja.vx do
        if (((obja.vx[i] - circ.x)*(obja.vx[i] - circ.x)+(obja.vy[i]-circ.y)*(obja.vy[i]-circ.y)) < circ.ratio*circ.ratio) then
            return true
        end
    end
    return false
end



function move(character, mx, my, objs, effects)
	local tmx
	local tmy
	local onGround = false
    for i = 1, #objs do
        local og
        tmx, tmy, og = colisaoAlpha(character, objs[i], mx, my)
        if (og==true) then 
            onGround = true
        end
		if(tmx*tmx+tmy*tmy < mx*mx+my*my) then
			mx, my = tmx, tmy
		end
    end
    return mx, my, onGround
end

