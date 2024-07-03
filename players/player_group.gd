extends Group

var current_members_turn := 0

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	Events.choosing_action_queue_state_entered.connect(_on_choosing_action_queue_state_entered)
	Events.choosing_action_state_entered.connect(_on_choosing_action_state_entered)
	Events.choosing_ally_state_entered.connect(_on_choosing_ally_state_entered)
	Events.choosing_self_state_entered.connect(_on_choosing_self_state_entered)
	Events.enter_action_queue_handle_input.connect(_on_enter_action_queue_handle_input) # Defined in Group
	Events.is_battling_state_entered.connect(_on_is_battling_state_entered)
	Events.update_player_group_current.connect(_on_update_current) # Defined in Group
	
# ----------------
# Public Functions
# ----------------

func next_player() -> void:
	if (current_members_turn <= members.size()):
		current_members_turn += 1
		current_member = current_members_turn

func load_members_from_save_data() -> void:
	var all_save_data := SaveAndLoadPlayer.load_all_players()
	var new_player_data: Array[NewPlayerData] = []
	
	for player_save_data: PlayerSaveData in all_save_data:
		if(player_save_data):
			var new_player_data_object := _create_new_player_data(player_save_data)
			new_player_data.append(new_player_data_object)

	instantiate_members(new_player_data)

func reset_current_member_and_turn() -> void:
	current_member = 0
	current_members_turn = 0

func get_current_member_turn() -> Node2D:
	return members[current_members_turn]

# -----------------
# Private Functions
# -----------------

func _create_new_player_data(save_data: PlayerSaveData) -> NewPlayerData:
	return NewPlayerData.new({
		"player_id": save_data.player_id,
		"player_details": Utils.get_player_details(save_data.player_id),
		"level_stats": LevelStats.load_level_data(save_data.player_id, save_data.level),
		"unique_id": Stats.create_unique_id(save_data.player_id)
	})

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

func _on_choosing_self_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
	get_current_member().focus(Focus.Type.FINGER)
