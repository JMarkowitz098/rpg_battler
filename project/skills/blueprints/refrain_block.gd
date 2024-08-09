extends Ingress
class_name RefrainBlock

@export var id: Id = Id.REFRAIN_BLOCK
@export var type: Type = Type.REFRAIN
@export var target: Target = Target.ALLY


func process(action: Action, _tree: SceneTree, _battle_groups: BattleGroups) -> void:
	action.actor.use_ingress(action.skill.ingress)
	if not Utils.is_test: await _play_refrain_animation(action)
	_set_refrain_block(action.actor, action.target, action.skill.element)


func is_incursion() -> bool: return Ing.is_incursion(type)
func is_refrain() -> bool: return Ing.is_refrain(type)
func has_target() -> bool: return Ing.has_target(target)
func format_for_save() -> Array: return Ing.format_for_save(id, element)
