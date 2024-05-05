--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(entity)
    self.entity = entity

    if self.entity.projectile then
        self.entity:changeAnimation('idle-pot-' .. self.entity.direction)
    else
        self.entity:changeAnimation('idle-' .. self.entity.direction)
    end

    -- used for AI waiting
    self.waitDuration = 0
    self.waitTimer = 0
end

function PlayerIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if not self.entity.projectile then 
        if love.keyboard.wasPressed('space') then
            self.entity:changeState('swing-sword')
        end
        if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
            self.entity:changeState('pot-lift')
        end
    else
        if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
            self.entity.frame = 111
            self.entity.projectile:throw(self.entity.direction)
            self.entity.projectile = nil
            self.entity:changeState('idle')
        end
    end

end