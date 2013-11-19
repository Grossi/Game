local cooldown = 2
local foo = function(self, character, stage, dt, mousex, mousey)
    if(self.cooldown < 0) then
        self.cooldown = 0
    end
    if(self.cooldown == 0) then
        character.velx = character.velx - ( mousex - character.x )*10
        character.vely = character.vely - ( mousey - character.y )*10
--        character.buffs['speed'] = Buff('speed', character)
        stage.effects['energyBall'] = Effect(nil, 2,  'circle', character.x+5, character.y, mousex - character.x, mousey - character.y, 15)
                               -- Effect(onhit,style,   x,                   y,                 vx,              vy,            raio)
        self.cooldown = 2
    end
end

return cooldown, foo
