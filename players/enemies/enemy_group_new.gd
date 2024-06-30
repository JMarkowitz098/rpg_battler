extends Group

func _ready() -> void:
	_connect_signals()

func load_members_from_round_data(round_number: Round.Number) -> void:
	var new_enemy_data: Array[NewPlayerData] = []
	match round_number:
		Round.Number.ONE:
			var round_data := load("res://players/enemies/round_one.tres")
			_create_new_player_data(new_enemy_data, round_data)
			
	instantiate_members(new_enemy_data)
	_flip_members_direction()

func _connect_signals() -> void:
	Events.choosing_action_queue_state_entered.connect(_on_choosing_action_queue_state_entered)
	Events.choosing_action_state_entered.connect(_on_choosing_action_state_entered)
	Events.choosing_enemy_all_state_entered.connect(_on_choosing_enemy_state_all_entered)
	Events.choosing_enemy_state_entered.connect(_on_choosing_enemy_state_entered)
	Events.choosing_skill_state_entered.connect(_on_choosing_skill_state_entered)
	Events.enter_action_queue_handle_input.connect(_on_enter_action_queue_handle_input)
	Events.is_battling_state_entered.connect(_on_is_battling_state_entered)
	Events.update_enemy_group_current.connect(_on_update_enemy_group_current)

func _create_new_player_data(new_enemy_data: Array[NewPlayerData], round_data: Round) -> void:
	for i: int in round_data.players_details.size():
		var player_details := round_data.players_details[i]

		new_enemy_data.append(NewPlayerData.new({
			"player_id": player_details.player_id,
			"player_details": player_details,
			"level_stats": round_data.levels[i],
			"unique_id": Stats.create_unique_id(player_details.player_id)
		}))

func _flip_members_direction() -> void:
	for member in members:
		member.base_sprite.scale.x *= -1
		member.attack_sprite.scale.x *= -1


func _on_choosing_action_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_choosing_action_queue_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_choosing_skill_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_is_battling_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_enter_action_queue_handle_input() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_update_enemy_group_current(direction: Direction) -> void:
	match direction:
		Direction.LEFT:
			var new_enemy_index := (current_member - 1) % members.size()
			switch_focus(Focus.Type.FINGER, new_enemy_index, current_member)
			current_member = new_enemy_index
		Direction.RIGHT:
			var new_enemy_index := (current_member + 1) % members.size()
			switch_focus(Focus.Type.FINGER, new_enemy_index, current_member)
			current_member = new_enemy_index

func _on_choosing_enemy_state_entered() -> void:
	get_current_member().focus(Focus.Type.FINGER)

func _on_choosing_enemy_state_all_entered() -> void:
	focus_all(Focus.Type.FINGER)
