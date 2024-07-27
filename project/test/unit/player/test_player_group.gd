extends GutTest

var TestPlayerGroup := load("res://players/player_group.tscn")
var TestActionQueueItem := load("res://battle_scene/action_queue/action_queue_item.tscn")
var player_group: Node2D
var item: ActionQueueItem
var player: Node2D
var player_2: Node2D

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
	item = TestActionQueueItem.instantiate()
	add_child_autoqfree(player_group)
	add_child_autoqfree(item)

	player_group.instantiate_members(data)
	player = player_group.members[0]
	player_2 = player_group.members[1]
	item.set_empty_action(player)
	

func test_can_create_new_group() -> void:
	assert_not_null(player_group)


func test_can_respond_to_choosing_action_state_entered_signal() -> void:
	gut.p("-----when member is passed-----")
	Events.choosing_action_state_entered.emit(StateParams.new(item))
	assert_true(player.triangle_focus.visible, "Player1 has triangle focus")
	assert_false(player_2.triangle_focus.visible, "Player2 does not have triangle focus")

	gut.p("-----when member is not passed but there is previous-----")
	Events.choosing_action_state_entered.emit()
	assert_true(player.triangle_focus.visible, "Player1 has triangle focus")
	assert_false(player_2.triangle_focus.visible, "Player2 does not have triangle focus")

	gut.p("-----focus is cleared from other players-----")
	player.focus(Focus.Type.TRIANGLE)
	player_2.focus(Focus.Type.TRIANGLE)
	Events.choosing_action_state_entered.emit()
	assert_true(player.triangle_focus.visible, "Player1 has triangle focus")
	assert_false(player_2.triangle_focus.visible, "Player2 does not have triangle focus")

func test_can_respond_to_choosing_skill_state_entered_signal() -> void:
	gut.p("-----when member is passed-----")
	Events.choosing_skill_state_entered.emit(StateParams.new(item))
	assert_true(player.triangle_focus.visible)
	assert_false(player_2.triangle_focus.visible)

	gut.p("-----when member is not passed but there is previous-----")
	Events.choosing_skill_state_entered.emit()
	assert_true(player.triangle_focus.visible)
	assert_false(player_2.triangle_focus.visible)

# func test_load_members_from_save_data() -> void:
#   player_group.load_members_from_save_data()
