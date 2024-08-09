extends Ingress
class_name GroupIncursion

@export var id: Id = Id.GROUP_INCURSION
@export var type: Type = Type.INCURSION
@export var target: Target = Target.ALL_ENEMIES


func process(action: Action, _tree: SceneTree, battle_groups: BattleGroups) -> void:
	if not Utils.is_test: await _play_attack_animation(action)

	var targets: Array[Node2D]
	if action.get_actor_type() == Player.Type.PLAYER:
		targets = battle_groups.enemies
	else: 
		targets = battle_groups.players

	var last_index := targets.size() - 1

	await _process_animations(last_index, targets, action, _tree)
	await _process_take_damage(last_index, targets, action)

	action.actor.use_ingress(action.skill.ingress)


func _process_animations(last_index: int, targets: Array[Node2D], action: Action, tree: SceneTree) -> void:
	var current_target: Node2D
	for index in range(last_index):
			current_target = targets[index]
			action.target = current_target
			_play_ingress_animation(action, tree)
	current_target = targets.back()
	action.target = current_target
	if not Utils.is_test: await _play_ingress_animation(action, tree)


func _process_take_damage(last_index: int, targets: Array[Node2D], action: Action) -> void:
	var current_target: Node2D
	for index in range(last_index):
			current_target = targets[index]
			_damage_target(current_target, action)
	current_target = targets.back()
	await _damage_target(current_target, action)


func _damage_target(player: Node2D, action: Action) -> void:
	action.target = player
	await player.take_damage(Utils.calculate_skill_damage(action), action)

   
func is_incursion() -> bool: return Ing.is_incursion(type)
func is_refrain() -> bool: return Ing.is_refrain(type)
func has_target() -> bool: return Ing.has_target(target)
func format_for_save() -> Array: return Ing.format_for_save(id, element)