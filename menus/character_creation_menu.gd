extends ColorRect

const NASH_PORTRAIT := preload("res://players/Nash/NashPortrait.jpeg")
const NASH_PLAYER_DETAILS = preload("res://players/Nash/nash_player_details.tres")
const NASH_LEVEL_1 = preload("res://players/Nash/levels/nash_level_1.tres")

const TALON_PORTRAIT := preload("res://players/Talon/TalonPortrait.jpeg")
const TALON_PLAYER_DETAILS := preload("res://players/Talon/talon_player_details.tres")
const TALON_LEVEL_1 := preload("res://players/Talon/levels/talon_level_1.tres")

@onready var talon_button := $VBoxContainer/HBoxContainer/CharacterButtons/TalonButton
@onready var nash_button := $VBoxContainer/HBoxContainer/CharacterButtons/NashButton
@onready var character_name := $VBoxContainer/HBoxContainer/CharacterDetails/CharacterName
@onready var portrait := $VBoxContainer/HBoxContainer/CharacterDetails/Control/Portrait
@onready var ingress := $VBoxContainer/HBoxContainer/CharacterDetails/Ingress
@onready var incursion := $VBoxContainer/HBoxContainer/CharacterDetails/Incursion
@onready var refrain := $VBoxContainer/HBoxContainer/CharacterDetails/Refrain
@onready var agility := $VBoxContainer/HBoxContainer/CharacterDetails/Agility
@onready var elements := $VBoxContainer/HBoxContainer/CharacterDetails/Elements

var details := TALON_PLAYER_DETAILS
var stats := TALON_LEVEL_1

var player_slot: int

func _ready() -> void:
	player_slot = Utils.get_param("slot")
	talon_button.focus()
	
# -------
# Signals
# -------

func _on_talon_button_pressed():
	_create_and_save_new_player()
	Utils.change_scene("res://menus/character_menu.tscn", { "slot": player_slot })

func _on_nash_button_pressed():
	_create_and_save_new_player()
	Utils.change_scene("res://menus/character_menu.tscn", { "slot": player_slot })

# ----------------
# Helper Functions
# ----------------

func _create_and_save_new_player() -> void:
	var save_data := SaveData.new(
		1, details.player_id, player_slot, Stats.create_unique_id(details.player_id))
	SaveAndLoadPlayer.save_player(player_slot, save_data.format_for_save())
	
func _on_talon_button_focus_entered():
	details = TALON_PLAYER_DETAILS
	stats = TALON_LEVEL_1
	_update_display_info(TALON_PORTRAIT)

func _on_nash_button_focus_entered():
	details = NASH_PLAYER_DETAILS
	stats = NASH_LEVEL_1
	_update_display_info(NASH_PORTRAIT)
		
func _update_display_info(player_portrait):
	# Ensure nodes have loaded. Focus signals seem to trigger before ready
	if !character_name: return
	
	character_name.text = details.label
	portrait.texture = player_portrait
	ingress.text = "Ingress: " + str(stats.max_ingress)
	incursion.text = "Incursion: " + str(stats.incursion)
	refrain.text = "Refrain: " + str(stats.refrain)
	agility.text = "Agility: " + str(stats.agility)
	elements.text = _create_elements_text()

func _create_elements_text() -> String:
	var new_str := "Elements: "
	for elem_id in details.elements:
		new_str += Stats.get_element_label(elem_id) + ", "
	return new_str.trim_suffix(", ")
