extends Resource
class_name PlayerSaveData

var level: int
var player_id: int
var slot: int
var unique_id: String

func _init(init: Dictionary) -> void:
	level = init.level
	player_id = init.player_id
	slot = init.slot
	unique_id = init.unique_id
	
func format_for_save() -> Dictionary:
	return {
		"level": level,
		"player_id": player_id,
		"slot": slot,
		"unique_id": unique_id
	}
