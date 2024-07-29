extends GutTest

var TestActionQueue := load("res://battle_scene/action_queue/action_queue.gd")

var queue: ActionQueue
var mocker: MockCreator


func before_each() -> void:
	mocker = MockCreator.new()
	mocker.initialize(add_child_autoqfree)
	queue = TestActionQueue.new()
	add_child_autoqfree(queue)
	add_child_autofree(mocker)


func test_can_create_item_manager() -> void:
	assert_not_null(queue)


func test_can_add_initial_items() -> void:
	queue.fill_initial_turn_items(mocker.battle_groups)
	assert_eq(queue.get_children().size(), 3)

	for item in queue.items: item.queue_free()


func test_can_respond_to_choosing_action_state_entered_signal() -> void:
	queue.fill_initial_turn_items(mocker.battle_groups)
	gut.p("-----when no paramaters are passed-----")
	Events.choosing_action_state_entered.emit()
	assert_true(queue.items.front().triangle_focus.is_visible(), "First item is focused")
	assert_false(queue.items[1].triangle_focus.is_visible(), "Other items not focused")
	assert_false(queue.items[2].triangle_focus.is_visible(), "Other items not focused")

	gut.p("-----it unfocuses other items-----")
	for item in queue.items: item.focus(Focus.Type.TRIANGLE)
	Events.choosing_action_state_entered.emit()
	assert_true(queue.items.front().triangle_focus.is_visible(), "First item is focused")
	assert_false(queue.items[1].triangle_focus.is_visible(), "Other items not focused")
	assert_false(queue.items[2].triangle_focus.is_visible(), "Other items not focused")


func test_can_respond_to_choosing_skill_state_entered_signal() -> void:
	queue.fill_initial_turn_items(mocker.battle_groups)
	for item in queue.items: item.focus(Focus.Type.TRIANGLE)
	Events.choosing_skill_state_entered.emit()
	assert_true(queue.items.front().triangle_focus.is_visible(), "First item is focused")
	assert_false(queue.items[1].triangle_focus.is_visible(), "Other items not focused")
	assert_false(queue.items[2].triangle_focus.is_visible(), "Other items not focused")


func test_can_respond_to_choosing_enemy_state_entered_signal() -> void:
	queue.fill_initial_turn_items(mocker.battle_groups)
	Events.choosing_enemy_state_entered.emit()
	gut.p("-----All focus is cleared-----") # First enemy focus will be set by select enemy signal
	assert_false(mocker.enemy.triangle_focus.visible, "Current enemy group member has triangle focus")
	assert_false(mocker.enemy_2.triangle_focus.visible, "Other group member is not focused")

