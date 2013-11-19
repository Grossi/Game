require "physics"
require "class"
require "animation"
move = function(obj, mx, my)
    for i = 1, #obj.vx do
        obj.vx[i] = obj.vx[i] + mx
        obj.vy[i] = obj.vy[i] + my
    end
end

local onGround = false

local mx, my = 0, 10
local dt = 0.15

local objb = Obj(1, 3, 2, 3, 2, 4, 1, 4)
local obja = Obj(0, 0, 3, 0, 3, 1, 0, 1)
local objc = Obj(17, 18, 18, 18, 18, 20, 17, 20)

print( "obja: A(" .. obja.vx[1]..","..obja.vy[1]..") - B(" .. obja.vx[2]..","..obja.vy[2]..") - C(" .. obja.vx[3]..","..obja.vy[3]..") - D(" .. obja.vx[4]..","..obja.vy[4]..")" )
print( "objb: A(" .. objb.vx[1]..","..objb.vy[1]..") - B(" .. objb.vx[2]..","..objb.vy[2]..") - C(" .. objb.vx[3]..","..objb.vy[3]..") - D(" .. objb.vx[4]..","..objb.vy[4]..")" )
print( "objc: A(" .. objc.vx[1]..","..objc.vy[1]..") - B(" .. objc.vx[2]..","..objc.vy[2]..") - C(" .. objc.vx[3]..","..objc.vy[3]..") - D(" .. objc.vx[4]..","..objc.vy[4]..")" )


for i = 1, 5 do
    --mx, my = mx + 1, my - 1
    my = 10
    mx, my, onGround = colisaoAlpha(obja, objb, mx, my)
    print( "1 mx, my: (".. mx .. "," .. my .. ")" )
    mx, my, onGround = colisaoAlpha(obja, objc, mx, my)
    move( obja, mx, my )
    print( "2 mx, my: (".. mx .. "," .. my .. ")" )
    print( "obja: A(" .. obja.vx[1]..","..obja.vy[1]..") - B(" .. obja.vx[2]..","..obja.vy[2]..") - C(" .. obja.vx[3]..","..obja.vy[3]..") - D(" .. obja.vx[4]..","..obja.vy[4]..")" )
    print( "objb: A(" .. objb.vx[1]..","..objb.vy[1]..") - B(" .. objb.vx[2]..","..objb.vy[2]..") - C(" .. objb.vx[3]..","..objb.vy[3]..") - D(" .. objb.vx[4]..","..objb.vy[4]..")" )
    print( "objc: A(" .. objc.vx[1]..","..objc.vy[1]..") - B(" .. objc.vx[2]..","..objc.vy[2]..") - C(" .. objc.vx[3]..","..objc.vy[3]..") - D(" .. objc.vx[4]..","..objc.vy[4]..")" )
end


--[[
mx, my, onGround = move(stg.character[i], stg.character[i].velx * dt, stg.character[i].vely * dt, stg.objs)

mx, my, onGround = colisaoAlpha(obja, objb, mx, my)

stg.character[i].vely = math.floor(my/dt)
stg.character[i].vely = stg.character[i].vely + stg.g

        if (stg.character[i].onGround == false ) then 
            stg.character[i].vely = math.floor(my/dt)
            stg.character[i].vely = stg.character[i].vely + stg.g
        else
            stg.character[i].vely = 0
        end

    for i = 1, #stg.character do
        local onGround
        local mx, my, onGround = move(stg.character[i], stg.character[i].velx * dt, stg.character[i].vely * dt, stg.objs)

        stg.character[i]:move(stg, mx, my)

    end
--]]