class_name StateParams

var item: ActionQueueItem
var battle_groups: BattleGroups
var button: Button
var ingress_type: Ingress.Type

func _init(
  _item: ActionQueueItem = null,
  _battle_groups: BattleGroups = null,
  _button: Button = null,
  _ingress_type: Ingress.Type = Ingress.Type.NONE
) -> void:
  item = _item
  battle_groups = _battle_groups
  button = _button
  ingress_type = _ingress_type