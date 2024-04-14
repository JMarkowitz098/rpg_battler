extends Node2D

var enemies: Array = []
var action_queue: Array = []
var is_battling: bool = false
var index: int = 0

@onready var choice = $"../CanvasLayer/choice"

signal next_player

func _ready():
	enemies = get_children()
	show_choice()

func _process(_delta):
	if not choice.visible:
		
		if Input.is_action_just_pressed("ui_up"):
			if index == 0:
				index = enemies.size() - 1
				switch_focus(index, 0)
			else:
				index -= 1
				switch_focus(index, index + 1)
			
		if Input.is_action_just_pressed("ui_down"):
			if index == enemies.size() - 1:
				index = 0
				switch_focus(index, enemies.size() - 1)
			else:
				index += 1
				switch_focus(index, index - 1)
			
		if Input.is_action_just_pressed("ui_accept"):
			action_queue.push_back(index)
			emit_signal("next_player")
		
	if action_queue.size() == enemies.size() and not is_battling:
		is_battling = true
		_action(action_queue)
		
func _action(stack):
	for i in stack:
		enemies[i].action.take_damage(1)
		await get_tree().create_timer(2).timeout
	action_queue.clear()
	is_battling = false
	show_choice()
		
func switch_focus(x, y):
	enemies[x].action.focus()
	enemies[y].action.unfocus()

func show_choice():
	choice.show()
	choice.find_child("Attack").grab_focus()
	
func _reset_focus():
	index = 0
	for enemy in enemies:
		enemy.action.unfocus()
	
func _start_choosing():
	_reset_focus()
	enemies[0].action.focus()


func _on_attack_pressed():
	choice.hide()
	_start_choosing()
