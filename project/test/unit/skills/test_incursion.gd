extends GutTest

var skill: Ingress

func before_each() -> void:
	Utils.is_test = true

func after_each() -> void:
	skill = null

func test_can_create_all_elements() -> void:
	skill = Ing.load_ingress([Ingress.Id.INCURSION, Element.Type.ETH])
	assert_not_null(skill)
	skill = Ing.load_ingress([Ingress.Id.INCURSION, Element.Type.ENH])
	assert_not_null(skill)
	skill = Ing.load_ingress([Ingress.Id.INCURSION, Element.Type.SHOR])
	assert_not_null(skill)
	skill = Ing.load_ingress([Ingress.Id.INCURSION, Element.Type.SCOR])
	assert_not_null(skill)


func test_can_process_correctly() -> void:
	var mocker := MockCreator.new()
	add_child_autoqfree(mocker)
	mocker.initialize(add_child_autoqfree)

	skill = Ing.load_ingress([Ingress.Id.INCURSION, Element.Type.ETH])
	mocker.set_action_skill(skill)
	mocker.set_action_target(Ingress.Target.ENEMY)

	gut.p("----Test player can use----")
	await skill.process(mocker.action, get_tree(), mocker.battle_groups)
	assert_eq(mocker.player.modifiers.current_ingress, 6, "Player Ingress")
	assert_eq(mocker.enemy.modifiers.current_ingress, 4, "Enemy Ingress")

	gut.p("----Test enemy can use----")
	mocker.reset_members_ingress()
	mocker.action.actor = mocker.enemy
	mocker.action.target = mocker.player
	await skill.process(mocker.action, get_tree(), mocker.battle_groups)
	assert_eq(mocker.player.modifiers.current_ingress, 4, "Player Ingress")
	assert_eq(mocker.enemy.modifiers.current_ingress, 6, "Enemy Ingress")
