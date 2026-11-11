-- SPDX-License-Identifier: GPL-3.0-only
-- Copyright (C) 2026 8a7l

-- Table to store active physics modifiers for each player
-- Таблиця для зберігання активних фізичних модифікаторів для кожного гравця
lean_physics = { modifiers = {} }

-- Add or update a modifier for a player
-- Додати або оновити множник для гравця
function lean_physics.set_modifier(player_name, source, mods)
    lean_physics.modifiers[player_name] = lean_physics.modifiers[player_name] or {}
    lean_physics.modifiers[player_name][source] = mods
    lean_physics.apply(player_name)
end

-- Clear a specific modifier (e.g., when a biome effect ends)
-- Очистити конкретний множник (наприклад, коли ефект біому закінчується)
function lean_physics.clear_modifier(player_name, source)
    if lean_physics.modifiers[player_name] then
        lean_physics.modifiers[player_name][source] = nil
        lean_physics.apply(player_name)
    end
end

-- Apply all active modifiers to the player's physics
-- Застосувати всі активні множники до фізики гравця
function lean_physics.apply(player_name)
    local player = minetest.get_player_by_name(player_name)
    if not player then return end
    
    local data = lean_physics.modifiers[player_name]
    
    -- Base values (1.0 means no change)
    -- Базові значення (1.0 означає без змін)
    local final_speed = 1.0
    local final_jump = 1.0
    local final_gravity = 1.0
    
    if data then
        -- Multiply all active modifiers together
        -- Перемножити всі активні множники
        for _, mods in pairs(data) do
            if mods.speed then final_speed = final_speed * mods.speed end
            if mods.jump then final_jump = final_jump * mods.jump end
            if mods.gravity then final_gravity = final_gravity * mods.gravity end
        end
    end
    
    -- Apply the final calculated physics
    -- Застосувати фінальну розраховану фізику
    player:set_physics_override({
        speed = final_speed,
        jump = final_jump,
        gravity = final_gravity
    })
end

-- Clean up data when a player leaves
-- Очищення даних, коли гравець виходить
minetest.register_on_leaveplayer(function(player)
    lean_physics.modifiers[player:get_player_name()] = nil
end)