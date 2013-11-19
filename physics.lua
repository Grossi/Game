--- CONTEM FUNÇÕES DE FISICA (colisões)

function collision(effect, character, mx, my)
    if(effect.style == 'circle')then
        return collisionCircle(character, effect, mx, my)
    elseif(effect.style == 'polygon')then
        return colisionPolygon(character, effect, mx, my)
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
    for i = 1, na do
        local xa, xb, ya, yb = obja.vx[i], obja.vx[i] + mx, obja.vy[i], obja.vy[i] + my

        -- Como em Lua os vetores começam de 1, fazer i+1%n não circularia pelos vetores (incluiria o 0).
        -- Para concertar isso faço (i%n)+1
        for j = 1, nb do
            local xc, yc = objb.vx[j], objb.vy[j]
            local xd = objb.vx[(j%nb)+1]
            local yd = objb.vy[(j%nb)+1]
            local d = (xb - xa)*(yc-yd)-(yb-ya)*(xc-xd)
            local dt = (xc-xa)*(yc-yd)-(yc-ya)*(xc-xd)
            local dtl = (xb-xa)*(yc-ya)-(yb-ya)*(xc-xa)
            -- A ordem de rotação do J, a linha de cima é o xd e o yd, a de baixo
            --  é xc e o yc. xg = xgrande, xp = xpequeno
            -- ordem é xg, yg - xg, yp - xp, yp - xp, yg
            -- ordem é xp, yg - xg, yg - xg, yp - xp, yp
            -- j = 1 chao j = 3 teto, j = 4 lado direito j = 2 lado esquerdo
            if ( d ~= 0 ) then
                local temptl = dtl/d
                local tempt = dt/d
                if(not(temptl>1 or temptl<0 or tempt>1 or tempt<0))then --Se colide...
                    if ( j == 1 or j == 3 ) then
                        local m2 = my
                        print("onGround = true")
                        onGround = true
                        -- Chão/Teto, considerar apenas o y
                        -- error( "MESSAGE ---->> " .. yc .. "  -  " .. yd .. " ---- " .. objb.vy[1] .. " - " .. objb.vy[3] .. " my -> " .. my .. " || 4 -> " .. na )
                        if ( math.abs(ya - yc) > math.abs(my) ) then 
                            error(" CHAO/ TETO Por que colide? " .. xa .. "," .. ya .. ") - (" .. xb .. ", ".. yb .. ") - (" .. xc .. ", " .. yc .. ") - (" .. xd .. ", " .. yd .. ") --> mx, my -> " .. mx .. " - " .. my .. "ya, yc ->" .. ya .. " - " .. yc  )
                        end
                        my = yc - ya
                        if ( math.abs( my ) < 0.1 ) then
                            my = 0
                        end
                        if ( my > 0 ) then
                            my = my - 0.1
                        end
                        if ( my < 0 ) then
                            my = my + 0.1
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
                        if ( math.abs( mx ) < 0.1 ) then
                            mx = 0
                        end
                        if ( mx > 0 ) then
                            mx = mx - 0.1
                        end
                        if ( mx < 0 ) then
                            mx = mx + 0.1
                        end
                        xb = xa + mx
                    end
                end
            end
         end
    end
    -- Agora tenho que fazer como se os objetos estivessem se movendo
    for i = 1, nb do
        xa, xb, ya, yb = objb.vx[i], objb.vx[i] - mx, objb.vy[i], objb.vy[i] - my
        -- Como em Lua os vetores começam de 1, fazer i+1%n não circularia pelos vetores (incluiria o 0).
        -- Para concertar isso faço (i%n)+1
        for j = 1, na do
            xc, yc = obja.vx[j], obja.vy[j]
            xd = obja.vx[(j%na)+1]
            yd = obja.vy[(j%na)+1]
            local d = (xb - xa)*(yc-yd)-(yb-ya)*(xc-xd)
            local dt = (xc-xa)*(yc-yd)-(yc-ya)*(xc-xd)
            local dtl = (xb-xa)*(yc-ya)-(yb-ya)*(xc-xa)
            if ( d ~= 0 ) then
                local temptl = dtl/d
                local tempt = dt/d
                if(not(temptl>1 or temptl<0 or tempt>1 or tempt<0))then --Se colide...
                    if ( j == 1 or j == 3 ) then
                        -- Chão/Teto, considerar apenas o y
                        my = ya - objb.vy[2]
                        if ( math.abs( my ) < 0.1 ) then
                            my = 0
                        end
                        if ( my > 0 ) then
                            my = my - 0.01
                        end
                        if ( my < 0 ) then
                            my = my + 0.01
                        end
                        yb = ya - my
                    end
                    if ( j == 2 or j == 4 ) then
                        -- Parede, considerar apenas o x
                        mx = xa - xc
                        if ( xc ~= xd ) then
                            error( "Personagem wtf -> (" .. xc .. ", " .. yc .. "), (" .. xd .. ", " .. yd .. ")" .. j )
                        end
                        if ( math.abs( mx ) < 0.1 ) then
                            mx = 0
                        end
                        if ( mx > 0 ) then
                            mx = mx - 0.01
                        end
                        if ( mx < 0 ) then
                            mx = mx + 0.01
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
            d = (xb - xa)*(yc-yd)-(yb-ya)*(xc-xd)
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

