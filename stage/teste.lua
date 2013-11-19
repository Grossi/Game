-- Basic stage stats

local x = 0
local y = 0
local w = 1700
local h = 1400
local g = 1700
local background = love.graphics.newImage( 'img/bg1.jpg' )

-- Table with the objects

local obj = {}

--Contorno da fase

obj[1] = Obj(0, 0, w, 0, w, 0, 0, 0)
obj[2] = Obj(0, h, 0, h, 0, 0, 0, 0)
obj[3] = Obj(w, h, w, h, w, 0, w, 0)
obj[4] = Obj(0, h, w, h, w, h, 0, h)

obj[5] = Obj(0, 1400, 1700, 1400, 1700, 1300, 0, 1300)
obj[6] = Obj(200, 300, 500, 300, 500, 250, 200, 250)

return x, y, w, h, g, obj, background
