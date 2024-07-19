extends Resource
class_name SkillGroup

@export var skills: Array[ Ingress ] = []

func add_skill(skill: Ingress) -> void:
	skills.append(skill)


func format_for_save() -> Array:
	if skills.size() == 0: print("No skills to format for save")
	return skills.map(func(ingress: Ingress) -> Array: return ingress.format_for_save())


func filter_by_type(type: Ingress.Type) -> Array[Ingress]:
	return skills.filter(func(skill: Ingress) -> bool: return skill.type == type)


func filter_by_usable(ingress: int) -> Array[Ingress]:
	return skills.filter(func(skill: Ingress) -> bool: return _is_usable_skill(skill, ingress))


func _is_usable_skill(skill: Ingress, ingress: int) -> bool:
	return skill.ingress < ingress

