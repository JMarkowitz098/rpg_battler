extends HBoxContainer
class_name ActionQueue

var items: Array[ActionQueueItem] = []
var current_member: int = 0

const ACTION_QUEUE_ITEM := preload("res://ui/action_queue_item.tscn")

func _ready() -> void:
	Events.choosing_action_queue_state_entered.connect(_on_choosing_action_queue_state_entered)
	Events.choosing_action_state_entered.connect(_on_choosing_action_state_entered)
	Events.choosing_ally_state_entered.connect(_on_choosing_ally_state_entered)
	Events.enter_action_queue_handle_input.connect(_on_enter_action_queue_handle_input)
	Events.is_battling_state_entered.connect(_on_is_battling_state_entered)
	Events.update_action_index.connect(_on_update_action_index)
	Events.update_action_queue_focuses.connect(_on_update_action_queue_focuses)

# -------------
# Process Queue
# -------------

func fill_initial_turn_items(players: Array[Node2D], enemies: Array[Node2D]) -> void:
	for child in get_children():
		child.queue_free()

	_queue_empty_items(players)
	_queue_empty_items(enemies)
	_sort_items_by_agility()
	_fill_enemy_actions(players, enemies)
	for item in items:
		add_child(item)

func process_action_queue(tree: SceneTree, players: Array[Node2D], enemies: Array[Node2D], set_battle_process: Callable) -> void:
	while items.size() > 0:
		var action: Action = items.pop_front().action

		# For some reason, have to stop process to trigger await in loops
		set_battle_process.call(false)
		await _process_skill(action, tree, players, enemies)
		set_battle_process.call(true)

func is_turn_over() -> bool:
	return items.all(func(item: ActionQueueItem)-> bool: 
		return item.action.action_chosen)

func update_player_action_with_skill(player: Node2D, target: Node2D, skill: Ingress) -> void:
	var action_to_update: Action = items.filter(func(item: ActionQueueItem)-> bool: 
		return item.action.actor.stats.unique_id == player.stats.unique_id)[0].action
	if skill.target == Ingress.Target.SELF or skill.target == Ingress.Target.ALL_ENEMIES:
		action_to_update.set_target(null, skill)
	else:
		action_to_update.set_target(target, skill)
	
func remove_action_by_character_id(id: String) -> void:
	items = items.filter(
		func(item: ActionQueueItem) -> bool: 
			var action: Action = item.action
			var action_matches := false
			if action.target and action.target.stats.unique_id == id:
				action_matches = true
			if action.actor.stats.unique_id == id:
				action_matches = true
			return !action_matches)

# -----------------
# Private Functions
# -----------------

func _queue_empty_items(players: Array[Node2D]) -> void:
	for player in players:
		var new_item := ACTION_QUEUE_ITEM.instantiate()
		new_item.set_empty_action(player)
		new_item.texture = Utils.get_player_portrait(player.stats.player_details.player_id)
		if(player.stats.player_details.icon_type == Stats.IconType.ENEMY):
			new_item.self_modulate = Color("Red")
		items.push_back(new_item)

func _fill_enemy_actions(players: Array[Node2D], enemies: Array[Node2D]) -> void:
	for item in items:
		var action := item.action
		if(action.actor.stats.player_details.icon_type == Stats.IconType.ENEMY):
			if action.actor.stats.current_ingress == 1:
				action.set_dodge()
			else:
				var enemy_skill := _select_enemy_skill(action.actor.stats.level_stats.skills)
				action.set_enemy_skill(enemy_skill, players, enemies)

func _select_enemy_skill(skills: Array) -> Ingress:
	var rand_skill_i := randi() % skills.size()
	return skills[rand_skill_i]
				
func _process_skill(action: Action, tree: SceneTree, players: Array[Node2D], enemies: Array[Node2D]) -> void:
	action.actor.stats.use_ingress_energy(action.skill.ingress)
	if action.actor.stats.current_ingress <= 0:
		return

	match action.skill.id: 
		Ingress.Id.INCURSION, Ingress.Id.PIERCING_INCURSION:
			await _use_incursion(action)
			
		Ingress.Id.DOUBLE_INCURSION:
			await _use_incursion(action)
			await tree.create_timer(2).timeout
			if action.target != null:
				_use_incursion(action)
				await tree.create_timer(2).timeout

		Ingress.Id.GROUP_INCURSION:
			await _play_attack_animation(action)
			for enemy in enemies:
				action.target = enemy
				var damage := Utils.calucluate_skill_damage(action)
				enemy.stats.take_damage(damage)
				
		Ingress.Id.REFRAIN:
			await _play_refrain_animation(action)
			_set_refrain(action.target, action.skill.element)
			
		Ingress.Id.GROUP_REFRAIN:
			await _play_refrain_animation(action)
			var target_players := players if action.actor.stats.player_details.icon_type == Stats.IconType.PLAYER else enemies
			for player: Node2D in target_players:
				# if player == Node2D:
				_set_refrain(player, action.skill.element)

		Ingress.Id.MOVEMENT:
			await _play_refrain_animation(action)
			action.actor.stats.level_stats.agility *= 2
			action.actor.set_is_eth_dodging(true)
			action.actor.set_dodge_animation(true)
				
	if action.skill.id != Ingress.Id.DODGE:
		await tree.create_timer(2).timeout
		
