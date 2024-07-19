extends GutTest

var skill: Ingress

func before_each() -> void:
	Utils.is_test = true

func after_each() -> void:
	skill = null

func test_can_create_all_elements() -> void:
	skill = Ing.load_ingress([Ingress.Id.REFRAIN, Element.Type.ETH])
	assert_not_null(skill)
	# skill = Ing.load_ingress([Ingress.Id.REFRAIN, Element.Type.ENH])
	# assert_not_null(skill)
	skill = Ing.load_ingress([Ingress.Id.REFRAIN, Element.Type.SHOR])
	assert_not_null(skill)
	skill = Ing.load_ingress([Ingress.Id.REFRAIN, Element.Type.SCOR])
	assert_not_null(skill)


func test_can_process_correctly() -> void:
	var mocker := MockCreator.new()
	add_child_autoqfree(mocker)
	mocker.initialize(add_child_autoqfree)

	skill = Ing.load_ingress([Ingress.Id.REFRAIN, Element.Type.ETH])
	mocker.set_action_skill(skill)
	mocker.set_action_target(Ingress.Target.SELF)

	gut.p("----Test player can use----")
	await skill.process(mocker.action, get_tree(), mocker.battle_groups)
	assert_eq(mocker.player.modifiers.current_ingress, _remaining_ingress(mocker.MAX_INGRESS, skill.ingress), "Player Ingress")
	assert_eq(mocker.player.modifiers.has_small_refrain_open, true, "Has small refrain open")
	assert_eq(mocker.player.modifiers.current_refrain_element, Element.Type.ETH, "Current Refrain Element")
	assert_eq(mocker.enemy.modifiers.current_ingress, mocker.MAX_INGRESS, "Enemy Ingress")

	gut.p("----Test enemy can use----")
	mocker.reset_members_ingress()
	mocker.action.actor = mocker.enemy
	mocker.action.target = mocker.enemy
	await skill.process(mocker.action, get_tree(), mocker.battle_groups)
	assert_eq(mocker.enemy.modifiers.current_ingress, _remaining_ingress(mocker.MAX_INGRESS, skill.ingress), "Enemy Ingress")
	assert_eq(mocker.enemy.modifiers.has_small_refrain_open, true, "Has small refrain open")
	assert_eq(mocker.enemy.modifiers.current_refrain_element, Element.Type.ETH, "Current Refrain Element")
	assert_eq(mocker.player.modifiers.current_ingress, mocker.MAX_INGRESS, "Player Ingress")

func _remaining_ingress(max_ingress: int, skill_ingress: int) -> int:
	return max_ingress - skill_ingress