local cooldown = 2
local foo = function(self, character, stage, dt, mousex, mousey)
    if(self.cooldown < 0) then
        self.cooldown = 0
    end
    if(self.cooldown == 0) then
        character.buffs['speed'] = Buff('speed', character)
        stage.effects['energyBall'] = Effect(nil, 'circle', character.x + character.w+5, character.y+character.h/2, mousex - character.x - character.w/2, mousey - character.y - character.h/2, 15)
                               -- Effect(onhit,style,   x,                   y,                 vx,              vy,            raio)
        self.cooldown = 2
    end
end

return cooldown, foo
