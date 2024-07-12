extends PlayerDetails
class_name MockPlayerDetails

func _init() -> void:
  player_id = Stats.PlayerId.TALON
  label = "Mock player label"
  icon_type = Stats.IconType.PLAYER
  elements = [ Element.Type.ETH, Element.Type.SHOR ]