class_name Character

var class_progress_bar: ProgressBar
var class_max_health: float
var class_focus_sprite: Sprite2D
var class_animation_player: AnimationPlayer
var class_animations: Node2D

func _init(max_health: float, progress_bar: ProgressBar, animations: Node2D, focus_sprite: Sprite2D):
	class_progress_bar = progress_bar
	class_max_health = max_health
	class_animations = animations
	class_animation_player = animations.get_node("AnimationPlayer")
	class_focus_sprite = focus_sprite
	
	health = class_max_health
	

var health: float:
	set(value):
		health = value
		_update_progress_bar()
		
func _update_progress_bar():
	class_progress_bar.value = (health / class_max_health) * 100
	
func _play_animation():
	class_animations.show()
	class_animation_player.play("hurt")
	
func focus():
	class_focus_sprite.show()
	
func unfocus():
	class_focus_sprite.hide()
	
func take_damage(value):
	health -= value
	_play_animation()
