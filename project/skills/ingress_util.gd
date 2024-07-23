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


func _create_ingress_list(list: Array) -> Array[Ingress]:
	var skills: Array[Ingress] = []
	for skill_info: Array in list:
		skills.append(load_ingress(skill_info))
	return skills


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

func get_new_skills(player_id: Player.Id, new_level: int) -> Array[Ingress]:
	match player_id:
		Player.Id.TALON:
			return _get_talon_skills(new_level)
		Player.Id.NASH:
			return _get_nash_skills(new_level)
		Player.Id.ESEN:
			return _get_esen_skills(new_level)
		_:
			return []

func _get_talon_skills(new_level: int) -> Array[Ingress]:
	var skills := _create_ingress_list([
		[Ingress.Id.INCURSION, Element.Type.SHOR],
		[Ingress.Id.INCURSION, Element.Type.ETH],
		[Ingress.Id.REFRAIN, Element.Type.SHOR],
		[Ingress.Id.REFRAIN, Element.Type.ETH],
	])
	
	match(new_level):
		1:
			pass
		2:
			skills.append_array(_create_ingress_list([
				[Ingress.Id.DOUBLE_INCURSION, Element.Type.SHOR],
				[Ingress.Id.DOUBLE_INCURSION, Element.Type.SCOR],
			]))
		3:
			pass
		_:
			return []

	return skills

func _get_nash_skills(new_level: int) -> Array[Ingress]:
	var skills := _create_ingress_list([
		[Ingress.Id.INCURSION, Element.Type.SHOR],
		[Ingress.Id.INCURSION, Element.Type.SCOR],
		[Ingress.Id.REFRAIN, Element.Type.SHOR],
		[Ingress.Id.REFRAIN, Element.Type.SCOR],
	])
	
	match(new_level):
		1:
			pass
		2:
			skills.append_array(_create_ingress_list([
				[Ingress.Id.GROUP_REFRAIN, Element.Type.SHOR],
				[Ingress.Id.GROUP_REFRAIN, Element.Type.SCOR],
			]))
		3:
			pass
		_:
			return []
		
	return skills

func _get_esen_skills(new_level: int) -> Array[Ingress]:
	var skills := _create_ingress_list([
		[Ingress.Id.INCURSION, Element.Type.ETH],
		[Ingress.Id.REFRAIN, Element.Type.ETH],
	])
	
	match(new_level):
		1:
			pass
		2:
			skills.append_array(_create_ingress_list([
				[Ingress.Id.GROUP_REFRAIN, Element.Type.ETH],
				[Ingress.Id.DOUBLE_INCURSION, Element.Type.ETH],
			]))
		3:
			pass
		_:
			return []
		
	return skills
