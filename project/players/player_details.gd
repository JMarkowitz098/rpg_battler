extends Resource
class_name PlayerDetails

@export var player_id: Player.Id
@export var label: String
@export var elements: Array[Element.Type]
@export var learnable_skills: Array[Ingress]


func _init(
	_player_id: Player.Id = Player.Id.TALON,
	_label: String = "",
	_elements: Array[Element.Type] = [],
	_learnable_skills: Array[Ingress] = [],
) -> void:
	player_id = _player_id
	label = _label
	elements = _elements
	learnable_skills = _learnable_skills


func format_for_save() -> Dictionary:
	return {
		"player_id": player_id,
		"label": label,
		"elements": elements as Array,
		"learnable_skills":
			learnable_skills.map(func(skill: Ingress) -> Array: return skill.format_for_save())
	}


static func get_player_label(incoming_player_id: Player.Id) -> String:
	match incoming_player_id:
		Player.Id.TALON:
			return "Talon"
		Player.Id.NASH:
			return "Nash"
		Player.Id.ESEN:
			return "Esen"
		_:
			return "No match"
