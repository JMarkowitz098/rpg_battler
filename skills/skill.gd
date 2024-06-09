class_name Skill
extends Node

const ENH_INCURSION_SMALL = preload("res://skills/enh_incursion_small.tscn")
const ENH_REFRAIN_SMALL = preload("res://skills/enh_refrain_small.tscn")
const ETH_INCURSION_SMALL = preload("res://skills/eth_incursion_small.tscn")
const ETH_REFRAIN_SMALL = preload("res://skills/eth_refrain_small.tscn")
const ETH_REFRAIN_SMALL_GROUP = preload("res://skills/eth_refrain_small_group.tscn")
const SCOR_INCURSION_SMALL = preload("res://skills/scor_incursion_small.tscn")
const SCOR_REFRAIN_SMALL = preload("res://skills/scor_refrain_small.tscn")
const SHOR_INCURSION_SMALL = preload("res://skills/shor_incursion_small.tscn")
const SHOR_REFRAIN_SMALL = preload("res://skills/shor_refrain_small.tscn")
const SMALL_ETH_INCURSION_DOUBLE = preload("res://skills/small_eth_incursion_double.tscn")
const SKILL = preload("res://skills/skill.tscn")

enum Id {
	ETH_INCURSION_SMALL,
	ETH_INCURSION_DOUBLE,
	ETH_REFRAIN_SMALL,
	ETH_REFRAIN_SMALL_GROUP,
	ENH_INCURSION_SMALL,
	ENH_REFRAIN_SMALL,
	SHOR_INCURSION_SMALL,
	SHOR_INCURSION_DOUBLE,
	SHOR_REFRAIN_SMALL,
	SHOR_REFRAIN_GROUP,
	SCOR_INCURSION_SMALL,
	SCOR_INCURSION_DOUBLE,
	SCOR_REFRAIN_SMALL,
	SCOR_REFRAIN_GROUP,
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
			return ETH_INCURSION_SMALL
		Id.ETH_INCURSION_DOUBLE:
			return SMALL_ETH_INCURSION_DOUBLE
		Id.ETH_REFRAIN_SMALL:
			return ETH_REFRAIN_SMALL
		Id.ETH_REFRAIN_SMALL_GROUP:
			return ETH_REFRAIN_SMALL_GROUP
		Id.ENH_INCURSION_SMALL:
			return ETH_INCURSION_SMALL
		Id.ENH_REFRAIN_SMALL:
			return ENH_REFRAIN_SMALL
		Id.SHOR_INCURSION_SMALL:
			return SHOR_INCURSION_SMALL
		Id.SHOR_REFRAIN_SMALL:
			return SHOR_REFRAIN_SMALL
		Id.SCOR_INCURSION_SMALL:
			return SCOR_INCURSION_SMALL
		Id.SCOR_REFRAIN_SMALL:
			return SCOR_REFRAIN_SMALL
		_:
			return SKILL
			
