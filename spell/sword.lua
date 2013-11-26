local cooldown = 2
local foo = function(self, character, stage, dt, mousex, mousey)
    if(self.cooldown < 0) then
        self.cooldown = 0
    end
    if(self.cooldown == 0) then
        stage.effects['Sword'] = Effect(nil, 0.2,  'circle', character.x, character.y - 50, 400, 400, 15)
        stage.effects['Sword2'] = Effect(nil, 0.15,  'circle', character.x, character.y - 20, 300, 300, 15)
                               -- Effect(onhit,style,   x,                   y,                 vx,              vy,            raio)
        self.cooldown = 2
    end
end

return cooldown, foo
