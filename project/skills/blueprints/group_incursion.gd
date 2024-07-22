extends Ingress
class_name GroupIncursion

@export var id: Id = Id.GROUP_INCURSION
@export var type: Type = Type.INCURSION
@export var target: Target = Target.ALL_ENEMIES


func process(action: Action, _tree: SceneTree, battle_groups: BattleGroups) -> void:
	if not Utils.is_test: await _play_attack_animation(action)
	action.actor.use_ingress(action.skill.ingress)

	var targets: Array[Node2D]
	if action.get_actor_type() == Player.Type.PLAYER:
		targets = battle_groups.enemies
	else: 
		targets = battle_groups.players
	for player in targets:
		await _damage_target(player, action)


func _damage_target(player: Node2D, action: Action) -> void:
	action.target = player
	await player.take_damage(Utils.calculate_skill_damage(action))

   
func is_incursion() -> bool: return Ing.is_incursion(type)
func is_refrain() -> bool: return Ing.is_refrain(type)
func has_target() -> bool: return Ing.has_target(target)
func format_for_save() -> Array: return Ing.format_for_save(id, element)