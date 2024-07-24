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

func before_each() -> void:
	_setup()


func test_can_create_item_manager() -> void:
	assert_not_null(manager)


func test_can_return_current_action_actor() -> void:
	var expected := item_1.action.actor
	var actual: Node2D = manager.get_current_action_player(items)
	assert_eq(actual, expected)


func test_get_action_by_unique_id() -> void:
	var expected := item_2.action
	var actual: Action = manager.get_action_by_unique_id(items, item_2.action.actor.unique_id)
	assert_eq(actual, expected)


func test_can_create_items() -> void:
	var players: Array[Node2D] = [player1]
	var enemies: Array[Node2D] = [player2, player3]
	var battle_groups := BattleGroups.new(players, enemies)

	var expected := 3
	var new_items: Array[ActionQueueItem] = manager.create_items(battle_groups)
	assert_eq(new_items.size(), expected)

	for item in new_items: item.queue_free()

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
	player1 = Talon.instantiate()
	player2 = Talon.instantiate()
	player3 = Talon.instantiate()
	add_child_autoqfree(player1)
	add_child_autoqfree(player2)
	add_child_autoqfree(player3)
	item_1 = _create_and_add_item(player1)
	item_2 = _create_and_add_item(player2)
	item_3 = _create_and_add_item(player3)

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