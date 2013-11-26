------------------ Bounding Box ------------------

Bbox = function(obj, ...) 
    local tab = {}
    -- Initialize both the max and min x and y as the first point of the object
    local maxx, maxy = obj.vx[1], obj.vy[1]
    local minx, miny = maxx, maxy
    -- Gets the actual max and min x and y of the object
    for i = 1, #obj.vx do
        if obj.vx[i] > maxx then
            maxx = obj.vx[i]
        elseif obj.vx[i] < minx then
            minx = obj.vx[i]
        end
        if obj.vy[i] > maxy then
            maxy = obj.vy[i]
        elseif obj.vy[i] < miny then
            miny = obj.vy[i]
        end
    end
    tab.maxx = maxx
    tab.maxy = maxy
    tab.minx = minx
    tab.miny = miny
    -- tests the collision of self with another boundind box, returning true or false
    tab.collision = function ( self, bb )
        local collision = false
        local xcollision = false
        -- tests collision on x first
        if self.maxx < bb.maxx then
            if self.maxx > bb.minx then
                xcollision = true
            end
        elseif self.minx > bb.minx then
            if self.minx < bb.maxx then
                xcollision = true
            end
        end
        if xcolision then
            -- test collision on y only if the bounding box collide on x
            if self.maxy < bb.maxy then
                if self.maxy > bb.miny then
                    collision = true
                end
            elseif self.miny > bb.miny then
                if self.miny < bb.maxy then
                    collision = true
                end
            end
        end
        return collision
    end
    return tab
end
