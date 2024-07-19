extends Ingress
class_name DoubleIncursion

@export var id: Id = Id.DOUBLE_INCURSION
@export var type: Type = Type.INCURSION
@export var target: Target = Target.ENEMY


func process(action: Action, tree: SceneTree, _battle_groups: BattleGroups) -> void:
	await _use_incursion(action, tree)
	if action.target:
		await tree.create_timer(2).timeout
		await _use_incursion(action, tree)

func _use_incursion(action: Action, tree: SceneTree) -> void:
	await _play_attack_animation(action)
	await _play_ingress_animation(action, tree)
	action.actor.use_ingress(action.skill.ingress)
	var damage := Utils.calculate_skill_damage(action)
	action.target.take_damage(damage)


func is_incursion() -> bool: return Ing.is_incursion(type)
func is_refrain() -> bool: return Ing.is_refrain(type)
func has_target() -> bool: return Ing.has_target(target)
func format_for_save() -> Array: return Ing.format_for_save(id, element)
