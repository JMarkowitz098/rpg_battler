extends Ingress
class_name Incursion

@export var id: Id = Id.INCURSION
@export var type: Type = Type.INCURSION
@export var target: Target = Target.ENEMY


func process(action: Action, tree: SceneTree, _battle_groups: BattleGroups) -> void:
	await _play_attack_animation(action)
	await _play_ingress_animation(action, tree)
	action.actor.use_ingress(action.skill.ingress)
	var damage := Utils.calculate_skill_damage(action)
	action.target.take_damage(damage)


func is_incursion() -> bool:
	return type == Type.INCURSION


func is_refrain() -> bool:
	return type == Type.REFRAIN


func has_target() -> bool:
	match target:
		Target.SELF, Target.ENEMY, Target.ALLY:
			return true
		_:
			return false


func format_for_save() -> Array:
	return [id, element]
