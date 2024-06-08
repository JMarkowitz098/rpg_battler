extends ColorRect

const TALON := preload("res://characters/Talon/talon.tscn")

@onready var talon_button = $VBoxContainer/TalonButton

var player_slot: int

func _ready():
	player_slot = Utils.get_param("slot")
	talon_button.grab_focus()
	

func _create_and_save_talon():
	var new_talon = TALON.instantiate()
	# Have to add Talon to scene before it will fully initialize for some reason
	get_tree().current_scene.add_child(new_talon)
	
	var stats = {
		"unique_id": CharacterStats.create_unique_id(CharacterStats.PlayerId.TALON),
		"player_id": CharacterStats.PlayerId.TALON,
		"label": "Talon",
		"icon_type": CharacterStats.IconType.PLAYER,
		"elements": [CharacterStats.Element.ETH, CharacterStats.Element.SHOR],
		"max_ingress_energy": new_talon.stats.max_ingress_energy,
		"current_ingress_energy": new_talon.stats.current_ingress_energy,
		"incursion_power": new_talon.stats.incursion_power,
		"refrain_power": new_talon.stats.refrain_power,
		"agility": new_talon.stats.agility,
		"slot": player_slot,
		"skills": new_talon.skills.get_children().map(func(skill): return skill.id)
	}
	
	SaveAndLoadPlayer.save_player(player_slot, stats)
	new_talon.queue_free()


func _on_talon_button_pressed():
	_create_and_save_talon()
	get_tree().change_scene_to_file("res://menus/character_menu.tscn")
