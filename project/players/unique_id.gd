class_name UniqueId

var id: String

func _init() -> void:
	id = str(randi() % 1000)
