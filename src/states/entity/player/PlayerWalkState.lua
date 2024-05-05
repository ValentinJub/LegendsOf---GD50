--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        if self.entity.projectile then
            self.entity:changeAnimation ('walk-pot-left')
        else
            self.entity:changeAnimation('walk-left')
        end
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        if self.entity.projectile then
            self.entity:changeAnimation('walk-pot-right')
        else
            self.entity:changeAnimation('walk-right')
        end 
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        if self.entity.projectile then
            self.entity:changeAnimation('walk-pot-up')
        else
            self.entity:changeAnimation('walk-up')
        end 
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        if self.entity.projectile then
            self.entity:changeAnimation('walk-pot-down')
        else
            self.entity:changeAnimation('walk-down')
        end 
    else
        self.entity:changeState('idle')
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
            self.entity:changeState('walk')
        end
    end

    -- perform base collision detection against walls and objects
    EntityWalkState.update(self, dt, {objects = self.dungeon.currentRoom.objects})

    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then
            
            -- temporarily adjust position into the wall, since bumping pushes outward
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-left')
                end
            end

            -- readjust
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'right' then
            
            -- temporarily adjust position
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-right')
                end
            end

            -- readjust
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'up' then
            
            -- temporarily adjust position
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-up')
                end
            end

            -- readjust
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
        else
            
            -- temporarily adjust position
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-down')
                end
            end

            -- readjust
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
        end
    end
end