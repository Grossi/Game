-- Basic stage stats

local x = 200
local y = 200
local w = 1700
local h = 1400
local g = 1700

-- Table with the objects

local obj = {}

--Contorno da fase

obj[1] = Obj(0, 0, w, 0)
obj[2] = Obj(0, 0, 0, h)
obj[3] = Obj(w, 0, w, h)
obj[4] = Obj(0, h, w, h)

obj[5] = Obj(0, 1300, 1700, 1300, 1700, 1400, 0, 1400)
obj[6] = Obj(200, 250, 500, 250, 500, 300, 200, 300)

return x, y, w, h, g, obj
