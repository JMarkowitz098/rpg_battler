extends Resource
class_name Ingress

enum Id {
  DOUBLE_INCURSION,
  GROUP_INCURSION,
  GROUP_REFRAIN,
  INCURSION,
  MOVEMENT,
  PIERCING_INCURSION,
  REFRAIN
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

@export var id: Id
@export var label: String
@export var ingress: int
@export var type: Type
@export var target: Target
@export_multiline var description: String