extends ColorRect

const ESEN_LEVEL_1 := preload("res://players/Esen/levels/esen_level_1.tres")
const NASH_LEVEL_1 = preload("res://players/Nash/levels/nash_level_1.tres")
const TALON_LEVEL_1 := preload("res://players/Talon/levels/talon_level_1.tres")

@onready var esen_button := $VBoxContainer/HBoxContainer/CharacterButtons/EsenButton
@onready var talon_button := $VBoxContainer/HBoxContainer/CharacterButtons/TalonButton
@onready var nash_button := $VBoxContainer/HBoxContainer/CharacterButtons/NashButton
@onready var character_name := $VBoxContainer/HBoxContainer/CharacterDetails/CharacterName
@onready var portrait := $VBoxContainer/HBoxContainer/CharacterDetails/Control/Portrait
@onready var ingress := $VBoxContainer/HBoxContainer/CharacterDetails/Ingress
@onready var incursion := $VBoxContainer/HBoxContainer/CharacterDetails/Incursion
@onready var refrain := $VBoxContainer/HBoxContainer/CharacterDetails/Refrain
@onready var agility := $VBoxContainer/HBoxContainer/CharacterDetails/Agility
@onready var elements := $VBoxContainer/HBoxContainer/CharacterDetails/Elements

var details := Utils.get_player_details(Stats.PlayerId.TALON)
var stats := TALON_LEVEL_1

var player_slot: int

func _ready() -> void:
	player_slot = Utils.get_param("slot")
	talon_button.focus(true)

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
	var save_data := PlayerSaveData.new({
		"level": 1,
		"player_id": details.player_id,
		"slot": player_slot,
		"unique_id": Stats.create_unique_id(details.player_id)
	})
	SaveAndLoadPlayer.save_player(player_slot, save_data)
	
func _on_talon_button_focus_entered() -> void:
	details = Utils.get_player_details(Stats.PlayerId.TALON)
	stats = TALON_LEVEL_1
	_update_display_info(Utils.get_player_portrait(Stats.PlayerId.TALON))

func _on_nash_button_focus_entered() -> void:
	details = Utils.get_player_details(Stats.PlayerId.NASH)
	stats = NASH_LEVEL_1
	_update_display_info(Utils.get_player_portrait(Stats.PlayerId.NASH))
	
func _on_esen_button_focus_entered() -> void:
	details = Utils.get_player_details(Stats.PlayerId.ESEN)
	stats = ESEN_LEVEL_1
	_update_display_info(Utils.get_player_portrait(Stats.PlayerId.ESEN))
		
func _update_display_info(player_portrait: Texture2D) -> void:
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
	for elem_id: Element.Type in details.elements:
		new_str += Element.get_label(elem_id) + ", "
	return new_str.trim_suffix(", ")

