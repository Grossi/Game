local colisao = require "physics"
Obj = function(...)
    local tabx = {}
    local taby = {}
    for i = 1 , #arg, 2 do
        tabx[((i+1)/2)] = arg[i]
        taby[((i+1)/2)] = arg[i+1]
end
    local tab = {vx = tabx, vy = taby}
    return tab
end
circ = {x = 0,
        y = 1.0,
        r = 1.0 }
character = {}
character.x = 0
character.y = 1
objb = Obj(3,1.2 ,3,4, 4,4, 4,1.2)
obja = Obj(1, 1, 2, 1, 2, 2, 1, 2)
print(colisaoPolig(obja, objb, 5, 0))
--colisaoCirc(objb, circ, 10.0, -1.0)
