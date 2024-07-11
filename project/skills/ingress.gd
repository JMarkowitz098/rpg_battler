extends Resource
class_name Ingress

enum Id {
  DOUBLE_INCURSION,
  GROUP_INCURSION,
  GROUP_REFRAIN,
  INCURSION,
  MOVEMENT,
  PIERCING_INCURSION,
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