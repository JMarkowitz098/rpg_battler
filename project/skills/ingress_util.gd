extends Node
class_name IngressUtil

func load_ingress(skill_data: Array) -> Ingress:
	var data_id: Ingress.Id = skill_data[0]
	var data_element: Element.Type = skill_data[1]
	
	match(data_element):
		Element.Type.ETH:
			return _load_skill(data_id, "eth")
		Element.Type.SHOR:
			return _load_skill(data_id, "shor")
		Element.Type.SCOR:
			return _load_skill(data_id, "scor")
		Element.Type.ENH:
			return _load_skill(data_id, "enh")
		_:
			return null


func is_incursion(type: Ingress.Type) -> bool:
	return type == Ingress.Type.INCURSION


func is_refrain(type: Ingress.Type) -> bool:
	return type == Ingress.Type.REFRAIN


func has_target(target: Ingress.Target) -> bool:
	match target:
		Ingress.Target.SELF, Ingress.Target.ENEMY, Ingress.Target.ALLY:
			return true
		_:
			return false


func format_for_save(id: Ingress.Id, element: Element.Type) -> Array:
	return [id, element]


func _load_skill(data_id: Ingress.Id, element_string: String) -> Ingress:
	var path := "res://skills/" + element_string + "/"

	match(data_id):
		Ingress.Id.INCURSION:
			path += element_string + "_incursion.tres"
		Ingress.Id.REFRAIN:
			path += element_string + "_refrain.tres"
		Ingress.Id.DOUBLE_INCURSION:
			path += element_string + "_double_incursion.tres"
		Ingress.Id.GROUP_REFRAIN:
			path += element_string + "_group_refrain.tres"
		Ingress.Id.GROUP_INCURSION:
			path += element_string + "_group_incursion.tres"
		_:
			return null

	return load(path)

func get_new_skills(player_id: Player.Id, new_level: int) -> SkillGroup:
	match player_id:
		Player.Id.TALON:
			return _get_talon_skills(new_level)
		Player.Id.NASH:
			return _get_nash_skills(new_level)
		Player.Id.ESEN:
			return _get_esen_skills(new_level)
		_:
			return null

func _get_talon_skills(new_level: int) -> SkillGroup:
	match(new_level):
		1:
			return load("res://players/Talon/levels/talon_1_skills.tres")
		2:
			print("made it")
			return load("res://players/Talon/levels/talon_2_skills.tres")
		3:
			return load("res://players/Talon/levels/talon_3_skills.tres")
		_:
			return null

func _get_nash_skills(new_level: int) -> SkillGroup:
	match(new_level):
		1:
			return load("res://players/Nash/levels/nash_1_skills.tres")
		2:
			return load("res://players/Nash/levels/nash_2_skills.tres")
		3:
			return load("res://players/Nash/levels/nash_3_skills.tres")
		_:
			return null

func _get_esen_skills(new_level: int) -> SkillGroup:
	match(new_level):
		1:
			return load("res://players/Esen/levels/esen_1_skills.tres")
		2:
			return load("res://players/Esen/levels/esen_2_skills.tres")
		3:
			return load("res://players/Esen/levels/esen_3_skills.tres")
		_:
			return null
