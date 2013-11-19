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

Effect = function(onHit, duration, style, ...)
    local tab = {arg = arg}
    tab.style = style
    tab.lifeTime = duration
    if (style == 'circle') then
        -- PARAMETERS FOR CIRCLE STYLE :
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
        if(onHit) then
            tab.onHit = function(self, character)
                local table = {}  -- Apenas os argumentos a partir do 5 são para o "onHit", pois circle exige 5 argumentos
                for i = 6, #self.arg do
                    table[i - 5] = self.arg[i]
                end
                return Buff(self.onHit, character, table)
            end
        end
        tab.update = function(self, dt)
            self.x = self.x + self.velx *dt
            self.y = self.y + self.vely *dt
            self.lifeTime = self.lifeTime - dt
        end
    else
        return 'Non supported type style'
    end
    return tab
end

------------------------ SPELL ----------------------------

Spell = function(name)
    --Returns a table with the function "run".
    local cooldown
    local foo
    cooldown, foo = dofile('spell/' .. name .. '.lua') --Returns a spell... function(self, character, stage, dt, mousex, mousey)
    local tab = {}
    tab.run = foo
    tab.cooldown = cooldown
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
    local tab = Obj(x, y+h, x+w, y+h, x+w, y, x, y)
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
        if(self.onGround or true)then
            self.vely = self.spd*-2
            self.onGround = false
        end
    end
    tab.moveRight = function(self)
        self.velx = self.spd
    end
    tab.moveLeft = function(self)
        self.velx = self.spd * -1
    end
    tab.stop = function(self, dt)
        if (self.onGround) then
            self.velx = 0
        end
    end
    tab.move = function(self, stage, mx, my)
        if(self == stage.character[1]) then
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
            background = nil,
            loadStage = function (self, file)
                self.x, self.y, self.w, self.h, self.g, self.objs, self.background = dofile('stage/' .. file .. '.lua')
            end
    }
    return tab
end

------------------------ HUD -----------------------------

HUD = function ( file )
    local tab = {
            x = 0,
            y = 0,
            w = 800,
            h = 600,
            characterStat = {},
            img = nil
    }
    tab.x, tab.y, tab.w, tab.h, tab.characterStat, tab.img = dofile('hud/' .. file .. '.lua')
    return tab
end


