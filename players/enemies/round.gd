extends Resource
class_name Round

enum Number {
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE
}

@export var round_number: Number
@export var players_details: Array[PlayerDetails]
@export var levels: Array[LevelStats]