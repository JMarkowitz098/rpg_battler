extends Resource
class_name SaveData

var level: int
var player_id: int
var slot: int
var unique_id: String

func _init(n_level: int, n_player_id: int, n_slot: int, n_unique_id: String) -> void:
	level = n_level
	player_id = n_player_id
	slot = n_slot
	unique_id = n_unique_id
	
func format_for_save() -> Dictionary:
	return {
		"level": level,
		"player_id": player_id,
		"slot": slot,
		"unique_id": unique_id
	}
