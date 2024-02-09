# CS2D-Percent-Health-Module
Makes the health in-game a percentage as opposed to an integer value, allowing for higher health counts.

Hello! I've created this health module that can be quite easy to integrate into pretty much any script. (As long as you have the Lua knowledge to do so.)

**You'd need to have a decent knowledge in Lua in order to make good use of this module!**

CS2D only supports up to 250 health, this means you can't have more than 250 health points.
The workaround was to have the health script sided and presented with a HUD of some sort.

It would go like this:
You'd lose your Lua scripted health and then your CS2D health and then, you'd die.

But I find that quite lame, what if you could make some use of your CS2D health? Maybe use it to... Present your health?
Crazy idea! I know, using your health to present your health may sound crazy but hear me out on this one.
I've created a script that presents your health using your CS2D health in a percentile manner.
If your Lua health is 100/1000 then your CS2D health would be 10 to represent 10%!

In a nutshell your health is similar to that of a building.

This script also only affects players who're supposed to have it affect them.

After integrating it you may use it as such:
```lua
sp.percent_health.add_player(1)
sp.percent_health.set_max_health(1, 2000)
sp.percent_health.set_cur_health(1, 2000)
```
This will set player id `1`'s max and current health to `2000`.

# Functions:
- Must use to initialize a player, all players are reset on round start.
`sp.percent_health.add_player(p)`

- Use this to reset a player manually.
`sp.percent_health.rem_player(p)`

- Set current health of a player.
`sp.percent_health.set_cur_health(p, health)`

- Set max health of a player.
`sp.percent_health.set_max_health(p, health)`

- Receive values from a specific player.
`sp.percent_health.get(p, value)`

# Values (string):
```lua
"added",
"current_health",
"max_health"
```

# Configuration Variables:
```lua
config.debug_hit_hook	= false	-- Debug the hit hook?
config.show_credits		= true	-- Show credits in the console on load?
```

# Lua Stats
- Hooks: 3
- Lines of code: 171
- Is commented: Yes.
- Time to create: About 2 hours.
