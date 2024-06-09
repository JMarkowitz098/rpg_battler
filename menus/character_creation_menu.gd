extends ColorRect

const TALON := preload("res://characters/Talon/talon.tscn")
const NASH := preload("res://characters/Nash/nash.tscn")

@onready var talon_button := $VBoxContainer/TalonButton
@onready var nash_button := $VBoxContainer/NashButton

var player_slot: int

func _ready() -> void:
	player_slot = Utils.get_param("slot")
	talon_button.grab_focus()

func _create_and_save_new_player(Player: PackedScene) -> void:
	var new_player = Player.instantiate()
	# Have to add Player to scene before it will fully initialize for some reason
	get_tree().current_scene.add_child(new_player)
	
	var stats = _create_stats_dict(new_player)
	
	SaveAndLoadPlayer.save_player(player_slot, stats)
	new_player.queue_free()
	
	
func _create_stats_dict(new_player: Node2D) -> Dictionary:
	return {
		"unique_id": CharacterStats.create_unique_id(new_player.stats.player_id),
		"player_id": new_player.stats.player_id,
		"label": new_player.stats.label,
		"icon_type": CharacterStats.IconType.PLAYER,
		"elements": [CharacterStats.Element.ETH, CharacterStats.Element.SHOR],
		"max_ingress_energy": new_player.stats.max_ingress_energy,
		"current_ingress_energy": new_player.stats.current_ingress_energy,
		"incursion_power": new_player.stats.incursion_power,
		"refrain_power": new_player.stats.refrain_power,
		"agility": new_player.stats.agility,
		"slot": player_slot,
		"skills": new_player.skills.get_children().map(func(skill): return skill.id)
	}


func _on_talon_button_pressed():
	_create_and_save_new_player(TALON)
	get_tree().change_scene_to_file("res://menus/character_menu.tscn")

func _on_nash_button_pressed():
	_create_and_save_new_player(NASH)
	get_tree().change_scene_to_file("res://menus/character_menu.tscn")
