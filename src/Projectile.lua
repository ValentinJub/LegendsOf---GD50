--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(def, x, y, player)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- to track the player's pos
    self.player = player
    
    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    self.throw_length = def.throw_length
    self.maxX = nil
    self.maxY = nil

    self.follow = true
    self.thrown = false
    self.consumed = false
    self.direction = nil

    -- default empty collision callback
    self.onCollide = function() end
end

function Projectile:throw(direction)
    self.follow = false
    self.thrown = true
    self.direction = direction
    self:setMaxDestination()
end

function Projectile:setMaxDestination()
    if self.direction == 'left' then
        self.maxX = self.x - self.throw_length
    elseif self.direction == 'right' then
        self.maxX = self.x + self.throw_length
    elseif self.direction == 'up' then
        self.maxY = self.y - self.throw_length
    elseif self.direction == 'down' then
        self.maxY = self.y + self.throw_length
    end
end

function Projectile:update(dt)

    if self.follow then
        self.x = self.player.x
        self.y = self.player.y - self.height / 2
    elseif self.thrown then
        if self.direction == 'left' then
            self.x = self.x - 100 * dt
            -- if we've reached the end of our throw, remove the projectile
            if self.x < self.maxX then
                self.consumed = true
                self.thrown = false
            end
        elseif self.direction == 'right' then
            self.x = self.x + 100 * dt
            if self.x > self.maxX then
                self.consumed = true
                self.thrown = false
            end
        elseif self.direction == 'up' then
            self.y = self.y - 100 * dt
            if self.y < self.maxY then
                self.consumed = true
                self.thrown = false
            end
        elseif self.direction == 'down' then
            self.y = self.y + 100 * dt
            if self.y > self.maxY then
                self.consumed = true
                self.thrown = false
            end
        end
    end

    if self.x < MAP_RENDER_OFFSET_X + TILE_SIZE or self.x > VIRTUAL_WIDTH - TILE_SIZE * 2 or
        self.y < MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 or self.y > VIRTUAL_HEIGHT - TILE_SIZE * 2 then
        self.consumed = true
        self.thrown = false
    end
end

function Projectile:collides(target) 
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Projectile:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x, self.y)
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end