class_name NewPlayerData

var player_id: Stats.PlayerId
var player_details: PlayerDetails
var level_stats: LevelStats
var unique_id: String

func _init(init: Dictionary) -> void:
  player_id = init.player_id
  player_details = init.player_details
  level_stats = init.level_stats
  unique_id = init.unique_id
