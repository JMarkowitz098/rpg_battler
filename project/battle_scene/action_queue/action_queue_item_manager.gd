class_name ActionQueueItemManager

const ACTION_QUEUE_ITEM := preload("res://battle_scene/action_queue/action_queue_item.tscn")

var queue: ActionQueue

func _init(init_queue: ActionQueue) -> void:
	queue = init_queue


func fill_initial_turn_items(battle_groups: BattleGroups) -> void:
	_remove_queue_children()
	_queue_new_items(battle_groups.players)
	_queue_new_items(battle_groups.enemies)
	_sort_items_by_agility()
	_fill_enemy_actions(battle_groups)
	_add_queue_children()


func update_player_action_with_skill(player: Node2D, target: Node2D, skill: Ingress) -> void:
	var action_to_update := _get_item_by_player(player).action
	if skill.has_target():
		action_to_update.set_skill(target, skill)
	else:
		action_to_update.set_skill(null, skill)


func _remove_queue_children() -> void:
	for child in queue.get_children(): child.queue_free()


func _add_queue_children() -> void:
	for item in queue.items: queue.add_child(item)


func _queue_new_items(members: Array[Node2D]) -> void:
	for member in members:
		var new_item := _create_new_item(member)
		queue.items.push_back(new_item)


func _create_new_item(member: Node2D) -> ActionQueueItem:
	var new_item := ACTION_QUEUE_ITEM.instantiate()
	new_item.set_empty_action(member)
	new_item.set_portrait(member)
	return new_item


func _sort_items_by_agility() -> void:
	for item in queue.items: item.set_rand_agi()
	queue.items.sort_custom(func(a: ActionQueueItem, b: ActionQueueItem) -> bool:
		return a.get_rand_agi()  > b.get_rand_agi() )


func _fill_enemy_actions(battle_groups: BattleGroups) -> void:
	for item in queue.items:
		if(item.is_player_action()): continue
		_fill_enemy_action(item.action, battle_groups)


func _fill_enemy_action(action: Action, battle_groups: BattleGroups) -> void:
	var usable_skills: Array[Ingress] = action.actor.get_usable_skills()

	if usable_skills.size() == 0:
			action.set_recover()
	else:
		var enemy_skill := _select_enemy_skill(usable_skills)
		action.set_enemy_skill(enemy_skill, battle_groups, action.actor)


func _select_enemy_skill(skills: Array) -> Ingress:
	var use_refrain := randi() % 4 == 1
	var filtered_skills: Array[Ingress]
	if use_refrain:
		filtered_skills = skills.filter(func(skill: Ingress) -> bool: return skill.is_refrain())
	else:
		filtered_skills = skills.filter(func(skill: Ingress) -> bool: return skill.is_incursion())

	var rand_skill_i := randi() % filtered_skills.size()
	return filtered_skills[rand_skill_i]


func _get_item_by_player(player: Node2D) -> ActionQueueItem:
	var items := queue.items.filter(func(item: ActionQueueItem)-> bool:
		return item.get_actor_unique_id() == player.stats.unique_id)
	return items[0]
