extends ColorRect

@onready var character_one_button = $HBoxContainer/CharacterOneButton
@onready var character_two_button = $HBoxContainer/CharacterTwoButton
@onready var character_three_button = $HBoxContainer/CharacterThreeButton
@onready var character_four_button = $HBoxContainer/CharacterFourButton

func _ready():
	character_one_button.grab_focus()
	_render_player_slots()
	
func _render_player_slots():
	for player_slot_index in 4:
		_render_slot(player_slot_index)
	
func _on_character_one_button_pressed():
	_change_to_character_creation(0)

func _on_character_two_button_pressed():
	_change_to_character_creation(1)
	
func _on_character_three_button_pressed():
	_change_to_character_creation(2)
	
func _on_character_four_button_pressed():
	_change_to_character_creation(3)
	
func _render_slot(slot_index):
	var slot = SaveAndLoadPlayer.load_player(slot_index)
	if not slot:
		return
		
	match slot_index:
		0:
			character_one_button.text = slot.label
		1: 
			character_two_button.text = slot.label
		2:
			character_three_button.text = slot.label
		3: 
			character_four_button.text = slot.label
			
	
func _change_to_character_creation(slot):
	Utils.change_scene("res://menus/character_creation_menu.tscn", { "slot": slot })


func _on_start_battle_button_pressed():
	get_tree().change_scene_to_file("res://world/battle_scene.tscn")
