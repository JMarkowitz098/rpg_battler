extends ColorRect

const MAX_SLOTS := 2

@onready var slot_one_button := $VBoxContainer/HBoxContainer/SlotOneContainer/SlotOneButton
@onready var slot_two_button := $VBoxContainer/HBoxContainer/SlotTwoContainer/SlotTwoButton
@onready var slot_one_portrait := $VBoxContainer/HBoxContainer/SlotOneContainer/SlotOnePortrait
@onready var slot_two_portrait := $VBoxContainer/HBoxContainer/SlotTwoContainer/SlotTwoPortrait
@onready var start_button := $VBoxContainer/StartButton

const TALON_PORTRAIT := preload("res://players/Talon/TalonPortrait.jpeg")
const TALON_PLAYER_DETAILS := preload("res://players/Talon/talon_player_details.tres")
const NASH_PORTRAIT := preload("res://players/Nash/NashPortrait.jpeg")
const NASH_PLAYER_DETAILS = preload("res://players/Nash/nash_player_details.tres")

func _ready():
	_set_focus()
	_render_player_slots()

func _set_focus():
	match Utils.get_param("slot"):
		0:
			slot_one_button.focus()
		1: 
			slot_two_button.focus()
		_:
			slot_one_button.focus()
	
func _render_player_slots():
	for player_slot_index in MAX_SLOTS:
		_render_slot(player_slot_index)
	
func _render_slot(slot_index: int):
	var save_data := SaveAndLoadPlayer.load_player(slot_index)
	if not save_data:
		return
		
	var player_details: Resource
	var player_portrait: Texture2D
	
	match save_data.player_id:
		Stats.PlayerId.TALON:
			player_details = TALON_PLAYER_DETAILS
			player_portrait = TALON_PORTRAIT
		Stats.PlayerId.NASH:
			player_details = NASH_PLAYER_DETAILS
			player_portrait = NASH_PORTRAIT
	
	match slot_index:
		0:
			slot_one_button.text = player_details.label
			slot_one_portrait.texture = player_portrait
			
		1: 
			slot_two_button.text = player_details.label
			slot_two_portrait.texture = player_portrait
		#2:
			#slot_three_button_container.text = slot.label
		#3: 
			#slot_four_button_container.text = slot.label
			
func _change_to_character_creation(slot):
	Utils.change_scene("res://menus/character_creation_menu.tscn", { "slot": slot })

func _on_slot_one_button_pressed():
	_change_to_character_creation(0)

func _on_slot_two_button_pressed():
	_change_to_character_creation(1)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://world/battle_scene.tscn")
