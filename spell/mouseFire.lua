local cooldown = 2
local foo = function(self, character, stage, dt, mousex, mousey)
    if(self.cooldown < 0) then
        self.cooldown = 0
    end
    if(self.cooldown == 0) then
        for i = 1, 10 do
            stage.effects['mouseFire' .. i] = Effect(nil, 0.2, 'circle', mousex, mousey, ((i%3)+3)*-81, ((10-i)%4-2)*79, 2) 
        end
        for i = 1, 10 do
            stage.effects['mouseFire' .. i+10] = Effect(nil, 0.2, 'circle', mousex, mousey, ((i%5)+-1)*81, ((10-i)%4-2)*-79, 2) 
        end
        for i = 1, 10 do
            stage.effects['mouseFire' .. i+20] = Effect(nil, 0.2, 'circle', mousex, mousey, ((i%3)-1)*-81, ((10-i)%4+2)*-79, 2) 
        end
        for i = 1, 10 do
            stage.effects['mouseFire' .. i+30] = Effect(nil, 0.2, 'circle', mousex, mousey, ((i%3)+1)*81, ((10-i)%4+1)*79, 2) 
        end
                               -- Effect(onhit,style,   x,                   y,                 vx,              vy,            raio)
        self.cooldown = 1
    end
end

return cooldown, foo
