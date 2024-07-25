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


func test_can_respond_to_choosing_skill_state_entered_signal() -> void:
	var mocker := MockCreator.new()
	mocker.initialize(add_child_autoqfree)
	mocker.create_action_queue_items()
	add_child_autofree(mocker)
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
	for button in skill_choice_list.get_children():
		assert_connected(button, skill_choice_list, "pressed", "_handle_choose_skill")
	assert_true(skill_choice_list.get_children()[0].has_focus(), "First button has focus")

	gut.p("-----State is remembered if no params are passed-----")
	Events.choosing_skill_state_entered.emit()
	assert_eq_deep(
		skill_choice_list.current_skills, 
		player_1.learned_skills.filter_by_type(Ingress.Type.INCURSION),
	)
	assert_eq(skill_choice_list.get_children().size(), skill_choice_list.current_skills.size())
	for button in skill_choice_list.get_children():
		assert_connected(button, skill_choice_list, "pressed", "_handle_choose_skill")