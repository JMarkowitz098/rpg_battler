extends PlayerDetails
class_name MockPlayerDetails


func _init() -> void:
	var mock_elements: Array[Element.Type] = [Element.Type.ETH, Element.Type.SHOR]
	var skills := MockIngress.create_array()

	player_id = Player.Id.TALON
	label = "Mock player label"
	elements = mock_elements
	skills = skills
