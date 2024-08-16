extends Panel

const TALON_STARTING_DATA := preload("res://players/Talon/details/talon_starting_data.tres")
const NASH_STARTING_DATA := preload("res://players/Nash/details/nash_starting_data.tres")
const ESEN_STARTING_DATA := preload("res://players/Esen/details/esen_starting_data.tres")
const NALTA_STARTING_DATA := preload("res://players/Nalta/details/nalta_starting_data.tres")

@onready var team_one_button := $Top/Columns/TeamButtons/TeamOneButton
@onready var team_two_button := $Top/Columns/TeamButtons/TeamTwoButton
@onready var team_three_button := $Top/Columns/TeamButtons/TeamThreeButton
@onready var slot_one := $Top/Columns/SlotOne
@onready var slot_two := $Top/Columns/SlotTwo
@onready var done := $Top/Columns/TeamButtons/Done
@onready var delete_popup := $DeletePopup
@onready var no_button := $DeletePopup/VBoxContainer/HBoxContainer/NoButton

var team_one_data: SaveFileData
var team_two_data: SaveFileData
var team_three_data: SaveFileData
var current_data: SaveFileData

var slot_one_data: PlayerData
var slot_two_data: PlayerData

var save_and_load := SaveAndLoad.new()
var current := team_one_button


func _ready() -> void:
	_load_team_data()
	team_one_button.focus()


func _process(_delta: float) -> void:
	_handle_input()


func _on_team_one_button_focus_entered() -> void:
	_handle_focus(team_one_data, [TALON_STARTING_DATA, NASH_STARTING_DATA])
	current = team_one_button


func _on_team_two_button_focus_entered() -> void:
	_handle_focus(team_two_data, [ESEN_STARTING_DATA, TALON_STARTING_DATA])
	current = team_two_button


func _on_team_three_button_focus_entered() -> void:
	_handle_focus(team_three_data, [NALTA_STARTING_DATA, TALON_STARTING_DATA])
	current = team_three_button


func _load_team_data() -> void:
	team_one_data = save_and_load.load_data("0")
	team_two_data = save_and_load.load_data("1")
	team_three_data = save_and_load.load_data("2")


func _handle_focus(team_data: SaveFileData, starting_data: Array[PlayerData]) -> void:
	current_data = team_data
	var round_num := Round.Number.ONE
	if team_data:
		_update_slot_data(team_data.players_data)
		round_num = team_data.round_number
	else:
		_update_slot_data(starting_data)
	_update_slots(round_num)


func _on_team_one_button_pressed() -> void:
	_handle_press("0")


func _on_team_two_button_pressed() -> void:
	_handle_press("1")


func _on_team_three_button_pressed() -> void:
	_handle_press("2")


func _on_no_button_pressed() -> void:
	_return()


func _on_yes_button_pressed() -> void:
	var file_id: String
	match(current):
		team_one_button:
			file_id = "0"
		team_two_button:
			file_id = "1"
		team_three_button:
			file_id = "2"
	save_and_load.clear_team_data(file_id)
	_load_team_data()
	_return()


func _handle_input() -> void:
	if Input.is_action_just_pressed("to_action_queue") and current_data:
		delete_popup.show()
		no_button.focus()

	if Input.is_action_just_pressed("menu_back") and delete_popup.visible:
		_return()


func _return() -> void:
	delete_popup.hide()
	current.focus()

func _update_slot_data(players_data: Array[PlayerData]) -> void:
	slot_one_data = players_data[0]
	slot_two_data = players_data[1]


func _update_slots(round_num: Round.Number) -> void:
	_update_slot(slot_one, slot_one_data)
	_update_slot(slot_two, slot_two_data)
	if round_num == Round.Number.ONE:
		done.text = "New Game"
	else:	
		done.text = "Done: " +str((round_num + 1) / 5.0 * 100) + "%"


func _update_slot(slot: VBoxContainer, data: PlayerData) -> void:
	slot.portrait.texture = Utils.get_player_portrait(data.player_details.player_id)
	slot.character_name.text = data.player_details.label
	slot.ingress.text = _stat_text("Ingress", data.stats.max_ingress)
	slot.incursion.text = _stat_text("Incursion", data.stats.incursion)
	slot.refrain.text = _stat_text("Refrain", data.stats.refrain)
	slot.agility.text = _stat_text("Agility", data.stats.agility)
	slot.elements.text = _elements_text(data.player_details.elements)


func _stat_text(label: String, val: int) -> String:
	return label + ": " + str(val)


func _elements_text(elements: Array[Element.Type]) -> String:
	var new_str := "Elements: \n"
	for elem_id: Element.Type in elements:
		new_str += Element.get_label(elem_id) + ", "
	return new_str.trim_suffix(", ")


func _handle_press(save_id: String) -> void:
	slot_one_data.slot = 0
	slot_two_data.slot = 1
	var players_data: Array[PlayerData] = [slot_one_data, slot_two_data]
	var save_data := SaveFileData.new(
		save_id, players_data, 
		Time.get_datetime_string_from_system(), 
		Round.Number.ONE
	)
	save_and_load.save_data(save_data)

