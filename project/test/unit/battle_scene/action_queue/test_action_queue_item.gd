extends GutTest

var TestActionQueueItem := load("res://battle_scene/action_queue/action_queue_item.tscn")
var Talon := load("res://players/Talon/talon.tscn")
var item: ActionQueueItem


func before_each() -> void:
	item = TestActionQueueItem.instantiate()
	add_child_autoqfree(item)
	

func test_can_create_item() -> void:
	assert_not_null(item)


func test_can_set_empty_action() -> void:
	var player: Node2D = Talon.instantiate()
	add_child_autoqfree(player)
	item.set_empty_action(player)
	assert_not_null(item.action)