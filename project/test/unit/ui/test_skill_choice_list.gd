extends GutTest

var TestSkillChoiceList := load("res://ui/skill_choice_list.tscn")
var skill_choice_list: GridContainer


func before_each() -> void:
	skill_choice_list = TestSkillChoiceList.instantiate()
	add_child_autoqfree(skill_choice_list)


func test_can_create_action_choice() -> void:
	assert_not_null(skill_choice_list)

func test_can_respond_to_choosing_action_state_entered_signal() -> void:
	skill_choice_list.show()
	Events.choosing_action_state_entered.emit()
	assert_false(skill_choice_list.visible, "is not visible")


func test_can_set_current_skills() -> void:
	var mocker := _mocker_setup()
	var player := mocker.player

	gut.p("-----Can set current skills to incursion-----")
	skill_choice_list.set_current_skills(player, Ingress.Type.INCURSION)
	assert_eq_deep(
		skill_choice_list.current_skills, 
		player.learned_skills.filter_by_type(Ingress.Type.INCURSION),
	)

	gut.p("-----Can set current skills to refrain-----")
	skill_choice_list.set_current_skills(player, Ingress.Type.REFRAIN)
	assert_eq_deep(
		skill_choice_list.current_skills, 
		player.learned_skills.filter_by_type(Ingress.Type.REFRAIN),
	)


func test_can_prepare_skill_menu() -> void:
	var mocker := _mocker_setup()
	var player := mocker.player

	skill_choice_list.set_current_skills(player, Ingress.Type.INCURSION)
	skill_choice_list.prepare_skill_menu()
	assert_eq(skill_choice_list.get_children().size(), skill_choice_list.current_skills.size())
	for button in skill_choice_list.get_children():
		assert_connected(button, skill_choice_list, "pressed", "_handle_choose_skill")
		assert_connected(button, skill_choice_list, "focus_entered", "_handle_button_focus")


func test_can_update_current_button_on_focus_change() -> void:
	var mocker := _mocker_setup()
	var player := mocker.player

	skill_choice_list.set_current_skills(player, Ingress.Type.INCURSION)
	skill_choice_list.prepare_skill_menu()
	_get_button(1).focus_no_sound()
	assert_eq(skill_choice_list.current_skill_button, _get_button(1))


func test_can_respond_to_choosing_skill_state_entered_signal() -> void:
	var mocker := _mocker_setup()
	var player_1 := mocker.player

	gut.p("-----Can set current skills to incursion-----")
	Events.choosing_skill_state_entered.emit(StateParams.new(
		mocker.item_1,
		null,
		null,
		Ingress.Type.INCURSION
	))
	assert_eq_deep(
		skill_choice_list.current_skills, 
		player_1.learned_skills.filter_by_type(Ingress.Type.INCURSION),
	)
	assert_eq(skill_choice_list.get_children().size(), skill_choice_list.current_skills.size())
	assert_true(_get_button(0).has_focus(), "First button has focus")

	gut.p("-----Can set current skills to refrain-----")
	Events.choosing_skill_state_entered.emit(StateParams.new(
		mocker.item_1,
		null,
		null,
		Ingress.Type.REFRAIN
	))
	assert_eq_deep(
		skill_choice_list.current_skills, 
		player_1.learned_skills.filter_by_type(Ingress.Type.REFRAIN),
	)
	assert_eq(skill_choice_list.get_children().size(), skill_choice_list.current_skills.size())
	assert_true(_get_button(0).has_focus(), "First button has focus")

	gut.p("-----State is remembered if no params are passed-----")
	_get_button(1).focus_no_sound()
	Events.choosing_skill_state_entered.emit()
	assert_eq_deep(
		skill_choice_list.current_skills, 
		player_1.learned_skills.filter_by_type(Ingress.Type.REFRAIN),
	)
	assert_eq(skill_choice_list.get_children().size(), skill_choice_list.current_skills.size())
	assert_true(skill_choice_list.get_children()[1].has_focus(), "Second button has focus")


func _get_button(i: int) -> Button:
	return skill_choice_list.get_children()[i]


func _mocker_setup() -> MockCreator:
	var mocker := MockCreator.new()
	mocker.initialize(add_child_autoqfree)
	mocker.create_action_queue_items()
	add_child_autofree(mocker)
	return mocker