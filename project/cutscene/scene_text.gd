class_name SceneText

var id: String
var content: String
var speaker: Player.Id
var language: String

func _init(_id: String, _content: String, _speaker: String, _language: String = "en") -> void:
  id = _id
  content = _content
  speaker = _get_speaker_id(_speaker)
  language = _language

func _get_speaker_id(speaker_id: String) -> Player.Id:
  match(speaker_id):
    "talon":
      return Player.Id.TALON
    "nash":
      return Player.Id.NASH
    "esen":
      return Player.Id.ESEN
    _:
      return Player.Id.NONE