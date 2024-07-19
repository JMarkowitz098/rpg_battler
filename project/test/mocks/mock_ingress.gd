extends Ingress
class_name MockIngress

var id: Id
var type: Type
var target: Target

func _init(init: Dictionary) -> void:
	var keys: Array[String] = [
		"id",
		"label",
		"ingress",
		"type",
		"target",
		"description",
		"element"
	]

	for key in keys:
		_set_initial_property(init, key)


func _set_initial_property(init: Dictionary, key: String) -> void:
	if(key in init): self[key] = init[key]
	else: _set_default(key)


func _set_default(key: String) -> void:
	var default_value: Variant
	match key:
		"id":
			default_value = Id.INCURSION
		"label":
			default_value = "Mock Ingress"
		"type":
			default_value = Type.INCURSION
		"target":
			default_value = Target.ENEMY
		"ingress":
			default_value = 2
		"description":
			default_value = "This is a mock"
		"element":
			default_value = Element.Type.ETH
	self[key] = default_value


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


static func create_incursion() -> MockIngress:
	return MockIngress.new({"label": "Mock Incursion"})
	

static func create_refrain() -> MockIngress:
	return MockIngress.new({
		"id": Ingress.Id.REFRAIN,
		"label": "Mock Refrain",
		"type": Ingress.Type.REFRAIN,
		"target": Ingress.Target.ALLY,
		"ingress": 1
	})


static func create_array() -> SkillGroup:
	var skills := SkillGroup.new()
	skills.add_skill(create_incursion())
	skills.add_skill(create_refrain())
	return skills