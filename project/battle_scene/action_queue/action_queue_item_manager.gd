class_name ActionQueueItemManager

const ACTION_QUEUE_ITEM := preload("res://battle_scene/action_queue/action_queue_item.tscn")


# ---------------------
# Public Methods
# ---------------------

func get_current_action_player(items: Array[ActionQueueItem]) -> Node2D:
	return items[0].action.actor


func get_action_by_unique_id(items: Array[ActionQueueItem], id: UniqueId) -> Action:
	return items.filter(
		func(item: ActionQueueItem) -> bool: return item.action.actor.unique_id.id == id.id
	)[0].action


func create_items(battle_groups: BattleGroups) -> Array[ActionQueueItem]:
	var items: Array[ActionQueueItem] = []
	_create_items_from_members(items, battle_groups.players)
	_create_items_from_members(items, battle_groups.enemies)
	return items


# func fill_initial_turn_items(battle_groups: BattleGroups) -> void:
# 	_remove_queue_children()
# 	_queue_new_items(battle_groups.players)
# 	_queue_new_items(battle_groups.enemies)
# 	_sort_items_by_agility()
# 	_fill_enemy_actions(battle_groups)
# 	_add_queue_children()


# func is_turn_over() -> bool:
# 	var action := queue.items[0].action
# 	if action.is_choosing: return false
# 	if queue.items.size() > 0:
# 		return action.action_chosen == true or action.is_player_action()
# 	else:
# 		return false


# func remove_actions_without_target_with_removed_id(unique_id: String) -> void:
# 	for item in queue.items:
# 		_remove_action_from_queue_without_target_with_removed_id(unique_id, item)


# func update_player_action_with_skill(action_to_update: Action, player: Node2D, target: Node2D, skill: Ingress) -> void:
# 	#var action_to_update := _get_item_by_player(player).action
# 	if skill.has_target():
# 		action_to_update.set_skill(target, skill)
# 	else:
# 		action_to_update.set_skill(null, skill)


# func update_actions_with_targets_with_removed_id(
# 	removed_id: String,
# 	battle_groups: BattleGroups
# 	) -> void:
# 	var actions := _get_actions_by_unique_id(removed_id)
# 	for action in actions:
# 		if not _action_needs_update(action, removed_id): continue
# 		_update_action_with_target_with_removed_id(action, removed_id, battle_groups)


# # ---------------------
# # Private Methods
# # ---------------------


# func _get_actions_by_unique_id(unique_id: String) -> Array[Action]:
# 	var filtered_items := queue.items.filter(func(item: ActionQueueItem) -> bool:
# 		return _action_has_unique_id(item.action, unique_id))
# 	var actions: Array[Action] = []
# 	for item: ActionQueueItem in filtered_items: actions.append(item.action)
# 	return actions


# func _action_has_unique_id(action: Action, unique_id: String) -> bool:
# 	if action.get_actor_unique_id() == unique_id or action.get_target_unique_id() == unique_id:
# 		return true
# 	else:
# 		return false


# func _update_action_with_target_with_removed_id(
# 	action: Action, 
# 	removed_id: String, 
# 	battle_groups: BattleGroups) -> void:

# 	if action.is_player_action() and battle_groups.enemies.size() > 0:
# 			action.target = battle_groups.get_random_enemy()
# 	elif action.is_enemy_action() and battle_groups.players.size() > 0:
# 		action.target = battle_groups.get_random_player()
# 	else:
# 		_remove_actions_from_queue_by_unique_id(removed_id)


# func _remove_queue_children() -> void:
# 	for child in queue.get_children(): child.queue_free()


# func _add_queue_children() -> void:
# 	for item in queue.items: queue.add_child(item)


func _create_items_from_members(items: Array[ActionQueueItem], members: Array[Node2D]) -> void:
	for member in members: items.append(_create_new_item(member))


func _create_new_item(member: Node2D) -> ActionQueueItem:
	var new_item := ACTION_QUEUE_ITEM.instantiate()
	new_item.set_empty_action(member)
	new_item.set_portrait(member)
	return new_item


# func _sort_items_by_agility() -> void:
# 	for item in queue.items: item.set_rand_agi()
# 	queue.items.sort_custom(_compare_by_agility)


# func _compare_by_agility(a: ActionQueueItem, b: ActionQueueItem) -> bool:
# 	return a.get_rand_agi() > b.get_rand_agi()


# func _fill_enemy_actions(battle_groups: BattleGroups) -> void:
# 	for item in queue.items:
# 		if(item.is_player_action()): continue
# 		_fill_enemy_action(item.action, battle_groups)


# func _fill_enemy_action(action: Action, battle_groups: BattleGroups) -> void:
# 	var usable_skills: Array[Ingress] = action.actor.get_usable_skills()

# 	if usable_skills.size() == 0:
# 		action.set_recover()
# 	else:
# 		action.set_enemy_skill(_select_enemy_skill(usable_skills), battle_groups, action.actor)


# func _select_enemy_skill(skills: Array) -> Ingress:
# 	var use_refrain := randi() % 4 == 1
# 	var filtered_skills: Array[Ingress] = skills

# 	if use_refrain and skills.any(_is_refrain_filter):
# 		filtered_skills = skills.filter(_is_refrain_filter)
# 	elif skills.any(_is_incursion_filter):
# 		filtered_skills = skills.filter(_is_incursion_filter)
		
# 	return filtered_skills[randi() % filtered_skills.size()]


# func _is_refrain_filter(skill: Ingress) -> bool: return skill.is_refrain()


# func _is_incursion_filter(skill: Ingress) -> bool: return skill.is_incursion()


# func _get_item_by_player(player: Node2D) -> ActionQueueItem:
# 	var items := queue.items.filter(func(item: ActionQueueItem)-> bool:
# 		return item.get_actor_unique_id() == player.unique_id.id
# 		)
# 	return items[0]


# func _is_targeting_removed_id(action: Action, unique_id: String) -> bool:
# 	return action.get_target_unique_id() == unique_id


# func _action_needs_update(action: Action, removed_id: String) -> bool:
# 	return action.target and _is_targeting_removed_id(action, removed_id)


# func _remove_actions_from_queue_by_unique_id(removed_id: String) -> void:
# 	queue.items = queue.items.filter(func(item: ActionQueueItem) -> bool:
# 		return item.action_has_unique_id(removed_id))


# func _remove_action_from_queue_without_target_with_removed_id(
# 	unique_id: String, item: ActionQueueItem) -> void:
# 	var action := item.action
# 	if _is_no_target_and_removed(action, unique_id): queue.items.erase(item)


# func _is_no_target_and_removed(action: Action, unique_id: String) -> bool:
# 	return not action.target and action.get_actor_unique_id() == unique_id


# func _action_chosen_filter(item: ActionQueueItem)-> bool: return item.action.action_chosen
