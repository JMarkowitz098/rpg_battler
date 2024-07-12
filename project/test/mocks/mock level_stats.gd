extends LevelStats
class_name MockLevelStats

func _init() -> void:
  level = 1
  max_ingress = 10
  incursion = 2
  refrain = 2
  agility = 2
  skills = _create_skills()

func _create_skills() -> Array[Ingress]:
  return [ MockIngress.create_incursion(), MockIngress.create_refrain()]