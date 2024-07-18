extends NewIngress
class_name Refrain

@export var id: Id = Id.REFRAIN
@export var type: Type = Type.REFRAIN
@export var target: Target = Target.SELF

func process(action: Action, _tree: SceneTree, _battle_groups: BattleGroups) -> void:
	await _play_refrain_animation(action)
	_set_refrain(action.target, action.skill.element)


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
