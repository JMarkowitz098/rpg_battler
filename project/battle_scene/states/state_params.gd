class_name StateParams

var item: ActionQueueItem
var battle_groups: BattleGroups
var button: Button

func _init(
  _item: ActionQueueItem = null,
  _battle_groups: BattleGroups = null,
  _button: Button = null
) -> void:
  item = _item
  battle_groups = _battle_groups
  button = _button