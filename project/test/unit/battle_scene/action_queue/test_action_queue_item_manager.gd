extends GutTest

var TestActionQueueItemManager := load("res://battle_scene/action_queue/action_queue_item_manager.gd")
var manager: ActionQueueItemManager

var expected: Variant
var actual: Ingress

func before_each() -> void:
	manager = ActionQueueItemManager.new(MockActionQueue.new())

func after_each() -> void:
	manager.queue.free()

func test_can_item_manager() -> void:
	assert_not_null(manager)

func test_select_enemy_skill() -> void:
	var skill_1 := MockIngress.create_incursion()
	var skill_2 := MockIngress.create_refrain()
	var skills: Array[Ingress] = [skill_1, skill_2]

	gut.p("Selected skill is from list of passed in skills")
	expected = skills
	actual = manager._select_enemy_skill(skills)
	assert_true(expected.has(actual))

	gut.p("Selected skill is refrain if list is only refrain skills")
	skills = [ skill_2 ]
	expected = skill_2
	actual = manager._select_enemy_skill(skills)
	assert_eq(expected, actual)