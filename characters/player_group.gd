extends Node2D

@onready var slot_one_location = $SlotOneLocation
@onready var slot_two_location = $SlotTwoLocation
@onready var slot_three_location = $SlotThreeLocation
@onready var slot_four_location = $SlotFourLocation

const KNIGHT := preload("res://characters/Knight/knight.tscn")

var players: Array[Node2D] = []
var index: int = 0

func _ready():
	_instantiate_players()
	players[0].focus.focus()
	
func switch_focus(x, y):
	players[x].focus.focus()
	players[y].focus.unfocus()
	
func reset_focus():
	index = 0
	for player in players:
		player.focus.unfocus()
		
func reset_defense():
	for player in players:
		player.stats.is_defending = false
		
func remove_player_by_id(id):
	players = players.filter(func(player): return player.stats.id != id)
	
func _instantiate_players():
	var players_stats := SaveAndLoadPlayer.load_all_players()
	
	var slot_index = 0
	for loaded_stats in players_stats:
		if(loaded_stats):
			_instantiate_player(loaded_stats)
			_set_location(slot_index, players[slot_index])
			slot_index += 1
		
func _instantiate_player(loaded_stats):
	match loaded_stats.character_type:
		CharacterStats.CharacterTypes.KNIGHT:
			var new_knight = KNIGHT.instantiate()
			add_child(new_knight)
			_set_stats_on_loaded_player(new_knight, loaded_stats)
			players.append(new_knight)
			
func _set_stats_on_loaded_player(player, loaded_stats):
	var stat_keys = [
		"max_health",
		"current_health",
		"attack",
		"defense",
		"label",
		"id",
		"icon_type",
		"character_type",
		"slot"
	]
	for key in stat_keys:
		player.stats[key] = loaded_stats[key]

func _set_location(index: int, player: Node2D):
	match index:
		0:
			player.global_position = slot_one_location.global_position
		1:
			player.global_position = slot_two_location.global_position
		2: 
			player.global_position = slot_three_location.global_position
		3:
			player.global_position = slot_four_location.global_position
			
	
	
func _on_battle_scene_next_player():
	if index < players.size() - 1:
		index += 1
		switch_focus(index, index - 1)
	else:
		index = 0
		switch_focus(index, players.size() - 1)

