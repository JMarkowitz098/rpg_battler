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
	assert_true(skill_choice_list.visible, "is not visible")