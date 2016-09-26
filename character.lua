------------------------ CHARACTER ---------------------------

-- Quadrado com x, y, width, heigth
Character = function (x, y, w, h, ...)
    local tab = Obj(x, y+h, x+w, y+h, x+w, y, x, y)
    tab.face = 1
    -- DO NOT change the value of x, y, w, h. They are just for internal calculations, use the functions to move the character (character.move)
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
    tab.moveRight = function(self, dt)
        self.velx = ( self.velx + self.spd*dt*5 )/(1+dt*5)
    end
    tab.moveLeft = function(self, dt)
        self.velx = ( self.velx + self.spd*-1*dt*5 )/(1+dt*5)
    end
    tab.stop = function(self, dt)
        if (self.onGround) then
            self.velx = 0
        end
        -- se aproxima de velx = 0
        self.velx = self.velx * ( 1 - 5*dt )
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
    local keyTab = {"ml", "mr", "kq"} -- MouseLeft, MouseRight, KeyQ
    local size = ((#keyTab<=#arg and #keyTab) or #arg)
    for i = 1, size do
        tab.spells[keyTab[i]] = Spell(arg[i])
    end

    --Buffs
    tab.buffs = {}

    return tab
end

-- Recebe um objeto direto

CharacterObj = function (obj, x, y, ...)
    local tab = obj
    for i = 1, #tab.vx do
        tab.vx[i] = tab.vx[i] + x
        tab.vy[i] = tab.vy[i] + y
    end
    tab.face = 1
    -- DO NOT change the value of x, y, w, h. They are just for easy calculations, use the functions to move the character (character.move)
    tab.velx = 0
    tab.vely = 0
    tab.mx = 0
    tab.my = 0
    tab.status = 'Normal'
    tab.spd = 300
    tab.x = tab.vx[1]
    tab.y = tab.vy[1]
    tab.onGround = true
    tab.jump = function(self)
        if(self.onGround or true)then
            self.vely = self.spd*-2
            self.onGround = false
        end
    end
    tab.moveRight = function(self, dt)
        self.velx = ( self.velx + self.spd*dt*5 )/(1+dt*5)
    end
    tab.moveLeft = function(self, dt)
        self.velx = ( self.velx + self.spd*-1*dt*5 )/(1+dt*5)
    end
    tab.stop = function(self, dt)
        if (self.onGround) then
            self.velx = 0
        end
        -- se aproxima de velx = 0
        self.velx = self.velx * ( 1 - 5*dt )
    end
    tab.move = function(self, stage, mx, my)
        if(self.status == 'Stun') then
            return
        end
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

    tab.dislocate = function(self, stage, mx, my)
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
    local keyTab = {"ml", "mr", "kq"} -- MouseLeft, MouseRight
    local size = ((#keyTab<=#arg and #keyTab) or #arg)
    for i = 1, size do
        tab.spells[keyTab[i]] = Spell(arg[i])
    end

    --Buffs
    tab.buffs = {}

    return tab
end
