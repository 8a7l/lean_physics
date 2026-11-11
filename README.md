# Lean Physics API

A lightweight, centralized physics manager for Luanti mods.

## The Problem

In Luanti, when you call `player:set_physics_override()`, it completely overwrites the player's current speed, jump, and gravity. If multiple mods (e.g., a potion mod, a biome mod, and an armor mod) try to change physics at the same time, they will overwrite each other. The last mod to run wins.

## The Solution

**Lean Physics** acts as a dispatcher. Mods register their physics modifiers under a unique "source" name, and this API multiplies them together before applying the final result to the player.

## API Usage

### 1. Set a modifier
```lua
-- player_name: The name of the player
-- source: A unique string to identify your mod/effect (e.g., "potion_speed", "biome_snow")
-- mods: A table with speed, jump, and/or gravity multipliers
lean_physics.set_modifier(player_name, "my_mod_effect", {
    speed = 1.5,
    jump = 1.2,
    gravity = 0.8
})
```

### 2. Clear a modifier
When the effect ends (e.g., a potion wears off), remove your modifier. The API will automatically recalculate physics based on what's left.
```lua
lean_physics.clear_modifier(player_name, "my_mod_effect")
```

## Example

If a player is in a snowy biome (`speed = 0.8`) and drinks a speed potion (`speed = 1.5`), Lean Physics calculates:
`1.0 (base) * 0.8 (biome) * 1.5 (potion) = 1.2`
The player will run faster than normal, but slower than they would in a normal biome.

## License

- **Code:** GPL-3.0-only (Copyright (C) 2026 8a7l)
