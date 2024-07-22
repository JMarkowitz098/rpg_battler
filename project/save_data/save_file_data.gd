extends Resource
class_name SaveFileData

var id: String
var players_data: Array[PlayerData]
var save_time: String
var round_number: Round.Number

func _init(
  _id: String = "",
  _players_data: Array[PlayerData] = [],
  _save_time: String = "",
  _round_number: Round.Number = Round.Number.ONE
) -> void:
  id = _id
  players_data = _players_data
  save_time = _save_time
  round_number = _round_number
