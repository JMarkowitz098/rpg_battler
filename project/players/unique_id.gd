extends Resource
class_name UniqueId

var id: String

func _init(incoming_id: String = "") -> void:
	if(incoming_id): id = incoming_id
	else: id = str(randi() % 1000)
