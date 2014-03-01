local timer = 5
local start = true
local x
local y
local dirx
local diry
local foo
foo = function(self, dt)
    if self.start == true then
        x = self.character.x
        y = self.character.x
        dirx = self.character.mx
        diry = self.character.my
        self.start = false
    end
    if self.start == false and self.timer > 0 then
        x = x + dirx
        y = y + diry
        self.character.x = x
        self.character.y = y
        self.timer = self.timer - dt
        return true
    end
    return false
end

return timer, foo

--False ---> Destroy the buff
--True ---> Do nothing
