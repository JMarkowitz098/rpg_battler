extends Node

const FINAL_ROUND = 1

var _params = null
var round_number := 0

func calucluate_attack_damage(actor_stats: CharacterStats, target_stats: CharacterStats) -> int:
	return _clamped_damage(actor_stats.incursion_power - target_stats.refrain_power)
	
func calucluate_skill_damage(action: Action) -> int:
	match action.skill.id:
		Skill.Id.ETH_INCURSION_SMALL, Skill.Id.ENH_INCURSION_SMALL, Skill.Id.SHOR_INCURSION_SMALL, Skill.Id.SCOR_INCURSION_SMALL, Skill.Id.ETH_INCURSION_DOUBLE, Skill.Id.SHOR_INCURSION_DOUBLE:
			var actor_power = action.actor.stats.incursion_power + action.skill.ingress_energy_cost
			var target_power = action.target.stats.refrain_power
			
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
		Skill.Id.ETH_REFRAIN_SMALL, Skill.Id.ENH_REFRAIN_SMALL, Skill.Id.SHOR_REFRAIN_SMALL, Skill.Id.SCOR_REFRAIN_SMALL:
			action.actor.stats.refrain_power *= 2

func change_scene(next_scene, params=null):
	_params = params
	get_tree().change_scene_to_file(next_scene)

func get_param(key):
	#var _params = {"defeated": ["0_88", "0_213"]}
	if _params != null and _params.has(key):
		return _params[key]
	return null
	
func _clamped_damage(value):
	return clamp(value, 0, INF)
	

