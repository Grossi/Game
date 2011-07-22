local timer = 5
local foo
foo = function(self, dt)
    if(self.timer == 5) then
        self.character.spd = self.character.spd + 1000
    end
    self.timer = self.timer - dt
    if(self.timer < 0) then
        self.character.spd = self.character.spd - 1000
        return false
    end
    return true
end

return timer, foo

--False ---> Destroy the buff
--True ---> Do nothing
