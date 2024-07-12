extends Node

enum GameOver {
	VICTORY,
	DEFEAT
}

const TALON_PORTRAIT := preload("res://players/Talon/TalonPortrait.jpeg")
const TALON_PLAYER_DETAILS := preload("res://players/Talon/talon_player_details.tres")
const NASH_PORTRAIT := preload("res://players/Nash/NashPortrait.jpeg")
const NASH_PLAYER_DETAILS = preload("res://players/Nash/nash_player_details.tres")
const ESEN_PORTRAIT := preload("res://players/Esen/esen_portrait.jpeg")
const ESEN_PLAYER_DETAILS := preload("res://players/Esen/esen_player_details.tres")

const FINAL_ROUND = Round.Number.THREE

var _params: Dictionary
var current_round := Round.Number.ONE
# var current_round := Round.Number.THREE # For testing

func calucluate_attack_damage(actor_stats: Stats, target_stats: Stats) -> int:
	return _clamped_damage(actor_stats.level_stats.incursion - target_stats.level_stats.refrain)
	
func calculate_skill_damage(action: Action) -> int:
	match action.skill.id:
		Ingress.Id.INCURSION, Ingress.Id.DOUBLE_INCURSION, Ingress.Id.GROUP_INCURSION, Ingress.Id.PIERCING_INCURSION:
			var incursion_power: int = action.actor.stats.level_stats.incursion
			if action.skill.id == Ingress.Id.INCURSION:
				incursion_power += action.skill.ingress
			else:
				incursion_power += action.skill.ingress / 2


			var target_refrain: int = action.target.stats.level_stats.refrain
			
			if _is_dodged(action): return 0
				
			if action.target.stats.has_small_refrain_open:
				return _get_refrain_damage(action, incursion_power)
	
			return _clamped_damage(incursion_power - target_refrain)
		_:
			return 0

func _is_dodged(action: Action) -> bool:
	if action.target.stats.is_dodging:
		return randi() % 2 == 1
	elif action.target.stats.is_eth_dodging:
		return randi() % 4 == 1

	return false

func _get_refrain_damage(action: Action, incursion_power: int) -> int:
	action.target.stats.has_small_refrain_open = false #TODO: This should be somewhere else
	action.target.refrain_aura.hide() #TODO: This should be somewhere else

	var multiplier: int
	if action.skill.id == Ingress.Id.PIERCING_INCURSION:
		multiplier = 2
	else:
		multiplier = 1

	if action.skill.element == action.target.stats.current_refrain_element:
		return incursion_power * multiplier * -1
	elif action.skill.id == Ingress.Id.PIERCING_INCURSION:
		return incursion_power * multiplier
	else:
		return 0


func change_scene(next_scene: String, params: Dictionary) -> void:
	_params = params
	get_tree().change_scene_to_file(next_scene)

func get_param(key: String) -> Variant:
	if _params != null and _params.has(key):
		return _params[key]
	return null

func next_round() -> void:
	match(current_round):
		Round.Number.ONE:
			current_round = Round.Number.TWO
		Round.Number.TWO:
			current_round = Round.Number.THREE
	
func _clamped_damage(value: int) -> int:
	return clamp(value, 1, INF)

func get_player_portrait(player_id: Player.Id) -> Texture:
	match(player_id):
		Player.Id.TALON:
			return TALON_PORTRAIT
		Player.Id.NASH:
			return NASH_PORTRAIT
		Player.Id.ESEN:
			return ESEN_PORTRAIT
		_:
			return null

func get_player_details(player_id: Player.Id) -> Resource:
	match(player_id):
		Player.Id.TALON:
			return TALON_PLAYER_DETAILS
		Player.Id.NASH:
			return NASH_PLAYER_DETAILS
		Player.Id.ESEN:
			return ESEN_PLAYER_DETAILS
		_:
			return null
