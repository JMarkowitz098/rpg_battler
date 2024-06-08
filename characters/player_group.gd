extends Node2D

@onready var slot_one_location := $SlotOneLocation
@onready var slot_two_location := $SlotTwoLocation
@onready var slot_three_location := $SlotThreeLocation
@onready var slot_four_location := $SlotFourLocation

const TALON := preload("res://characters/Talon/talon.tscn")

var players: Array[Node2D] = []
var index: int = 0

func _ready() -> void:
	_instantiate_players()
	players[0].focus.focus()
	
func switch_focus(x: int, y: int) -> void:
	players[x].focus.focus()
	players[y].focus.unfocus()
	
func reset_focus() -> void:
	index = 0
	for player in players:
		player.focus.unfocus()
		
func remove_player_by_id(id: String) -> void:
	players = players.filter(func(player): return player.stats.unique_id != id)
	
func _instantiate_players() -> void:
	var players_stats := SaveAndLoadPlayer.load_all_players()
	
	var slot_index := 0
	for loaded_stats in players_stats:
		if(loaded_stats):
			_instantiate_player(loaded_stats)
			_set_location(slot_index, players[slot_index])
			slot_index += 1
		
func _instantiate_player(loaded_stats: Dictionary) -> void:
	match loaded_stats.player_id:
		CharacterStats.PlayerId.TALON:
			var new_talon := TALON.instantiate()
			add_child(new_talon)
			_set_stats_on_loaded_player(new_talon, loaded_stats)
			_set_skills_on_loaded_player(new_talon, loaded_stats.skills)
			_set_name_on_loaded_player(new_talon)
			players.append(new_talon)
			new_talon._update_energy_bar()
			
func _set_stats_on_loaded_player(player: Node2D, loaded_stats: Dictionary) -> void:
	var stat_keys := [
		"unique_id",
		"player_id",
		"label",
		"icon_type",
		"elements",
		"max_ingress_energy",
		"current_ingress_energy",
		"incursion_power",
		"refrain_power",
		"agility",
		"slot"
	]
	for key in stat_keys:
		player.stats[key] = loaded_stats[key]

func _set_skills_on_loaded_player(player: Node2D, skills: Array):
	for skill in player.skills.get_children():
		skill.queue_free()
		
	for skill_id in skills:
		var skill = Skill.create_skill_instance(skill_id).instantiate()
		player.skills.add_child(skill)
		
func _set_name_on_loaded_player(player: Node2D):
	player.player_name.text = player.stats.label + " " + str(player.stats.slot)
	

func _set_location(slot_index: int, player: Node2D) -> void:
	match slot_index:
		0:
			player.global_position = slot_one_location.global_position
		1:
			player.global_position = slot_two_location.global_position
		2: 
			player.global_position = slot_three_location.global_position
		3:
			player.global_position = slot_four_location.global_position
			
	
	
func _on_battle_scene_next_player() -> void:
	if index < players.size() - 1:
		index += 1
		switch_focus(index, index - 1)
	else:
		index = 0
		switch_focus(index, players.size() - 1)

