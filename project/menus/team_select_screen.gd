extends Panel

const TALON_STARTING_DATA := preload("res://players/Talon/details/talon_starting_data.tres")
const NASH_STARTING_DATA := preload("res://players/Nash/details/nash_starting_data.tres")
const ESEN_STARTING_DATA := preload("res://players/Esen/details/esen_starting_data.tres")
const NALTA_STARTING_DATA := preload("res://players/Nalta/details/nalta_starting_data.tres")

@onready var team_one_button := $HBoxContainer/TeamButtons/TeamOneButton
@onready var team_two_button := $HBoxContainer/TeamButtons/TeamTwoButton
@onready var team_three_button := $HBoxContainer/TeamButtons/TeamThreeButton
@onready var slot_one := $HBoxContainer/SlotOne
@onready var slot_two := $HBoxContainer/SlotTwo

var slot_one_starting_data: PlayerData
var slot_two_starting_data: PlayerData

func _ready() -> void:
	team_one_button.focus()


func _on_team_one_button_focus_entered() -> void:
	slot_one_starting_data = TALON_STARTING_DATA
	slot_two_starting_data = NASH_STARTING_DATA
	_update_slots()


func _on_team_two_button_focus_entered() -> void:
	slot_one_starting_data = ESEN_STARTING_DATA
	slot_two_starting_data = TALON_STARTING_DATA
	_update_slots()
	# slot_two_starting_data = SORAH_STARTING_DATA # TODO


func _on_team_three_button_focus_entered() -> void:
	slot_one_starting_data = NALTA_STARTING_DATA
	slot_two_starting_data = TALON_STARTING_DATA
	_update_slots()
	# slot_two_starting_data = DEVLIN_STARTING_DATA # TODO


func _update_slots() -> void:
	_update_slot(slot_one, slot_one_starting_data)
	_update_slot(slot_two, slot_two_starting_data)


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
