extends GutTest

var TestFocusManager := load("res://battle_scene/action_queue/action_queue_focus_manager.gd")

var manager: ActionQueueFocusManager
var mocker: MockCreator
var items: Array[ActionQueueItem]


func before_each() -> void:
	manager = TestFocusManager.new()
	mocker = autofree(MockCreator.new())
	mocker.initialize(add_child_autoqfree)
	mocker.create_action_queue_items()
	items = [ mocker.item_1, mocker.item_2, mocker.item_3 ]


func test_can_create_item_manager() -> void:
	assert_not_null(manager)

func test_can_set_item_focus() -> void:
	manager.set_item_focus(items, 1, Focus.Type.TRIANGLE)
	var tests := [
		[mocker.item_1, false],
		[mocker.item_3, false],
		[mocker.item_2, true],
	]
	_assert_items(tests)


func test_can_set_with_color() -> void:
	var target_focus := mocker.item_2.triangle_focus
	manager.set_item_focus(items, 1, Focus.Type.TRIANGLE, Color.RED)
	assert_true(target_focus.is_visible())
	assert_eq(target_focus.self_modulate, Color.RED)


func test_can_set_and_remove_triangle_focus_on_player() -> void:
	items = [ mocker.item_2, mocker.item_3 ]
	manager.set_triangle_focus_on_player(items, mocker.enemy.unique_id.id)
	var tests := [
		[mocker.item_1, false],
		[mocker.item_2, true],
		[mocker.item_3, false]
	]
	_assert_items(tests)

	gut.p("-----It can remove focus-----")
	manager.remove_triangle_focus_on_player(items, mocker.enemy.unique_id.id)
	tests = [
		[mocker.item_1, false],
		[mocker.item_2, false],
		[mocker.item_3, false]
	]
	_assert_items(tests)

	gut.p("-----It doesn't set focus if no item matches-----")
	manager.set_triangle_focus_on_player(items, mocker.player.unique_id.id)
	tests = [
		[mocker.item_1, false],
		[mocker.item_2, false],
		[mocker.item_3, false]
	]
	_assert_items(tests) 


func _assert_items(tests: Array) -> void:
	for test: Array in tests: _assert_item(test[0], test[1])


func _assert_item(item: ActionQueueItem, type: bool) -> void:
	if type == true: 
		assert_true(item.triangle_focus.is_visible())
	else:
		assert_false(item.triangle_focus.is_visible())