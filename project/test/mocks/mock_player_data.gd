extends PlayerData
class_name MockPlayerData

func _init() -> void:
	player_details = MockPlayerDetails.new()
	stats = MockStats.new()
	unique_id = MockUniqueId.new()
	learned_skills = MockIngress.create_array()
	type = Player.Type.PLAYER
