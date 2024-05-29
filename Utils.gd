extends Node

var _params = null

func calucluate_attack_damage(actor_stats: CharacterStats, target_stats: CharacterStats) -> int:
	return _clamped_damage(actor_stats.incursion_power - target_stats.refrain_power)
	
func calucluate_skill_damage(action: Action) -> int:
	match action.skill.id:
		Skill.Id.ETH_INCURSION_SMALL:
			return _clamped_damage((action.actor_stats.incursion_power - action.target_stats.refrain_power) * 2)
		_:
			return 0
			
func process_buff(action: Action) -> void:
	match action.skill.id:
		Skill.Id.ETH_REFRAIN_SMALL:
			action.actor_stats.refrain_power *= 2

func change_scene(next_scene, params=null):
	_params = params
	get_tree().change_scene_to_file(next_scene)

func get_param(key):
	if _params != null and _params.has(key):
		return _params[key]
	return null
	
func _clamped_damage(value):
	return clamp(value, 1, INF)
