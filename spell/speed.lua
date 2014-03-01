local cooldown = 5
local foo = function(self, character, stage, dt, mousex, mousey)
    if(self.cooldown < 0) then
        self.cooldown = 0
    end
    if(self.cooldown == 0) then
        character.buffs['speed'] = Buff('speed', character)
        self.cooldown = 5
    end
end

return cooldown, foo
