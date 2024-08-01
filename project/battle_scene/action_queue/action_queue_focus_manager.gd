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


func set_triangle_focus_on_player(
	items: Array[ActionQueueItem], 
	unique_id: String, 
	color: Color = Color.WHITE
) -> void:
	var index := get_action_index_by_unique_id(items, unique_id)
	if index >= 0: set_item_focus(items, index, Focus.Type.TRIANGLE, color)


func remove_triangle_focus_on_player(items: Array[ActionQueueItem], unique_id: String) -> void:
	var index := get_action_index_by_unique_id(items, unique_id)
	items[index].unfocus(Focus.Type.ALL)


# -----------------
# Private Functions
# -----------------

# Legacy code
# var queue: ActionQueue
# var items: Array[ActionQueueItem]


# func reset_current_member() -> void:
# 	queue.current_member = 0


# func get_current_item() -> ActionQueueItem:
# 	return items[queue.current_member]

# func create_action_message(action: Action) -> String:
# 	var message: String = "Player: " + action.get_actor_label()
# 	if action.skill: message += "\nAction: " + action.skill.label
# 	if action.target: message += "\nTarget -> " + action.get_target_label()
# 	return message



# func set_focuses() -> void:
# 	var item := get_current_item()
# 	var action: Action = item.action

# 	_focus_actor(action.actor)
# 	item.focus(Focus.Type.FINGER)

# 	if action.skill: _focus_target_by_skill(action)

# func _focus_actor(actor: Node2D) -> void:
# 	actor.focus(Focus.Type.TRIANGLE)
# 	actor.set_triangle_focus_color(Color.GRAY)
# 	actor.set_triangle_focus_size(Vector2(.6, .6))


# func _focus_target_by_skill(action: Action) -> void:
# 	match action.skill.id:
# 		Ingress.Id.INCURSION, Ingress.Id.DOUBLE_INCURSION, Ingress.Id.PIERCING_INCURSION:
# 				action.target.focus(Focus.Type.TRIANGLE)
# 				action.target.set_triangle_focus_color(Color.RED)
# 		Ingress.Id.REFRAIN, Ingress.Id.MOVEMENT:
# 				action.target.focus(Focus.Type.TRIANGLE)
# 				action.target.set_triangle_focus_color(Color.GREEN)
# 		Ingress.Id.GROUP_REFRAIN:
# 			_emit_group_refrain_focus_event(action, Focus.Type.TRIANGLE, Color.GREEN)
# 		Ingress.Id.GROUP_INCURSION:
# 			_emit_group_incursion_focus_event(action, Focus.Type.TRIANGLE, Color.RED)


# func _emit_group_refrain_focus_event(action: Action, focus_type: Focus.Type, color: Color) -> void:
# 	if action.is_player_action():
# 		Events.action_queue_focus_all_allies.emit(focus_type, color)
# 	else:
# 		Events.action_queue_focus_all_enemies.emit(focus_type, color)


# func _emit_group_incursion_focus_event(action: Action, focus_type: Focus.Type, color: Color) -> void:
# 	if action.is_player_action():
# 		Events.action_queue_focus_all_enemies.emit(focus_type, color)
# 	else:
# 		Events.action_queue_focus_all_allies.emit(focus_type, color)
