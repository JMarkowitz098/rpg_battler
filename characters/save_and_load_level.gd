class_name SaveAndLoadLevel

const FILE_PATH := "res://characters/levels.cfg"

var config := ConfigFile.new()

func _init():
	config.load(FILE_PATH)
	
func get_data(player_id: int, level: int):
	return config.get_value(str(player_id), str(level))
