--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotLiftState = Class{__includes = BaseState}

function PlayerPotLiftState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif direction == 'right' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y + self.player.height
    end

    -- separate hitbox for the player's sword; will only be active during this state
    self.reachHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
end

function PlayerPotLiftState:liftPot()
    local destinationX, desitinationY = self.player.x, self.player.y - self.pot.height / 2
    Timer.tween(0.3, {
        [self.pot] = {x = destinationX, y = desitinationY}
    })
end

function PlayerPotLiftState:getPot()
    -- go through the objects and find the pot that collides with reachHitbox
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object.type == 'pot' and object:collides(self.reachHitbox) then
            return object
        end
    end
    return nil
end

function PlayerPotLiftState:makePotThrowable()
    self.pot.consumed = true
    local pot = Projectile(
        PROJECTILE_DEFS['pot'],
        self.pot.x,
        self.pot.y,
        self.player
    )
    self.pot = pot
    table.insert(self.dungeon.currentRoom.throwable, pot)
end

function PlayerPotLiftState:enter(params)
    self.pot = self:getPot()

    -- change state immediately if no pot can be picked up
    if self.pot == nil then
        self.player:changeState('idle')
    else 
        -- lift-pot-up, lift-pot-right, etc...
        self.player:changeAnimation('lift-pot-' .. self.player.direction)
        self:makePotThrowable()
        -- create a Tween so that the pot is shifted above the player
        self:liftPot()
        self.player.projectile = self.pot
        -- restart animation
        self.player.currentAnimation:refresh()
    end
end

function PlayerPotLiftState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change to pot walk state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end
end

function PlayerPotLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x), math.floor(self.player.y))

    --
    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end