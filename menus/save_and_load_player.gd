extends Node

const SAVE_PATH = "res://save.cfg"
#const SAVE_PATH = "user://save.cfg"

const PARTY_SIZE = 4

@onready var config = ConfigFile.new()

func _ready():
	config.load(SAVE_PATH)

func save_player(player_slot, stats):
	#config.load(SAVE_PATH)
	# We want it to create a new file if one doesn't exist, so for now no check
	#var error = config.load(SAVE_PATH)
	#if error != OK: return null
	
	config.set_value("Players", str(player_slot), stats)
	config.save(SAVE_PATH)
	
func load_player(id: int):
	if config.has_section_key("Players", str(id)):
		#var error = config.load(SAVE_PATH)
		#if error != OK: return null
		var player = config.get_value("Players", str(id))
		return player
	else:
		return null
		
func load_all_players() -> Array:
	var players_stats = []
	for i in PARTY_SIZE:
		players_stats.append(load_player(i))
	return players_stats
	
	
func clear_save_file():
	config.clear()
	config.save(SAVE_PATH)
	