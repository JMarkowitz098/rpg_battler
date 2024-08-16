extends GutTest

const TALON_STARTING_DATA := preload("res://players/Talon/details/talon_starting_data.tres")
const NASH_STARTING_DATA := preload("res://players/Nash/details/nash_starting_data.tres")
const ESEN_STARTING_DATA := preload("res://players/Esen/details/esen_starting_data.tres")
const NALTA_STARTING_DATA := preload("res://players/Nalta/details/nalta_starting_data.tres")


var TestTeamSelectScreen := load("res://menus/team_select_screen.tscn")
var screen: Panel


func before_each() -> void:
	Utils.is_test = true
	screen = TestTeamSelectScreen.instantiate()
	add_child_autoqfree(screen)


func test_can_create_team_select_screen() -> void:
	assert_not_null(screen)


func test_talon_and_nash_selected_on_load() -> void:
	assert_true(screen.team_one_button.has_focus(), "button has focus")
	_assert_slot(screen.slot_one, TALON_STARTING_DATA)
	_assert_slot(screen.slot_two, NASH_STARTING_DATA)


func test_esen_and_sorah_selected_on_load() -> void:
	screen.team_two_button.focus()
	assert_true(screen.team_two_button.has_focus(), "button has focus")
	_assert_slot(screen.slot_one, ESEN_STARTING_DATA)
	# _assert_slot(screen.slot_two, SORAH_STARTING_DATA) # Sorah not created yet


func test_nalta_and_devlin_selected_on_load() -> void:
	screen.team_three_button.focus()
	assert_true(screen.team_three_button.has_focus(), "button has focus")
	_assert_slot(screen.slot_one, NALTA_STARTING_DATA)
	# _assert_slot(screen.slot_two, DEVLIN_STARTING_DATA) # Sorah not created yet


func _assert_slot(slot: VBoxContainer, details: PlayerData) -> void:
	assert_eq(slot.portrait.texture, Utils.get_player_portrait(details.player_details.player_id))
	assert_eq(slot.character_name.text, details.player_details.label)
	assert_eq(slot.ingress.text, "Ingress: " + str(details.stats.max_ingress))
	assert_eq(slot.incursion.text, "Incursion: " + str(details.stats.incursion))
	assert_eq(slot.refrain.text, "Refrain: " + str(details.stats.refrain))
	assert_eq(slot.agility.text, "Agility: " + str(details.stats.agility))
	assert_eq(slot.elements.text, _elements_text(details.player_details.elements))


func _elements_text(elements: Array[Element.Type]) -> String:
	var new_str := "Elements: \n"
	for elem_id: Element.Type in elements:
		new_str += Element.get_label(elem_id) + ", "
	return new_str.trim_suffix(", ")
