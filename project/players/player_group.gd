extends Group

var current_members_turn := 0

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	var signals := [
		["action_queue_focus_all_allies", _on_action_queue_focus_all_members], # Defined in Group
		["choosing_action_queue_state_entered", _on_choosing_action_queue_state_entered],
		["choosing_action_state_entered", _on_choosing_action_state_entered],
		["choosing_ally_all_state_entered", _on_choosing_ally_all_state_entered],
		["choosing_ally_state_entered", _on_choosing_ally_state_entered],
		["choosing_self_state_entered", _on_choosing_self_state_entered],
		["choosing_skill_state_entered", _on_choosing_skill_state_entered],
		["enter_action_queue_handle_input", _on_enter_action_queue_handle_input], # Defined in Group
		["is_battling_state_entered", _on_is_battling_state_entered],
		["update_player_group_current", _on_update_current], # Defined in Group
	]
	Utils.connect_signals(signals)

	
# ----------------
# Public Functions
# ----------------

func next_player() -> void:
	if (current_members_turn <= members.size()):
		current_members_turn += 1
		current_member = current_members_turn

func load_members_from_save_data(id: String) -> void:
	var save_and_load := SaveAndLoad.new()
	var save_data := save_and_load.load_data(id)
	
	instantiate_members(save_data.players_data)

func reset_current_member_and_turn() -> void:
	current_member = 0
	current_members_turn = 0

func get_current_member_turn() -> Node2D:
	return members[current_members_turn]

# -----------------
# Private Functions
# -----------------


# -------
# Signals
# -------

func _on_choosing_action_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
	get_current_member().focus(Focus.Type.TRIANGLE)

func _on_choosing_action_queue_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_is_battling_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_choosing_ally_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
	get_current_member().focus(Focus.Type.FINGER)

func _on_choosing_ally_all_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
	focus_all(Focus.Type.FINGER)

func _on_choosing_self_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
	get_current_member().focus(Focus.Type.FINGER)

func _on_choosing_skill_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
