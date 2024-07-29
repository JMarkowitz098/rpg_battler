extends GutTest

var TestEnemyGroup := load("res://players/enemies/enemy_group.tscn")
var enemy_group: Node2D

func before_each() -> void:
  enemy_group = TestEnemyGroup.instantiate()
  add_child_autoqfree(enemy_group)
  enemy_group.load_members_from_round_data(Round.Number.ONE)


func test_can_create_enemy_group() -> void:
  assert_not_null(enemy_group)


func test_can_load_enemies_from_round_data() -> void:
  assert_eq(enemy_group.members.size(), 2)


func test_can_respond_to_choosing_action_state_entered_signal() -> void:
  gut.p("-----focus is cleared from all memebers-----")
  enemy_group.focus_all(Focus.Type.TRIANGLE)
  Events.choosing_action_state_entered.emit()
  for enemy: Node2D in enemy_group.members: 
    assert_false(enemy.triangle_focus.visible)


func test_can_respond_to_choosing_skill_state_entered_signal() -> void:
  gut.p("-----focus is cleared from all memebers-----")
  enemy_group.focus_all(Focus.Type.TRIANGLE)
  Events.choosing_skill_state_entered.emit()
  for enemy: Node2D in enemy_group.members: 
    assert_false(enemy.triangle_focus.visible)


func test_can_respond_to_choosing_enemy_state_entered_signal() -> void:
  var enemy_1: Node2D = enemy_group.members[0]
  var enemy_2: Node2D = enemy_group.members[1]

  gut.p("-----focus is set to first member if current_state member is null-----")
  enemy_group.focus_all(Focus.Type.TRIANGLE)
  Events.choosing_enemy_state_entered.emit()
  assert_true(enemy_1.finger_focus.visible)
  assert_false(enemy_2.finger_focus.visible)

  gut.p("-----focus is set to current_member -----")
  enemy_group.current_state_member = enemy_2
  Events.choosing_enemy_state_entered.emit()
  assert_false(enemy_1.finger_focus.visible)
  assert_true(enemy_2.finger_focus.visible)


