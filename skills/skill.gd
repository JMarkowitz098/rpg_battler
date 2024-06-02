class_name Skill
extends Node

enum Id {
	ETH_INCURSION_SMALL,
	ETH_REFRAIN_SMALL,
	ENH_INCURSION_SMALL,
	ENH_REFRAIN_SMALL,
	DODGE
}
enum Type {
	INCURSION,
	REFRAIN,
	DODGE
}

enum Target {
	SELF,
	ENEMY,
	ALLY
}

const SMALL_REFRAIN_POWER := 1

@export var id: Id
@export var label: String
@export var ingress_energy_cost: int
@export var element: CharacterStats.Element
@export var type: Type
@export var target: Target
@export_multiline var description: String

signal pressed()

static func fill_skill_choice_list(player: Node2D, skill_choice_list: GridContainer, filter_type: Skill.Type):
	for child in skill_choice_list.get_children():
		# queue_free is deferred until end of frame, so we remove node from list
		# to prevent indexing issues while turn is processing
		skill_choice_list.remove_child(child)
		child.queue_free()
		
	for skill in player.get_skills(filter_type):
		_create_button_choice(skill_choice_list, skill.label)

static func create_dodge():
	var dodge = new()
	dodge.id = Id.DODGE
	dodge.label  = "Dodge"
	dodge.ingress_energy_cost = 0
	dodge.type = Type.DODGE
	dodge.target = Target.SELF
	return dodge
	

static func _create_button_choice(skill_choice_list, button_text):
	var button = Button.new()
	button.text = button_text
	skill_choice_list.add_child(button)
