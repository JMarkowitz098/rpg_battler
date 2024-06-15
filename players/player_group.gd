extends Node2D

@onready var slot_one_location := $SlotOneLocation
@onready var slot_two_location := $SlotTwoLocation
@onready var slot_three_location := $SlotThreeLocation
@onready var slot_four_location := $SlotFourLocation

const TALON := preload("res://players/Talon/talon.tscn")
const NASH := preload("res://players/Nash/nash.tscn")

var players: Array[Node2D] = []
var index: int = 0

func _ready() -> void:
	_instantiate_players()
	players[0].turn.focus()
	
# ----------------
# Public Functions
# ----------------
	
func switch_turn_focus(x: int, y: int) -> void:
	players[x].turn.focus()
	players[y].turn.unfocus()
	
func clear_focus() -> void:
	for player in players:
		player.focus.clear()
		
func clear_turn_focus() -> void:
	for player in players:
		player.turn.clear()
		
func remove_player_by_id(id: String) -> void:
	players = players.filter(func(player): return player.stats.unique_id != id)
	
# -----------------
# Private Functions
# -----------------
	
func _instantiate_players() -> void:
	var all_save_data := SaveAndLoadPlayer.load_all_players()
	
	var slot_index := 0
	for data in all_save_data:
		if(data):
			_instantiate_player(data)
			_set_location(slot_index, players[slot_index])
			slot_index += 1
		
func _instantiate_player(save_data: SaveData) -> void:
	var new_player: Node2D
	match save_data.player_id:
		Stats.PlayerId.TALON:
			new_player = TALON.instantiate()
		Stats.PlayerId.NASH:
			new_player = NASH.instantiate()
	add_child(new_player)
	new_player.stats.unique_id = save_data.unique_id
	
	if save_data.level > 1:
		_update_level(new_player, save_data)
	
	players.append(new_player)

func _update_level(player: Node2D, save_data: SaveData):
	var new_stats = LevelStats.load_level_data(save_data.player_id, save_data.level)
	player.stats.level_stats = new_stats
	player.stats.current_ingress = new_stats.max_ingress
	player.update_energy_bar()

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


