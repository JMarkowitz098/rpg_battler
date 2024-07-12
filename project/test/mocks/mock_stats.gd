extends Stats
class_name MockStats

func _init() -> void:
  level_stats = MockLevelStats.new()
  player_details = MockPlayerDetails.new()
  current_ingress = level_stats.max_ingress
