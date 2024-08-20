extends Panel

@onready var portrait := $Portrait
@onready var texture: Texture2D = portrait.texture

func _ready() -> void:
  var length := size.x - 2
  portrait.size.x = length
  portrait.size.y = length
  portrait.position.x = 1
  portrait.position.y = 1
