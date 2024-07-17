extends Node

const SAVE_PATH = "res://save.cfg"
#const SAVE_PATH = "user://save.cfg"

const PARTY_SIZE = 4

@onready var config := ConfigFile.new()

func _ready() -> void:
	config.load(SAVE_PATH)

func save_player(player_slot: int, stats: PlayerSaveData) -> void:
	
	config.load(SAVE_PATH)
	# We want it to create a new file if one doesn't exist, so for now no check
	#var error = config.load(SAVE_PATH)
	#print("ERROR", error)
	#if error != OK: return null
	
	config.set_value("Players", str(player_slot), stats.format_for_save())
	
	config.save(SAVE_PATH)
	
func load_player(slot: int) -> PlayerSaveData:
	if config.has_section_key("Players", str(slot)):
		var data_dict: Variant = config.get_value("Players", str(slot))
		var save_data := PlayerSaveData.new({
			"level": data_dict.level,
			"player_id": data_dict.player_id,
			"slot": data_dict.slot,
			"unique_id": data_dict.unique_id
		})
		return save_data
		# return data_dict
	else:
		return null
		
func load_all_players() -> Array[PlayerSaveData]:
	var all_players_data: Array[PlayerSaveData] = []
	for i in PARTY_SIZE:
		if load_player(i) is PlayerSaveData:
			all_players_data.append(load_player(i))
	return all_players_data
	
	
func clear_save_file() -> void:
	config.clear()
	config.save(SAVE_PATH)

	
