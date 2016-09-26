local cooldown = 2
local delay = 0.5

local foo = function(self, character, stage, dt, mousex, mousey)
    if(self.cooldown < 0) then
        self.cooldown = 0
    end
    if(self.cooldown == 0) then
        character.buffs['dash'] = Buff('dash')
        self.cooldown = 2
    end
end

return foo, cooldown, delay
