extends Resource
class_name NewPlayerData

@export var player_id: Player.Id
@export var player_details: PlayerDetails
@export var stats: Stats
@export var unique_id: UniqueId
@export var skills: Array[Ingress]
@export var type: Player.Type

func _init(init: Dictionary) -> void:
  player_id = init.player_id
  player_details = init.player_details
  stats = init.stats
  unique_id = init.unique_id
  skills = init.skills
  type = init.type
