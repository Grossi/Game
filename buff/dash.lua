local timer = 1.1
local foo
local args = {}
foo = function(self, character, dt, stage)
    if(self.timer == 1) then
        self.args.status = character.status
        character.status = 'Stun'
    end
    character:dislocate(stage, character.spd*dt*5, 0)
    if(self.timer < 0.0) then
        character.status = self.args.status
        return false
    end
    self.timer = self.timer - dt
    return true
end

return foo, timer, args

--False ---> Destroy the buff
--True ---> Do nothing
