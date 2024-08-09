extends GutTest

var skill: Ingress


func before_each() -> void:
	Utils.is_test = true


func after_each() -> void:
	skill = null


func test_can_create_all_elements() -> void:
	# skill = Ing.load_ingress([Ingress.Id.REFRAIN_BLOCK, Element.Type.ETH])
	# assert_not_null(skill)
	# skill = Ing.load_ingress([Ingress.Id.REFRAIN_BLOCK, Element.Type.ENH])
	# assert_not_null(skill)
	skill = Ing.load_ingress([Ingress.Id.REFRAIN_BLOCK, Element.Type.SHOR])
	assert_not_null(skill)
	skill = Ing.load_ingress([Ingress.Id.REFRAIN_BLOCK, Element.Type.SCOR])
	assert_not_null(skill)


func test_can_process_correctly() -> void:
	var mocker := MockCreator.new()
	add_child_autoqfree(mocker)
	mocker.initialize(add_child_autoqfree)

	skill = Ing.load_ingress([Ingress.Id.REFRAIN_BLOCK, Element.Type.SCOR])
	_set_action_skill(mocker, mocker.player, mocker.enemy, skill)

	gut.p("----Test player can use----")
	await skill.process(mocker.action, get_tree(), mocker.battle_groups)
	assert_eq(
		mocker.player.current_ingress(),
		_remaining_ingress(mocker.MAX_INGRESS, skill.ingress),
		"Player Ingress"
	)
	assert_true(_flag(mocker.enemy, "has_refrain_block"), "has_refrain_block")
	assert_true(mocker.enemy.refrain_block.visible, "Refrain block visible")
	assert_eq(_flag(mocker.enemy, "current_refrain_block_element"), Element.Type.SCOR, "current_refrain_block_element")
	assert_eq(_flag(mocker.enemy, "refrain_blocker"), mocker.player, "refrain_blocker")

func test_it_blocks_incursion() -> void:
	var mocker := MockCreator.new()
	add_child_autoqfree(mocker)
	mocker.initialize(add_child_autoqfree)

	var refrain_block := Ing.load_ingress([Ingress.Id.REFRAIN_BLOCK, Element.Type.SCOR])
	_set_action_skill(mocker, mocker.player, mocker.enemy, refrain_block)
	await refrain_block.process(mocker.action, get_tree(), mocker.battle_groups)

	var incursion := Ing.load_ingress([Ingress.Id.INCURSION, Element.Type.SHOR])
	_set_action_skill(mocker, mocker.enemy, mocker.player, incursion)
	await incursion.process(mocker.action, get_tree(), mocker.battle_groups)

	gut.p("Check all flags are reset after use")
	assert_false(_flag(mocker.enemy, "has_refrain_block"), "has_refrain_block")
	assert_false(mocker.enemy.refrain_block.visible, "Refrain block hidden")
	assert_eq(_flag(mocker.enemy, "current_refrain_block_element"), Element.Type.NONE, "current_refrain_block_element")
	assert_eq(_flag(mocker.enemy, "refrain_blocker"), null, "refrain_blocker")

	gut.p("Check player took no damamge")
	assert_eq(mocker.player.modifiers.current_ingress, mocker.MAX_INGRESS - refrain_block.ingress)

func test_matching_element() -> void:
	var mocker := MockCreator.new()
	add_child_autoqfree(mocker)
	mocker.initialize(add_child_autoqfree)

	var refrain_block := Ing.load_ingress([Ingress.Id.REFRAIN_BLOCK, Element.Type.SCOR])
	_set_action_skill(mocker, mocker.player, mocker.enemy, refrain_block)
	await refrain_block.process(mocker.action, get_tree(), mocker.battle_groups)

	var incursion := Ing.load_ingress([Ingress.Id.INCURSION, Element.Type.SCOR])
	_set_action_skill(mocker, mocker.enemy, mocker.player, incursion)
	await incursion.process(mocker.action, get_tree(), mocker.battle_groups)

	gut.p("Check all flags are reset after use")
	assert_false(_flag(mocker.enemy, "has_refrain_block"), "has_refrain_block")
	assert_false(mocker.enemy.refrain_block.visible, "Refrain block hidden")
	assert_eq(_flag(mocker.enemy, "current_refrain_block_element"), Element.Type.NONE, "current_refrain_block_element")
	assert_eq(_flag(mocker.enemy, "refrain_blocker"), null, "refrain_blocker")

	gut.p("Check player took no damamge")
	assert_eq(mocker.player.modifiers.current_ingress, mocker.MAX_INGRESS)

func _remaining_ingress(max_ingress: int, skill_ingress: int) -> int:
	return max_ingress - skill_ingress

func _flag(member: Node2D, flag: String) -> Variant:
	return member.modifiers[flag]

func _set_action_skill(mocker: MockCreator, actor: Node2D, target: Node2D, skill_to_set: Ingress) -> void:
	mocker.set_action_skill(skill_to_set)
	mocker.action.actor = actor
	mocker.action.target = target