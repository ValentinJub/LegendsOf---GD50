--[[
    GD50
    Legend of Zelda

    Author: Valentin Wissler
    valentinwissler42@outlook.com
]]

PROJECTILE_DEFS = {
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 111,
        width = 16,
        height = 16,
        throw_length = 4 * TILE_SIZE,
        defaultState = 'walk',
        states = {
            ['walk'] = {
                frame = 110
            },
            ['throw'] = {
                frame = 111
            }
        }
    }
}