--[[
    GD50
    Legend of Zelda

    Author: Valentin Wissler
]]

PlayerPotWalkState = Class{__includes = EntityWalkState}

function PlayerPotWalkState:init(player, dungeon)
    self.entity = player 
    self.dungeon = dungeon
    self.pot = self.entity.projectile
end

function PlayerPotWalkState:enter(params)
    self.entity:changeAnimation('walk-pot-' .. self.entity.direction)
    self.entity.currentAnimation:refresh()
end

function PlayerPotWalkState:update(dt)
    -- the pot follows the entity
    -- self.pot.x = self.entity.x
    -- self.pot.y = self.entity.y - self.pot.height

    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    end

    -- perform base collision detection against walls and objects
    EntityWalkState.update(self, dt, {objects = self.dungeon.currentRoom.objects})
end

function PlayerPotWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))

    --
    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end