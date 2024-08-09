extends GutTest

var skill: Ingress


func before_each() -> void:
	Utils.is_test = true


func after_each() -> void:
	skill = null


func test_can_create_all_elements() -> void:
	skill = Ing.load_ingress([Ingress.Id.GROUP_REFRAIN, Element.Type.ETH])
	assert_not_null(skill)
	# skill = Ing.load_ingress([Ingress.Id.GROUP_REFRAIN, Element.Type.ENH])
	# assert_not_null(skill)
	skill = Ing.load_ingress([Ingress.Id.GROUP_REFRAIN, Element.Type.SHOR])
	assert_not_null(skill)
	skill = Ing.load_ingress([Ingress.Id.GROUP_REFRAIN, Element.Type.SCOR])
	assert_not_null(skill)


func test_can_process_correctly() -> void:
	var mocker := _setup()

	await skill.process(mocker.action, get_tree(), mocker.battle_groups)
	assert_eq(
		mocker.player.current_ingress(),
		_remaining_ingress(mocker.MAX_INGRESS, skill.ingress),
		"Player Ingress"
	)
	assert_true(mocker.player.modifiers.has_small_refrain_open, "Has small refrain open")
	assert_true(mocker.player_2.modifiers.has_small_refrain_open, "Has small refrain open")
	assert_eq(mocker.player.modifiers.refrain_actor, mocker.player, "refrain_actor")
	assert_eq(mocker.player_2.modifiers.refrain_actor, mocker.player, "refrain_actor")
	assert_eq(
		mocker.player.modifiers.current_refrain_element, Element.Type.ETH, "Current Refrain Element"
	)
	assert_eq(
		mocker.player_2.modifiers.current_refrain_element, Element.Type.ETH, "Current Refrain Element"
	)

func test_enemy_can_use() -> void:
	var mocker := _setup()
	mocker.action.actor = mocker.enemy

	await skill.process(mocker.action, get_tree(), mocker.battle_groups)
	assert_eq(
		mocker.enemy.current_ingress(),
		_remaining_ingress(mocker.MAX_INGRESS, skill.ingress),
		"Enemy Ingress"
	)
	assert_true(mocker.enemy.modifiers.has_small_refrain_open, "Has small refrain open")
	assert_true(mocker.enemy_2.modifiers.has_small_refrain_open, "Has small refrain open")
	assert_eq(mocker.enemy.modifiers.refrain_actor, mocker.enemy, "refrain_actor")
	assert_eq(mocker.enemy_2.modifiers.refrain_actor, mocker.enemy, "refrain_actor")
	assert_eq(
		mocker.enemy.modifiers.current_refrain_element, Element.Type.ETH, "Current Refrain Element"
	)
	assert_eq(
		mocker.enemy_2.modifiers.current_refrain_element, Element.Type.ETH, "Current Refrain Element"
	)


func _remaining_ingress(max_ingress: int, skill_ingress: int) -> int:
	return max_ingress - skill_ingress

func _setup() -> MockCreator:
	var mocker := MockCreator.new()
	add_child_autoqfree(mocker)
	mocker.initialize(add_child_autoqfree)
	skill = Ing.load_ingress([Ingress.Id.GROUP_REFRAIN, Element.Type.ETH])
	mocker.set_action_skill(skill)
	return mocker