local cooldown = 1
local foo = function(self, character, stage, dt, mousex, mousey)
    if(self.cooldown < 0) then
        self.cooldown = 0
    end
    if(self.cooldown == 0) then
        if(stage.effects['teleport']) then
            character:move( stage, stage.effects['teleport'].x - character.x, stage.effects['teleport'].y - character.y)
            stage.effects['teleport'] = nil
        else
            stage.effects['teleport'] = Effect(nil, 'circle', character.x+character.w+5, character.y+character.h/2, mousex - character.x - character.w/2, mousey - character.y - character.h/2, 5)
        end
        self.cooldown = 0.5
    end
end

return cooldown, foo
