extends GutTest

var TestActionQueueItemManager := load("res://battle_scene/action_queue/action_queue_item_manager.gd")
var Talon := load("res://players/Talon/talon.tscn")
var Item := load("res://battle_scene/action_queue/action_queue_item.tscn")

var manager: ActionQueueItemManager
var items: Array[ActionQueueItem]
var player1: Node2D
var player2: Node2D
var player3: Node2D
var item_1: ActionQueueItem
var item_2: ActionQueueItem
var item_3: ActionQueueItem
var mocker: MockCreator

func before_each() -> void:
	_setup()


func test_can_create_item_manager() -> void:
	assert_not_null(manager)


func test_get_action_by_unique_id() -> void:
	var expected := mocker.item_2.action
	var actual: Action = manager.get_action_by_unique_id(items, mocker.item_2.action.actor.unique_id)
	assert_eq(actual, expected)


func test_can_create_items() -> void:
	var expected := 4
	var new_items: Array[ActionQueueItem] = manager.create_items(mocker.battle_groups)
	assert_eq(new_items.size(), expected)

	for item in new_items: item.queue_free()

func test_can_fill_enemy_actions() -> void:
	manager.fill_enemy_actions(items, mocker.battle_groups)
	assert_null(items[0].action.skill)
	assert_not_null(items[1].action.skill)
	assert_not_null(items[2].action.skill)

# ----------------
# Helper Functions
# ----------------

func _create_and_add_item(player: Node2D) -> ActionQueueItem:
	var item: ActionQueueItem = Item.instantiate()
	add_child_autoqfree(item)
	item.set_empty_action(player)
	items.append(item)
	return item


func _setup() -> void:
	items = []
	manager = TestActionQueueItemManager.new()
	mocker = autofree(MockCreator.new())
	mocker.initialize(add_child_autoqfree)
	mocker.create_action_queue_items()
	items = [ mocker.item_1, mocker.item_2, mocker.item_3 ]


# Legacy
# func test_select_enemy_skill() -> void:
# 	var skill_1 := MockIngress.create_incursion()
# 	var skill_2 := MockIngress.create_refrain()
# 	var skills: Array[Ingress] = [skill_1, skill_2]

# 	gut.p("Selected skill is from list of passed in skills")
# 	expected = skills
# 	actual = manager._select_enemy_skill(skills)
# 	assert_true(expected.has(actual))

# 	gut.p("Selected skill is refrain if list is only refrain skills")
# 	skills = [ skill_2 ]
# 	expected = skill_2
# 	actual = manager._select_enemy_skill(skills)
# 	assert_eq(expected, actual)