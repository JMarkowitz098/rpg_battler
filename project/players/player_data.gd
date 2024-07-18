extends Resource
class_name PlayerData

@export var player_details: PlayerDetails
@export var stats: Stats
@export var unique_id: UniqueId
@export var skills: Array[NewIngress]
@export var type: Player.Type

var slot := 0

func _init(
  _player_details: PlayerDetails = null, 
  _stats: Stats = null, 
  _unique_id: UniqueId = null, 
  _skills: Array[NewIngress] = [], 
  _type: Player.Type = Player.Type.PLAYER,
  _slot: int = 0
) -> void:
  player_details = _player_details
  stats = _stats
  unique_id = _unique_id
  skills = _skills
  type = _type
  slot = _slot

func format_for_save() -> Dictionary:
  return {
	"player_details": player_details.format_for_save(),
	"stats": stats.format_for_save(),
	"unique_id": unique_id.id,
	"skills": skills.map(func(ingress: NewIngress) -> Array: return ingress.format_for_save()),
	"type": type,
  "slot": slot
  }
