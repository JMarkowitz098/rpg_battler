class_name ProcessQueue

const INGRESS_ANIMATION = preload("res://skills/ingress_animation.tscn")


func process_action_queue(
	items: Array[ActionQueueItem],
	tree: SceneTree,
	battle_groups: BattleGroups,
) -> void:
	while items.size() > 0:
		var action: Action = items.pop_front().action
		if _can_use_skill(action): await(action.skill.process(action, tree, battle_groups))
		await tree.create_timer(2).timeout

func _can_use_skill(action: Action) -> bool:
	if not action.actor:
		return false
	if action.actor.modifiers.current_ingress - action.skill.ingress <= 0:
		print("Not enough Ingress")
		return false
	return true


# Will be moved into skills own class

# func _use_group_incursion(action: Action, enemies: Array[Node2D]) -> void:
# 	await _play_attack_animation(action)
# 	for enemy in enemies:
# 		action.target = enemy
# 		var damage := Utils.calculate_skill_damage(action)
# 		enemy.take_damage(damage)


# func _use_group_refrain(action: Action, battle_groups: BattleGroups) -> void:
# 	await _play_refrain_animation(action)
# 	var targets := (
# 		battle_groups.players
# 		if action.get_actor_type() == Player.Type.PLAYER
# 		else battle_groups.enemies
# 	)
# 	for target in targets:
# 		_set_refrain(target, action.skill.element)


# func _use_movement(action: Action) -> void:
# 	await _play_refrain_animation(action)
# 	action.actor.modifiers.plus_agility += action.actor.stats.agility
# 	action.actor.set_is_eth_dodging(true)
# 	action.actor.set_dodge_animation(true)


# func _use_recover(action: Action) -> void:
# 	await _play_refrain_animation(action)
# 	action.actor.use_ingress(-1)

