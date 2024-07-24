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