--Retorna o movimento que o objeto faz considerando o outro objeto. (a se move até encostar em b)
function colisaoPolig( obja, objb, mx, my)
    t = 1
    tl = 1
    abx = 0
    aby = 0
    for i = 1, #obja.vx do
        xa, xb, ya, yb = obja.vx[i], obja.vx[i] + mx, obja.vy[i], obja.vy[i] + my
        for j = 1, #objb.vx do
            -- n%n = 0, logo fiz uma algebra booleana para retornar "n" se "n%n < 1".
            xc, yc, xd, yd = objb.vx[j], objb.vy[j], objb.vx[((((j+1)%#objb.vx)>=1 and ((j+1)%#objb.vx)) or #objb.vx)], objb.vy[((((j+1)%#objb.vx)>=1 and ((j+1)%#objb.vx)) or #objb.vx)]
            d = (xb-xa)*(yc-yd)-(yb-ya)*(xc-xd)
            dt = (xc-xa)*(yc-yd)-(yc-ya)*(xc-xd)
            dtl = (xb-xa)*(yc-ya)-(yb-ya)*(xc-xa)
            if(d ~= 0)then
                temptl = dtl/d
                tempt = dt/d
                if(not(temptl>1 or temptl<0 or tempt>1 or tempt<0))then --Se colide...
                    if(tempt<t)then
                        t = tempt
                        tl = temptl
                        abx = (xd - xc)
                        aby = (yd - yc)
                    end
                end
            end
        end
    end
    if (t < 0) then
        print("ERROR: T < 0")
    end
    

	--Acha o vetor resultante paralelo a linha onde o objeto colidiu. Adiciona esse vetor ao vetor de movimento, multiplicando pelo atrito (Not using it right now)
	-- Projecao cd em ab = cf
	-- cf = cos * ab/||ab|| * ||cd||
	-- cos = ab.cd/||ab||||cd||
	-- cf = ab.cd*ab/||ab||**2
    cfx = 0
    cfy = 0
	cdx = (1 - t) *mx
	cdy = (1 - t) *my
	cfx = 0
	cfy = 0
	if(((abx*cdx)+(aby*cdy)) ~= 0) then -- Se for perpendicular, não existe projeção paralela
		cfx = ((abx*cdx+aby*cdy)*abx)/((abx*abx)+(aby*aby))
		cfy = ((abx*cdx+aby*cdy)*aby)/((abx*abx)+(aby*aby))
	end
    
    local tempmx = t*mx
    local tempmy = t*my
    
    
    -- Subtrai (0.001*vetor unitario) do vetor. Se o vetor for menor que 0.001, vetor = 0
    if((tempmx*tempmx+tempmy*tempmy)*(abx*abx+aby*aby)~=0)then    
        local lixo = 0.001
        local sineteta = math.abs(tempmx*aby - tempmy*abx)/math.sqrt((tempmx*tempmx+tempmy*tempmy)*(abx*abx+aby*aby))
        local vetlixo = lixo/sineteta
        local newx = tempmx - (tempmx/math.sqrt(tempmx*tempmx+tempmy*tempmy)*vetlixo)
        local newy = tempmy - (tempmy/math.sqrt(tempmx*tempmx+tempmy*tempmy)*vetlixo)
        if(newx*tempmx<0 or newy*tempmy<0)then --Se eles tem o mesmo sinal
            tempmx = 0
            tempmy = 0
        else
            tempmx = newx
            tempmy = newy
        end
    end


	if (tempmy < 0.001 and tempmy > -0.001) then tempmy = 0 end
	if (tempmx < 0.001 and tempmx > -0.001) then tempmx = 0 end
	if(t < 0.01) then
		return 0, 0
	end
--	colisaoP(obja, objb, tempmx, tempmy)
    return tempmx , tempmy 
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
	local onGround = nil
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

