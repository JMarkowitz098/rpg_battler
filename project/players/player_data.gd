extends Resource
class_name PlayerData

@export var player_details: PlayerDetails
@export var stats: Stats
@export var unique_id: UniqueId
@export var skills: Array[Ingress]
@export var type: Player.Type

func _init(
  _player_details: PlayerDetails, 
  _stats: Stats, 
  _unique_id: UniqueId, 
  _skills: Array[Ingress], 
  _type: Player.Type
) -> void:
  player_details = _player_details
  stats = _stats
  unique_id = _unique_id
  skills = _skills
  type = _type

func format_for_save() -> Dictionary:
  return {
    "player_details": player_details.format_for_save(),
    "stats": stats._format_for_save(),
    "unique_id": unique_id.id,
    "skills": skills.map(func(ingress: Ingress) -> Array: return ingress.format_for_save()),
    "type": type,
  }
