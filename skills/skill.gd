class_name Skill
extends Node

enum Id {
	ETH_INCURSION, # 0
	ETH_INCURSION_DOUBLE, # 1
	ETH_REFRAIN, # 2
	ETH_REFRAIN_GROUP, # 3
	ENH_INCURSION, # 4
	ENH_REFRAIN, # 5
	SHOR_INCURSION, # 6
	SHOR_INCURSION_DOUBLE, # 7
	SHOR_REFRAIN, # 8
	SHOR_REFRAIN_GROUP, # 9
	SCOR_INCURSION, # 10
	SCOR_INCURSION_DOUBLE, # 11
	SCOR_REFRAIN, # 12
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
	ALLY,
	ALL_ENEMIES,
	ALL_ALLIES
}

const SMALL_REFRAIN_POWER := 1

#@export var id: Id
#@export var label: String
#@export var ingress_energy_cost: int
#@export var element: Stats.Element
#@export var type: Type
#@export var target: Target
#@export_multiline var description: String
@export var skill_stats: SkillStats

signal pressed()

static func fill_skill_choice_list(player: Node2D, skill_choice_list: GridContainer, filter_type: Skill.Type) -> void:
	for child in skill_choice_list.get_children():
		# queue_free is deferred until end of frame, so we remove node from list
		# to prevent indexing issues while turn is processing
		skill_choice_list.remove_child(child)
		child.queue_free()
		
	for skill: SkillStats in player.get_skills(filter_type):
		_create_button_choice(skill_choice_list, skill.label)

#static func create_dodge() -> Skill:
	#var dodge = new()
	#dodge.id = Id.DODGE
	#dodge.label  = "Dodge"
	#dodge.ingress_energy_cost = 0
	#dodge.type = Type.DODGE
	#dodge.target = Target.SELF
	#return dodge
	
static func _create_button_choice(skill_choice_list: GridContainer, button_text: String) -> void:
	var button := Button.new()
	button.text = button_text
	skill_choice_list.add_child(button)

static func create_skill_instance(skill_id: int) -> Resource:
	match skill_id:
		Id.ETH_INCURSION:
			return load("res://skills/eth/eth_incursion.tres")
		Id.ETH_INCURSION_DOUBLE:
			return load("res://skills/eth/eth_incursion_double.tres")
		Id.ETH_REFRAIN:
			return load("res://skills/eth/eth_refrain.tres")
		Id.ETH_REFRAIN_GROUP:
			return null
		Id.ENH_INCURSION:
			return load("res://skills/enh/enh_incursion.tres")
		Id.ENH_REFRAIN:
			return load("res://skills/enh/enh_refrain.tres")
		Id.SHOR_INCURSION:
			return load("res://skills/shor/shor_incursion.tres")
		Id.SHOR_REFRAIN:
			return load("res://skills/shor/shor_refrain.tres")
		Id.SHOR_INCURSION_DOUBLE:
			return load("res://skills/shor/shor_incursion_double.tres")
		Id.SHOR_REFRAIN_GROUP:
			return load("res://skills/scor/shor_refrain_group.tres")
		Id.SCOR_INCURSION:
			return load("res://skills/scor/scor_incursion.tres")
		Id.SCOR_REFRAIN:
			return load("res://skills/scor/scor_refrain.tres")
		Id.SCOR_REFRAIN_GROUP:
			return load("res://skills/scor/scor_refrain_group.tres")
		Id.DODGE:
			return load("res://skills/dodge.tres")
		_:
			return null

static func get_skill_label(skill_id: int) -> String:
	return create_skill_instance(skill_id).label