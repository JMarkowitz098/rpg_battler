extends HBoxContainer
class_name ActionQueue

var items: Array[ActionQueueItem] = []
var current_member: int = 0
var current_state_item: ActionQueueItem

var process_queue := ProcessQueue.new()
var item_manager := ActionQueueItemManager.new()
var focus_manager := ActionQueueFocusManager.new()

var current_skill_target: Ingress.Target

const ACTION_QUEUE_ITEM := preload("res://battle_scene/action_queue/action_queue_item.tscn")


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	var signals := [
		["choosing_action_queue_state_entered", _on_choosing_action_queue_state_entered],
		["choosing_action_state_entered", _on_choosing_action_state_entered],
		["choosing_ally_state_entered", _on_choosing_ally_state_entered],
		["choosing_enemy_state_entered", _on_choosing_enemy_state_entered],
		["choosing_self_state_entered", _on_choosing_self_state_entered],
		["choosing_skill_state_entered",_on_choosing_skill_state_entered],
		["is_battling_state_entered", _on_is_battling_state_entered],
		["update_action_index", _on_update_action_index],
		["update_current_member", _on_update_current_member], 
	]


	for new_signal: Array in signals:
		Events[new_signal[0]].connect(new_signal[1])

# -------------
# Process Queue
# -------------


func process_action_queue(tree: SceneTree, battle_groups: BattleGroups) -> void:
	await process_queue.process_action_queue(items, tree, battle_groups)


# -------------
# Item Manager
# -------------

func fill_initial_turn_items(battle_groups: BattleGroups) -> void:
	items = item_manager.create_items(battle_groups)
	item_manager.sort_items_by_agility(items)
	item_manager.fill_enemy_actions(items, battle_groups)
	for item in items: add_child(item)


func is_turn_over() -> bool: return item_manager.is_turn_over(items)


func update_player_action_with_skill(action: Action, skill: Ingress, target: Node2D = null) -> void:
	item_manager.update_player_action_with_skill(action, skill, target)


func update_actions_with_targets_with_removed_id(
	removed_id: String,
	battle_groups: BattleGroups
	) -> void:
		item_manager.update_actions_with_targets_with_removed_id(items, removed_id, battle_groups)


func remove_actions_without_target_with_removed_id(unique_id: String) -> void:
	item_manager.remove_actions_without_target_with_removed_id(items, unique_id)


func next_item() -> void:
	items.front().queue_free()
	items.pop_front()


# ------------------
# Focus Manager
# ------------------

func reset_current_member() -> void: focus_manager.reset_current_member()
func get_current_item() -> ActionQueueItem: return focus_manager.get_current_item()
func set_item_focus(index: int, type: Focus.Type, color: Color = Color.WHITE) -> void: 
	focus_manager.set_item_focus(items, index, type, color)
func create_action_message(action: Action) -> String: 
	return focus_manager.create_action_message(action)
func unfocus_all(type: Focus.Type) -> void: focus_manager.unfocus_all(items, type)
func get_action_index_by_unique_id(unique_id: String) -> int:
	return focus_manager.get_action_index_by_unique_id(items, unique_id)
func set_triangle_focus_on_player(unique_id: String) -> void:
	focus_manager.set_triangle_focus_on_player(items, unique_id)


# -------
# Signals
# -------

func _on_choosing_action_state_entered(_params: StateParams = null) -> void:
	unfocus_all(Focus.Type.ALL)
	items.front().focus(Focus.Type.TRIANGLE)

	
func _on_choosing_action_queue_state_entered() -> void:
	if !current_state_item:
		current_state_item = items.front()
		current_member = 0
	_on_update_action_index(Direction.Type.NONE)
	Events.update_info_label.emit(create_action_message(current_state_item.action))


func _on_is_battling_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)


func _on_update_action_index(direction: Direction.Type) -> void:
	_handle_direction(direction)

	var action := current_state_item.action
	unfocus_all(Focus.Type.ALL)
	Events.update_action_queue_focuses.emit(current_state_item)
	Events.update_info_label.emit(create_action_message(action))

	current_state_item.focus(Focus.Type.FINGER)
	if action.target: 
		action.target.set_triangle_focus_size(Vector2(.4, .4)) # Does not set for some reason
		focus_manager.set_triangle_focus_on_player(
			items,
			action.get_target_unique_id(),
			Focus.color(action.skill.target)
	)


func _on_choosing_ally_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
	current_skill_target = Ingress.Target.ALLY


func _on_choosing_self_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
	items.front().focus(Focus.Type.TRIANGLE)
	current_skill_target = Ingress.Target.ALLY


func _on_choosing_skill_state_entered(_params: StateParams = null) -> void:
	unfocus_all(Focus.Type.ALL)
	items.front().focus(Focus.Type.TRIANGLE)


func _on_choosing_enemy_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
	current_skill_target = Ingress.Target.ENEMY


func _on_update_current_member(player: Node2D, focused: bool) -> void:
	unfocus_all(Focus.Type.ALL) 
	if focused:
		focus_manager.set_triangle_focus_on_player(items, player.unique_id.id, Focus.color(current_skill_target))
	else:
		focus_manager.remove_triangle_focus_on_player(items, player.unique_id.id)


# -----------------
# Private Functions
# -----------------

func _handle_direction(direction: Direction.Type)-> void:
	match direction:
		Direction.Type.RIGHT:
			current_member = (current_member + 1) % items.size()
		Direction.Type.LEFT:
			if current_member == 0:
				current_member = items.size() - 1
			else:
				current_member = current_member - 1
	current_state_item = items[current_member]
