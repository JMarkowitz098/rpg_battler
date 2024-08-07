class_name ActionQueueItemManager

const ACTION_QUEUE_ITEM := preload("res://battle_scene/action_queue/action_queue_item.tscn")


# ---------------------
# Public Methods
# ---------------------

func get_action_by_unique_id(items: Array[ActionQueueItem], id: UniqueId) -> Action:
	return items.filter(
		func(item: ActionQueueItem) -> bool: return item.action.actor.unique_id.id == id.id
	)[0].action


func create_items(battle_groups: BattleGroups) -> Array[ActionQueueItem]:
	var items: Array[ActionQueueItem] = []
	_create_items_from_members(items, battle_groups.players)
	_create_items_from_members(items, battle_groups.enemies)
	return items


func sort_items_by_agility(items: Array[ActionQueueItem]) -> void:
	for item in items: item.set_rand_agi()
	items.sort_custom(_compare_by_agility)


func fill_enemy_actions(items: Array[ActionQueueItem], battle_groups: BattleGroups) -> void:
	for item in items:
		if(item.is_player_action()): continue
		_fill_enemy_action(item.action, battle_groups)


func update_player_action_with_skill(action_to_update: Action, skill: Ingress, target: Node2D = null) -> void:
	action_to_update.set_skill(skill, target)


func update_actions_with_targets_with_removed_id(
	items: Array[ActionQueueItem],
	removed_id: String,
	battle_groups: BattleGroups
	) -> void:
	var items_to_update := _get_items_by_unique_id(items, removed_id)
	for item in items_to_update:
		if _action_needs_update(item.action, removed_id): 
			_update_action_with_target_with_removed_id(items, item, battle_groups)

func remove_actions_without_target_with_removed_id(items: Array[ActionQueueItem], unique_id: String) -> void:
	for item in items:
		_remove_action_from_queue_without_target_with_removed_id(items, unique_id, item)


# # ---------------------
# # Private Methods
# # ---------------------

func _create_items_from_members(items: Array[ActionQueueItem], members: Array[Node2D]) -> void:
	for member in members: items.append(_create_new_item(member))


func _create_new_item(member: Node2D) -> ActionQueueItem:
	var new_item := ACTION_QUEUE_ITEM.instantiate()
	new_item.set_empty_action(member)
	new_item.set_portrait(member)
	return new_item


func _compare_by_agility(a: ActionQueueItem, b: ActionQueueItem) -> bool:
	return a.get_rand_agi() > b.get_rand_agi()


func _fill_enemy_action(action: Action, battle_groups: BattleGroups) -> void:
	var usable_skills: Array[Ingress] = action.actor.get_usable_skills()

	if usable_skills.size() == 0:
		action.set_recover()
	else:
		action.set_enemy_skill(_select_enemy_skill(usable_skills), battle_groups, action.actor)


func _select_enemy_skill(skills: Array) -> Ingress:
	var use_refrain := randi() % 4 == 1
	var filtered_skills: Array[Ingress] = skills

	if use_refrain and skills.any(_is_refrain_filter):
		filtered_skills = skills.filter(_is_refrain_filter)
	elif skills.any(_is_incursion_filter):
		filtered_skills = skills.filter(_is_incursion_filter)
		
	return filtered_skills[randi() % filtered_skills.size()]


func _get_items_by_unique_id(items: Array[ActionQueueItem], unique_id: String) -> Array[ActionQueueItem]:
	return items.filter(func(item: ActionQueueItem) -> bool: 
		return _action_has_unique_id(item.action, unique_id))


func _action_has_unique_id(action: Action, unique_id: String) -> bool:
	if action.get_actor_unique_id() == unique_id or action.get_target_unique_id() == unique_id:
		return true
	else:
		return false


func _update_action_with_target_with_removed_id(
	items: Array[ActionQueueItem],
	item: ActionQueueItem, 
	battle_groups: BattleGroups) -> void:

	var action := item.action
	if action.is_player_action() and battle_groups.enemies.size() > 0:
		action.target = battle_groups.get_random_enemy()
	elif action.is_enemy_action() and battle_groups.players.size() > 0:
		action.target = battle_groups.get_random_player()
	else:
		items.erase(item)
		item.queue_free()


func is_turn_over(items: Array[ActionQueueItem]) -> bool:
	return items.size() <= 0


func _action_needs_update(action: Action, removed_id: String) -> bool:
	return action.target and _is_targeting_removed_id(action, removed_id)


func _is_targeting_removed_id(action: Action, unique_id: String) -> bool:
	return action.get_target_unique_id() == unique_id


func _remove_actions_from_queue_by_unique_id(items: Array[ActionQueueItem], removed_id: String) -> Array[ActionQueueItem]:
	return items.filter(func(item: ActionQueueItem) -> bool:
		return item.action_has_unique_id(removed_id))


func _remove_action_from_queue_without_target_with_removed_id(
	items: Array[ActionQueueItem],
	unique_id: String, 
	item: ActionQueueItem) -> void:
	var action := item.action
	if _is_no_target_and_removed(action, unique_id): 
		items.erase(item)
		item.queue_free()


func _is_no_target_and_removed(action: Action, unique_id: String) -> bool:
	return not action.target and action.get_actor_unique_id() == unique_id


func _is_refrain_filter(skill: Ingress) -> bool: return skill.is_refrain()
func _is_incursion_filter(skill: Ingress) -> bool: return skill.is_incursion()

