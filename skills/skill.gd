class_name Skill
extends Node

enum Id {
	ETH_INCURSION_SMALL, # 0
	ETH_INCURSION_DOUBLE, # 1
	ETH_REFRAIN_SMALL, # 2
	ETH_REFRAIN_SMALL_GROUP, # 3
	ENH_INCURSION_SMALL, # 4
	ENH_REFRAIN_SMALL, # 5
	SHOR_INCURSION_SMALL, # 6
	SHOR_INCURSION_DOUBLE, # 7
	SHOR_REFRAIN_SMALL, # 8
	SHOR_REFRAIN_GROUP, # 9
	SCOR_INCURSION_SMALL, # 10
	SCOR_INCURSION_DOUBLE, # 11
	SCOR_REFRAIN_SMALL, # 12
	SCOR_REFRAIN_GROUP, # 13
	DODGE # 14
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
@export var element: Stats.Element
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

static func create_dodge() -> Skill:
	var dodge = new()
	dodge.id = Id.DODGE
	dodge.label  = "Dodge"
	dodge.ingress_energy_cost = 0
	dodge.type = Type.DODGE
	dodge.target = Target.SELF
	return dodge
	
static func _create_button_choice(skill_choice_list, button_text) -> void:
	var button = Button.new()
	button.text = button_text
	skill_choice_list.add_child(button)

static func create_skill_instance(skill_id: int) -> PackedScene:
	match skill_id:
		Id.ETH_INCURSION_SMALL:
			return load("res://skills/eth_incursion_small.tscn")
		Id.ETH_INCURSION_DOUBLE:
			return load("res://skills/small_eth_incursion_double.tscn")
		Id.ETH_REFRAIN_SMALL:
			return load("res://skills/eth_refrain_small.tscn")
		Id.ETH_REFRAIN_SMALL_GROUP:
			return load("res://skills/eth_refrain_small_group.tscn")
		Id.ENH_INCURSION_SMALL:
			return load("res://skills/enh_incursion_small.tscn")
		Id.ENH_REFRAIN_SMALL:
			return load("res://skills/enh_refrain_small.tscn")
		Id.SHOR_INCURSION_SMALL:
			return load("res://skills/shor_incursion_small.tscn")
		Id.SHOR_REFRAIN_SMALL:
			return load("res://skills/shor_refrain_small.tscn")
		Id.SHOR_INCURSION_DOUBLE:
			return load("res://skills/small_shor_incursion_double.tscn")
		Id.SHOR_REFRAIN_GROUP:
			return load("res://skills/shor_refrain_small_group.tscn")
		Id.SCOR_INCURSION_SMALL:
			return load("res://skills/scor_incursion_small.tscn")
		Id.SCOR_REFRAIN_SMALL:
			return load("res://skills/scor_refrain_small.tscn")
		Id.SCOR_REFRAIN_GROUP:
			return load("res://skills/scor_refrain_small_group.tscn")
		_:
			return load("res://skills/skill.tscn")

static func get_skill_label(skill_id: int) -> String:
	var skill = create_skill_instance(skill_id).instantiate()
	var skill_label = skill.label
	skill.queue_free()
	return skill_label
