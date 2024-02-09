print('[Lua]: Attempting to load module: Percent Health')


-- ----------------------------------------------------------------------------------------------------
-- Core Initialization
-- ----------------------------------------------------------------------------------------------------

local _math			= require 'math'
local math_ceil		= _math.ceil
local math_min		= _math.min
local exec			= parse
local pl			= player
local addevent		= addhook
local chat			= msg

if not sp then sp = { } end

sp.percent_health = { config = { }, players = { } }


-- ----------------------------------------------------------------------------------------------------
-- Configuration
-- ----------------------------------------------------------------------------------------------------

local config = sp.percent_health.config	-- Ignore.

config.debug_hit_hook	= true			-- Debug the hit hook?
config.show_credits		= true			-- Show credits in the console on load?


-- ----------------------------------------------------------------------------------------------------
-- Internal Functions
-- ----------------------------------------------------------------------------------------------------

-- Used to specify where the message came from. In this case; this script.
local console = function(text)
	print('[Percent Health]: ' .. text)
end


-- ----------------------------------------------------------------------------------------------------
-- External Functions
-- ----------------------------------------------------------------------------------------------------

-- Must use to initialize a player, all players are reset on round start.
function sp.percent_health.add_player(p)
	sp.percent_health.players[p] = { pl(p, 'health'), pl(p, 'maxhealth') }
end

-- Use this to reset a player manually.
function sp.percent_health.rem_player(p)
	sp.percent_health.players[p] = false
end

-- Set current health of a player, no more than max health.
function sp.percent_health.set_cur_health(p, health)
	local health_table = sp.percent_health.players[p]
	
	if pl(p, 'exists') and health_table then
		local current_health, max_health = health_table[1], health_table[2]
		
		health_table[1] = math_min(health, max_health)
		
		exec('sethealth ' .. p .. ' ' .. math_ceil(current_health / max_health * 100))
			
		return true
	end
	
	return false
end

-- Set max health of a player.
function sp.percent_health.set_max_health(p, health)
	local health_table = sp.percent_health.players[p]
	
	if pl(p, 'exists') and health_table then
		local current_health, max_health = health_table[1], health_table[2]
		
		current_health = health
		sp.percent_health.players[p][2] = current_health
		
		exec('sethealth ' .. p .. ' ' .. math_ceil(current_health / max_health * 100))
		
		return true
	end
	
	return false
end

-- Receive values from a specific player.
-- added			- Is the player added by sp.percent_health.add_player?
-- current_health	- What is the player's current health? Lua only.
-- max_health		- What is the player's current max health? Lua only.
function sp.percent_health.get(p, value)
	if value == 'added' then
		return (sp.percent_health.players[p] and true) or false
	elseif value == 'current_health' then
		return (sp.percent_health.get(p, 'added') and sp.percent_health.players[p][1]) or false
	elseif value == 'max_health' then
		return (sp.percent_health.get(p, 'added') and sp.percent_health.players[p][2]) or false
	end
	
	return nil
end


-- ----------------------------------------------------------------------------------------------------
-- Hooks Callback
-- ----------------------------------------------------------------------------------------------------

-- Core hook, used to allow more than 100 health (using percent health).
function sp.percent_health.hit_hook(victim, source, weapon, hpdmg, apdmg, rawdmg, object_id)
	local health_table = sp.percent_health.players[victim]
	
	if health_table then
		local current_health, max_health = health_table[1], health_table[2]
		
		current_health = current_health - hpdmg
		
		
		if current_health > 0 then
			health_table[1] = current_health
			
			local newhealth = math_ceil(current_health / max_health * 100)
			
			exec('sethealth ' .. victim .. ' ' .. newhealth)
			
			if config.debug_hit_hook then
				chat('[DEBUG]: max_health=' .. max_health .. ' - current_health=' .. current_health)
				chat('[DEBUG]: ' .. newhealth .. ' %')
			end
		else
			health_table = false
			
			exec('customkill ' .. source .. ' "' .. itemtype(weapon, 'name') .. '" ' .. victim)
			
			if config.debug_hit_hook then
				chat('[DEBUG]: max_health=' .. max_health .. ' - current_health=' .. current_health)
				chat('[DEBUG]: 0 %')
			end
		end
		
		return 1
	end
end

-- Reset all players on round start, recommended.
function sp.percent_health.startround_hook(mode)
	for i = 1, 32 do
		sp.percent_health.players[i] = false
	end
end

-- Update hook when a player spawns.
function sp.percent_health.spawn_hook(p)
	local health_table = sp.percent_health.players[p]
	
	if health_table then
		health_table[1] = health_table[2]
	end
end


-- ----------------------------------------------------------------------------------------------------
-- Module Initialization
-- ----------------------------------------------------------------------------------------------------

-- Initialize the module.
function sp.percent_health.init(config)
	-- Attaching hooks/events.
	addevent('hit',			'sp.percent_health.hit_hook',			100000)
	addevent('startround',	'sp.percent_health.startround_hook',	100000)
	addevent('spawn',		'sp.percent_health.spawn_hook',			100000)
	
	sp.percent_health.startround_hook(0) -- Making sure the startround hook is called upon load.
	
	console('Loaded successfully.')
	
	if config.show_credits then
		console('Author: SlowPoke101 (U.S.G.N.: #99153)')
		console('Date: 10/09/2019')
		console('Build: 3')
	end
end

sp.percent_health.init(config)