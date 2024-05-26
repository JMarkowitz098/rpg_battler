extends ColorRect

const KNIGHT := preload("res://characters/Knight/knight.tscn")

@onready var knight_button = $VBoxContainer/KnightButton

var player_slot: int

func _ready():
	player_slot = Utils.get_param("slot")
	knight_button.grab_focus()
	

func _on_knight_button_pressed():
	_create_and_save_knight()
	get_tree().change_scene_to_file("res://menus/character_menu.tscn")

func _create_and_save_knight():
	var new_knight = KNIGHT.instantiate()
	# Have to add knight to scene before it will fully initialize for some reason
	get_tree().current_scene.add_child(new_knight)
	
	var stats = {
		"max_health": new_knight.stats.max_health,
		"current_health": new_knight.stats.current_health,
		"attack": new_knight.stats.attack,
		"defense": new_knight.stats.defense,
		"id": "knight_" + str(player_slot),
		"label": "Knight",
		"icon_type": CharacterStats.IconTypes.PLAYER,
		"slot": player_slot,
		"character_type": CharacterStats.CharacterTypes.KNIGHT
	}
	
	SaveAndLoadPlayer.save_player(player_slot, stats)
	new_knight.queue_free()
