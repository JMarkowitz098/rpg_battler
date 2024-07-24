extends Ingress
class_name Incursion

@export var id: Id = Id.INCURSION
@export var type: Type = Type.INCURSION
@export var target: Target = Target.ENEMY


func process(action: Action, tree: SceneTree, _battle_groups: BattleGroups) -> void:
	if not Utils.is_test: 
		await _play_attack_animation(action)
		await _play_ingress_animation(action, tree)
	action.actor.use_ingress(action.skill.ingress)
	var damage := Utils.calculate_skill_damage(action)
	await action.target.take_damage(damage)


func is_incursion() -> bool: return Ing.is_incursion(type)
func is_refrain() -> bool: return Ing.is_refrain(type)
func has_target() -> bool: return Ing.has_target(target)
func format_for_save() -> Array: return Ing.format_for_save(id, element)

