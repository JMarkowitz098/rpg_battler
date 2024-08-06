class_name ActionQueueFocusManager


func set_item_focus(
	items: Array[ActionQueueItem], 
	index: int, 
	type: Focus.Type, 
	color: Color = Color.WHITE
) -> void:
	items[index].focus(type, color)


func unfocus_all(items: Array[ActionQueueItem], type: Focus.Type) -> void:
	for item in items: item.unfocus(type)


func get_action_index_by_unique_id(items: Array[ActionQueueItem], unique_id: String) -> int:
	for i in items.size(): 
		if items[i].get_actor_unique_id() == unique_id: return i
	return -1


func set_triangle_focuses_on_items(
	items: Array[ActionQueueItem], 
	unique_id: String,
	current_skill_target: Ingress.Target,
	color: Color = Color.WHITE
) -> void:
	var index := get_action_index_by_unique_id(items, unique_id)

	match current_skill_target:
		Ingress.Target.ALL_ALLIES:
			_focus_player_items(items, color)
		Ingress.Target.ALL_ENEMIES:
			_focus_enemy_items(items, color)
		_:
			if index >= 0: set_item_focus(items, index, Focus.Type.TRIANGLE, color)


func remove_triangle_focus_on_player(items: Array[ActionQueueItem], unique_id: String) -> void:
	var index := get_action_index_by_unique_id(items, unique_id)
	items[index].unfocus(Focus.Type.ALL)


func create_action_message(action: Action) -> String:
	var message: String = "Player: " + action.get_actor_label()
	if action.skill: message += "\nAction: " + action.skill.label
	if action.target: message += "\nTarget -> " + action.get_target_label()
	return message


# -----------------
# Private Functions
# -----------------

func _focus_player_items(items: Array[ActionQueueItem], color: Color) -> void:
	for item in items: 
		if item.is_player_action(): item.focus(Focus.Type.TRIANGLE, color)


func _focus_enemy_items(items: Array[ActionQueueItem], color: Color) -> void:
	for item in items: 
		if item.is_enemy_action(): item.focus(Focus.Type.TRIANGLE, color)
