extends Node

const TALON_PORTRAIT := preload("res://players/Talon/TalonPortrait.jpeg")
const TALON_PLAYER_DETAILS := preload("res://players/Talon/talon_player_details.tres")
const NASH_PORTRAIT := preload("res://players/Nash/NashPortrait.jpeg")
const NASH_PLAYER_DETAILS = preload("res://players/Nash/nash_player_details.tres")
const ESEN_PORTRAIT := preload("res://players/Esen/esen_portrait.jpeg")
const ESEN_PLAYER_DETAILS := preload("res://players/Esen/esen_player_details.tres")

const FINAL_ROUND = 2

var _params: Dictionary
var round_number := 0

func calucluate_attack_damage(actor_stats: Stats, target_stats: Stats) -> int:
	return _clamped_damage(actor_stats.level_stats.incursion - target_stats.level_stats.refrain)
	
func calucluate_skill_damage(action: Action) -> int:
	match action.skill.id:
		Ingress.Id.INCURSION:
			var actor_power: int = action.actor.stats.level_stats.incursion + action.skill.ingress
			var target_power: int = action.target.stats.level_stats.refrain
			
			if action.target.stats.is_dodging:
				var dodged :=  randi() % 2 == 1
				if(dodged): return 0
				
			if action.target.stats.has_small_refrain_open:
				action.target.stats.has_small_refrain_open = false
				action.target.refrain_aura.hide()
				if action.skill.element == action.target.stats.current_refrain_element:
					return actor_power * -1
				else:
					return 0
				
			return _clamped_damage(actor_power - target_power)
		_:
			return 0
			
func process_buff(action: Action) -> void:
	match action.skill.id:
		Skill.Id.ETH_REFRAIN, Skill.Id.ENH_REFRAIN, Skill.Id.SHOR_REFRAIN, Skill.Id.SCOR_REFRAIN:
			action.actor.stats.refrain *= 2

func change_scene(next_scene: String, params: Dictionary) -> void:
	_params = params
	get_tree().change_scene_to_file(next_scene)

func get_param(key: String) -> Variant:
	if _params != null and _params.has(key):
		return _params[key]
	return null
	
func _clamped_damage(value: int) -> int:
	return clamp(value, 0, INF)

func get_player_portrait(player_id: Stats.PlayerId) -> Texture:
	match(player_id):
		Stats.PlayerId.TALON:
			return TALON_PORTRAIT
		Stats.PlayerId.NASH:
			return NASH_PORTRAIT
		Stats.PlayerId.ESEN:
			return ESEN_PORTRAIT
		_:
			return null

func get_player_details(player_id: Stats.PlayerId) -> Resource:
	match(player_id):
		Stats.PlayerId.TALON:
			return TALON_PLAYER_DETAILS
		Stats.PlayerId.NASH:
			return NASH_PLAYER_DETAILS
		Stats.PlayerId.ESEN:
			return ESEN_PLAYER_DETAILS
		_:
			return null
