extends Resource
class_name Ingress

enum Id {
  DOUBLE_INCURSION, # 1
  GROUP_INCURSION, # 2
  GROUP_REFRAIN, # 3
  INCURSION, #4
  MOVEMENT, #5
  PIERCING_INCURSION, #6
  REFRAIN,
	DODGE,
	RECOVER
}

enum Type {
	INCURSION,
	REFRAIN,
	DODGE,
	RECOVER
}

enum Target {
	SELF,
	ENEMY,
	ALLY,
	ALL_ENEMIES,
	ALL_ALLIES
}

@export var id: Id
@export var label: String
@export var ingress: int
@export var type: Type
@export var target: Target
@export var element: Element.Type
@export_multiline var description: String


func is_incursion() -> bool:
	return type == Type.INCURSION


func is_refrain() -> bool:
	return type == Type.REFRAIN


func has_target() -> bool:
	match target:
		Target.SELF, Target.ENEMY, Target.ALLY:
			return true
		_:
			return false


func format_for_save() -> Array:
	return [id, element]


static func load_ingress(skill_data: Array) -> Ingress:
	var data_id: Id = skill_data[0]
	var data_element: Element.Type = skill_data[1]
	
	match(data_element):
		Element.Type.ETH:
			return _load_skill(data_id, "eth")
		Element.Type.SHOR:
			return _load_skill(data_id, "shor")
		_:
			return null
		

static func _load_skill(data_id: Id, element_string: String) -> Ingress:
	var path := "res://skills/" + element_string + "/"

	match(data_id):
		Ingress.Id.INCURSION:
			path += element_string + "_incursion.tres"
		Ingress.Id.REFRAIN:
			path += element_string + "_refrain.tres"
		Ingress.Id.GROUP_INCURSION:
			path += element_string + "_group_incursion.tres"
		Ingress.Id.GROUP_REFRAIN:
			path += element_string + "_group_refrain.tres"
		_:
			return null

	return load(path)
