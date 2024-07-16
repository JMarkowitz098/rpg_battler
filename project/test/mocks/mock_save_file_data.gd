extends SaveFileData
class_name MockSaveFileData

func _init() -> void:
  var mock_players_data: Array[PlayerData] = [MockPlayerData.new()]
  id = "mock_id"
  players_data = mock_players_data
  save_time = Time.get_datetime_string_from_system()
  round_number = Round.Number.ONE