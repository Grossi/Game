--- CONTEM FUNÇÕES DE FISICA (colisões)

function collision(effect, character, mx, my)
    if(effect.style == 'circle')then
        return collisionCircle(character, effect, mx, my)
    elseif(effect.style == 'polygon')then
        return colisionPolygon(character, effect, mx, my)
    end
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
        print("WOW")
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
    for i = 1, #objs do
        tmx, tmy = colisaoPolig(character, objs[i], mx, my)
		if(tmx*tmx+tmy*tmy < mx*mx+my*my) then
			mx, my = tmx, tmy
		end
    end
    return mx, my
end

