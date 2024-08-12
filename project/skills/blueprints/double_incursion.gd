extends Ingress
class_name DoubleIncursion

@export var id: Id = Id.DOUBLE_INCURSION
@export var type: Type = Type.INCURSION
@export var target: Target = Target.ENEMY


func process(action: Action, tree: SceneTree, _battle_groups: BattleGroups) -> void:
	action.actor.use_ingress(action.skill.ingress)
	await _use_incursion(action, tree)
	if action.target.modifiers.current_ingress > 0:
		await _use_incursion(action, tree)

func _use_incursion(action: Action, tree: SceneTree) -> void:
	if not Utils.is_test:
		await _play_attack_animation(action)
		await _play_ingress_animation(action, tree)
	var damage := Utils.calculate_skill_damage(action)
	await action.target.take_damage(damage, action)


func is_incursion() -> bool: return Ing.is_incursion(type)
func is_refrain() -> bool: return Ing.is_refrain(type)
func has_target() -> bool: return Ing.has_target(target)
func format_for_save() -> Array: return Ing.format_for_save(id, element)
