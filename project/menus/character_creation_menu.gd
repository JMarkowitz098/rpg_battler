extends ColorRect

const TALON_STARTING_DATA := preload("res://players/Talon/details/talon_starting_data.tres")
const NASH_STARTING_DATA := preload("res://players/Nash/details/nash_starting_data.tres")
const ESEN_STARTING_DATA := preload("res://players/Esen/details/esen_starting_data.tres")

@onready var agility := $VBoxContainer/HBoxContainer/CharacterDetails/Agility
@onready var character_name := $VBoxContainer/HBoxContainer/CharacterDetails/CharacterName
@onready var elements := $VBoxContainer/HBoxContainer/CharacterDetails/Elements
@onready var esen_button := $VBoxContainer/HBoxContainer/CharacterButtons/EsenButton
@onready var incursion := $VBoxContainer/HBoxContainer/CharacterDetails/Incursion
@onready var ingress := $VBoxContainer/HBoxContainer/CharacterDetails/Ingress
@onready var nash_button := $VBoxContainer/HBoxContainer/CharacterButtons/NashButton
@onready var portrait := $VBoxContainer/HBoxContainer/CharacterDetails/Control/Portrait
@onready var refrain := $VBoxContainer/HBoxContainer/CharacterDetails/Refrain
@onready var talon_button := $VBoxContainer/HBoxContainer/CharacterButtons/TalonButton

var player_data := TALON_STARTING_DATA

var player_slot: int

func _ready() -> void:
	player_slot = Utils.get_param("slot")
	talon_button.focus_no_sound()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu_back"):
		Sound.play(Sound.focus)
		Utils.change_scene("res://menus/character_menu.tscn", { "slot": player_slot })
	
# -------
# Signals
# -------

func _on_talon_button_pressed() -> void:
	Sound.play(Sound.confirm)
	_create_and_save_new_player()
	Utils.change_scene("res://menus/character_menu.tscn", { "slot": player_slot })

func _on_nash_button_pressed() -> void:
	Sound.play(Sound.confirm)
	_create_and_save_new_player()
	Utils.change_scene("res://menus/character_menu.tscn", { "slot": player_slot })

func _on_esen_button_pressed() -> void:
	Sound.play(Sound.confirm)
	_create_and_save_new_player()
	Utils.change_scene("res://menus/character_menu.tscn", { "slot": player_slot })

# ----------------
# Helper Functions
# ----------------

func _create_and_save_new_player() -> void:
	var save_and_load := SaveAndLoad.new()
	player_data.slot = player_slot
	save_and_load.save_player("0", player_slot, player_data)
	
	
func _on_talon_button_focus_entered() -> void:
	player_data = TALON_STARTING_DATA
	_update_display_info(Utils.get_player_portrait(Player.Id.TALON))

func _on_nash_button_focus_entered() -> void:
	player_data = NASH_STARTING_DATA
	_update_display_info(Utils.get_player_portrait(Player.Id.NASH))
	
func _on_esen_button_focus_entered() -> void:
	player_data = ESEN_STARTING_DATA
	_update_display_info(Utils.get_player_portrait(Player.Id.ESEN))
		
func _update_display_info(player_portrait: Texture2D) -> void:
	# Ensure nodes have loaded. Focus signals seem to trigger before ready
	if !character_name: return
	
	character_name.text = player_data.player_details.label
	portrait.texture = player_portrait
	ingress.text = "Ingress: " + str(player_data.stats.max_ingress)
	incursion.text = "Incursion: " + str(player_data.stats.incursion)
	refrain.text = "Refrain: " + str(player_data.stats.refrain)
	agility.text = "Agility: " + str(player_data.stats.agility)
	elements.text = _create_elements_text()

func _create_elements_text() -> String:
	var new_str := "Elements: "
	for elem_id: Element.Type in player_data.player_details.elements:
		new_str += Element.get_label(elem_id) + ", "
	return new_str.trim_suffix(", ")

