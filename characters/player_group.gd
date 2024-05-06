extends Node2D

var players: Array = []
var index: int = 0

func _ready():
	players = get_children()
	players[0].focus.focus()
	
func switch_focus(x, y):
	players[x].focus.focus()
	players[y].focus.unfocus()
	
func reset_focus():
	index = 0
	for player in players:
		player.focus.unfocus()
		
func reset_defense():
	for player in players:
		player.stats.is_defending = false
	
func _on_battle_scene_next_player():
	if index < players.size() - 1:
		index += 1
		switch_focus(index, index - 1)
	else:
		index = 0
		switch_focus(index, players.size() - 1)
