class_name SceneText

var id: String
var content: String
var speaker: PlayerId.Id
var language: String

func _init(_id: String, _content: String, _speaker: String, _language: String = "en") -> void:
  id = _id
  content = _content
  speaker = _get_speaker_id(_speaker)
  language = _language

func _get_speaker_id(speaker_id: String) -> PlayerId.Id:
  match(speaker_id):
    "talon":
      return PlayerId.Id.TALON
    "nash":
      return PlayerId.Id.NASH
    "esen":
      return PlayerId.Id.ESEN
    "nalta":
      return PlayerId.Id.NALTA
    "sorah":
      return PlayerId.Id.SORAH
    "devlin":
      return PlayerId.Id.DEVLIN
    _:
      return PlayerId.Id.NONE