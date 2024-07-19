extends Ingress
class_name GroupRefrain

@export var id: Id = Id.GROUP_REFRAIN
@export var type: Type = Type.REFRAIN
@export var target: Target = Target.ALL_ALLIES


func process(action: Action, _tree: SceneTree, battle_groups: BattleGroups) -> void:
	await _play_refrain_animation(action)
	var targets: Array[Node2D]

	if action.get_actor_type() == Player.Type.PLAYER:
		targets = battle_groups.players
	else: 
		targets = battle_groups.enemies

	for skill_target in targets:
		_set_refrain(skill_target, action.skill.element)


func is_incursion() -> bool: return Ing.is_incursion(type)
func is_refrain() -> bool: return Ing.is_refrain(type)
func has_target() -> bool: return Ing.has_target(target)
func format_for_save() -> Array: return Ing.format_for_save(id, element)
