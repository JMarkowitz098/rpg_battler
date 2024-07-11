extends HBoxContainer
class_name ActionQueue

var items: Array[ActionQueueItem] = []
var current_member: int = 0

var process_queue := ProcessQueue.new()
var item_manager := ActionQueueItemManager.new(self)

const ACTION_QUEUE_ITEM := preload("res://battle_scene/action_queue/action_queue_item.tscn")

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	var signals := [
		["choosing_action_queue_state_entered", _on_choosing_action_queue_state_entered],
		["choosing_action_state_entered", _on_choosing_action_state_entered],
		["choosing_ally_state_entered", _on_choosing_ally_state_entered],
		["enter_action_queue_handle_input", _on_enter_action_queue_handle_input],
		["is_battling_state_entered", _on_is_battling_state_entered],
		["update_action_index", _on_update_action_index],
		["update_action_queue_focuses", _on_update_action_queue_focuses]
	]

	for new_signal: Array in signals:
		Events[new_signal[0]].connect(new_signal[1])

# -------------
# Process Queue
# -------------

func fill_initial_turn_items(battle_groups: BattleGroups) -> void:
	item_manager.fill_initial_turn_items(battle_groups)

func process_action_queue(tree: SceneTree, battle_groups: BattleGroups, set_battle_process: Callable) -> void:
	await process_queue.process_action_queue(items, tree, battle_groups, set_battle_process)

func is_turn_over() -> bool:
	return items.all(func(item: ActionQueueItem)-> bool:
		return item.action.action_chosen)

func update_player_action_with_skill(player: Node2D, target: Node2D, skill: Ingress) -> void:
	var action_to_update: Action = items.filter(func(item: ActionQueueItem)-> bool:
		return item.action.actor.stats.unique_id == player.stats.unique_id)[0].action
	if skill.target == Ingress.Target.ALL_ENEMIES or skill.target == Ingress.Target.ALL_ALLIES:
		action_to_update.set_skill(null, skill)
	else:
		action_to_update.set_skill(target, skill)

func remove_action_by_character_id(id: String) -> void:
	items = items.filter(
		func(item: ActionQueueItem) -> bool:
			var action: Action = item.action
			var action_matches := false
			if action.target and action.target.stats.unique_id == id:
				action_matches = true
			if action.actor.stats.unique_id == id:
				action_matches = true
			return !action_matches)

func update_actions_with_targets_with_removed_id(
	removed_id: String,
	groups: BattleGroups
	) -> void:
	var actions := get_actions_by_unique_id(removed_id)
	for action in actions:
		if not action.target or not _is_targeting_removed_id(action, removed_id): continue

		if action.is_player_action() and groups.enemies.size() > 0:
			var rand_enemy_i := randi() % groups.enemies.size()
			action.target = groups.enemies[rand_enemy_i]
		elif action.is_enemy_action() and groups.players.size() > 0:
			var rand_player_i := randi() % groups.players.size()
			action.target = groups.players[rand_player_i]
		else:
			remove_action_by_character_id(removed_id)

func remove_actions_without_target_with_removed_id(unique_id: String) -> void:
	for item in items:
		var action := item.action
		if not action.target and action.get_actor_unique_id() == unique_id:
			items.erase(item)

func get_actions_by_unique_id(unique_id: String) -> Array[Action]:
	var filtered_items := items.filter(func(item: ActionQueueItem) -> bool:
		return _action_has_unique_id(item.action, unique_id))
	var actions: Array[Action] = []
	for item: ActionQueueItem in filtered_items: actions.append(item.action)
	return actions

# -----------------
# Private Functions
# -----------------

func _action_has_unique_id(action: Action, unique_id: String) -> bool:
	if action.get_actor_unique_id() == unique_id or action.get_target_unique_id() == unique_id:
		return true
	else:
		return false

func _is_targeting_removed_id(action: Action, unique_id: String) -> bool:
	return action.get_target_unique_id() == unique_id

# ------------------
# Action Queue Focus
# ------------------

func reset_current_member() -> void:
	current_member = 0

func size() -> int:
	return items.size()

func get_current_item() -> ActionQueueItem:
	return items[current_member]

func set_item_focus(index: int, type: Focus.Type) -> void:
	items[index].focus(type)

func create_action_message(action: Action) -> String:
	var message: String = "Player: " + action.actor.player_name.text
	if action.skill:
		message += "\nAction: " + action.skill.label
	if action.target:
		message += "\nTarget -> " + action.target.player_name.text
	return message

func unfocus_all(type: Focus.Type) -> void:
	for item in items:
		item.unfocus(type)

func set_focuses() -> void:
	var item := get_current_item()
	var action: Action = item.action

	action.actor.focus(Focus.Type.TRIANGLE)
	action.actor.set_triangle_focus_color(Color.GRAY)
	action.actor.set_triangle_focus_size(Vector2(.6, .6))

	item.focus(Focus.Type.FINGER)

	if action.skill:
		match action.skill.id:
			Ingress.Id.INCURSION, Ingress.Id.DOUBLE_INCURSION, Ingress.Id.PIERCING_INCURSION:
				action.target.focus(Focus.Type.TRIANGLE)
				action.target.set_triangle_focus_color(Color.RED)
			Ingress.Id.REFRAIN, Ingress.Id.MOVEMENT:
				action.target.focus(Focus.Type.TRIANGLE)
				action.target.set_triangle_focus_color(Color.GREEN)
			Ingress.Id.GROUP_REFRAIN:
				if action.actor.stats.player_details.icon_type == Stats.IconType.PLAYER:
					Events.action_queue_focus_all_allies.emit(Focus.Type.TRIANGLE, Color.GREEN)
				else:
					Events.action_queue_focus_all_enemies.emit(Focus.Type.TRIANGLE, Color.GREEN)
			Ingress.Id.GROUP_INCURSION:
				if action.actor.stats.player_details.icon_type == Stats.IconType.PLAYER:
					Events.action_queue_focus_all_enemies.emit(Focus.Type.TRIANGLE, Color.RED)
				else:
					Events.action_queue_focus_all_allies.emit(Focus.Type.TRIANGLE, Color.RED)

func get_action_index_by_unique_id(unique_id: String) -> int:
	for i in items.size():
		var action := items[i].action
		if action.actor.stats.unique_id == unique_id:
			return i
	return 0

func set_turn_on_player(unique_id: String) -> void:
	var index := get_action_index_by_unique_id(unique_id)
	set_item_focus(index, Focus.Type.TRIANGLE)

# -------
# Signals
# -------

func _on_choosing_action_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_choosing_action_queue_state_entered() -> void:
	set_item_focus(0, Focus.Type.FINGER)
	var action := get_current_item().action
	Events.update_info_label.emit(create_action_message(action))

func _on_is_battling_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_enter_action_queue_handle_input() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_update_action_index(direction: Direction.Type) -> void:
	match direction:
		Direction.Type.RIGHT:
			current_member = (current_member + 1) % items.size()
		Direction.Type.LEFT:
			if current_member == 0:
				current_member = size() - 1
			else:
				current_member = current_member - 1

	var action := get_current_item().action
	Events.update_info_label.emit(create_action_message(action))

func _on_update_action_queue_focuses() -> void:
	set_focuses()

func _on_choosing_ally_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
