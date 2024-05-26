extends Node

var _params = null

func calucluate_attack_damage(actor_stats: CharacterStats, target_stats: CharacterStats) -> int:
	return _clamped_damage(actor_stats.attack - target_stats.defense)
	
func calucluate_skill_damage(action: Action) -> int:
	match action.skill.id:
		Skill.Id.DOUBLE_SLASH:
			return _clamped_damage((action.actor_stats.attack - action.target_stats.defense) * 2)
		Skill.Id.TRIPLE_SLASH:
			return _clamped_damage((action.actor_stats.attack - action.target_stats.defense) * 3)
		_:
			return 0
			
func process_buff(action: Action) -> void:
	match action.skill.id:
		Skill.Id.FLEX:
			action.actor_stats.attack *= 2
		Skill.Id.COY:
			action.actor_stats.defense *= 2

func change_scene(next_scene, params=null):
	_params = params
	get_tree().change_scene_to_file(next_scene)

func get_param(name):
	if _params != null and _params.has(name):
		return _params[name]
	return null
	
func _clamped_damage(value):
	return clamp(value, 1, INF)
