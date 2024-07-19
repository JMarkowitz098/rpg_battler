extends Ingress
class_name Recover

@export var id: Id = Id.RECOVER
@export var type: Type = Type.RECOVER
@export var target: Target = Target.SELF


func process(action: Action, _tree: SceneTree, _battle_groups: BattleGroups) -> void:
	await _play_refrain_animation(action)
	action.actor.use_ingress(-1)


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
