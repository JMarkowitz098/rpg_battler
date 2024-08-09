extends GutTest

var skill: Ingress


func before_each() -> void:
	Utils.is_test = true


func after_each() -> void:
	skill = null


func test_can_create_all_elements() -> void:
	# skill = Ing.load_ingress([Ingress.Id.ALLY_REFRAIN, Element.Type.ETH])
	# assert_not_null(skill)
	# skill = Ing.load_ingress([Ingress.Id.ALLY_REFRAIN, Element.Type.ENH])
	# assert_not_null(skill)
	skill = Ing.load_ingress([Ingress.Id.ALLY_REFRAIN, Element.Type.SHOR])
	assert_not_null(skill)
	skill = Ing.load_ingress([Ingress.Id.ALLY_REFRAIN, Element.Type.SCOR])
	assert_not_null(skill)


func test_can_process() -> void:
	var mocker := MockCreator.new()
	add_child_autoqfree(mocker)
	mocker.initialize(add_child_autoqfree)

	skill = Ing.load_ingress([Ingress.Id.ALLY_REFRAIN, Element.Type.SHOR])
	mocker.set_action_skill(skill)
	mocker.action.target = mocker.player_2

	await skill.process(mocker.action, get_tree(), mocker.battle_groups)
	assert_eq(
		mocker.player.current_ingress(),
		_remaining_ingress(mocker.MAX_INGRESS, skill.ingress),
		"Player Ingress"
	)
	assert_true(mocker.player_2.modifiers.has_small_refrain_open, "Has small refrain open")
	assert_true(mocker.player_2.refrain_aura.visible, "refrain aura visible")
	assert_eq(
		mocker.player_2.modifiers.current_refrain_element, Element.Type.SHOR, "Current Refrain Element"
	)
	assert_eq(mocker.player_2.modifiers.refrain_actor, mocker.player, "refrain_actor")


func test_actor_recovers_ingress() -> void:
	var mocker := MockCreator.new()
	add_child_autoqfree(mocker)
	mocker.initialize(add_child_autoqfree)

	var ally_refrain := Ing.load_ingress([Ingress.Id.ALLY_REFRAIN, Element.Type.SHOR])
	mocker.set_action_skill(ally_refrain)
	mocker.action.target = mocker.player_2
	await ally_refrain.process(mocker.action, get_tree(), mocker.battle_groups)

	var incursion := Ing.load_ingress([Ingress.Id.INCURSION, Element.Type.SHOR])
	mocker.set_action_skill(incursion)
	mocker.action.actor = mocker.enemy
	mocker.action.target = mocker.player_2
	await incursion.process(mocker.action, get_tree(), mocker.battle_groups)

	assert_eq(mocker.player.current_ingress(), mocker.MAX_INGRESS, "Player Ingress")
	assert_eq(mocker.player_2.current_ingress(), mocker.MAX_INGRESS, "Player 2 Ingress")
	assert_false(mocker.player_2.modifiers.has_small_refrain_open, "Has small refrain open")
	assert_false(mocker.player_2.refrain_aura.visible, "refrain aura hidden")
	assert_eq(
		mocker.player_2.modifiers.current_refrain_element, Element.Type.NONE, "Current Refrain Element"
	)
	assert_null(mocker.player_2.modifiers.refrain_actor, "refrain_actor")


func _remaining_ingress(max_ingress: int, skill_ingress: int) -> int:
	return max_ingress - skill_ingress