extends Resource
class_name PlayerLevelData

var max_ingress_energy: int
var incursion_power: int
var refrain_power: int
var agility: int
var skills: Array[Skill.Id]

func _init(init: Dictionary) -> void:
	max_ingress_energy = init.max_ingress_energy
	incursion_power = init.incursion_power
	refrain_power = init.refrain_power
	agility = init.agility
	skills = init.skills
