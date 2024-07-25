extends GutTest

var TestPlayerGroup := load("res://players/player_group.tscn")
var player_group: Node2D

var data: Array[PlayerData] = [
		PlayerData.new(
			MockPlayerDetails.new(),
			MockStats.new(),
			UniqueId.new("1234"),
			MockIngress.create_array(),
			Player.Type.PLAYER
		),
		PlayerData.new(
			MockPlayerDetails.new(),
			MockStats.new(),
			UniqueId.new("5678"),
			MockIngress.create_array(),
			Player.Type.ENEMY
		),
	]


func before_each() -> void:
	player_group = TestPlayerGroup.instantiate()
	add_child_autoqfree(player_group)
	player_group.instantiate_members(data)


func test_can_create_new_group() -> void:
	assert_not_null(player_group)


func test_can_respond_to_choosing_action_state_entered_signal() -> void:
	var item: ActionQueueItem = load("res://battle_scene/action_queue/action_queue_item.tscn").instantiate()
	var player: Node2D = player_group.members[0]
	var player_2: Node2D = player_group.members[1]
	add_child_autoqfree(item)
	item.set_empty_action(player)

	gut.p("-----when member is passed-----")
	Events.choosing_action_state_entered.emit(StateParams.new(item))
	assert_true(player.triangle_focus.visible, "Player1 has triangle focus")
	assert_false(player_2.triangle_focus.visible, "Player2 does not have triangle focus")

	gut.p("-----when member is not passed but there is previous-----")
	Events.choosing_action_state_entered.emit()
	assert_true(player.triangle_focus.visible, "Player has triangle focus")
	assert_false(player_2.triangle_focus.visible, "Player has triangle focus")


# func test_load_members_from_save_data() -> void:
#   player_group.load_members_from_save_data()
