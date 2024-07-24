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
	assert_false(mocker.item_1.triangle_focus.is_visible())
	assert_false(mocker.item_3.triangle_focus.is_visible())
	assert_true(mocker.item_2.triangle_focus.is_visible())