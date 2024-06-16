extends Node

const FINAL_ROUND = 1

var _params = null
var round_number := 0

func calucluate_attack_damage(actor_stats: Stats, target_stats: Stats) -> int:
	return _clamped_damage(actor_stats.level_stats.incursion - target_stats.level_stats.refrain)
	
func calucluate_skill_damage(action: Action) -> int:
	match action.skill.id:
		Skill.Id.ETH_INCURSION, Skill.Id.ENH_INCURSION, Skill.Id.SHOR_INCURSION, Skill.Id.SCOR_INCURSION, Skill.Id.ETH_INCURSION_DOUBLE, Skill.Id.SHOR_INCURSION_DOUBLE:
			var actor_power = action.actor.stats.level_stats.incursion + action.skill.ingress
			var target_power = action.target.stats.level_stats.refrain
			
			if action.target.stats.is_dodging:
				var dodged =  randi() % 2 == 1
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

func change_scene(next_scene, params=null):
	_params = params
	get_tree().change_scene_to_file(next_scene)

func get_param(key):
	if _params != null and _params.has(key):
		return _params[key]
	return null
	
func _clamped_damage(value):
	return clamp(value, 0, INF)
	

