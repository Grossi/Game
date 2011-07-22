------------------------ BUFF -----------------------------

Buff = function(name, character, ...) --Recebe o nome, ponteiro para o pai e os parametros do buff especifico
    local tab = {}
    tab.arg = arg
    tab.character = character
    local foo
    local timer
    timer, foo  = dofile('buff/' .. name .. '.lua') -- Retorna uma função "buff.run", recebebe self(com o ponteiro para o character e os argumentos) e dt (para buffs com timers)
    tab.run = foo
    tab.timer = timer
    return tab
end


------------------------ EFFECT ---------------------------

Effect = function(onHit, style, ...)
    local tab = {arg = arg}
    tab.style = style
    if (style == 'circle') then
        local x = arg[1]
        local y = arg[2]
        local velx = arg[3]
        local vely = arg[4]
        local ratio = arg[5]
        tab.x = x
        tab.y = y
        tab.velx = velx
        tab.vely = vely
        tab.ratio = ratio
        function draw(self, stage)
            love.graphics.circle( 'fill', self.x + stage.x, self.y + stage.y , self.ratio )
        end
        tab.draw = draw
        tab.name = onHit
        if(onHit) then
            tab.onHit = function(self, character)
                local table = {}  -- Apenas os argumentos a partir do 5 são para o "onHit", pois circle exige 5 argumentos
                for i = 6, #self.arg do
                    table[i - 5] = self.arg[i]
                end
                tab.table = table
                return Buff(tab.name, character, table)
            end
        end
        tab.update = function(self, dt)
            self.x = self.x + self.velx *dt
            self.y = self.y + self.vely *dt
        end
    else
        return 'Non supported type style'
    end
    return tab
end

------------------------ SPELL ----------------------------

Spell = function(name)
    --Returns a table with the function "run".
    local tab = {
    name = name}
    tab.cooldown, tab.run = dofile('spell/' .. tab.name .. '.lua') --Returns a spell... function(self, character, stage, dt, mousex, mousey)
    return tab
end

------------------------ OBJECT ----------------------------

Obj = function(...)
    local tabx = {}
    local taby = {}
    for i = 1 , #arg, 2 do
        tabx[((i+1)/2)] = arg[i]
        taby[((i+1)/2)] = arg[i+1]
    end
    local tab = {vx = tabx, 
                vy = taby,
                draw = function(self, stage)
                    local t = {}
                    for i = 1, #self.vx do
                        t[(i*2)-1] = self.vx[i] + stage.x
                        t[i*2] = self.vy[i] + stage.y
                    end
                    love.graphics.polygon('line', t)
                end
    }                
    return tab
end

------------------------ CHARACTER ---------------------------

Character = function (x, y, w, h, ...)
    local tab = Obj(x, y, x+w, y, x+w, y+h, x, y+h)
    tab.face = 1
    -- DO NOT change the value of x, y, w, h. They are just for easy calculations, use the functions to move the character (character.move)
    tab.x = x
    tab.y = y
    tab.w = w
    tab.h = h
    tab.velx = 0
    tab.vely = 0
    tab.spd = 300 
    tab.onGround = true
    tab.jump = function(self)
        if(self.onGround)then
            self.vely = self.spd*-2
        end
    end
    tab.moveRight = function(self)
        self.velx = self.spd
    end
    tab.moveLeft = function(self)
        self.velx = self.spd * -1
    end
    tab.stop = function(self)
        self.velx = 0
    end
    tab.move = function(self, stage, mx, my)
        if(self == stage.character[id]) then
            stage.x = stage.x - mx
            stage.y = stage.y - my
        end
        self.x = self.x + mx
        self.y = self.y + my
        for i = 1, #self.vx do
            self.vx[i] = self.vx[i] + mx
            self.vy[i] = self.vy[i] + my
        end
    end
    
    --Spells
    tab.spells = {}
    local keyTab = {"ml", "mr"} -- MouseLeft, MouseRight
    local size = ((#keyTab<=#arg and #keyTab) or #arg)
    for i = 1, size do
        tab.spells[keyTab[i]] = Spell(arg[i])
    end
    
    --Buffs
    tab.buffs = {}
    
    return tab
end

------------------------ STAGE -----------------------------

Stage = function ()
    local tab = {
            x = 0,
            y = 0,
            w = 800,
            h = 600,
            g = 800,
            character = {},
            objs = {},
            effects = {},
            loadStage = function (self, file)
                self.x, self.y, self.w, self.h, self.g, self.objs = dofile('stage/' .. file .. '.lua')
            end
    }
    return tab
end
