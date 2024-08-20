extends Resource
class_name PlayerDetails

@export var player_id: PlayerId.Id
@export var label: String
@export_multiline var description: String
@export var elements: Array[Element.Type]
@export var learnable_skills: SkillGroup


func _init(
	_player_id: PlayerId.Id = PlayerId.Id.TALON,
	_label: String = "",
	_elements: Array[Element.Type] = [],
	_learnable_skills: SkillGroup = null,
	_description: String = ""
) -> void:
	player_id = _player_id
	label = _label
	elements = _elements
	learnable_skills = _learnable_skills
	description = _description


func format_for_save() -> Dictionary:
	return {
		"player_id": player_id,
		"label": label,
		"elements": elements as Array,
		"learnable_skills": learnable_skills.format_for_save(),
		"description": description
	}
