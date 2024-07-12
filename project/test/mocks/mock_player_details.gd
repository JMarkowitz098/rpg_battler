extends PlayerDetails
class_name MockPlayerDetails

func _init() -> void:
  player_id = Player.Id.TALON
  label = "Mock player label"
  elements = [ Element.Type.ETH, Element.Type.SHOR ]