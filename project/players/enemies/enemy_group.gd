extends Group

# @export var round_data: Round

func _ready() -> void:
	_connect_signals()

func load_members_from_round_data(round_number: Round.Number) -> void:
	var new_enemy_data: Array[PlayerData] = []
	var round_data: Round

	match round_number:
		Round.Number.ONE:
			round_data = load("res://players/enemies/round_1/round_1.tres")
		Round.Number.TWO:
			round_data = load("res://players/enemies/round_2/round_2.tres")
		Round.Number.THREE:
			round_data = load("res://players/enemies/round_3/round_3.tres")

	_create_player_data(new_enemy_data, round_data)
	instantiate_members(new_enemy_data)
	_flip_members_direction()

func _connect_signals() -> void:
	var signals := [
		["action_queue_focus_all_enemies", _on_action_queue_focus_all_members],
		["choosing_action_queue_state_entered", _on_choosing_action_queue_state_entered],
		["choosing_action_state_entered", _on_choosing_action_state_entered],
		["choosing_enemy_all_state_entered", _on_choosing_enemy_state_all_entered],
		["choosing_enemy_state_entered", _on_choosing_enemy_state_entered],
		["choosing_skill_state_entered", _on_choosing_skill_state_entered],
		["is_battling_state_entered", _on_is_battling_state_entered],
		["enter_action_queue_handle_input", _on_enter_action_queue_handle_input], # Defined in Group
		["update_enemy_group_current", _on_update_current] # Defined in Group
	]

	Utils.connect_signals(signals)

func _create_player_data(new_enemy_data: Array[PlayerData], round_data: Round) -> void:
	for data: EnemyPlayerData in round_data.enemies:
		new_enemy_data.append(PlayerData.new(
			data.details,
			data.stats,
			UniqueId.new(),
			data.skills,
			Player.Type.ENEMY
		))

func _flip_members_direction() -> void:
	for member in members:
		member.base_sprite.scale.x *= -1
		member.attack_sprite.scale.x *= -1


func _on_choosing_action_state_entered(_params: StateParams = null) -> void:
	unfocus_all(Focus.Type.ALL)

func _on_choosing_action_queue_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_choosing_skill_state_entered(_params: StateParams = null) -> void:
	unfocus_all(Focus.Type.ALL)

func _on_is_battling_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_choosing_enemy_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
	if(members.size() > 0):
		get_current_member().focus(Focus.Type.FINGER)

func _on_choosing_enemy_state_all_entered() -> void:
	focus_all(Focus.Type.FINGER)
