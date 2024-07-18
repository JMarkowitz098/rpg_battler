extends Resource
class_name SkillGroup

@export var skills: Array[ NewIngress ] = []

func add_skill(skill: NewIngress) -> void:
	skills.append(skill)


func format_for_save() -> Array:
	return skills.map(func(ingress: NewIngress) -> Array: return ingress.format_for_save())


func filter_by_type(type: NewIngress.Type) -> Array[NewIngress]:
	return skills.filter(func(skill: NewIngress) -> bool: return skill.type == type)


func filter_by_usable(ingress: int) -> Array[NewIngress]:
	return skills.filter(func(skill: NewIngress) -> bool: return _is_usable_skill(skill, ingress))


func _is_usable_skill(skill: NewIngress, ingress: int) -> bool:
	return skill.ingress < ingress

