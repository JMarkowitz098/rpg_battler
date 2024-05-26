class_name Skill
extends Node

enum Id {
	DOUBLE_SLASH,
	TRIPLE_SLASH
}
@export var id: Id
@export var label: String
@export var mp_cost: int
@export_enum("Damage") var type: String
@export_multiline var description: String

signal pressed()

static func fill_skill_choice_list(player, skill_choice_list):
	for child in skill_choice_list.get_children():
		# queue_free is deferred until end of frame, so we remove node from list
		# to prevent indexing issues while turn is processing
		skill_choice_list.remove_child(child)
		child.queue_free()
		
	for skill in player.get_skills():
		_create_button_choice(skill_choice_list, skill.label)


static func _create_button_choice(skill_choice_list, button_text):
	var button = Button.new()
	button.text = button_text
	skill_choice_list.add_child(button)