func _use_incursion(action: Action) -> void:
	await _play_attack_animation(action)
	var damage := Utils.calucluate_skill_damage(action)
	action.target.stats.take_damage(damage)
		
func _play_attack_animation(action: Action) -> void:
	action.actor.base_sprite.hide()
	action.actor.attack_sprite.show()

	action.actor.animation_player.play("attack")
	await action.actor.animation_player.animation_finished

	if(action.actor != null):
		action.actor.base_sprite.show()
		action.actor.attack_sprite.hide()
		action.actor.animation_player.play("idle")

func _play_refrain_animation(action: Action) -> void:
	action.actor.animation_player.play("refrain")
	await action.actor.animation_player.animation_finished
	action.actor.animation_player.play("idle")
		
func _set_refrain(player: Node2D, skill_element: Element.Type) -> void:
	player.stats.has_small_refrain_open = true
	player.stats.current_refrain_element = skill_element
	player.refrain_aura.show()
	match skill_element:
		Element.Type.ETH:
			player.refrain_aura.modulate = Color("Green")
		Element.Type.ENH:
			player.refrain_aura.modulate = Color("Orange")
		Element.Type.SCOR:
			player.refrain_aura.modulate = Color("Red")
		Element.Type.SHOR:
			player.refrain_aura.modulate = Color("Blue")

func _sort_items_by_agility() -> void:
	for item in items:
		item.action.actor.stats.rand_agi = item.action.actor.stats.level_stats.agility + randi() % 10 
	items.sort_custom(func(a: ActionQueueItem, b: ActionQueueItem) -> bool: 
		return a.action.actor.stats.rand_agi  > b.action.actor.stats.rand_agi )

# ------------------
# Action Queue Focus
# ------------------
		
func reset_current_member() -> void:
	current_member = 0
	
func size() -> int:
	return items.size()
	
func get_current_item() -> ActionQueueItem:
	return items[current_member]

func set_item_focus(index: int, type: Focus.Type) -> void:
	items[index].focus(type)
			
func create_action_message(action: Action) -> String:
	var message: String = "Player: " + action.actor.player_name.text
	if action.skill:
		message += "\nAction: " + action.skill.label
	if action.target:
		message += "\nTarget -> " + action.target.player_name.text
	return message

func unfocus_all(type: Focus.Type) -> void:
	for item in items:
		item.unfocus(type)
	

func set_focuses() -> void:
	var item := get_current_item()
	var action: Action = item.action

	action.actor.focus(Focus.Type.TRIANGLE)
	action.actor.set_triangle_focus_color(Color.GRAY)
	action.actor.set_triangle_focus_size(Vector2(.6, .6))

	item.focus(Focus.Type.FINGER)

	if action.skill:
		match action.skill.id:
			Ingress.Id.INCURSION:
				action.target.focus(Focus.Type.TRIANGLE)
				action.target.set_triangle_focus_color(Color.RED)
			Ingress.Id.REFRAIN:
				action.target.focus(Focus.Type.TRIANGLE)
				action.target.set_triangle_focus_color(Color.GREEN)

func get_action_index_by_unique_id(unique_id: String) -> int:
	for i in items.size():
		var action := items[i].action
		if action.actor.stats.unique_id == unique_id:
			return i
	return 0

func set_turn_on_player(unique_id: String) -> void:
	var index := get_action_index_by_unique_id(unique_id)
	set_item_focus(index, Focus.Type.TRIANGLE)


# -------
# Signals
# -------

func _on_choosing_action_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_choosing_action_queue_state_entered() -> void:
	set_item_focus(0, Focus.Type.FINGER)
	var action := get_current_item().action
	Events.update_info_label.emit(create_action_message(action))

func _on_is_battling_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_enter_action_queue_handle_input() -> void:
	unfocus_all(Focus.Type.ALL)

func _on_update_action_index(direction: Direction.Type) -> void:
	match direction:
		Direction.Type.RIGHT:
			current_member = (current_member + 1) % items.size()
		Direction.Type.LEFT:
			if current_member == 0:
				current_member = size() - 1
			else:
				current_member = current_member - 1
		
	var action := get_current_item().action
	Events.update_info_label.emit(create_action_message(action))

func _on_update_action_queue_focuses() -> void:
	set_focuses()

func _on_choosing_ally_state_entered() -> void:
	unfocus_all(Focus.Type.ALL)
