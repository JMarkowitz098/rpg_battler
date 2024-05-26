extends Node

var _params = null

func calucluate_attack_damage(actor_stats: CharacterStats, target_stats: CharacterStats) -> int:
	return actor_stats.attack - target_stats.defense
	
func calucluate_skill_damage(action: Action) -> int:
	
	match action.skill.id:
		Skill.Id.DOUBLE_SLASH:
			return (action.actor_stats.attack - action.target_stats.defense) * 2
		Skill.Id.TRIPLE_SLASH:
			return (action.actor_stats.attack - action.target_stats.defense) * 3
		_:
			return 0

func change_scene(next_scene, params=null):
	_params = params
	get_tree().change_scene_to_file(next_scene)

func get_param(name):
	if _params != null and _params.has(name):
		return _params[name]
	return null
