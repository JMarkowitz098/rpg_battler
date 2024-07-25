extends GutTest

var TestActionChoice := load("res://ui/action_choice.tscn")
var action_choice: GridContainer


func before_each() -> void:
	action_choice = TestActionChoice.instantiate()
	add_child_autoqfree(action_choice)


func test_can_create_action_choice() -> void:
	assert_not_null(action_choice)


func test_can_respond_to_choosing_action_state_entered_signal() -> void:
	gut.p("-----when no paramaters are passed-----")
	action_choice.hide()
	Events.choosing_action_state_entered.emit()
	assert_true(action_choice.visible, "is visible")
	assert_true(action_choice.incursion.has_focus(), "incursion has focus")
	assert_false(action_choice.refrain.has_focus(), "refrain does not have focus")
	assert_false(action_choice.recover.has_focus(), "recover does not have focus")

	gut.p("-----when button is passed-----")
	Events.choosing_action_state_entered.emit(StateParams.new(null, null, action_choice.refrain))
	assert_true(action_choice.visible, "is visible")
	assert_false(action_choice.incursion.has_focus(), "incursion does not have focus")
	assert_true(action_choice.refrain.has_focus(), "refrain does have focus")
	assert_false(action_choice.recover.has_focus(), "recover does not have focus")

	gut.p("-----when no button is passed but there is a current button-----")
	Events.choosing_action_state_entered.emit()
	assert_true(action_choice.visible, "is visible")
	assert_false(action_choice.incursion.has_focus(), "incursion does not have focus")
	assert_true(action_choice.refrain.has_focus(), "refrain does have focus")
	assert_false(action_choice.recover.has_focus(), "recover does not have focus")
